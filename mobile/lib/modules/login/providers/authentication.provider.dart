import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/album/providers/album.provider.dart';
import 'package:immich_mobile/modules/album/providers/shared_album.provider.dart';
import 'package:immich_mobile/shared/models/store.dart';
import 'package:immich_mobile/modules/login/models/authentication_state.model.dart';
import 'package:immich_mobile/shared/models/user.dart';
import 'package:immich_mobile/shared/providers/api.provider.dart';
import 'package:immich_mobile/shared/providers/db.provider.dart';
import 'package:immich_mobile/shared/services/api.service.dart';
import 'package:immich_mobile/utils/db.dart';
import 'package:immich_mobile/utils/hash.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:openapi/api.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  AuthenticationNotifier(
    this._apiService,
    this._db,
    this._ref,
  ) : super(
          AuthenticationState(
            deviceId: "",
            userId: "",
            userEmail: "",
            name: '',
            profileImagePath: '',
            isAdmin: false,
            shouldChangePassword: false,
            isAuthenticated: false,
          ),
        );

  final ApiService _apiService;
  final Isar _db;
  final StateNotifierProviderRef<AuthenticationNotifier, AuthenticationState>
      _ref;
  final _log = Logger("AuthenticationNotifier");

  Future<bool> login(
    String email,
    String password,
    String serverUrl,
  ) async {
    try {
      // Resolve API server endpoint from user provided serverUrl
      await _apiService.resolveAndSetEndpoint(serverUrl);
      await _apiService.serverInfoApi.pingServer();
    } catch (e) {
      debugPrint('Invalid Server Endpoint Url $e');
      return false;
    }

    // Make sign-in request
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      _apiService.authenticationApi.apiClient
          .addDefaultHeader('deviceModel', iosInfo.utsname.machine ?? '');
      _apiService.authenticationApi.apiClient
          .addDefaultHeader('deviceType', 'iOS');
    } else {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      _apiService.authenticationApi.apiClient
          .addDefaultHeader('deviceModel', androidInfo.model);
      _apiService.authenticationApi.apiClient
          .addDefaultHeader('deviceType', 'Android');
    }

    try {
      var loginResponse = await _apiService.authenticationApi.login(
        LoginCredentialDto(
          email: email,
          password: password,
        ),
      );

      if (loginResponse == null) {
        debugPrint('Login Response is null');
        return false;
      }

      return setSuccessLoginInfo(
        accessToken: loginResponse.accessToken,
        serverUrl: serverUrl,
      );
    } catch (e) {
      HapticFeedback.vibrate();
      debugPrint("Error logging in $e");
      return false;
    }
  }

  Future<void> logout() async {
    var log = Logger('AuthenticationNotifier');
    try {
      String? userEmail = Store.tryGet(StoreKey.currentUser)?.email;

      _apiService.authenticationApi
          .logout()
          .then((_) => log.info("Logout was successful for $userEmail"))
          .onError(
            (error, stackTrace) =>
                log.severe("Error logging out $userEmail", error, stackTrace),
          );

      await Future.wait([
        clearAssetsAndAlbums(_db),
        Store.delete(StoreKey.currentUser),
        Store.delete(StoreKey.accessToken),
      ]);
      _ref.invalidate(albumProvider);
      _ref.invalidate(sharedAlbumProvider);

      state = state.copyWith(
        deviceId: "",
        userId: "",
        userEmail: "",
        name: '',
        profileImagePath: '',
        isAdmin: false,
        shouldChangePassword: false,
        isAuthenticated: false,
      );
    } catch (e) {
      log.severe("Error logging out $e");
    }
  }

  updateUserProfileImagePath(String path) {
    state = state.copyWith(profileImagePath: path);
  }

  Future<bool> changePassword(String newPassword) async {
    try {
      await _apiService.userApi.updateUser(
        UpdateUserDto(
          id: state.userId,
          password: newPassword,
          shouldChangePassword: false,
        ),
      );

      state = state.copyWith(shouldChangePassword: false);

      return true;
    } catch (e) {
      debugPrint("Error changing password $e");
      return false;
    }
  }

  Future<bool> setSuccessLoginInfo({
    required String accessToken,
    required String serverUrl,
    bool offlineLogin = false,
  }) async {
    _apiService.setAccessToken(accessToken);

    // Get the deviceid from the store if it exists, otherwise generate a new one
    String deviceId =
        Store.tryGet(StoreKey.deviceId) ?? await FlutterUdid.consistentUdid;

    bool shouldChangePassword = false;
    User? user;

    bool retResult = false;
    User? offlineUser = Store.tryGet(StoreKey.currentUser);

    // If the user is offline and there is a user saved on the device,
    // if not try an online login
    if (offlineLogin && offlineUser != null) {
      user = offlineUser;
      retResult = false;
    } else {
      UserResponseDto? userResponseDto;
      try {
        userResponseDto = await _apiService.userApi.getMyUserInfo();
      } on ApiException catch (e) {
        if (e.innerException is SocketException) {
          state = state.copyWith(isAuthenticated: true);
        }
      }

      if (userResponseDto != null) {
        Store.put(StoreKey.deviceId, deviceId);
        Store.put(StoreKey.deviceIdHash, fastHash(deviceId));
        Store.put(
          StoreKey.currentUser,
          User.fromUserDto(userResponseDto),
        );
        Store.put(StoreKey.serverUrl, serverUrl);
        Store.put(StoreKey.accessToken, accessToken);

        shouldChangePassword = userResponseDto.shouldChangePassword;
        user = User.fromUserDto(userResponseDto);

        retResult = true;
      } else {
        _log.severe("Unable to get user information from the server.");
        return false;
      }
    }

    state = state.copyWith(
      isAuthenticated: true,
      userId: user.id,
      userEmail: user.email,
      name: user.name,
      profileImagePath: user.profileImagePath,
      isAdmin: user.isAdmin,
      shouldChangePassword: shouldChangePassword,
      deviceId: deviceId,
    );

    return retResult;
  }
}

final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationState>((ref) {
  return AuthenticationNotifier(
    ref.watch(apiServiceProvider),
    ref.watch(dbProvider),
    ref,
  );
});

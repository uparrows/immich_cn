import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/backup/providers/backup.provider.dart';
import 'package:immich_mobile/modules/login/providers/authentication.provider.dart';
import 'package:immich_mobile/modules/onboarding/providers/gallery_permission.provider.dart';
import 'package:immich_mobile/routing/router.dart';
import 'package:immich_mobile/shared/models/store.dart';
import 'package:immich_mobile/shared/providers/api.provider.dart';
import 'package:logging/logging.dart';
import 'package:openapi/api.dart';

@RoutePage()
class SplashScreenPage extends HookConsumerWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.watch(apiServiceProvider);
    final serverUrl = Store.tryGet(StoreKey.serverUrl);
    final accessToken = Store.tryGet(StoreKey.accessToken);
    final log = Logger("SplashScreenPage");

    void performLoggingIn() async {
      bool isSuccess = false;
      bool deviceIsOffline = false;
      if (accessToken != null && serverUrl != null) {
        try {
          // Resolve API server endpoint from user provided serverUrl
          await apiService.resolveAndSetEndpoint(serverUrl);
        } on ApiException catch (e) {
          // okay, try to continue anyway if offline
          if (e.code == 503) {
            deviceIsOffline = true;
            log.fine("Device seems to be offline upon launch");
          } else {
            log.severe(e);
          }
        } catch (e) {
          log.severe(e);
        }

        try {
          isSuccess = await ref
              .read(authenticationProvider.notifier)
              .setSuccessLoginInfo(
                accessToken: accessToken,
                serverUrl: serverUrl,
                offlineLogin: deviceIsOffline,
              );
        } catch (error, stackTrace) {
          ref.read(authenticationProvider.notifier).logout();

          log.severe(
            'Cannot set success login info: $error',
            error,
            stackTrace,
          );

          context.pushRoute(const LoginRoute());
        }
      }

      // If the device is offline and there is a currentUser stored locallly
      // Proceed into the app
      if (deviceIsOffline && Store.tryGet(StoreKey.currentUser) != null) {
        context.replaceRoute(const TabControllerRoute());
      } else if (isSuccess) {
        // If device was able to login through the internet successfully
        final hasPermission =
            await ref.read(galleryPermissionNotifier.notifier).hasPermission;
        if (hasPermission) {
          // Resume backup (if enable) then navigate
          ref.watch(backupProvider.notifier).resumeBackup();
        }
        context.replaceRoute(const TabControllerRoute());
      } else {
        // User was unable to login through either offline or online methods
        context.replaceRoute(const LoginRoute());
      }
    }

    useEffect(
      () {
        if (serverUrl != null && accessToken != null) {
          performLoggingIn();
        } else {
          context.replaceRoute(const LoginRoute());
        }
        return null;
      },
      [],
    );

    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/immich-logo-no-outline.png'),
          width: 80,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

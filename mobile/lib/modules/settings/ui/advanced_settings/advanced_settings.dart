import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useState;
import 'package:immich_mobile/extensions/build_context_extensions.dart';
import 'package:immich_mobile/shared/models/store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/settings/providers/app_settings.provider.dart';
import 'package:immich_mobile/modules/settings/services/app_settings.service.dart';
import 'package:immich_mobile/modules/settings/ui/settings_switch_list_tile.dart';
import 'package:immich_mobile/shared/services/immich_logger.service.dart';
import 'package:immich_mobile/utils/http_ssl_cert_override.dart';
import 'package:logging/logging.dart';

class AdvancedSettings extends HookConsumerWidget {
  const AdvancedSettings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoggedIn = Store.tryGet(StoreKey.currentUser) != null;
    final appSettingService = ref.watch(appSettingsServiceProvider);
    final isEnabled =
        useState(AppSettingsEnum.advancedTroubleshooting.defaultValue);
    final levelId = useState(AppSettingsEnum.logLevel.defaultValue);
    final preferRemote =
        useState(AppSettingsEnum.preferRemoteImage.defaultValue);
    final allowSelfSignedSSLCert =
        useState(AppSettingsEnum.allowSelfSignedSSLCert.defaultValue);

    useEffect(
      () {
        isEnabled.value = appSettingService.getSetting<bool>(
          AppSettingsEnum.advancedTroubleshooting,
        );
        levelId.value = appSettingService.getSetting(AppSettingsEnum.logLevel);
        preferRemote.value =
            appSettingService.getSetting(AppSettingsEnum.preferRemoteImage);
        allowSelfSignedSSLCert.value = appSettingService
            .getSetting(AppSettingsEnum.allowSelfSignedSSLCert);
        return null;
      },
      [],
    );

    final logLevel = Level.LEVELS[levelId.value].name;

    return ExpansionTile(
      textColor: context.primaryColor,
      title: Text(
        "advanced_settings_tile_title",
        style: context.textTheme.titleMedium,
      ).tr(),
      subtitle: const Text(
        "advanced_settings_tile_subtitle",
      ).tr(),
      children: [
        SettingsSwitchListTile(
          enabled: true,
          appSettingService: appSettingService,
          valueNotifier: isEnabled,
          settingsEnum: AppSettingsEnum.advancedTroubleshooting,
          title: "advanced_settings_troubleshooting_title".tr(),
          subtitle: "advanced_settings_troubleshooting_subtitle".tr(),
        ),
        ListTile(
          dense: true,
          title: const Text(
            "advanced_settings_log_level_title",
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(args: [logLevel]),
          subtitle: Slider(
            value: levelId.value.toDouble(),
            onChanged: (double v) => levelId.value = v.toInt(),
            onChangeEnd: (double v) {
              appSettingService.setSetting(
                AppSettingsEnum.logLevel,
                v.toInt(),
              );
              ImmichLogger().level = Level.LEVELS[v.toInt()];
            },
            max: 8,
            min: 1.0,
            divisions: 7,
            label: logLevel,
            activeColor: context.primaryColor,
          ),
        ),
        SettingsSwitchListTile(
          appSettingService: appSettingService,
          valueNotifier: preferRemote,
          settingsEnum: AppSettingsEnum.preferRemoteImage,
          title: "advanced_settings_prefer_remote_title".tr(),
          subtitle: "advanced_settings_prefer_remote_subtitle".tr(),
        ),
        SettingsSwitchListTile(
          enabled: !isLoggedIn,
          appSettingService: appSettingService,
          valueNotifier: allowSelfSignedSSLCert,
          settingsEnum: AppSettingsEnum.allowSelfSignedSSLCert,
          title: "advanced_settings_self_signed_ssl_title".tr(),
          subtitle: "advanced_settings_self_signed_ssl_subtitle".tr(),
          onChanged: (value) {
            HttpOverrides.global = HttpSSLCertOverride();
          },
        ),
      ],
    );
  }
}

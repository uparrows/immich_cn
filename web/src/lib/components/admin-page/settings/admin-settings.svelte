<svelte:options accessors />

<script lang="ts">
  import { type SystemConfigDto, api } from '@api';
  import {
    notificationController,
    NotificationType,
  } from '$lib/components/shared-components/notification/notification';
  import { handleError } from '$lib/utils/handle-error';
  import type { SettingsEventType } from './admin-settings';
  import { createEventDispatcher, onMount } from 'svelte';

  export let config: SystemConfigDto;

  let savedConfig: SystemConfigDto;
  let defaultConfig: SystemConfigDto;

  const dispatch = createEventDispatcher<{ save: void }>();

  const handleReset = async (detail: SettingsEventType['reset']) => {
    if (detail.default) {
      await resetToDefault(detail.configKeys);
    } else {
      await reset(detail.configKeys);
    }
  };

  const handleSave = async (config: Partial<SystemConfigDto>) => {
    try {
      const result = await api.systemConfigApi.updateConfig({
        systemConfigDto: {
          ...savedConfig,
          ...config,
        },
      });

      savedConfig = { ...result.data };
      notificationController.show({ message: '设置已保存', type: NotificationType.Info });

      dispatch('save');
    } catch (error) {
      handleError(error, '无法保存设置');
    }
  };

  const reset = async (configKeys: Array<keyof SystemConfigDto>) => {
    const { data: resetConfig } = await api.systemConfigApi.getConfig();
    config = configKeys.reduce((acc, key) => ({ ...acc, [key]: resetConfig[key] }), config);

    notificationController.show({
      message: '将设置重置为最近保存的值',
      type: NotificationType.Info,
    });
  };

  const resetToDefault = async (configKeys: Array<keyof SystemConfigDto>) => {
    config = configKeys.reduce((acc, key) => ({ ...acc, [key]: defaultConfig[key] }), config);

    notificationController.show({
      message: '将设置重置为默认值',
      type: NotificationType.Info,
    });
  };

  onMount(async () => {
    [savedConfig, defaultConfig] = await Promise.all([
      api.systemConfigApi.getConfig().then((res) => res.data),
      api.systemConfigApi.getConfigDefaults().then((res) => res.data),
    ]);
  });
</script>

{#if savedConfig && defaultConfig}
  <slot {handleReset} {handleSave} {savedConfig} {defaultConfig} />
{/if}

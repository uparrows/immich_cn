<script lang="ts">
  import { page } from '$app/stores';
  import FFmpegSettings from '$lib/components/admin-page/settings/ffmpeg/ffmpeg-settings.svelte';
  import JobSettings from '$lib/components/admin-page/settings/job-settings/job-settings.svelte';
  import MachineLearningSettings from '$lib/components/admin-page/settings/machine-learning-settings/machine-learning-settings.svelte';
  import MapSettings from '$lib/components/admin-page/settings/map-settings/map-settings.svelte';
  import OAuthSettings from '$lib/components/admin-page/settings/oauth/oauth-settings.svelte';
  import PasswordLoginSettings from '$lib/components/admin-page/settings/password-login/password-login-settings.svelte';
  import SettingAccordion from '$lib/components/admin-page/settings/setting-accordion.svelte';
  import StorageTemplateSettings from '$lib/components/admin-page/settings/storage-template/storage-template-settings.svelte';
  import ThumbnailSettings from '$lib/components/admin-page/settings/thumbnail/thumbnail-settings.svelte';
  import ServerSettings from '$lib/components/admin-page/settings/server/server-settings.svelte';
  import TrashSettings from '$lib/components/admin-page/settings/trash-settings/trash-settings.svelte';
  import ThemeSettings from '$lib/components/admin-page/settings/theme/theme-settings.svelte';
  import LinkButton from '$lib/components/elements/buttons/link-button.svelte';
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import { downloadManager } from '$lib/stores/download';
  import { featureFlags } from '$lib/stores/server-config.store';
  import { downloadBlob } from '$lib/utils/asset-utils';
  import { SystemConfigDto, copyToClipboard } from '@api';
  import Icon from '$lib/components/elements/icon.svelte';
  import type { PageData } from './$types';
  import NewVersionCheckSettings from '$lib/components/admin-page/settings/new-version-check-settings/new-version-check-settings.svelte';
  import LibrarySettings from '$lib/components/admin-page/settings/library-settings/library-settings.svelte';
  import LoggingSettings from '$lib/components/admin-page/settings/logging-settings/logging-settings.svelte';
  import { mdiAlert, mdiContentCopy, mdiDownload } from '@mdi/js';
  import _ from 'lodash';
  import AdminSettings from '$lib/components/admin-page/settings/admin-settings.svelte';

  export let data: PageData;

  let config = data.configs;
  let openSettings = ($page.url.searchParams.get('open')?.split(',') || []) as Array<keyof SystemConfigDto>;

  const downloadConfig = () => {
    const blob = new Blob([JSON.stringify(config, null, 2)], { type: 'application/json' });
    const downloadKey = 'immich-config.json';
    downloadManager.add(downloadKey, blob.size);
    downloadManager.update(downloadKey, blob.size);
    downloadBlob(blob, downloadKey);
    setTimeout(() => downloadManager.clear(downloadKey), 5_000);
  };

  const settings = [
    {
      item: JobSettings,
      title: '作业设定',
      subtitle: '管理作业并发',
      isOpen: openSettings.includes('job'),
    },
    {
      item: LibrarySettings,
      title: '资源库',
      subtitle: '管理资源库设置',
      isOpen: openSettings.includes('library'),
    },
    {
      item: LoggingSettings,
      title: '登录',
      subtitle: '管理登录设置',
      isOpen: openSettings.includes('logging'),
    },
    {
      item: MachineLearningSettings,
      title: '机器学习设置',
      subtitle: '管理机器学习功能和设置',
      isOpen: openSettings.includes('machineLearning'),
    },
    {
      item: MapSettings,
      title: '地图和GPS设置',
      subtitle: '管理地图相关功能和设置',
      isOpen: openSettings.some((key) => ['map', 'reverseGeocoding'].includes(key)),
    },
    {
      item: OAuthSettings,
      title: 'OAuth认证',
      subtitle: '管理OAuth登录',
      isOpen: openSettings.includes('oauth'),
    },
    {
      item: PasswordLoginSettings,
      title: '密码认证',
      subtitle: '使用密码设置管理登录',
      isOpen: openSettings.includes('passwordLogin'),
    },
    {
      item: ServerSettings,
      title: '服务器设置',
      subtitle: '管理服务器设置',
      isOpen: openSettings.includes('server'),
    },
    {
      item: StorageTemplateSettings,
      title: '存储模板',
      subtitle: '管理上传资源的文件夹结构和文件名',
      isOpen: openSettings.includes('storageTemplate'),
    },
    {
      item: ThemeSettings,
      title: '主题设置',
      subtitle: '管理 Immich 网络界面的定制',
      isOpen: openSettings.includes('theme'),
    },
    {
      item: ThumbnailSettings,
      title: '缩略图设置',
      subtitle: '管理缩略图大小的分辨率',
      isOpen: openSettings.includes('thumbnail'),
    },
    {
      item: TrashSettings,
      title: '回收站设置',
      subtitle: '管理回收站设置',
      isOpen: openSettings.includes('trash'),
    },
    {
      item: NewVersionCheckSettings,
      title: '版本检查',
      subtitle: '启用/禁用新版本通知',
      isOpen: openSettings.includes('newVersionCheck'),
    },
    {
      item: FFmpegSettings,
      title: '视频转码设置',
      subtitle: '管理视频文件的分辨率和编码信息',
      isOpen: openSettings.includes('ffmpeg'),
    },
  ];
</script>

{#if $featureFlags.configFile}
  <div class="mb-8 flex flex-row items-center gap-2 rounded-md bg-gray-100 p-3 dark:bg-gray-800">
    <Icon path={mdiAlert} class="text-yellow-400" size={18} />
    <h2 class="text-md text-immich-primary dark:text-immich-dark-primary">配置当前由配置文件设置</h2>
  </div>
{/if}

<UserPageLayout title={data.meta.title} admin>
  <div class="flex justify-end gap-2" slot="buttons">
    <LinkButton on:click={() => copyToClipboard(JSON.stringify(config, null, 2))}>
      <div class="flex place-items-center gap-2 text-sm">
        <Icon path={mdiContentCopy} size="18" />
        复制到剪贴板
      </div>
    </LinkButton>
    <LinkButton on:click={() => downloadConfig()}>
      <div class="flex place-items-center gap-2 text-sm">
        <Icon path={mdiDownload} size="18" />
        导出为 JSON
      </div>
    </LinkButton>
  </div>

  <AdminSettings bind:config let:handleReset let:handleSave let:savedConfig let:defaultConfig>
    <section id="setting-content" class="flex place-content-center sm:mx-4">
      <section class="w-full pb-28 sm:w-5/6 md:w-[850px]">
        {#each settings as { item, title, subtitle, isOpen }}
          <SettingAccordion {title} {subtitle} {isOpen}>
            <svelte:component
              this={item}
              on:save={({ detail }) => handleSave(detail)}
              on:reset={({ detail }) => handleReset(detail)}
              disabled={$featureFlags.configFile}
              {defaultConfig}
              {config}
              {savedConfig}
            />
          </SettingAccordion>
        {/each}
      </section>
    </section>
  </AdminSettings>
</UserPageLayout>

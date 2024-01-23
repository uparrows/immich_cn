<script lang="ts">
  import OnboardingCard from './onboarding-card.svelte';
  import { createEventDispatcher, onMount } from 'svelte';
  import { featureFlags } from '$lib/stores/server-config.store';
  import StorageTemplateSettings from '../admin-page/settings/storage-template/storage-template-settings.svelte';
  import { type SystemConfigDto, api } from '@api';
  import { user } from '$lib/stores/user.store';
  import AdminSettings from '../admin-page/settings/admin-settings.svelte';
  import { mdiArrowLeft, mdiCheck } from '@mdi/js';
  import Button from '../elements/buttons/button.svelte';
  import Icon from '../elements/icon.svelte';

  const dispatch = createEventDispatcher<{
    done: void;
    previous: void;
  }>();

  let config: SystemConfigDto | null = null;

  onMount(async () => {
    const { data } = await api.systemConfigApi.getConfig();
    config = data;
  });
</script>

<OnboardingCard>
  <p class="text-xl text-immich-primary dark:text-immich-dark-primary">存储模板</p>

  <p>
    存储模板用于确定媒体文件的文件夹结构和文件名。
    您可以根据您的喜好使用变量自定义模板。
  </p>

  {#if config && $user}
    <AdminSettings bind:config let:defaultConfig let:savedConfig let:handleSave let:handleReset>
      <StorageTemplateSettings
        minified
        disabled={$featureFlags.configFile}
        {config}
        {defaultConfig}
        {savedConfig}
        on:save={({ detail }) => handleSave(detail)}
        on:reset={({ detail }) => handleReset(detail)}
      >
        <div class="flex pt-4">
          <div class="w-full flex place-content-start">
            <Button class="flex gap-2 place-content-center" on:click={() => dispatch('previous')}>
              <Icon path={mdiArrowLeft} size="18" />
              <p>主题</p>
            </Button>
          </div>
          <div class="flex w-full place-content-end">
            <Button
              on:click={() => {
                handleSave({ storageTemplate: config?.storageTemplate });
                dispatch('done');
              }}
            >
              <span class="flex place-content-center place-items-center gap-2">
                完成
                <Icon path={mdiCheck} size="18" />
              </span>
            </Button>
          </div>
        </div>
      </StorageTemplateSettings>
    </AdminSettings>
  {/if}
</OnboardingCard>

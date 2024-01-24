<script lang="ts">
  import { api, SystemConfigDto, SystemConfigTemplateStorageOptionDto } from '@api';
  import * as luxon from 'luxon';
  import handlebar from 'handlebars';
  import LoadingSpinner from '$lib/components/shared-components/loading-spinner.svelte';
  import { fade } from 'svelte/transition';
  import SupportedDatetimePanel from './supported-datetime-panel.svelte';
  import SupportedVariablesPanel from './supported-variables-panel.svelte';
  import SettingButtonsRow from '../setting-buttons-row.svelte';
  import { isEqual } from 'lodash-es';
  import SettingInputField, { SettingInputFieldType } from '../setting-input-field.svelte';
  import { user } from '$lib/stores/user.store';
  import { createEventDispatcher } from 'svelte';
  import SettingSwitch from '../setting-switch.svelte';
  import type { SettingsEventType } from '../admin-settings';

  export let savedConfig: SystemConfigDto;
  export let defaultConfig: SystemConfigDto;
  export let config: SystemConfigDto; // this is the config that is being edited
  export let disabled = false;
  export let minified = false;

  const dispatch = createEventDispatcher<SettingsEventType>();
  let templateOptions: SystemConfigTemplateStorageOptionDto;
  let selectedPreset = '';

  const getTemplateOptions = async () => {
    templateOptions = await api.systemConfigApi.getStorageTemplateOptions().then((res) => res.data);
    selectedPreset = savedConfig.storageTemplate.template;
  };

  const getSupportDateTimeFormat = async () => {
    const { data } = await api.systemConfigApi.getStorageTemplateOptions();
    return data;
  };

  $: parsedTemplate = () => {
    try {
      return renderTemplate(config.storageTemplate.template);
    } catch (error) {
      return 'error';
    }
  };

  const renderTemplate = (templateString: string) => {
    const template = handlebar.compile(templateString, {
      knownHelpers: undefined,
    });

    const substitutions: Record<string, string> = {
      filename: 'IMAGE_56437',
      ext: 'jpg',
      filetype: 'IMG',
      filetypefull: 'IMAGE',
      assetId: 'a8312960-e277-447d-b4ea-56717ccba856',
      album: 'Album Name',
    };

    const dt = luxon.DateTime.fromISO(new Date('2022-02-03T04:56:05.250').toISOString());

    const dateTokens = [
      ...templateOptions.yearOptions,
      ...templateOptions.monthOptions,
      ...templateOptions.weekOptions,
      ...templateOptions.dayOptions,
      ...templateOptions.hourOptions,
      ...templateOptions.minuteOptions,
      ...templateOptions.secondOptions,
    ];

    for (const token of dateTokens) {
      substitutions[token] = dt.toFormat(token);
    }

    return template(substitutions);
  };

  const handlePresetSelection = () => {
    config.storageTemplate.template = selectedPreset;
  };
</script>

<section class="dark:text-immich-dark-fg">
  {#await getTemplateOptions() then}
    <div id="directory-path-builder" class="flex flex-col gap-4 {minified ? '' : 'ml-4 mt-4'}">
      <SettingSwitch
        title="启用"
        {disabled}
        subtitle="启用存储模板引擎"
        bind:checked={config.storageTemplate.enabled}
        isEdited={!(config.storageTemplate.enabled === savedConfig.storageTemplate.enabled)}
      />

      {#if !minified}
        <SettingSwitch
          title="HASH VERIFICATION ENABLED"
          {disabled}
          subtitle="启用哈希验证，除非您确定其含义，否则请勿禁用此功能"
          bind:checked={config.storageTemplate.hashVerificationEnabled}
          isEdited={!(
            config.storageTemplate.hashVerificationEnabled === savedConfig.storageTemplate.hashVerificationEnabled
          )}
        />
      {/if}

      {#if config.storageTemplate.enabled}
        <hr />

        <h3 class="text-base font-medium text-immich-primary dark:text-immich-dark-primary">变量</h3>

        <section class="support-date">
          {#await getSupportDateTimeFormat()}
            <LoadingSpinner />
          {:then options}
            <div transition:fade={{ duration: 200 }}>
              <SupportedDatetimePanel {options} />
            </div>
          {/await}
        </section>

        <section class="support-date">
          <SupportedVariablesPanel />
        </section>

        <div class="flex flex-col mt-4">
          <h3 class="text-base font-medium text-immich-primary dark:text-immich-dark-primary">模板</h3>

          <div class="my-2 text-sm">
            <h4>预览</h4>
          </div>

          <p class="text-sm">
            路径长度限制 : <span
              class="font-semibold text-immich-primary dark:text-immich-dark-primary"
              >{parsedTemplate().length + $user.id.length + 'UPLOAD_LOCATION'.length}</span
            >/260
          </p>

          <p class="text-sm">
            <code class="text-immich-primary dark:text-immich-dark-primary">{$user.storageLabel || $user.id}</code> 是
            用户的存储标签
          </p>

          <p class="p-4 py-2 mt-2 text-xs bg-gray-200 rounded-lg dark:bg-gray-700 dark:text-immich-dark-fg">
            <span class="text-immich-fg/25 dark:text-immich-dark-fg/50"
              >UPLOAD_LOCATION/{$user.storageLabel || $user.id}</span
            >/{parsedTemplate()}.jpg
          </p>

          <form autocomplete="off" class="flex flex-col" on:submit|preventDefault>
            <div class="flex flex-col my-2">
              <label class="text-sm" for="preset-select">PRESET</label>
              <select
                class="immich-form-input p-2 mt-2 text-sm rounded-lg bg-slate-200 hover:cursor-pointer dark:bg-gray-600"
                disabled={disabled || !config.storageTemplate.enabled}
                name="presets"
                id="preset-select"
                bind:value={selectedPreset}
                on:change={handlePresetSelection}
              >
                {#each templateOptions.presetOptions as preset}
                  <option value={preset}>{renderTemplate(preset)}</option>
                {/each}
              </select>
            </div>
            <div class="flex gap-2 align-bottom">
              <SettingInputField
                label="TEMPLATE"
                disabled={disabled || !config.storageTemplate.enabled}
                required
                inputType={SettingInputFieldType.TEXT}
                bind:value={config.storageTemplate.template}
                isEdited={!(config.storageTemplate.template === savedConfig.storageTemplate.template)}
              />

              <div class="flex-0">
                <SettingInputField label="EXTENSION" inputType={SettingInputFieldType.TEXT} value={'.jpg'} disabled />
              </div>
            </div>

            {#if !minified}
              <div id="migration-info" class="mt-2 text-sm">
                <h3 class="text-base font-medium text-immich-primary dark:text-immich-dark-primary">提示</h3>
                <section class="flex flex-col gap-2">
                  <p>
                    模板更改仅适用于新资源。 要将模板追溯应用到之前
                    上传的资产，请运行
                    <a href="/admin/jobs-status" class="text-immich-primary dark:text-immich-dark-primary"
                      >存储迁移作业</a
                    >.
                  </p>
                  <p>
                    新资源的模板变量 <span class="font-mono">{`{{album}}`}</span> 将始终为空，
                    因此手动运行

                    <a href="/admin/jobs-status" class="text-immich-primary dark:text-immich-dark-primary"
                      >存储迁移作业</a
                    >
                    是必要的，为了成功使用该变量.
                  </p>
                </section>
              </div>
            {/if}
          </form>
        </div>
      {/if}

      {#if minified}
        <slot />
      {:else}
        <SettingButtonsRow
          on:reset={({ detail }) => dispatch('reset', { ...detail, configKeys: ['storageTemplate'] })}
          on:save={() => dispatch('save', { storageTemplate: config.storageTemplate })}
          showResetToDefault={!isEqual(savedConfig, defaultConfig) && !minified}
          {disabled}
        />
      {/if}
    </div>
  {/await}
</section>

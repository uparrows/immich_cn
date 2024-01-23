<script lang="ts">
  import type { SystemConfigDto } from '@api';
  import { isEqual } from 'lodash-es';
  import { createEventDispatcher } from 'svelte';
  import { fade } from 'svelte/transition';
  import type { SettingsEventType } from '../admin-settings';
  import SettingButtonsRow from '../setting-buttons-row.svelte';
  import SettingInputField, { SettingInputFieldType } from '../setting-input-field.svelte';
  import SettingSwitch from '../setting-switch.svelte';

  export let savedConfig: SystemConfigDto;
  export let defaultConfig: SystemConfigDto;
  export let config: SystemConfigDto; // this is the config that is being edited
  export let disabled = false;

  const dispatch = createEventDispatcher<SettingsEventType>();
</script>

<div>
  <div in:fade={{ duration: 500 }}>
    <form autocomplete="off" on:submit|preventDefault>
      <div class="ml-4 mt-4 flex flex-col gap-4">
        <SettingSwitch
          title="启用"
          {disabled}
          subtitle="启用回收站功能"
          bind:checked={config.trash.enabled}
        />

        <hr />

        <SettingInputField
          inputType={SettingInputFieldType.NUMBER}
          label="Number of days"
          desc="Number of days to keep the assets in trash before permanently removing them"
          bind:value={config.trash.days}
          required={true}
          disabled={disabled || !config.trash.enabled}
          isEdited={config.trash.days !== savedConfig.trash.days}
        />

        <SettingButtonsRow
          on:reset={({ detail }) => dispatch('reset', { ...detail, configKeys: ['trash'] })}
          on:save={() => dispatch('save', { trash: config.trash })}
          showResetToDefault={!isEqual(savedConfig, defaultConfig)}
          {disabled}
        />
      </div>
    </form>
  </div>
</div>

<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import Button from '../elements/buttons/button.svelte';
  import FullScreenModal from '../shared-components/full-screen-modal.svelte';
  import Icon from '$lib/components/elements/icon.svelte';
  import { mdiFolderRemove } from '@mdi/js';

  export let exclusionPattern: string;
  export let canDelete = false;
  export let submitText = 'Submit';

  const dispatch = createEventDispatcher<{
    cancel: void;
    submit: { excludePattern: string };
    delete: void;
  }>();
  const handleCancel = () => dispatch('cancel');
  const handleSubmit = () => dispatch('submit', { excludePattern: exclusionPattern });
</script>

<FullScreenModal on:clickOutside={() => handleCancel()}>
  <div
    class="w-[500px] max-w-[95vw] rounded-3xl border bg-immich-bg p-4 py-8 shadow-sm dark:border-immich-dark-gray dark:bg-immich-dark-gray dark:text-immich-dark-fg"
  >
    <div
      class="flex flex-col place-content-center place-items-center gap-4 px-4 text-immich-primary dark:text-immich-dark-primary"
    >
      <Icon path={mdiFolderRemove} size="4em" />
      <h1 class="text-2xl font-medium text-immich-primary dark:text-immich-dark-primary">添加排除模式</h1>
    </div>

    <form on:submit|preventDefault={() => handleSubmit()} autocomplete="off">
      <p class="p-5 text-sm">
        排除模式允许您在扫描库时忽略文件和文件夹。 如果您的文件夹中包含
        您不想导入的文件（例如 RAW 文件），此功能非常有用。
        <br /><br />
        添加排除模式。 使用 *、** 和 ? 进行通配 是支持的。 要忽略任何名为“Raw”的目录中的所有文件，请使用“**/Raw/**”。
        要忽略所有以“.tif”结尾的文件，请使用“**/*.tif”。 要忽略绝对路径，请使用“/path/to/ignore”
      </p>
      <div class="m-4 flex flex-col gap-2">
        <label class="immich-form-label" for="exclusionPattern">模式</label>
        <input
          class="immich-form-input"
          id="exclusionPattern"
          name="exclusionPattern"
          type="text"
          bind:value={exclusionPattern}
        />
      </div>
      <div class="mt-8 flex w-full gap-4 px-4">
        <Button color="gray" fullwidth on:click={() => handleCancel()}>取消</Button>
        {#if canDelete}
          <Button color="red" fullwidth on:click={() => dispatch('delete')}>删除</Button>
        {/if}

        <Button type="submit" fullwidth>{submitText}</Button>
      </div>
    </form>
  </div>
</FullScreenModal>

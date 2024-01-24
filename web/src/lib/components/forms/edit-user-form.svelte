<script lang="ts">
  import { api, UserResponseDto } from '@api';
  import { createEventDispatcher } from 'svelte';
  import { notificationController, NotificationType } from '../shared-components/notification/notification';
  import Button from '../elements/buttons/button.svelte';
  import ConfirmDialogue from '$lib/components/shared-components/confirm-dialogue.svelte';
  import Icon from '$lib/components/elements/icon.svelte';
  import { mdiAccountEditOutline, mdiClose } from '@mdi/js';
  import { AppRoute } from '$lib/constants';
  import CircleIconButton from '../elements/buttons/circle-icon-button.svelte';
  import { handleError } from '$lib/utils/handle-error';
  import { convertFromBytes, convertToBytes } from '$lib/utils/byte-converter';

  export let user: UserResponseDto;
  export let canResetPassword = true;

  let error: string;
  let success: string;

  let isShowResetPasswordConfirmation = false;

  const dispatch = createEventDispatcher<{
    close: void;
    resetPasswordSuccess: void;
    editSuccess: void;
  }>();

  let quotaSize = user.quotaSizeInBytes ? convertFromBytes(user.quotaSizeInBytes, 'GiB') : null;

  const editUser = async () => {
    try {
      const { id, email, name, storageLabel, externalPath } = user;
      const { status } = await api.userApi.updateUser({
        updateUserDto: {
          id,
          email,
          name,
          storageLabel: storageLabel || '',
          externalPath: externalPath || '',
          quotaSizeInBytes: quotaSize ? convertToBytes(Number(quotaSize), 'GiB') : null,
        },
      });

      if (status === 200) {
        dispatch('editSuccess');
      }
    } catch (error) {
      handleError(error, '无法更新用户');
    }
  };

  const resetPassword = async () => {
    try {
      const defaultPassword = 'password';

      const { status } = await api.userApi.updateUser({
        updateUserDto: {
          id: user.id,
          password: defaultPassword,
          shouldChangePassword: true,
        },
      });

      if (status == 200) {
        dispatch('resetPasswordSuccess');
      }
    } catch (e) {
      console.error('重置用户密码时出错', e);
      notificationController.show({
        message: '重置用户密码时出错，请检查控制台以获取更多详细信息',
        type: NotificationType.Error,
      });
    } finally {
      isShowResetPasswordConfirmation = false;
    }
  };
</script>

<div
  class="relative max-h-screen w-[500px] max-w-[95vw] overflow-y-auto rounded-3xl border bg-immich-bg p-4 py-8 shadow-sm dark:border-immich-dark-gray dark:bg-immich-dark-gray dark:text-immich-dark-fg"
>
  <div class="absolute top-0 right-0 px-2 py-2 h-fit">
    <CircleIconButton icon={mdiClose} on:click={() => dispatch('close')} />
  </div>

  <div
    class="flex flex-col place-content-center place-items-center gap-4 px-4 text-immich-primary dark:text-immich-dark-primary"
  >
    <Icon path={mdiAccountEditOutline} size="4em" />
    <h1 class="text-2xl font-medium text-immich-primary dark:text-immich-dark-primary">修改用户</h1>
  </div>

  <form on:submit|preventDefault={editUser} autocomplete="off">
    <div class="m-4 flex flex-col gap-2">
      <label class="immich-form-label" for="email">邮件</label>
      <input class="immich-form-input" id="email" name="email" type="email" bind:value={user.email} />
    </div>

    <div class="m-4 flex flex-col gap-2">
      <label class="immich-form-label" for="name">名称</label>
      <input class="immich-form-input" id="name" name="name" type="text" required bind:value={user.name} />
    </div>

    <div class="m-4 flex flex-col gap-2">
      <label class="immich-form-label" for="quotaSize">配额 (GiB)</label>
      <input class="immich-form-input" id="quotaSize" name="quotaSize" type="number" min="0" bind:value={quotaSize} />
      <p>Note: Enter 0 for unlimited quota</p>
    </div>

    <div class="m-4 flex flex-col gap-2">
      <label class="immich-form-label" for="storage-label">存储标签</label>
      <input
        class="immich-form-input"
        id="storage-label"
        name="storage-label"
        type="text"
        bind:value={user.storageLabel}
      />

      <p>
        注意：要将存储标签应用于之前上传的资源，请运行
        <a href={AppRoute.ADMIN_JOBS} class="text-immich-primary dark:text-immich-dark-primary">
          存储迁移任务</a
        >
      </p>
    </div>

    <div class="m-4 flex flex-col gap-2">
      <label class="immich-form-label" for="external-path">外部路径</label>
      <input
        class="immich-form-input"
        id="external-path"
        name="external-path"
        type="text"
        bind:value={user.externalPath}
      />

      <p>
        注意：父导入目录的绝对路径。 用户只能导入位于此位置或下的
        文件.
      </p>
    </div>

    {#if error}
      <p class="ml-4 text-sm text-red-400">{error}</p>
    {/if}

    {#if success}
      <p class="ml-4 text-sm text-immich-primary">{success}</p>
    {/if}
    <div class="mt-8 flex w-full gap-4 px-4">
      {#if canResetPassword}
        <Button color="light-red" fullwidth on:click={() => (isShowResetPasswordConfirmation = true)}
          >重置密码</Button
        >
      {/if}
      <Button type="submit" fullwidth>确认</Button>
    </div>
  </form>
</div>

{#if isShowResetPasswordConfirmation}
  <ConfirmDialogue
    title="重置密码"
    confirmText="重置"
    on:confirm={resetPassword}
    on:cancel={() => (isShowResetPasswordConfirmation = false)}
  >
    <svelte:fragment slot="prompt">
      <p>
        您确定要重置 <b>{user.name}</b>的密码吗?
      </p>
    </svelte:fragment>
  </ConfirmDialogue>
{/if}

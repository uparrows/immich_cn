<script lang="ts">
  import UserPageLayout from '$lib/components/layouts/user-page-layout.svelte';
  import DeleteAssets from '$lib/components/photos-page/actions/delete-assets.svelte';
  import RestoreAssets from '$lib/components/photos-page/actions/restore-assets.svelte';
  import SelectAllAssets from '$lib/components/photos-page/actions/select-all-assets.svelte';
  import AssetGrid from '$lib/components/photos-page/asset-grid.svelte';
  import AssetSelectControlBar from '$lib/components/photos-page/asset-select-control-bar.svelte';
  import EmptyPlaceholder from '$lib/components/shared-components/empty-placeholder.svelte';
  import { AppRoute } from '$lib/constants';
  import { createAssetInteractionStore } from '$lib/stores/asset-interaction.store';
  import { handleError } from '$lib/utils/handle-error';
  import {
    NotificationType,
    notificationController,
  } from '$lib/components/shared-components/notification/notification';
  import LinkButton from '$lib/components/elements/buttons/link-button.svelte';
  import { AssetStore } from '$lib/stores/assets.store';
  import { api } from '@api';
  import Icon from '$lib/components/elements/icon.svelte';
  import type { PageData } from './$types';
  import { featureFlags, serverConfig } from '$lib/stores/server-config.store';
  import { goto } from '$app/navigation';
  import empty3Url from '$lib/assets/empty-3.svg';
  import ConfirmDialogue from '$lib/components/shared-components/confirm-dialogue.svelte';
  import { mdiDeleteOutline, mdiHistory } from '@mdi/js';
  import UpdatePanel from '$lib/components/shared-components/update-panel.svelte';

  export let data: PageData;

  $: $featureFlags.trash || goto(AppRoute.PHOTOS);

  const assetStore = new AssetStore({ isTrashed: true });
  const assetInteractionStore = createAssetInteractionStore();
  const { isMultiSelectState, selectedAssets } = assetInteractionStore;
  let isShowEmptyConfirmation = false;

  const handleEmptyTrash = async () => {
    isShowEmptyConfirmation = false;
    try {
      await api.assetApi.emptyTrash();

      notificationController.show({
        message: `已清空回收站，刷新页面即可看到变化`,
        type: NotificationType.Info,
      });
    } catch (e) {
      handleError(e, '清空回收站时出错');
    }
  };

  const handleRestoreTrash = async () => {
    try {
      await api.assetApi.restoreTrash();

      notificationController.show({
        message: `已还原回收站项，刷新页面即可看到变化`,
        type: NotificationType.Info,
      });
    } catch (e) {
      handleError(e, '还原回收站项时出错');
    }
  };
</script>

{#if $isMultiSelectState}
  <AssetSelectControlBar assets={$selectedAssets} clearSelect={() => assetInteractionStore.clearMultiselect()}>
    <SelectAllAssets {assetStore} {assetInteractionStore} />
    <DeleteAssets force onAssetDelete={(assetId) => assetStore.removeAsset(assetId)} />
    <RestoreAssets onRestore={(ids) => assetStore.removeAssets(ids)} />
  </AssetSelectControlBar>
{/if}

{#if $featureFlags.loaded && $featureFlags.trash}
  <UserPageLayout hideNavbar={$isMultiSelectState} title={data.meta.title} scrollbar={false}>
    <div class="flex place-items-center gap-2" slot="buttons">
      <LinkButton on:click={handleRestoreTrash}>
        <div class="flex place-items-center gap-2 text-sm">
          <Icon path={mdiHistory} size="18" />
          恢复全部
        </div>
      </LinkButton>
      <LinkButton on:click={() => (isShowEmptyConfirmation = true)}>
        <div class="flex place-items-center gap-2 text-sm">
          <Icon path={mdiDeleteOutline} size="18" />
          清空回收站
        </div>
      </LinkButton>
    </div>

    <AssetGrid {assetStore} {assetInteractionStore}>
      <p class="font-medium text-gray-500/60 dark:text-gray-300/60 p-4">
        已删除的项目将在 {$serverConfig.trashDays} 天后被永久删除.
      </p>
      <EmptyPlaceholder
        text="已删除的照片和视频将显示在此处."
        alt="清空回收站"
        slot="empty"
        src={empty3Url}
      />
    </AssetGrid>
  </UserPageLayout>
{/if}

{#if isShowEmptyConfirmation}
  <ConfirmDialogue
    title="清空回收站"
    confirmText="清空"
    on:confirm={handleEmptyTrash}
    on:cancel={() => (isShowEmptyConfirmation = false)}
  >
    <svelte:fragment slot="prompt">
      <p>您确定要清空回收站吗？ 这将从 Immich 中永久删除回收站的所有资源。</p>
      <p><b>您无法撤消此操作!</b></p>
    </svelte:fragment>
  </ConfirmDialogue>
{/if}
<UpdatePanel {assetStore} />

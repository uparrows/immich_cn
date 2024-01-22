<script lang="ts">
  import CircleIconButton from '../elements/buttons/circle-icon-button.svelte';
  import { createEventDispatcher } from 'svelte';
  import FullScreenModal from './full-screen-modal.svelte';
  import { mdiClose, mdiInformationOutline } from '@mdi/js';
  import Icon from '../elements/icon.svelte';

  interface Shortcuts {
    general: ExplainedShortcut[];
    actions: ExplainedShortcut[];
  }

  interface ExplainedShortcut {
    key: string[];
    action: string;
    info?: string;
  }

  const shortcuts: Shortcuts = {
    general: [
      { key: ['←', '→'], action: '上一张或下一张照片' },
      { key: ['Esc'], action: '返回、关闭或取消选择' },
      { key: ['/'], action: '搜索您的照片' },
    ],
    actions: [
      { key: ['f'], action: '收藏或取消收藏照片' },
      { key: ['i'], action: '显示或隐藏信息' },
      { key: ['⇧', 'a'], action: '归档或取消归档' },
      { key: ['⇧', 'd'], action: '下载' },
      { key: ['Space'], action: '播放或暂停视频' },
      { key: ['Del'], action: '删除/删除资源', info: '点击 ⇧ 以永久删除' },
    ],
  };
  const dispatch = createEventDispatcher<{
    close: void;
  }>();
</script>

<FullScreenModal on:clickOutside={() => dispatch('close')} on:escape={() => dispatch('close')}>
  <div class="flex h-full w-full place-content-center place-items-center overflow-hidden">
    <div
      class="w-[400px] max-w-[125vw] rounded-3xl border bg-immich-bg shadow-sm dark:border-immich-dark-gray dark:bg-immich-dark-gray dark:text-immich-dark-fg md:w-[650px]"
    >
      <div class="relative px-4 pt-4">
        <h1 class="px-4 py-4 font-medium text-immich-primary dark:text-immich-dark-primary">键盘快捷键</h1>
        <div class="absolute inset-y-0 right-0 px-4 py-4">
          <CircleIconButton icon={mdiClose} on:click={() => dispatch('close')} />
        </div>
      </div>

      <div class="grid grid-cols-1 gap-4 px-4 pb-4 md:grid-cols-2">
        <div class="px-4 py-4">
          <h2>一般</h2>
          <div class="text-sm">
            {#each shortcuts.general as shortcut}
              <div class="grid grid-cols-[20%_80%] items-center gap-4 pt-4 text-sm">
                <div class="flex justify-self-end">
                  {#each shortcut.key as key}
                    <p
                      class="mr-1 flex items-center justify-center justify-self-end rounded-lg bg-immich-primary/25 p-2"
                    >
                      {key}
                    </p>
                  {/each}
                </div>
                <p class="mb-1 mt-1 flex">{shortcut.action}</p>
              </div>
            {/each}
          </div>
        </div>

        <div class="px-4 py-4">
          <h2>动作</h2>
          <div class="text-sm">
            {#each shortcuts.actions as shortcut}
              <div class="grid grid-cols-[20%_80%] items-center gap-4 pt-4 text-sm">
                <div class="flex justify-self-end">
                  {#each shortcut.key as key}
                    <p
                      class="mr-1 flex items-center justify-center justify-self-end rounded-lg bg-immich-primary/25 p-2"
                    >
                      {key}
                    </p>
                  {/each}
                </div>
                <div class="flex items-center gap-2">
                  <p class="mb-1 mt-1 flex">{shortcut.action}</p>
                  {#if shortcut.info}
                    <Icon path={mdiInformationOutline} title={shortcut.info} />
                  {/if}
                </div>
              </div>
            {/each}
          </div>
        </div>
      </div>
    </div>
  </div>
</FullScreenModal>

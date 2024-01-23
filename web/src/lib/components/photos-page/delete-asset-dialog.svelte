<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import ConfirmDialogue from '../shared-components/confirm-dialogue.svelte';
  import { showDeleteModal } from '$lib/stores/preferences.store';

  export let size: number;

  let checked = false;

  const dispatch = createEventDispatcher<{
    confirm: void;
    cancel: void;
  }>();

  const onToggle = () => {
    checked = !checked;
  };

  const handleConfirm = () => {
    if (checked) {
      $showDeleteModal = false;
    }
    dispatch('confirm');
  };
</script>

<ConfirmDialogue
  title="永久删除资源{size > 1 ? 's' : ''}"
  confirmText="删除"
  on:confirm={handleConfirm}
  on:cancel={() => dispatch('cancel')}
  on:escape={() => dispatch('cancel')}
>
  <svelte:fragment slot="prompt">
    <p>
      您确定要永久删除
      {#if size > 1}
        这些 <b>{size}</b> 资源? 这也会将他们从相册中删除.
      {:else}
        该资源? 这也会将他们从相册中删除.
      {/if}
    </p>
    <p><b>您无法撤消此操作!</b></p>

    <div class="flex gap-2 items-center justify-center pt-4">
      <label id="confirm-label" for="confirm-input">不再显示此消息</label>
      <input
        id="confirm-input"
        aria-labelledby="confirm-input"
        class="disabled::cursor-not-allowed h-3 w-3 opacity-1"
        type="checkbox"
        bind:checked
        on:click={onToggle}
      />
    </div>
  </svelte:fragment>
</ConfirmDialogue>

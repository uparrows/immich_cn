<script lang="ts">
  import ConfirmDialogue from '$lib/components/shared-components/confirm-dialogue.svelte';
</script>

<ConfirmDialogue title="禁用日志" on:cancel on:confirm>
  <svelte:fragment slot="prompt">
    <div class="flex flex-col gap-4">
      <p>您确定要禁用所有日志方法吗？ 日志将被完全禁用.</p>
      <p>
        To re-enable, use a
        <a
          href="https://immich.app/docs/administration/server-commands"
          rel="noreferrer"
          target="_blank"
          class="underline"
        >
          服务器命令</a
        >.
      </p>
    </div>
  </svelte:fragment>
</ConfirmDialogue>

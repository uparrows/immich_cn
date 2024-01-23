<script lang="ts">
  import AdminRegistrationForm from '$lib/components/forms/admin-registration-form.svelte';
  import FullscreenContainer from '$lib/components/shared-components/fullscreen-container.svelte';
  import type { PageData } from './$types';

  export let data: PageData;
</script>

<FullscreenContainer title={data.meta.title}>
  <p slot="message">
    由于您是系统上的第一个用户，因此您将被指定为管理员并负责管理
    任务，其他用户将由您创建。
  </p>

  <AdminRegistrationForm />
</FullscreenContainer>

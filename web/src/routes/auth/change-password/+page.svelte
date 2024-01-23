<script lang="ts">
  import { goto } from '$app/navigation';
  import ChangePasswordForm from '$lib/components/forms/change-password-form.svelte';
  import FullscreenContainer from '$lib/components/shared-components/fullscreen-container.svelte';
  import { AppRoute } from '$lib/constants';
  import { user } from '$lib/stores/user.store';
  import type { PageData } from './$types';

  export let data: PageData;

  const onSuccessHandler = async () => {
    await fetch(AppRoute.AUTH_LOGOUT, { method: 'POST' });

    goto(AppRoute.AUTH_LOGIN);
  };
</script>

<FullscreenContainer title={data.meta.title}>
  <p slot="message">
    Hi {$user.name} ({$user.email}),
    <br />
    <br />
    这是您初次登录系统或已请求更改您的密码。请
    在下面输入新密码.
  </p>

  <ChangePasswordForm user={$user} on:success={onSuccessHandler} />
</FullscreenContainer>

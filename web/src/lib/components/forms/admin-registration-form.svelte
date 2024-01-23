<script lang="ts">
  import { goto } from '$app/navigation';
  import { AppRoute } from '$lib/constants';
  import { api } from '@api';
  import Button from '../elements/buttons/button.svelte';

  let error: string;
  let password = '';
  let confirmPassowrd = '';
  let canRegister = false;

  $: {
    if (password !== confirmPassowrd && confirmPassowrd.length > 0) {
      error = '密码不匹配';
      canRegister = false;
    } else {
      error = '';
      canRegister = true;
    }
  }

  async function registerAdmin(event: SubmitEvent & { currentTarget: HTMLFormElement }) {
    if (canRegister) {
      error = '';

      const form = new FormData(event.currentTarget);

      const email = form.get('email');
      const password = form.get('password');
      const name = form.get('name');

      const { status } = await api.authenticationApi.signUpAdmin({
        signUpDto: {
          email: String(email),
          password: String(password),
          name: String(name),
        },
      });

      if (status === 201) {
        await goto(AppRoute.AUTH_LOGIN);
        return;
      } else {
        error = '创建管理员帐户时出错';
        return;
      }
    }
  }
</script>

<form on:submit|preventDefault={registerAdmin} method="post" class="mt-5 flex flex-col gap-5">
  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="email">管理员邮箱</label>
    <input class="immich-form-input" id="email" name="email" type="email" autocomplete="email" required />
  </div>

  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="password">管理员密码</label>
    <input
      class="immich-form-input"
      id="password"
      name="password"
      type="password"
      autocomplete="new-password"
      required
      bind:value={password}
    />
  </div>

  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="confirmPassword">确认管理员密码</label>
    <input
      class="immich-form-input"
      id="confirmPassword"
      name="password"
      type="password"
      autocomplete="new-password"
      required
      bind:value={confirmPassowrd}
    />
  </div>

  <div class="flex flex-col gap-2">
    <label class="immich-form-label" for="name">名称</label>
    <input class="immich-form-input" id="name" name="name" type="text" autocomplete="name" required />
  </div>

  {#if error}
    <p class="text-red-400">{error}</p>
  {/if}

  <div class="my-5 flex w-full">
    <Button type="submit" size="lg" fullwidth>注册</Button>
  </div>
</form>

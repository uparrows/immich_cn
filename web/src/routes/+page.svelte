<script lang="ts">
  import Button from '$lib/components/elements/buttons/button.svelte';
  import ImmichLogo from '$lib/components/shared-components/immich-logo.svelte';
  import { AppRoute } from '$lib/constants';
</script>

<section class="flex h-screen w-screen place-content-center place-items-center">
  <div class="flex max-w-[350px] flex-col place-items-center gap-8 text-center">
    <div class="flex place-content-center place-items-center">
      <ImmichLogo class="text-center" height="200" width="200" />
    </div>
    <h1 class="font-immich-title text-4xl font-bold text-immich-primary dark:text-immich-dark-primary">
      欢迎来到 IMMICH 网站
    </h1>
    <a href={AppRoute.AUTH_REGISTER}>
      <Button size="lg" rounded="lg">
        <span class="px-2 font-bold">开始使用</span>
      </Button>
    </a>
  </div>
</section>

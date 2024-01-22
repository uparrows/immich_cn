/// <reference types="@sveltejs/kit" />

// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
declare namespace App {
  interface PageData {
    meta: {
      title: string;
      description?: string;
      imageUrl?: string;
    };
  }

  interface Error {
    message: string;
    stack?: string;
    code?: string | number;
  }
}

// Source: https://stackoverflow.com/questions/63814432/typescript-typing-of-non-standard-window-event-in-svelte
// To fix the <svelte:window... in components/asset-viewer/photo-viewer.svelte
declare namespace svelteHTML {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  interface HTMLAttributes<T> {
    'on:copyImage'?: () => void;
    'on:zoomImage'?: () => void;
  }
}

import { authenticate } from '$lib/utils/auth';
import type { PageLoad } from './$types';

export const load = (async () => {
  const user = await authenticate();
  return {
    user,
    meta: {
      title: '历史记录',
    },
  };
}) satisfies PageLoad;

import { authenticate } from '$lib/utils/auth';
import { api } from '@api';
import type { PageLoad } from './$types';

export const load = (async () => {
  await authenticate({ admin: true });
  const { data: stats } = await api.serverInfoApi.getServerStatistics();

  return {
    stats,
    meta: {
      title: '服务器计数',
    },
  };
}) satisfies PageLoad;

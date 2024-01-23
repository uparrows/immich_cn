import { authenticate } from '$lib/utils/auth';
import { api } from '@api';
import type { PageLoad } from './$types';

export const load = (async () => {
  await authenticate({ admin: true });

  const { data: jobs } = await api.jobApi.getAllJobsStatus();

  return {
    jobs,
    meta: {
      title: '工作状态',
    },
  };
}) satisfies PageLoad;

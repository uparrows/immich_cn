import { AppRoute } from '$lib/constants';
import { authenticate } from '$lib/utils/auth';
import { redirect } from '@sveltejs/kit';
import type { PageLoad } from './$types';
import { getSavedUser } from '$lib/stores/user.store';

export const load = (async () => {
  await authenticate();
  if (!getSavedUser().shouldChangePassword) {
    throw redirect(302, AppRoute.PHOTOS);
  }

  return {
    meta: {
      title: '修改密码',
    },
  };
}) satisfies PageLoad;

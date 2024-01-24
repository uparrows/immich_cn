import { AppRoute } from '$lib/constants';
import { redirect } from '@sveltejs/kit';
import type { PageLoad } from './$types';

export const load = (async () => {
  throw redirect(302, AppRoute.ADMIN_USER_MANAGEMENT);
}) satisfies PageLoad;

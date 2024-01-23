import { goto } from '$app/navigation';
import type { AxiosError, AxiosPromise } from 'axios';
import {
  notificationController,
  NotificationType,
} from '../lib/components/shared-components/notification/notification';
import { handleError } from '../lib/utils/handle-error';
import { api } from './api';
import type { UserResponseDto } from '@immich/sdk';

export type ApiError = AxiosError<{ message: string }>;

export const copyToClipboard = async (secret: string) => {
  try {
    await navigator.clipboard.writeText(secret);
    notificationController.show({ message: '已复制到剪贴板!', type: NotificationType.Info });
  } catch (error) {
    handleError(error, '无法复制到剪贴板，请确保您通过 https 访问该页面');
  }
};

export const makeSharedLinkUrl = (externalDomain: string, key: string) => {
  let url = externalDomain || window.location.origin;
  if (!url.endsWith('/')) {
    url += '/';
  }
  return `${url}share/${key}`;
};

export const oauth = {
  isCallback: (location: Location) => {
    const search = location.search;
    return search.includes('code=') || search.includes('error=');
  },
  isAutoLaunchDisabled: (location: Location) => {
    const values = ['autoLaunch=0', 'password=1', 'password=true'];
    for (const value of values) {
      if (location.search.includes(value)) {
        return true;
      }
    }
    return false;
  },
  authorize: async (location: Location) => {
    try {
      const redirectUri = location.href.split('?')[0];
      const { data } = await api.oauthApi.startOAuth({ oAuthConfigDto: { redirectUri } });
      goto(data.url);
    } catch (error) {
      handleError(error, 'Unable to login with OAuth');
    }
  },
  login: (location: Location) => {
    return api.oauthApi.finishOAuth({ oAuthCallbackDto: { url: location.href } });
  },
  link: (location: Location): AxiosPromise<UserResponseDto> => {
    return api.oauthApi.linkOAuthAccount({ oAuthCallbackDto: { url: location.href } });
  },
  unlink: () => {
    return api.oauthApi.unlinkOAuthAccount();
  },
};

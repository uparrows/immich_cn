import { SessionService } from './session.service';
import fs from 'node:fs';
import yaml from 'yaml';
import { LoginError } from '../cores/errors/login-error';
import {
  TEST_AUTH_FILE,
  TEST_CONFIG_DIR,
  TEST_IMMICH_API_KEY,
  TEST_IMMICH_INSTANCE_URL,
  createTestAuthFile,
  deleteAuthFile,
  readTestAuthFile,
  spyOnConsole,
} from '../../test/cli-test-utils';

const mockPingServer = jest.fn(() => Promise.resolve({ data: { res: 'pong' } }));
const mockUserInfo = jest.fn(() => Promise.resolve({ data: { email: 'admin@example.com' } }));

jest.mock('@immich/sdk', () => {
  return {
    ...jest.requireActual('@immich/sdk'),
    UserApi: jest.fn().mockImplementation(() => {
      return { getMyUserInfo: mockUserInfo };
    }),
    ServerInfoApi: jest.fn().mockImplementation(() => {
      return { pingServer: mockPingServer };
    }),
  };
});

describe('SessionService', () => {
  let sessionService: SessionService;
  let consoleSpy: jest.SpyInstance;

  beforeAll(() => {
    consoleSpy = spyOnConsole();
  });

  beforeEach(() => {
    deleteAuthFile();
    sessionService = new SessionService(TEST_CONFIG_DIR);
  });

  afterEach(() => {
    deleteAuthFile();
  });

  it('should connect to immich', async () => {
    await createTestAuthFile(
      JSON.stringify({
        apiKey: TEST_IMMICH_API_KEY,
        instanceUrl: TEST_IMMICH_INSTANCE_URL,
      }),
    );

    await sessionService.connect();
    expect(mockPingServer).toHaveBeenCalledTimes(1);
  });

  it('should error if no auth file exists', async () => {
    await sessionService.connect().catch((error) => {
      expect(error.message).toEqual('No auth file exist. Please login first');
    });
  });

  it('should error if auth file is missing instance URl', async () => {
    await createTestAuthFile(
      JSON.stringify({
        apiKey: TEST_IMMICH_API_KEY,
      }),
    );
    await sessionService.connect().catch((error) => {
      expect(error).toBeInstanceOf(LoginError);
      expect(error.message).toEqual(`Instance URL missing in auth config file ${TEST_AUTH_FILE}`);
    });
  });

  it('should error if auth file is missing api key', async () => {
    await createTestAuthFile(
      JSON.stringify({
        instanceUrl: TEST_IMMICH_INSTANCE_URL,
      }),
    );

    await expect(sessionService.connect()).rejects.toThrow(
      new LoginError(`API key missing in auth config file ${TEST_AUTH_FILE}`),
    );
  });

  it('should create auth file when logged in', async () => {
    await sessionService.keyLogin(TEST_IMMICH_INSTANCE_URL, TEST_IMMICH_API_KEY);

    const data: string = await readTestAuthFile();
    const authConfig = yaml.parse(data);
    expect(authConfig.instanceUrl).toBe(TEST_IMMICH_INSTANCE_URL);
    expect(authConfig.apiKey).toBe(TEST_IMMICH_API_KEY);
  });

  it('should delete auth file when logging out', async () => {
    await createTestAuthFile(
      JSON.stringify({
        apiKey: TEST_IMMICH_API_KEY,
        instanceUrl: TEST_IMMICH_INSTANCE_URL,
      }),
    );
    await sessionService.logout();

    await fs.promises.access(TEST_AUTH_FILE, fs.constants.F_OK).catch((error) => {
      expect(error.message).toContain('ENOENT');
    });

    expect(consoleSpy.mock.calls).toEqual([[`Removed auth file ${TEST_AUTH_FILE}`]]);
  });
});

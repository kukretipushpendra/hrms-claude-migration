import axios, { type AxiosInstance, type InternalAxiosRequestConfig, type AxiosError } from 'axios';
import type { ApiResponse, UserData } from '@/stores/auth.store';

// API Key required by .NET backend for internal user login
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

// Build version storage key (matching legacy)
const BUILD_VERSION_STORAGE_KEY = 'Build-Version';

// CRITICAL: Point to EXISTING .NET backend during frontend migration
const httpClient: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:5281/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Helper to get build version from localStorage
const getBuildVersion = (): string => {
  const rawStr = localStorage.getItem(BUILD_VERSION_STORAGE_KEY);

  if (!rawStr) {
    return '';
  }

  try {
    const parsed = JSON.parse(rawStr);
    return parsed;
  } catch {
    return '';
  }
};

// Queue for failed requests during token refresh
interface QueueItem {
  resolve: (value?: unknown) => void;
  reject: (error?: unknown) => void;
}

let failedRequestQueue: QueueItem[] = [];
let isRefreshing = false;

// Process all queued requests
const processQueue = (error: unknown, token: string | null = null) => {
  failedRequestQueue.forEach(({ resolve, reject }) => {
    if (error) {
      reject(error);
    } else {
      resolve(token);
    }
  });

  failedRequestQueue = [];
};

// Check if error is build version mismatch (422 status)
const isBuildVersionError = (error: AxiosError): boolean => {
  return error.response?.status === 422;
};

// Add JWT token and Build-Version header to requests
httpClient.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    // Get token from localStorage (same as legacy - multiple locations)
    const token =
      localStorage.getItem('paramToken') ||
      localStorage.getItem('accessToken') ||
      (() => {
        try {
          const userToken = localStorage.getItem('userToken');
          if (userToken) {
            const parsed = JSON.parse(userToken);
            return parsed?.state?.userData?.authToken;
          }
        } catch {
          return null;
        }
        return null;
      })();

    const buildVersion = getBuildVersion();

    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    if (buildVersion) {
      config.headers['Build-Version'] = buildVersion;
    }

    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Handle responses and errors with token refresh logic
httpClient.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => {
    const originalRequest = error.config as InternalAxiosRequestConfig & {
      _retry?: boolean;
    };

    if (!originalRequest) {
      return Promise.reject(error);
    }

    // Handle build version error (422)
    if (isBuildVersionError(error)) {
      const data = error.response?.data;

      if (
        typeof data === 'object' &&
        data &&
        'buildVersion' in data &&
        typeof data.buildVersion === 'string'
      ) {
        const newVersion = data.buildVersion;

        // Store new version and trigger app update dialog
        // This will be handled by app update store when it exists
        try {
          const appUpdateModule = await import('@/stores/appUpdate.store');
          const { useAppUpdateStore } = appUpdateModule;
          const appUpdateStore = useAppUpdateStore();

          if (!appUpdateStore.showUpdateDialog) {
            appUpdateStore.setNewVersion(newVersion);
          }
        } catch {
          // App update store not yet implemented
          console.warn('Build version mismatch detected:', newVersion);
        }
      }
    }

    // Handle 401 Unauthorized - Token refresh logic
    if (error.response?.status === 401 && !originalRequest._retry) {
      // If already refreshing, queue this request
      if (isRefreshing) {
        return new Promise((resolve, reject) => {
          failedRequestQueue.push({ resolve, reject });
        })
          .then((token) => {
            originalRequest.headers.Authorization = `Bearer ${token}`;
            return httpClient(originalRequest);
          })
          .catch((err) => {
            return Promise.reject(err);
          });
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        // Get current tokens
        const accessToken = localStorage.getItem('accessToken');
        const refreshToken = localStorage.getItem('refreshToken');

        if (!refreshToken) {
          throw new Error('No refresh token available');
        }

        // Call refresh token endpoint (CRITICAL: .NET expects capitalized field names)
        const response = await axios.post<ApiResponse<UserData>>(
          `${httpClient.defaults.baseURL}/Auth/RefreshToken`,
          {
            AccessToken: accessToken,
            RefreshToken: refreshToken,
          }
        );

        const userData = response.data.result;

        // Update tokens in localStorage
        localStorage.setItem('accessToken', userData.authToken);
        localStorage.setItem('refreshToken', userData.refreshToken);

        // Update auth store (if available)
        try {
          const authModule = await import('@/stores/auth.store');
          const { useAuthStore } = authModule;
          const authStore = useAuthStore();

          authStore.accessToken = userData.authToken;
          authStore.refreshToken = userData.refreshToken;

          // Update user data with new module permissions if available
          if (userData.modulePermissions?.modules) {
            // User will be updated via the auth store's mapUserDataToUser
            const user = authStore.user;
            if (user) {
              const newPermissions: string[] = [];
              for (const module of userData.modulePermissions.modules) {
                newPermissions.push(...module.permissions);
              }
              user.permissions = newPermissions;
            }
          }

          // Update stored user data
          if (authStore.user) {
            localStorage.setItem('userData', JSON.stringify(authStore.user));
          }
        } catch {
          // Auth store not available, tokens already updated in localStorage
        }

        // Update the failed request with new token
        originalRequest.headers.Authorization = `Bearer ${userData.authToken}`;

        // Process the queue with new token
        processQueue(null, userData.authToken);

        // Retry the original request
        return httpClient(originalRequest);
      } catch (refreshError) {
        // Refresh failed, clear tokens and logout
        processQueue(refreshError, null);

        // Clear all auth data
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        localStorage.removeItem('isInternalUser');
        localStorage.removeItem('userData');

        // Redirect to login
        window.location.href = '/login';

        return Promise.reject(refreshError);
      } finally {
        isRefreshing = false;
      }
    }

    return Promise.reject(error);
  }
);

// Export API key for endpoints that need it
export { API_KEY };
export default httpClient;

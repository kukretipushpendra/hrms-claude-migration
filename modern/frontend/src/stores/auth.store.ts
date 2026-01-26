import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import httpClient, { API_KEY } from '@/services/api/http-client';

// Menu types matching legacy
export interface SubMenu {
  subMenu: string;
  subMenuApiEndPoint: string;
}

export interface Menu {
  mainMenu: string;
  mainMenuApiEndPoint: string;
  subMenus: SubMenu[];
}

// Module permissions
export interface ModulePermission {
  moduleId: number;
  moduleName: string;
  permissions: string[];
}

export interface ModulePermissions {
  modules: ModulePermission[];
}

// User data matching .NET backend response
export interface UserData {
  authToken: string;
  refreshToken: string;
  firstName: string;
  lastName: string;
  roleId: string;
  roleName: string;
  userEmail: string;
  userId: string;
  userName: string;
  menus: Menu[];
  modulePermissions?: ModulePermissions;
}

// API Response wrapper (matches .NET backend TResponse<T>)
export interface ApiResponse<T> {
  statusCode: number;
  message: string;
  result: T;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface SSOLoginRequest {
  msAuthToken: string;
}

// User state for the store
export interface User {
  id: string;
  email: string;
  fullName: string;
  firstName: string;
  lastName: string;
  roleId: string;
  roleName: string;
  menus: Menu[];
  permissions: string[];
}

export const useAuthStore = defineStore('auth', () => {
  // State
  const user = ref<User | null>(null);
  const accessToken = ref<string | null>(localStorage.getItem('accessToken'));
  const refreshToken = ref<string | null>(localStorage.getItem('refreshToken'));
  const isInternalUser = ref<boolean>(localStorage.getItem('isInternalUser') === 'true');
  const loading = ref(false);
  const error = ref<string | null>(null);

  // Getters
  const isAuthenticated = computed(() => !!accessToken.value && !!user.value);
  const userFullName = computed(() => user.value?.fullName || '');
  const userPermissions = computed(() => user.value?.permissions || []);

  // Helper to convert UserData to User
  function mapUserDataToUser(userData: UserData): User {
    // Extract all permissions from module permissions
    const permissions: string[] = [];
    if (userData.modulePermissions?.modules) {
      for (const module of userData.modulePermissions.modules) {
        permissions.push(...module.permissions);
      }
    }

    return {
      id: userData.userId,
      email: userData.userEmail,
      fullName: `${userData.firstName} ${userData.lastName}`.trim(),
      firstName: userData.firstName,
      lastName: userData.lastName,
      roleId: userData.roleId,
      roleName: userData.roleName,
      menus: userData.menus || [],
      permissions,
    };
  }

  // Actions
  async function login(credentials: LoginRequest): Promise<void> {
    loading.value = true;
    error.value = null;

    try {
      // Include X-API_KEY header required by .NET backend for internal user login
      // CRITICAL: .NET expects capitalized field names (Email, Password)
      const response = await httpClient.post<ApiResponse<UserData>>(
        '/Auth/Login',
        {
          Email: credentials.email,
          Password: credentials.password,
        },
        {
          headers: {
            'X-API_KEY': API_KEY,
          },
        }
      );

      const userData = response.data.result;

      if (!userData) {
        throw new Error('User not found');
      }

      // Store tokens
      accessToken.value = userData.authToken;
      refreshToken.value = userData.refreshToken;
      localStorage.setItem('accessToken', userData.authToken);
      localStorage.setItem('refreshToken', userData.refreshToken);
      localStorage.setItem('isInternalUser', 'true');
      isInternalUser.value = true;

      // Store user
      user.value = mapUserDataToUser(userData);

      // Store user data in localStorage for persistence
      localStorage.setItem('userData', JSON.stringify(user.value));
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Login failed';
      error.value = errorMessage;
      throw e;
    } finally {
      loading.value = false;
    }
  }

  async function logout(): Promise<void> {
    // Clear state
    user.value = null;
    accessToken.value = null;
    refreshToken.value = null;
    isInternalUser.value = false;

    // Clear localStorage
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('isInternalUser');
    localStorage.removeItem('userData');
  }

  async function refreshAccessToken(): Promise<void> {
    if (!refreshToken.value) {
      await logout();
      return;
    }

    try {
      // CRITICAL: .NET expects capitalized field names
      const response = await httpClient.post<ApiResponse<UserData>>('/Auth/RefreshToken', {
        RefreshToken: refreshToken.value,
      });

      const userData = response.data.result;

      accessToken.value = userData.authToken;
      refreshToken.value = userData.refreshToken;
      localStorage.setItem('accessToken', userData.authToken);
      localStorage.setItem('refreshToken', userData.refreshToken);
    } catch {
      await logout();
    }
  }

  async function loadUser(): Promise<void> {
    if (!accessToken.value) return;

    try {
      // Load from localStorage - all user data is stored during login
      const storedUserData = localStorage.getItem('userData');
      if (storedUserData) {
        user.value = JSON.parse(storedUserData);
        return;
      }

      // If no stored user data but we have a token, the session is invalid
      // Note: We can't fetch user profile without knowing the user ID
      // which is only available after login. Force re-login.
      await logout();
    } catch {
      await logout();
    }
  }

  /**
   * Login with Microsoft SSO
   * The user clicks the button, gets redirected to Microsoft login,
   * then comes back with an MSAL token that we send to .NET backend
   */
  async function loginWithSSO(msAuthToken: string): Promise<void> {
    loading.value = true;
    error.value = null;

    try {
      // Send MSAL token to .NET backend for validation
      // CRITICAL: .NET expects capitalized field names
      const response = await httpClient.post<ApiResponse<UserData>>('/Auth', {
        MsAuthToken: msAuthToken,
      });

      const userData = response.data.result;

      if (!userData) {
        throw new Error('User not found');
      }

      // Store tokens
      accessToken.value = userData.authToken;
      refreshToken.value = userData.refreshToken;
      localStorage.setItem('accessToken', userData.authToken);
      localStorage.setItem('refreshToken', userData.refreshToken);
      localStorage.setItem('isInternalUser', 'false');
      isInternalUser.value = false;

      // Store user
      user.value = mapUserDataToUser(userData);
      localStorage.setItem('userData', JSON.stringify(user.value));
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'SSO login failed';
      error.value = errorMessage;
      throw e;
    } finally {
      loading.value = false;
    }
  }

  function hasPermission(permission: string): boolean {
    return userPermissions.value.includes(permission);
  }

  return {
    // State
    user,
    accessToken,
    refreshToken,
    isInternalUser,
    loading,
    error,
    // Getters
    isAuthenticated,
    userFullName,
    userPermissions,
    // Actions
    login,
    loginWithSSO,
    logout,
    refreshAccessToken,
    loadUser,
    hasPermission,
  };
});

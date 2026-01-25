<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useDisplay } from 'vuetify';
import { useAuthStore } from '@/stores/auth.store';

const router = useRouter();
const authStore = useAuthStore();
const { smAndUp } = useDisplay();

// State
const errorMessage = ref('');
const ssoLoading = ref(false);

// Redirect if already logged in
onMounted(() => {
  if (authStore.isAuthenticated) {
    router.push('/dashboard');
  }
});

// SSO Login Handler (Microsoft)
// Note: Full MSAL integration requires @azure/msal-browser package
// For now, this shows a message that SSO is being configured
async function handleSSOLogin() {
  errorMessage.value = '';
  ssoLoading.value = true;

  try {
    // TODO: Integrate MSAL for Microsoft authentication
    // 1. User clicks button -> MSAL popup opens
    // 2. User authenticates with Microsoft
    // 3. MSAL returns access token
    // 4. Send token to .NET backend via authStore.loginWithSSO(msAuthToken)

    // For now, show configuration message
    errorMessage.value =
      'Microsoft SSO is being configured. Please use internal login at /internal-login';

    // Once MSAL is integrated:
    // const msalInstance = await import('@azure/msal-browser');
    // const userData = await msalInstance.loginPopup(loginRequest);
    // await authStore.loginWithSSO(userData.accessToken);
    // router.push(redirect);
  } catch (error) {
    errorMessage.value =
      error instanceof Error ? error.message : 'SSO login failed. Please try again.';
  } finally {
    ssoLoading.value = false;
  }
}

// Computed loading state
const isLoading = computed(() => ssoLoading.value);
</script>

<template>
  <v-app>
    <v-main class="login-page">
      <v-container fluid class="fill-height pa-0">
        <v-row class="fill-height ma-0">
          <!-- Left Column - Image (hidden on mobile) -->
          <v-col v-if="smAndUp" cols="4" class="login-sidebar d-flex align-center justify-center">
            <div class="login-sidebar-image">
              <img src="/login-left-img.jpg" alt="HRMS" class="login-image" />
            </div>
          </v-col>

          <!-- Divider (hidden on mobile) -->
          <v-col v-if="smAndUp" cols="1" class="d-flex justify-center pa-0">
            <div class="login-divider"></div>
          </v-col>

          <!-- Right Column - SSO Login -->
          <v-col :cols="smAndUp ? 7 : 12" class="d-flex align-center justify-center">
            <v-card
              flat
              class="login-main-container"
              :width="smAndUp ? 450 : '100%'"
              :max-width="450"
            >
              <!-- Logo and Brand -->
              <div class="login-center-icon-container mb-8">
                <div class="login-center-icon">
                  <img src="/pio-logo.svg" alt="Logo" height="40" />
                </div>
                <div class="login-brand-divider"></div>
                <span class="login-brand-text">HRMS</span>
              </div>

              <!-- Title -->
              <div class="text-center mb-8">
                <h1 class="login-title">Sign In</h1>
              </div>

              <!-- Error Alert -->
              <v-alert
                v-if="errorMessage"
                type="error"
                variant="tonal"
                class="mb-6"
                closable
                @click:close="errorMessage = ''"
              >
                {{ errorMessage }}
              </v-alert>

              <!-- SSO Login Button (Microsoft Only) -->
              <div class="d-flex justify-center">
                <v-btn
                  variant="outlined"
                  color="primary"
                  size="large"
                  class="login-sso-button"
                  :loading="ssoLoading"
                  :disabled="isLoading"
                  @click="handleSSOLogin"
                >
                  <img src="/microsoft365.svg" alt="Microsoft" height="30" class="mr-3" />
                  <span class="font-weight-bold">Sign In with Microsoft</span>
                </v-btn>
              </div>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<style scoped lang="scss">
.login-page {
  background-color: #ffffff;
  min-height: 100vh;
}

.login-sidebar {
  background-color: #fafafa;
}

.login-sidebar-image {
  display: flex;
  align-items: center;
  justify-content: center;

  .login-image {
    max-width: 228px;
    height: auto;
  }
}

.login-divider {
  border-left: 2px solid #f0f0f0;
  height: 100%;
  min-height: 400px;
}

.login-main-container {
  padding: 40px;
}

.login-center-icon-container {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
}

.login-center-icon {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  background-color: #283a50;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 1px 8px 0px rgba(0, 0, 0, 0.2);
}

.login-brand-divider {
  width: 2px;
  height: 40px;
  background-color: #d9d9d9;
}

.login-brand-text {
  font-size: 1.5rem;
  font-weight: 700;
  color: #283a50;
}

.login-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1e75bb;
}

.login-sso-button {
  height: 48px !important;
  padding-left: 50px !important;
  padding-right: 50px !important;
  border-color: #1e75bb !important;
  color: #1e75bb !important;

  &:hover {
    background-color: #1e75bb !important;
    color: #ffffff !important;

    img {
      filter: brightness(0) invert(1);
    }
  }
}

// Mobile adjustments
@media (max-width: 768px) {
  .login-main-container {
    padding: 24px 16px;
  }
}
</style>

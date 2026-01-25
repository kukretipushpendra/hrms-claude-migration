<script setup lang="ts">
/**
 * SSO Login Page - Matches Legacy React InternalUserLogin.tsx Exactly
 * From: legacy/Frontend/HRMS-Frontend/source/src/pages/Login/
 */
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useDisplay } from 'vuetify';
import { useAuthStore } from '@/stores/auth.store';

const router = useRouter();
const authStore = useAuthStore();
const { smAndDown } = useDisplay();

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
    // router.push('/dashboard');
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
  <div class="auth-wrapper">
    <!-- Top Logo -->
    <div class="top-logo">
      <img src="/programmers-io.svg" alt="Programmers.io" class="top-logo-image" />
    </div>

    <!-- Auth Card Container -->
    <div class="auth-card-container">
      <div class="auth-card">
        <div class="login-grid">
          <!-- Left Sidebar - Image (hidden on mobile) -->
          <div v-if="!smAndDown" class="login-sidebar">
            <img src="/login-left-img.jpg" alt="HRMS" class="sidebar-image" />
          </div>

          <!-- Divider (hidden on mobile) -->
          <div v-if="!smAndDown" class="login-divider-container">
            <div class="login-divider"></div>
          </div>

          <!-- Right Side - Form -->
          <div class="login-form-section">
            <!-- Logo and Brand Header -->
            <div class="login-center-icon-container">
              <div class="login-center-icon">
                <img src="/pio-logo.svg" alt="Logo" height="40" />
              </div>
              <div class="brand-divider"></div>
              <h3 class="brand-text">HRMS</h3>
            </div>

            <!-- Title -->
            <div class="login-title-container">
              <h3 class="login-title">Sign in to start Your Session</h3>
            </div>

            <!-- Error Alert -->
            <v-alert
              v-if="errorMessage"
              type="error"
              variant="tonal"
              class="mb-4"
              closable
              density="compact"
              @click:close="errorMessage = ''"
            >
              {{ errorMessage }}
            </v-alert>

            <!-- SSO Login Button -->
            <div class="login-button-container">
              <div class="login-button-wrapper">
                <button
                  type="button"
                  class="login-button"
                  :disabled="isLoading"
                  @click="handleSSOLogin"
                >
                  <img src="/microsoft365.svg" alt="Microsoft" height="30" class="button-icon" />
                  <b>Sign In with Microsoft</b>
                </button>
                <v-progress-circular
                  v-if="ssoLoading"
                  indeterminate
                  size="24"
                  width="2"
                  color="primary"
                  class="loading-spinner"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
// Auth Wrapper - Full page background
.auth-wrapper {
  min-height: 100vh;
  background-color: #eef4fb;
  background-image: url('/header-cloud-light.png');
  background-repeat: no-repeat;
  background-position: center bottom;
  display: flex;
  flex-direction: column;
}

// Top Logo
.top-logo {
  padding: 24px;

  .top-logo-image {
    height: 30px;
    width: auto;
  }
}

// Auth Card Container - Centers the card
.auth-card-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

// Auth Card - Main white card
.auth-card {
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
  max-width: 726px;
  width: 100%;
  padding: 20px;
}

// Login Grid - 3 column layout
.login-grid {
  display: grid;
  grid-template-columns: 4fr 1fr 7fr;
  min-height: 350px;

  @media (max-width: 600px) {
    grid-template-columns: 1fr;
  }
}

// Left Sidebar with Image
.login-sidebar {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;

  .sidebar-image {
    width: 258px;
    height: 180px;
    object-fit: contain;
    opacity: 0.8;
  }
}

// Divider Container
.login-divider-container {
  display: flex;
  justify-content: center;
  padding-left: 30px;

  .login-divider {
    border-right: 2px solid rgba(0, 0, 0, 0.12);
    height: 100%;
  }
}

// Right Side Form Section
.login-form-section {
  display: flex;
  flex-direction: column;
  padding: 20px;
}

// Logo and Brand Header
.login-center-icon-container {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  margin-bottom: 24px;
}

.login-center-icon {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  background-color: #283a50;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0px 1px 8px 0px rgba(0, 0, 0, 0.3);
}

.brand-divider {
  border-right: 2px solid rgba(0, 0, 0, 0.12);
  height: 50px;
}

.brand-text {
  font-size: 1.75rem;
  font-weight: 700;
  color: #283a50;
  margin: 0;
}

// Title
.login-title-container {
  text-align: center;
  margin-bottom: 24px;
}

.login-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1e75bb;
  margin: 0;
}

// Button Container
.login-button-container {
  display: flex;
  justify-content: center;
  align-items: center;
  flex: 1;
}

.login-button-wrapper {
  position: relative;
  margin: 8px;
}

.login-button {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 12px 50px;
  border: 1px solid #1e75bb;
  border-radius: 4px;
  background-color: transparent;
  color: #1e75bb;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover:not(:disabled) {
    background-color: #1e75bb;
    color: #ffffff;

    .button-icon {
      filter: brightness(0) invert(1);
    }
  }

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }

  .button-icon {
    transition: filter 0.2s ease;
  }
}

.loading-spinner {
  position: absolute;
  top: 50%;
  left: 50%;
  margin-top: -12px;
  margin-left: -12px;
}

// Mobile adjustments
@media (max-width: 600px) {
  .auth-card {
    margin: 8px;
    padding: 16px;
  }

  .login-form-section {
    padding: 16px 8px;
  }

  .login-button {
    padding: 12px 24px;
  }
}
</style>

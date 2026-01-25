<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useDisplay } from 'vuetify';
import { useAuthStore } from '@/stores/auth.store';

const router = useRouter();
const route = useRoute();
const authStore = useAuthStore();
const { smAndUp } = useDisplay();

// Form state
const email = ref('');
const password = ref('');
const showPassword = ref(false);
const errorMessage = ref('');

// Validation rules
const emailRules = [
  (v: string) => !!v || 'Email is required',
  (v: string) => /.+@.+\..+/.test(v) || 'Email must be valid',
  (v: string) => v.length >= 8 || 'Email must be at least 8 characters long',
  (v: string) => v.length <= 50 || 'Email cannot exceed 50 characters',
];

const passwordRules = [
  (v: string) => !!v || 'Password is required',
  (v: string) => v.length >= 8 || 'Password must be at least 8 characters',
];

// Redirect if already logged in
onMounted(() => {
  if (authStore.isAuthenticated) {
    router.push('/dashboard');
  }
});

// Standard login handler
async function handleSubmit() {
  errorMessage.value = '';

  try {
    await authStore.login({
      email: email.value.trim(),
      password: password.value.trim(),
    });

    // Redirect to intended page or dashboard
    const redirect = (route.query.redirect as string) || '/dashboard';
    router.push(redirect);
  } catch (error) {
    errorMessage.value = error instanceof Error ? error.message : 'Login failed. Please try again.';
  }
}

// Computed loading state
const isLoading = computed(() => authStore.loading);
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

          <!-- Right Column - Login Form -->
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
                <h1 class="login-title">User Login</h1>
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

              <!-- Login Form -->
              <v-form @submit.prevent="handleSubmit">
                <v-text-field
                  v-model="email"
                  label="Email"
                  type="email"
                  variant="outlined"
                  :rules="emailRules"
                  :disabled="isLoading"
                  required
                  class="mb-4"
                />

                <v-text-field
                  v-model="password"
                  label="Password"
                  :type="showPassword ? 'text' : 'password'"
                  variant="outlined"
                  :rules="passwordRules"
                  :append-inner-icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'"
                  :disabled="isLoading"
                  required
                  class="mb-6"
                  @click:append-inner="showPassword = !showPassword"
                />

                <div class="d-flex justify-center">
                  <v-btn
                    type="submit"
                    variant="outlined"
                    color="primary"
                    size="large"
                    class="login-button"
                    :loading="authStore.loading"
                    :disabled="isLoading"
                  >
                    <span class="font-weight-bold">Sign In</span>
                  </v-btn>
                </div>
              </v-form>
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

.login-button {
  height: 48px !important;
  padding-left: 50px !important;
  padding-right: 50px !important;
  border-color: #1e75bb !important;
  color: #1e75bb !important;

  &:hover {
    background-color: #1e75bb !important;
    color: #ffffff !important;
  }
}

// Mobile adjustments
@media (max-width: 768px) {
  .login-main-container {
    padding: 24px 16px;
  }
}
</style>

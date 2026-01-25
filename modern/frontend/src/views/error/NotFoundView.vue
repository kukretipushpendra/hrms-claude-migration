<script setup lang="ts">
import { useRouter } from 'vue-router';

const router = useRouter();

function goHome() {
  router.push('/dashboard');
}

function goBack() {
  router.back();
}
</script>

<template>
  <v-app>
    <v-main class="error-page">
      <v-container class="fill-height">
        <v-row align="center" justify="center">
          <v-col cols="12" sm="8" md="6" lg="4" class="text-center">
            <!-- Error Icon -->
            <div class="error-icon mb-6">
              <v-icon size="120" color="grey-400"> mdi-alert-circle-outline </v-icon>
            </div>

            <!-- Error Code -->
            <h1 class="error-code mb-4">404</h1>

            <!-- Error Message -->
            <h2 class="error-title mb-4">Page Not Found</h2>

            <p class="error-description mb-8">
              The page you are looking for might have been removed, had its name changed, or is
              temporarily unavailable.
            </p>

            <!-- Action Buttons -->
            <div class="d-flex justify-center gap-3">
              <v-btn color="primary" size="large" @click="goHome">
                <v-icon start>mdi-home</v-icon>
                Go to Dashboard
              </v-btn>

              <v-btn variant="outlined" color="primary" size="large" @click="goBack">
                <v-icon start>mdi-arrow-left</v-icon>
                Go Back
              </v-btn>
            </div>
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<style scoped lang="scss">
.error-page {
  background-color: #fafafb;
  min-height: 100vh;
}

.error-icon {
  opacity: 0.6;
}

.error-code {
  font-size: 6rem;
  font-weight: 700;
  color: #1e75bb;
  line-height: 1;
}

.error-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #283a50;
}

.error-description {
  font-size: 0.875rem;
  color: #8c8c8c;
  max-width: 400px;
  margin-left: auto;
  margin-right: auto;
}

.gap-3 {
  gap: 12px;
}
</style>

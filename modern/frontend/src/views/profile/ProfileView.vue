<script setup lang="ts">
import { ref, onMounted } from 'vue';
import httpClient from '@/services/api/http-client';

// Profile data
const profile = ref<Record<string, unknown> | null>(null);
const loading = ref(true);
const error = ref<string | null>(null);

// Fetch profile data
async function fetchProfile() {
  loading.value = true;
  error.value = null;

  try {
    const response = await httpClient.get('/UserProfile/GetPersonalDetail');
    profile.value = response.data.result;
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'Failed to load profile';
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  fetchProfile();
});
</script>

<template>
  <div class="profile-page">
    <!-- Page Header -->
    <div class="page-header mb-6">
      <h2 class="page-title">My Profile</h2>
    </div>

    <!-- Loading State -->
    <v-row v-if="loading">
      <v-col cols="12" class="text-center py-12">
        <v-progress-circular indeterminate color="primary" size="64" />
      </v-col>
    </v-row>

    <!-- Error State -->
    <v-row v-else-if="error">
      <v-col cols="12">
        <v-alert type="error" variant="tonal">
          {{ error }}
        </v-alert>
      </v-col>
    </v-row>

    <!-- Profile Content -->
    <v-row v-else>
      <!-- Profile Card -->
      <v-col cols="12" md="4">
        <v-card class="main-card">
          <div class="text-center pa-6">
            <!-- Avatar -->
            <v-avatar size="120" color="primary" class="mb-4">
              <span class="text-h3 text-white">
                {{ profile?.fullName?.charAt(0) || 'U' }}
              </span>
            </v-avatar>

            <!-- Name -->
            <h3 class="text-h5 font-weight-bold mb-1">
              {{ profile?.fullName }}
            </h3>

            <!-- Role -->
            <p class="text-body-2 text-grey-600 mb-2">
              {{ profile?.roleName }}
            </p>

            <!-- Employee Code -->
            <v-chip color="primary" variant="outlined" size="small">
              {{ profile?.employeeCode }}
            </v-chip>
          </div>
        </v-card>
      </v-col>

      <!-- Details Card -->
      <v-col cols="12" md="8">
        <v-card class="main-card">
          <v-card-title class="border-b"> Personal Information </v-card-title>
          <v-card-text class="pa-6">
            <v-row>
              <v-col cols="12" sm="6">
                <div class="detail-item">
                  <div class="detail-label">Email</div>
                  <div class="detail-value">{{ profile?.email || '-' }}</div>
                </div>
              </v-col>

              <v-col cols="12" sm="6">
                <div class="detail-item">
                  <div class="detail-label">Phone</div>
                  <div class="detail-value">{{ profile?.phone || '-' }}</div>
                </div>
              </v-col>

              <v-col cols="12" sm="6">
                <div class="detail-item">
                  <div class="detail-label">Department</div>
                  <div class="detail-value">{{ profile?.departmentName || '-' }}</div>
                </div>
              </v-col>

              <v-col cols="12" sm="6">
                <div class="detail-item">
                  <div class="detail-label">Designation</div>
                  <div class="detail-value">{{ profile?.designationName || '-' }}</div>
                </div>
              </v-col>

              <v-col cols="12" sm="6">
                <div class="detail-item">
                  <div class="detail-label">Team</div>
                  <div class="detail-value">{{ profile?.teamName || '-' }}</div>
                </div>
              </v-col>

              <v-col cols="12" sm="6">
                <div class="detail-item">
                  <div class="detail-label">Reporting Manager</div>
                  <div class="detail-value">{{ profile?.reportingManagerName || '-' }}</div>
                </div>
              </v-col>

              <v-col cols="12" sm="6">
                <div class="detail-item">
                  <div class="detail-label">Date of Joining</div>
                  <div class="detail-value">{{ profile?.dateOfJoining || '-' }}</div>
                </div>
              </v-col>

              <v-col cols="12" sm="6">
                <div class="detail-item">
                  <div class="detail-label">Employment Type</div>
                  <div class="detail-value">{{ profile?.employmentType || '-' }}</div>
                </div>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<style scoped lang="scss">
.profile-page {
  padding: 8px;
}

.page-title {
  font-size: 1.75rem;
  font-weight: 600;
  color: #273a50;
}

.main-card {
  border-radius: 8px;
  border: 1px solid #f0f0f0;
}

.border-b {
  border-bottom: 1px solid #f0f0f0;
}

.detail-item {
  margin-bottom: 8px;
}

.detail-label {
  font-size: 0.75rem;
  font-weight: 500;
  color: #8c8c8c;
  margin-bottom: 4px;
}

.detail-value {
  font-size: 0.875rem;
  font-weight: 500;
  color: #262626;
}
</style>

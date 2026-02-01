<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import httpClient from '@/services/api/http-client';
import dayjs from 'dayjs';
import { useSnackbar } from '@/composables/useSnackbar';

const route = useRoute();
const authStore = useAuthStore();
const { showError, showSuccess } = useSnackbar();

// Get employee ID from query param or use logged-in user
const employeeId = computed(() => {
  const queryId = route.query.employeeId as string;
  return queryId ? parseInt(queryId) : authStore.user?.id;
});

// Tab management
const activeTab = ref(0);
const tabs = [
  { title: 'Personal Details', value: 0 },
  { title: 'Official Details', value: 1 },
  { title: 'Employment Details', value: 2 },
  { title: 'Education Details', value: 3 },
  { title: 'Nominee Details', value: 4 },
  { title: 'Certificate Details', value: 5 },
  { title: 'Exit Details', value: 6 },
];

// Page state
const loading = ref(true);
const isSaving = ref(false);
const isEditable = ref(false);
const profileData = ref<Record<string, any>>({});
const personalDetailsData = ref<Record<string, any>>({});
const documents = ref<any[]>([]);
const countries = ref<any[]>([]);
const states = ref<any[]>([]);
const cities = ref<any[]>([]);
const hasActiveResignation = ref(false);

// Check if viewing own profile
const isOwnProfile = computed(() => employeeId.value === authStore.user?.id);

// Get profile display name
const profileDisplayName = computed(() => {
  if (personalDetailsData.value?.firstName) {
    return `${personalDetailsData.value.firstName} ${personalDetailsData.value.lastName || ''}`.trim();
  }
  return 'N/A';
});

// Initialize data loading
onMounted(async () => {
  if (!employeeId.value) {
    showError('Employee ID not found');
    return;
  }

  try {
    loading.value = true;
    // Load all data in parallel
    await Promise.all([
      fetchProfileData(),
      fetchPersonalDetails(),
      fetchDocuments(),
      fetchCountries(),
      checkResignationStatus(),
    ]);
  } catch (error) {
    console.error('Error loading profile:', error);
    showError('Failed to load profile data');
  } finally {
    loading.value = false;
  }
});

// Fetch main profile data
const fetchProfileData = async () => {
  try {
    const response = await httpClient.get(
      `/UserProfile/GetPersonalProfileByIdAsync/${employeeId.value}`
    );
    if (response.data?.result) {
      profileData.value = response.data.result;
      // Load states if country is set
      if (profileData.value.countryId) {
        await fetchStates(profileData.value.countryId);
      }
      // Load cities if state is set
      if (profileData.value.stateId) {
        await fetchCities(profileData.value.stateId);
      }
    }
  } catch (error) {
    console.error('Error fetching profile:', error);
  }
};

// Fetch personal details
const fetchPersonalDetails = async () => {
  try {
    const response = await httpClient.get(
      `/UserProfile/GetPersonalDetailsById/${employeeId.value}`
    );
    if (response.data?.result) {
      personalDetailsData.value = response.data.result;
    }
  } catch (error) {
    console.error('Error fetching personal details:', error);
  }
};

// Fetch documents
const fetchDocuments = async () => {
  try {
    const response = await httpClient.get(
      `/UserProfile/GetUserDocumentList/${employeeId.value}`
    );
    if (response.data?.result) {
      documents.value = response.data.result;
    }
  } catch (error) {
    console.error('Error fetching documents:', error);
  }
};

// Fetch countries
const fetchCountries = async () => {
  try {
    const response = await httpClient.get('/UserProfile/GetCountryList');
    if (response.data?.result) {
      countries.value = response.data.result;
    }
  } catch (error) {
    console.error('Error fetching countries:', error);
  }
};

// Fetch states
const fetchStates = async (countryId: number) => {
  try {
    const response = await httpClient.get(`/UserProfile/GetStateList/${countryId}`);
    if (response.data?.result) {
      states.value = response.data.result;
    }
  } catch (error) {
    console.error('Error fetching states:', error);
  }
};

// Fetch cities
const fetchCities = async (stateId: number) => {
  try {
    const response = await httpClient.get(`/UserProfile/GetCityList/${stateId}`);
    if (response.data?.result) {
      cities.value = response.data.result;
    }
  } catch (error) {
    console.error('Error fetching cities:', error);
  }
};

// Check if employee has active resignation
const checkResignationStatus = async () => {
  try {
    const response = await httpClient.get(
      `/ExitEmployee/IsResignationExist/${employeeId.value}`
    );
    if (response.data?.result) {
      hasActiveResignation.value = response.data.result.hasActiveResignation || false;
    }
  } catch (error) {
    console.error('Error checking resignation status:', error);
  }
};

// Handle country change
const onCountryChange = async () => {
  states.value = [];
  cities.value = [];
  profileData.value.stateId = null;
  profileData.value.cityId = null;

  if (profileData.value.countryId) {
    await fetchStates(profileData.value.countryId);
  }
};

// Handle state change
const onStateChange = async () => {
  cities.value = [];
  profileData.value.cityId = null;

  if (profileData.value.stateId) {
    await fetchCities(profileData.value.stateId);
  }
};

// Handle save
const handleSave = async () => {
  isSaving.value = true;
  try {
    // TODO: Call API to update profile
    showSuccess('Profile updated successfully');
    isEditable.value = false;
    await fetchProfileData();
  } catch (error) {
    showError('Failed to update profile');
  } finally {
    isSaving.value = false;
  }
};

// Handle cancel
const handleCancel = () => {
  isEditable.value = false;
};

// Format date
const formatDate = (dateString: string | null) => {
  if (!dateString) return '-';
  return dayjs(dateString).format('MMM DD, YYYY');
};

// Get country name
const getCountryName = (countryId: number) => {
  const country = countries.value.find((c) => c.id === countryId);
  return country?.name || '-';
};

// Get state name
const getStateName = (stateId: number) => {
  const state = states.value.find((s) => s.id === stateId);
  return state?.name || '-';
};

// Get city name
const getCityName = (cityId: number) => {
  const city = cities.value.find((c) => c.id === cityId);
  return city?.name || '-';
};
</script>

<template>
  <v-container fluid class="pb-8">
    <!-- Page Header with Edit/Cancel Buttons -->
    <v-row class="mb-4">
      <v-col cols="12">
        <div class="d-flex align-center justify-space-between mb-2">
          <h2 class="text-h4" style="color: #273a50; font-weight: 600">Profile</h2>
          <div v-if="isOwnProfile && !loading && activeTab === 0" class="d-flex gap-2">
            <v-btn
              v-if="!isEditable"
              color="primary"
              variant="outlined"
              size="small"
              @click="isEditable = true"
            >
              <v-icon small class="mr-1">mdi-pencil</v-icon>
              Edit Personal Details
            </v-btn>
            <div v-else class="d-flex gap-2">
              <v-btn
                color="primary"
                variant="outlined"
                size="small"
                :loading="isSaving"
                @click="handleSave"
              >
                <v-icon small class="mr-1">mdi-content-save</v-icon>
                Save
              </v-btn>
              <v-btn color="error" variant="outlined" size="small" @click="handleCancel">
                <v-icon small class="mr-1">mdi-close</v-icon>
                Cancel
              </v-btn>
            </div>
          </div>
        </div>
      </v-col>
    </v-row>

    <!-- Loading State -->
    <v-row v-if="loading">
      <v-col cols="12" class="text-center py-12">
        <v-progress-circular indeterminate color="primary" size="64" />
      </v-col>
    </v-row>

    <!-- Tab Container -->
    <v-card v-else>
      <!-- Tabs -->
      <v-tabs v-model="activeTab" bg-color="#f5f5f5" color="primary">
        <v-tab v-for="tab in tabs" :key="tab.value" :value="tab.value">
          {{ tab.title }}
        </v-tab>
      </v-tabs>

      <v-divider />

      <!-- Profile Content in Tabs -->
      <v-card-text class="pa-6 bg-grey-lighten-2">
        <v-row>
          <!-- Left Panel: Profile Card -->
          <v-col cols="12" md="3" class="mb-4">
            <v-card class="mb-4">
              <!-- Avatar Section -->
              <div class="text-center pa-6">
                <v-avatar
                  size="120"
                  color="primary"
                  class="mb-4"
                  :style="{ fontSize: '48px', fontWeight: 'bold' }"
                >
                  {{ personalDetailsData.firstName?.charAt(0)?.toUpperCase() || 'U' }}
                </v-avatar>

                <!-- Name -->
                <div class="mb-2">
                  <p class="text-h6" style="color: #273a50; font-weight: 600; margin: 0">
                    {{ profileDisplayName }}
                  </p>
                </div>

                <!-- Status Badge -->
                <v-chip
                  v-if="hasActiveResignation"
                  color="warning"
                  label
                  small
                  class="mb-2"
                >
                  Active Resignation
                </v-chip>
              </div>

              <v-divider />

              <!-- Quick Info with Icons -->
              <v-card-text class="pa-4">
                <!-- Location -->
                <div
                  v-if="personalDetailsData?.cityName || personalDetailsData?.stateName"
                  class="mb-3 d-flex align-start gap-2"
                >
                  <v-icon size="18" color="#1E75BB" class="mt-1">mdi-map-marker</v-icon>
                  <div style="flex: 1">
                    <p class="text-caption mb-0" style="color: #8c8c8c">Location</p>
                    <p class="text-body-2 mb-0" style="color: #262626">
                      {{ personalDetailsData.cityName }}, {{ personalDetailsData.stateName }}
                    </p>
                  </div>
                </div>

                <!-- Phone -->
                <div v-if="personalDetailsData?.phone" class="mb-3 d-flex align-start gap-2">
                  <v-icon size="18" color="#1E75BB" class="mt-1">mdi-phone</v-icon>
                  <div style="flex: 1">
                    <p class="text-caption mb-0" style="color: #8c8c8c">Phone</p>
                    <a
                      :href="`tel:${personalDetailsData.phone}`"
                      class="text-body-2 text-decoration-none"
                      style="color: #1E75BB"
                    >
                      {{ personalDetailsData.phone }}
                    </a>
                  </div>
                </div>

                <!-- Email -->
                <div v-if="personalDetailsData?.email" class="d-flex align-start gap-2">
                  <v-icon size="18" color="#1E75BB" class="mt-1">mdi-email</v-icon>
                  <div style="flex: 1">
                    <p class="text-caption mb-0" style="color: #8c8c8c">Email</p>
                    <a
                      :href="`mailto:${personalDetailsData.email}`"
                      class="text-body-2 text-decoration-none"
                      style="color: #1E75BB"
                    >
                      {{ personalDetailsData.email }}
                    </a>
                  </div>
                </div>
              </v-card-text>
            </v-card>

            <!-- Documents Card -->
            <v-card v-if="documents.length > 0">
              <v-card-title class="pa-4 bg-grey-lighten-2" style="font-size: 0.875rem; font-weight: 600">
                Documents
              </v-card-title>
              <v-card-text class="pa-4">
                <div v-for="(doc, index) in documents" :key="index" class="mb-2 d-flex align-center gap-2">
                  <v-icon size="18" color="primary">mdi-file</v-icon>
                  <a
                    :href="doc.documentUrl"
                    target="_blank"
                    class="text-body-2 text-decoration-none"
                    style="color: #1E75BB"
                  >
                    {{ doc.documentName }}
                  </a>
                </div>
              </v-card-text>
            </v-card>
          </v-col>

          <!-- Right Panel: Tab Content -->
          <v-col cols="12" md="9">
            <v-window v-model="activeTab">
              <!-- Window Item 0: Personal Details -->
              <v-window-item :value="0">
        <v-card class="mb-4">
          <v-card-title class="pa-4 bg-grey-lighten-2" style="font-size: 0.875rem; font-weight: 600">
            Personal Information
          </v-card-title>

          <v-card-text class="pa-6">
            <v-row>
              <!-- First Name -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">First Name</p>
                  <p class="value">{{ personalDetailsData.firstName || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.firstName"
                  label="First Name"
                  outlined
                  dense
                  required
                />
              </v-col>

              <!-- Middle Name -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Middle Name</p>
                  <p class="value">{{ personalDetailsData.middleName || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.middleName"
                  label="Middle Name"
                  outlined
                  dense
                />
              </v-col>

              <!-- Last Name -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Last Name</p>
                  <p class="value">{{ personalDetailsData.lastName || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.lastName"
                  label="Last Name"
                  outlined
                  dense
                  required
                />
              </v-col>

              <!-- Email (Read-only) -->
              <v-col cols="12" md="4">
                <div class="form-item">
                  <p class="label">Email</p>
                  <p class="value">{{ personalDetailsData.email || '-' }}</p>
                </div>
              </v-col>

              <!-- Personal Email -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Personal Email</p>
                  <p class="value">{{ personalDetailsData.personalEmail || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.personalEmail"
                  label="Personal Email"
                  type="email"
                  outlined
                  dense
                />
              </v-col>

              <!-- Phone (Read-only) -->
              <v-col cols="12" md="4">
                <div class="form-item">
                  <p class="label">Phone</p>
                  <p class="value">{{ personalDetailsData.phone || '-' }}</p>
                </div>
              </v-col>

              <!-- Alternate Phone -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Alternate Phone</p>
                  <p class="value">{{ personalDetailsData.alternatePhone || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.alternatePhone"
                  label="Alternate Phone"
                  outlined
                  dense
                />
              </v-col>

              <!-- Date of Birth -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Date of Birth</p>
                  <p class="value">{{ formatDate(personalDetailsData.dob) }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.dateOfBirth"
                  label="Date of Birth"
                  type="date"
                  outlined
                  dense
                />
              </v-col>

              <!-- Gender -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Gender</p>
                  <p class="value">{{ personalDetailsData.gender || '-' }}</p>
                </div>
                <v-select
                  v-else
                  v-model="profileData.gender"
                  label="Gender"
                  :items="[
                    { value: 'M', title: 'Male' },
                    { value: 'F', title: 'Female' },
                    { value: 'O', title: 'Other' },
                  ]"
                  outlined
                  dense
                />
              </v-col>

              <!-- Blood Group -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Blood Group</p>
                  <p class="value">{{ personalDetailsData.bloodGroup || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.bloodGroup"
                  label="Blood Group"
                  outlined
                  dense
                />
              </v-col>

              <!-- Marital Status -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Marital Status</p>
                  <p class="value">{{ personalDetailsData.maritalStatus || '-' }}</p>
                </div>
                <v-select
                  v-else
                  v-model="profileData.maritalStatus"
                  label="Marital Status"
                  :items="[
                    { value: 'Single', title: 'Single' },
                    { value: 'Married', title: 'Married' },
                    { value: 'Divorced', title: 'Divorced' },
                    { value: 'Widowed', title: 'Widowed' },
                  ]"
                  outlined
                  dense
                />
              </v-col>

              <!-- Nationality -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Nationality</p>
                  <p class="value">{{ personalDetailsData.nationality || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.nationality"
                  label="Nationality"
                  outlined
                  dense
                />
              </v-col>

              <!-- Father Name -->
              <v-col cols="12" md="4">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Father Name</p>
                  <p class="value">{{ personalDetailsData.fatherName || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.fatherName"
                  label="Father Name"
                  outlined
                  dense
                />
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>

        <!-- Current Address Section -->
        <v-card class="mb-4">
          <v-card-title class="pa-4 bg-grey-lighten-2" style="font-size: 0.875rem; font-weight: 600">
            Current Address
          </v-card-title>

          <v-card-text class="pa-6">
            <v-row>
              <!-- Country -->
              <v-col cols="12" md="6">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Country</p>
                  <p class="value">{{ getCountryName(personalDetailsData.countryId) }}</p>
                </div>
                <v-select
                  v-else
                  v-model="profileData.countryId"
                  label="Country"
                  :items="countries"
                  item-value="id"
                  item-title="name"
                  outlined
                  dense
                  @update:modelValue="onCountryChange"
                />
              </v-col>

              <!-- State -->
              <v-col cols="12" md="6">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">State/Province</p>
                  <p class="value">{{ getStateName(personalDetailsData.stateId) }}</p>
                </div>
                <v-select
                  v-else
                  v-model="profileData.stateId"
                  label="State/Province"
                  :items="states"
                  item-value="id"
                  item-title="name"
                  :disabled="!profileData.countryId"
                  outlined
                  dense
                  @update:modelValue="onStateChange"
                />
              </v-col>

              <!-- City -->
              <v-col cols="12" md="6">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">City</p>
                  <p class="value">{{ getCityName(personalDetailsData.cityId) }}</p>
                </div>
                <v-select
                  v-else
                  v-model="profileData.cityId"
                  label="City"
                  :items="cities"
                  item-value="id"
                  item-title="name"
                  :disabled="!profileData.stateId"
                  outlined
                  dense
                />
              </v-col>

              <!-- Postal Code -->
              <v-col cols="12" md="6">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Postal Code</p>
                  <p class="value">{{ personalDetailsData.postalCode || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.postalCode"
                  label="Postal Code"
                  outlined
                  dense
                />
              </v-col>

              <!-- Street Address Line 1 -->
              <v-col cols="12">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Street Address</p>
                  <p class="value">{{ personalDetailsData.addressLine1 || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.addressLine1"
                  label="Street Address"
                  outlined
                  dense
                />
              </v-col>

              <!-- Street Address Line 2 -->
              <v-col cols="12">
                <div v-if="!isEditable" class="form-item">
                  <p class="label">Address Line 2</p>
                  <p class="value">{{ personalDetailsData.addressLine2 || '-' }}</p>
                </div>
                <v-text-field
                  v-else
                  v-model="profileData.addressLine2"
                  label="Address Line 2 (Apartment, Suite, etc.)"
                  outlined
                  dense
                />
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>

              </v-window-item>

              <!-- Window Item 1: Official Details -->
              <v-window-item :value="1">
                <v-card>
                  <v-card-text class="pa-6">
                    <v-alert type="info" variant="tonal">
                      Official Details tab - Coming soon
                    </v-alert>
                  </v-card-text>
                </v-card>
              </v-window-item>

              <!-- Window Item 2: Employment Details -->
              <v-window-item :value="2">
                <v-card>
                  <v-card-text class="pa-6">
                    <v-alert type="info" variant="tonal">
                      Employment Details tab - Coming soon
                    </v-alert>
                  </v-card-text>
                </v-card>
              </v-window-item>

              <!-- Window Item 3: Education Details -->
              <v-window-item :value="3">
                <v-card>
                  <v-card-text class="pa-6">
                    <v-alert type="info" variant="tonal">
                      Education Details tab - Coming soon
                    </v-alert>
                  </v-card-text>
                </v-card>
              </v-window-item>

              <!-- Window Item 4: Nominee Details -->
              <v-window-item :value="4">
                <v-card>
                  <v-card-text class="pa-6">
                    <v-alert type="info" variant="tonal">
                      Nominee Details tab - Coming soon
                    </v-alert>
                  </v-card-text>
                </v-card>
              </v-window-item>

              <!-- Window Item 5: Certificate Details -->
              <v-window-item :value="5">
                <v-card>
                  <v-card-text class="pa-6">
                    <v-alert type="info" variant="tonal">
                      Certificate Details tab - Coming soon
                    </v-alert>
                  </v-card-text>
                </v-card>
              </v-window-item>

              <!-- Window Item 6: Exit Details -->
              <v-window-item :value="6">
                <v-card>
                  <v-card-text class="pa-6">
                    <v-alert
                      v-if="!hasActiveResignation"
                      type="warning"
                      variant="tonal"
                    >
                      No active resignation found
                    </v-alert>
                    <v-alert v-else type="info" variant="tonal">
                      Exit Details tab - Coming soon
                    </v-alert>
                  </v-card-text>
                </v-card>
              </v-window-item>
            </v-window>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<style scoped lang="scss">
// Typography
.label {
  font-size: 0.75rem;
  font-weight: 600;
  color: #8c8c8c;
  margin-bottom: 4px;
  display: block;
}

.value {
  font-size: 0.875rem;
  font-weight: 500;
  color: #262626;
  margin: 0;
}

.form-item {
  display: flex;
  flex-direction: column;

  .label {
    margin-bottom: 6px;
  }

  .value {
    word-break: break-word;
  }
}

// Colors and spacing
v-card {
  border: none !important;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08) !important;
}

:deep(.bg-grey-lighten-2) {
  background-color: #f5f5f5 !important;
}

// Button group styling
.button-group {
  display: flex;
  gap: 8px;
  align-items: center;
}

// Quick info styling
.quick-info-item {
  display: flex;
  flex-direction: column;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;

  &:last-child {
    border-bottom: none;
  }
}

// Link styling
a {
  color: #1e75bb;
  text-decoration: none;

  &:hover {
    text-decoration: underline;
  }
}

// Grid spacing
:deep(.v-col) {
  padding: 12px;
}

// Responsive adjustments
@media (max-width: 960px) {
  :deep(.v-col) {
    padding: 8px;
  }
}
</style>

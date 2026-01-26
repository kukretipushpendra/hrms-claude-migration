<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import dayjs from 'dayjs';
import { useAuthStore } from '@/stores/auth.store';
import { useSnackbar } from '@/composables/useSnackbar';
import {
  getResignationDetails,
  revokeResignation,
  requestEarlyRelease,
} from '@/services/exit/exit.service';
import { canRevokeResignation, canRequestEarlyRelease } from '@/utils/exit-helpers';
import {
  ResignationStatus,
  RESIGNATION_STATUS_LABELS,
  EARLY_RELEASE_STATUS_LABELS,
  type ResignationExitDetails,
} from '@/types/exit.types';
import ResignationReasonDialog from '@/components/exit/ResignationReasonDialog.vue';
import EarlyReleaseDialog from '@/components/exit/EarlyReleaseDialog.vue';

const router = useRouter();
const authStore = useAuthStore();
const { showSuccess, showError } = useSnackbar();

// State
const loading = ref(false);
const resignationDetails = ref<ResignationExitDetails | null>(null);
const showReasonDialog = ref(false);
const showRejectionDialog = ref(false);
const showEarlyReleaseDialog = ref(false);
const revoking = ref(false);

// Computed
const canRevoke = computed(() => {
  if (!resignationDetails.value) return false;
  return canRevokeResignation(
    resignationDetails.value.status,
    resignationDetails.value.lastWorkingDay
  );
});

const canRequestEarlyReleaseAction = computed(() => {
  if (!resignationDetails.value) return false;
  return canRequestEarlyRelease(
    resignationDetails.value.status,
    resignationDetails.value.earlyReleaseStatus
  );
});

const statusLabel = computed(() => {
  if (!resignationDetails.value) return '';
  return RESIGNATION_STATUS_LABELS[resignationDetails.value.status] || '';
});

const earlyReleaseLabel = computed(() => {
  if (!resignationDetails.value || !resignationDetails.value.earlyReleaseStatus) return 'N/A';
  return EARLY_RELEASE_STATUS_LABELS[resignationDetails.value.earlyReleaseStatus] || 'N/A';
});

// Fetch resignation details
const fetchDetails = async () => {
  if (!authStore.user) {
    router.push('/login');
    return;
  }

  try {
    loading.value = true;
    const response = await getResignationDetails(Number(authStore.user.id));

    if (response.result) {
      resignationDetails.value = response.result;
    } else {
      showError('No resignation found');
      router.push('/profile');
    }
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to fetch resignation details');
    router.push('/profile');
  } finally {
    loading.value = false;
  }
};

// Revoke resignation
const handleRevoke = async () => {
  if (!resignationDetails.value) return;

  const confirmed = confirm('Are you sure you want to revoke your resignation?');
  if (!confirmed) return;

  try {
    revoking.value = true;
    const response = await revokeResignation(resignationDetails.value.id);
    showSuccess(response.message || 'Resignation revoked successfully');
    await fetchDetails();
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to revoke resignation');
  } finally {
    revoking.value = false;
  }
};

// Handle early release request
const handleEarlyReleaseSubmit = async (earlyReleaseDate: string) => {
  if (!resignationDetails.value) return;

  try {
    const response = await requestEarlyRelease({
      resignationId: resignationDetails.value.id,
      earlyReleaseDate,
    });
    showSuccess(response.message || 'Early release request submitted');
    showEarlyReleaseDialog.value = false;
    await fetchDetails();
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to request early release');
  }
};

// Open reason dialogs
const openResignationReason = () => {
  showReasonDialog.value = true;
};

const openRejectionReason = () => {
  showRejectionDialog.value = true;
};

onMounted(() => {
  fetchDetails();
});
</script>

<template>
  <v-container fluid>
    <!-- Breadcrumbs -->
    <v-breadcrumbs
      :items="[
        { title: 'Home', disabled: false, href: '/' },
        { title: 'Profile', disabled: false, href: '/profile' },
        { title: 'Exit Details', disabled: true },
      ]"
    />

    <!-- Page Header -->
    <v-card elevation="3" class="mb-4">
      <v-card-title class="text-h5 pa-4">Exit Details</v-card-title>
    </v-card>

    <!-- Loading State -->
    <v-progress-linear v-if="loading" indeterminate color="primary" />

    <!-- Content -->
    <v-card v-else-if="resignationDetails" elevation="3">
      <v-card-text class="pa-6">
        <v-row>
          <!-- Employee Name -->
          <v-col cols="12" sm="6" md="4">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Employee Name</div>
            <div class="text-body-1 font-weight-medium">
              {{ resignationDetails.employeeName }}
            </div>
          </v-col>

          <!-- Department -->
          <v-col cols="12" sm="6" md="4">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Department</div>
            <div class="text-body-1 font-weight-medium">
              {{ resignationDetails.department }}
            </div>
          </v-col>

          <!-- Reporting Manager -->
          <v-col cols="12" sm="6" md="4">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Reporting Manager</div>
            <div class="text-body-1 font-weight-medium">
              {{ resignationDetails.reportingManager }}
            </div>
          </v-col>

          <!-- Resignation Date -->
          <v-col cols="12" sm="6" md="4">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Resignation Date</div>
            <div class="text-body-1 font-weight-medium">
              {{ dayjs(resignationDetails.resignationDate).format('MMM DD, YYYY') }}
            </div>
          </v-col>

          <!-- Last Working Day -->
          <v-col cols="12" sm="6" md="4">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Last Working Day</div>
            <div class="text-body-1 font-weight-medium">
              {{ dayjs(resignationDetails.lastWorkingDay).format('MMM DD, YYYY') }}
            </div>
          </v-col>

          <!-- Status -->
          <v-col cols="12" sm="6" md="4">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Status</div>
            <v-chip
              :color="
                resignationDetails.status === ResignationStatus.accepted
                  ? 'success'
                  : resignationDetails.status === ResignationStatus.pending
                    ? 'warning'
                    : 'error'
              "
              size="small"
            >
              {{ statusLabel }}
            </v-chip>
          </v-col>

          <!-- Early Release Date (if applicable) -->
          <v-col v-if="resignationDetails.earlyReleaseDate" cols="12" sm="6" md="4">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Early Release Date</div>
            <div class="text-body-1 font-weight-medium">
              {{ dayjs(resignationDetails.earlyReleaseDate).format('MMM DD, YYYY') }}
            </div>
          </v-col>

          <!-- Early Release Status -->
          <v-col v-if="resignationDetails.earlyReleaseStatus" cols="12" sm="6" md="4">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Early Release Status</div>
            <div class="text-body-1 font-weight-medium">
              {{ earlyReleaseLabel }}
            </div>
          </v-col>

          <!-- Resignation Reason -->
          <v-col cols="12">
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Resignation Reason</div>
            <div class="text-body-1">
              {{ resignationDetails.reason }}
              <v-btn size="small" variant="text" color="primary" @click="openResignationReason">
                View Full
              </v-btn>
            </div>
          </v-col>

          <!-- Rejection Reason (if rejected) -->
          <v-col
            v-if="
              resignationDetails.rejectResignationReason ||
              resignationDetails.rejectEarlyReleaseReason
            "
            cols="12"
          >
            <div class="text-subtitle-2 text-grey-darken-1 mb-1">Rejection Reason</div>
            <div class="text-body-1">
              {{
                resignationDetails.rejectResignationReason ||
                resignationDetails.rejectEarlyReleaseReason
              }}
              <v-btn size="small" variant="text" color="primary" @click="openRejectionReason">
                View Full
              </v-btn>
            </div>
          </v-col>
        </v-row>

        <!-- Action Buttons -->
        <v-row class="mt-4">
          <v-col>
            <v-btn
              v-if="canRevoke"
              color="error"
              variant="outlined"
              :loading="revoking"
              @click="handleRevoke"
            >
              Revoke Resignation
            </v-btn>
            <v-btn
              v-if="canRequestEarlyReleaseAction"
              color="primary"
              class="ml-2"
              @click="showEarlyReleaseDialog = true"
            >
              Request Early Release
            </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- Resignation Reason Dialog -->
    <ResignationReasonDialog
      v-model="showReasonDialog"
      title="Resignation Reason"
      :reason="resignationDetails?.reason || ''"
    />

    <!-- Rejection Reason Dialog -->
    <ResignationReasonDialog
      v-model="showRejectionDialog"
      title="Rejection Reason"
      :reason="
        resignationDetails?.rejectResignationReason ||
        resignationDetails?.rejectEarlyReleaseReason ||
        ''
      "
    />

    <!-- Early Release Dialog -->
    <EarlyReleaseDialog
      v-model="showEarlyReleaseDialog"
      :last-working-day="resignationDetails?.lastWorkingDay || ''"
      @submit="handleEarlyReleaseSubmit"
    />
  </v-container>
</template>

<style scoped>
.v-breadcrumbs {
  padding-left: 0;
}
</style>

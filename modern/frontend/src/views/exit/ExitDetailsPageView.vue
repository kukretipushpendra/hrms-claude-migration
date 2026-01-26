<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import dayjs from 'dayjs';
import { useAuthStore } from '@/stores/auth.store';
import { useSnackbar } from '@/composables/useSnackbar';
import {
  getResignationById,
  acceptResignation,
  acceptEarlyRelease,
  adminRejection,
  updateLastWorkingDay,
} from '@/services/exit/exit.service';
import { canEditClearances } from '@/utils/exit-helpers';
import {
  RESIGNATION_STATUS_LABELS,
  type ExitEmployeeListItem,
  type AdminRejectionRequest,
  type UpdateLastWorkingDayRequest,
} from '@/types/exit.types';
import HRClearanceForm from '@/components/exit/HRClearanceForm.vue';
import DepartmentClearanceForm from '@/components/exit/DepartmentClearanceForm.vue';
import ITClearanceForm from '@/components/exit/ITClearanceForm.vue';
import AccountClearanceForm from '@/components/exit/AccountClearanceForm.vue';
import AcceptResignationDialog from '@/components/exit/AcceptResignationDialog.vue';
import RejectDialog from '@/components/exit/RejectDialog.vue';
import UpdateLWDDialog from '@/components/exit/UpdateLWDDialog.vue';

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const { showSuccess, showError } = useSnackbar();

// State
const loading = ref(false);
const resignationData = ref<ExitEmployeeListItem | null>(null);
const activeTab = ref('hr');
const showAcceptDialog = ref(false);
const showRejectResignationDialog = ref(false);
const showRejectEarlyReleaseDialog = ref(false);
const showUpdateLWDDialog = ref(false);
const actionLoading = ref(false);

// Computed
const resignationId = computed(() => Number(route.params.resignationId));

const canEdit = computed(() => {
  if (!resignationData.value) return false;
  return canEditClearances(resignationData.value.resignationStatus);
});

const statusLabel = computed(() => {
  if (!resignationData.value) return '';
  return RESIGNATION_STATUS_LABELS[resignationData.value.resignationStatus] || '';
});

const canAcceptResignation = computed(() => {
  if (!resignationData.value) return false;
  return resignationData.value.resignationStatus === 1; // Pending
});

const canAcceptEarlyRelease = computed(() => {
  if (!resignationData.value) return false;
  return (
    resignationData.value.resignationStatus === 3 && // Accepted
    resignationData.value.earlyReleaseStatus === 1 // Early release pending
  );
});

// Fetch resignation details
const fetchResignationDetails = async () => {
  try {
    loading.value = true;
    const response = await getResignationById(resignationId.value);

    if (response.result) {
      resignationData.value = response.result;
    } else {
      showError('Resignation not found');
      router.push({ name: 'exit-employee-list' });
    }
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to fetch resignation details');
    router.push({ name: 'exit-employee-list' });
  } finally {
    loading.value = false;
  }
};

// Accept resignation
const handleAcceptResignation = async () => {
  if (!resignationData.value) return;

  try {
    actionLoading.value = true;
    const response = await acceptResignation(resignationData.value.resignationId);
    showSuccess(response.message || 'Resignation accepted successfully');
    showAcceptDialog.value = false;
    await fetchResignationDetails();
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to accept resignation');
  } finally {
    actionLoading.value = false;
  }
};

// Reject resignation
const handleRejectResignation = async (reason: string) => {
  if (!resignationData.value) return;

  try {
    actionLoading.value = true;
    const request: AdminRejectionRequest = {
      resignationId: resignationData.value.resignationId,
      employeeId: resignationData.value.employeeCode
        ? parseInt(resignationData.value.employeeCode)
        : 0,
      rejectionType: 'Resignation',
      rejectReason: reason,
    };
    const response = await adminRejection(request);
    showSuccess(response.message || 'Resignation rejected successfully');
    showRejectResignationDialog.value = false;
    await fetchResignationDetails();
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to reject resignation');
  } finally {
    actionLoading.value = false;
  }
};

// Accept early release
const handleAcceptEarlyRelease = async () => {
  if (!resignationData.value || !resignationData.value.earlyReleaseDate) return;

  try {
    actionLoading.value = true;
    const response = await acceptEarlyRelease({
      resignationId: resignationData.value.resignationId,
      earlyReleaseDate: resignationData.value.earlyReleaseDate,
    });
    showSuccess(response.message || 'Early release accepted successfully');
    await fetchResignationDetails();
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to accept early release');
  } finally {
    actionLoading.value = false;
  }
};

// Reject early release
const handleRejectEarlyRelease = async (reason: string) => {
  if (!resignationData.value) return;

  try {
    actionLoading.value = true;
    const request: AdminRejectionRequest = {
      resignationId: resignationData.value.resignationId,
      employeeId: resignationData.value.employeeCode
        ? parseInt(resignationData.value.employeeCode)
        : 0,
      rejectionType: 'EarlyRelease',
      rejectReason: reason,
    };
    const response = await adminRejection(request);
    showSuccess(response.message || 'Early release rejected successfully');
    showRejectEarlyReleaseDialog.value = false;
    await fetchResignationDetails();
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to reject early release');
  } finally {
    actionLoading.value = false;
  }
};

// Update last working day
const handleUpdateLWD = async (newLWD: string) => {
  if (!resignationData.value) return;

  try {
    actionLoading.value = true;
    const request: UpdateLastWorkingDayRequest = {
      resignationId: resignationData.value.resignationId,
      lastWorkingDay: newLWD,
    };
    const response = await updateLastWorkingDay(request);
    showSuccess(response.message || 'Last working day updated successfully');
    showUpdateLWDDialog.value = false;
    await fetchResignationDetails();
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to update last working day');
  } finally {
    actionLoading.value = false;
  }
};

// Permission check
onMounted(() => {
  const hasPermission = authStore.hasPermission('Read.Employees');
  if (!hasPermission) {
    router.replace('/unauthorized');
    return;
  }
  fetchResignationDetails();
});
</script>

<template>
  <v-container fluid>
    <!-- Breadcrumbs -->
    <v-breadcrumbs
      :items="[
        { title: 'Home', disabled: false, href: '/' },
        { title: 'Employees', disabled: false, href: '/employees' },
        { title: 'Employee Exit', disabled: false, href: '/employees/employee-exit' },
        { title: 'Exit Details', disabled: true },
      ]"
    />

    <!-- Loading State -->
    <v-progress-linear v-if="loading" indeterminate color="primary" />

    <template v-else-if="resignationData">
      <!-- Page Header with Actions -->
      <v-card elevation="3" class="mb-4">
        <v-card-title class="text-h5 pa-4">
          Exit Details - {{ resignationData.employeeName }}
        </v-card-title>
        <v-card-text>
          <v-row>
            <v-col cols="auto">
              <v-chip :color="statusLabel === 'Accepted' ? 'success' : 'warning'" size="small">
                {{ statusLabel }}
              </v-chip>
            </v-col>
          </v-row>
          <v-row class="mt-2">
            <v-col>
              <v-btn
                v-if="canAcceptResignation"
                color="success"
                variant="flat"
                :loading="actionLoading"
                @click="showAcceptDialog = true"
              >
                Accept Resignation
              </v-btn>
              <v-btn
                v-if="canAcceptResignation"
                color="error"
                variant="outlined"
                class="ml-2"
                :loading="actionLoading"
                @click="showRejectResignationDialog = true"
              >
                Reject Resignation
              </v-btn>
              <v-btn
                v-if="canAcceptEarlyRelease"
                color="primary"
                variant="flat"
                class="ml-2"
                :loading="actionLoading"
                @click="handleAcceptEarlyRelease"
              >
                Accept Early Release
              </v-btn>
              <v-btn
                v-if="canAcceptEarlyRelease"
                color="error"
                variant="outlined"
                class="ml-2"
                :loading="actionLoading"
                @click="showRejectEarlyReleaseDialog = true"
              >
                Reject Early Release
              </v-btn>
              <v-btn
                v-if="canEdit"
                color="primary"
                variant="outlined"
                class="ml-2"
                @click="showUpdateLWDDialog = true"
              >
                Update Last Working Day
              </v-btn>
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>

      <!-- Resignation Info -->
      <v-card elevation="3" class="mb-4">
        <v-card-text class="pa-6">
          <v-row>
            <v-col cols="12" sm="6" md="3">
              <div class="text-subtitle-2 text-grey-darken-1 mb-1">Employee Code</div>
              <div class="text-body-1 font-weight-medium">{{ resignationData.employeeCode }}</div>
            </v-col>
            <v-col cols="12" sm="6" md="3">
              <div class="text-subtitle-2 text-grey-darken-1 mb-1">Department</div>
              <div class="text-body-1 font-weight-medium">{{ resignationData.departmentName }}</div>
            </v-col>
            <v-col cols="12" sm="6" md="3">
              <div class="text-subtitle-2 text-grey-darken-1 mb-1">Resignation Date</div>
              <div class="text-body-1 font-weight-medium">
                {{ dayjs(resignationData.resignationDate).format('MMM DD, YYYY') }}
              </div>
            </v-col>
            <v-col cols="12" sm="6" md="3">
              <div class="text-subtitle-2 text-grey-darken-1 mb-1">Last Working Day</div>
              <div class="text-body-1 font-weight-medium">
                {{ dayjs(resignationData.lastWorkingDay).format('MMM DD, YYYY') }}
              </div>
            </v-col>
            <v-col v-if="resignationData.earlyReleaseDate" cols="12" sm="6" md="3">
              <div class="text-subtitle-2 text-grey-darken-1 mb-1">Early Release Date</div>
              <div class="text-body-1 font-weight-medium">
                {{ dayjs(resignationData.earlyReleaseDate).format('MMM DD, YYYY') }}
              </div>
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>

      <!-- Clearance Forms Tabs -->
      <v-card elevation="3">
        <v-tabs v-model="activeTab" bg-color="primary">
          <v-tab value="hr">HR Clearance</v-tab>
          <v-tab value="department">Department Clearance</v-tab>
          <v-tab value="it">IT Clearance</v-tab>
          <v-tab value="accounts">Accounts Clearance</v-tab>
        </v-tabs>

        <v-card-text class="pa-6">
          <v-window v-model="activeTab">
            <v-window-item value="hr">
              <HRClearanceForm
                :resignation-id="resignationId"
                :employee-id="parseInt(resignationData.employeeCode) || 0"
                :can-edit="canEdit"
              />
            </v-window-item>

            <v-window-item value="department">
              <DepartmentClearanceForm
                :resignation-id="resignationId"
                :employee-id="parseInt(resignationData.employeeCode) || 0"
                :can-edit="canEdit"
              />
            </v-window-item>

            <v-window-item value="it">
              <ITClearanceForm
                :resignation-id="resignationId"
                :employee-id="parseInt(resignationData.employeeCode) || 0"
                :can-edit="canEdit"
              />
            </v-window-item>

            <v-window-item value="accounts">
              <AccountClearanceForm
                :resignation-id="resignationId"
                :employee-id="parseInt(resignationData.employeeCode) || 0"
                :can-edit="canEdit"
              />
            </v-window-item>
          </v-window>
        </v-card-text>
      </v-card>
    </template>

    <!-- Accept Resignation Dialog -->
    <AcceptResignationDialog
      v-model="showAcceptDialog"
      :loading="actionLoading"
      @confirm="handleAcceptResignation"
    />

    <!-- Reject Resignation Dialog -->
    <RejectDialog
      v-model="showRejectResignationDialog"
      type="resignation"
      :loading="actionLoading"
      @submit="handleRejectResignation"
    />

    <!-- Reject Early Release Dialog -->
    <RejectDialog
      v-model="showRejectEarlyReleaseDialog"
      type="earlyrelease"
      :loading="actionLoading"
      @submit="handleRejectEarlyRelease"
    />

    <!-- Update LWD Dialog -->
    <UpdateLWDDialog
      v-model="showUpdateLWDDialog"
      :current-lwd="resignationData?.lastWorkingDay || ''"
      :loading="actionLoading"
      @submit="handleUpdateLWD"
    />
  </v-container>
</template>

<style scoped>
.v-breadcrumbs {
  padding-left: 0;
}
</style>

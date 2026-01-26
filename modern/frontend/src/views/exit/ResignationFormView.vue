<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import dayjs from 'dayjs';
import { useAuthStore } from '@/stores/auth.store';
import { useSnackbar } from '@/composables/useSnackbar';
import {
  getResignationForm,
  addResignation,
  isResignationExist,
} from '@/services/exit/exit.service';
import { calculateLastWorkingDay, formatDateForApi } from '@/utils/exit-helpers';
import { ResignationStatus } from '@/types/exit.types';
import type { ResignationFormData, AddResignationRequest } from '@/types/exit.types';

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const { showSuccess, showError } = useSnackbar();

// State
const loading = ref(false);
const submitting = ref(false);
const resignationData = ref<ResignationFormData | null>(null);
const showConfirmDialog = ref(false);
const resignationDate = ref('');
const lastWorkingDay = ref('');

// Get target employee ID (from route param or current user)
const targetEmployeeId = computed(() => {
  const paramId = route.params.userId as string | undefined;
  return paramId ? Number(paramId) : authStore.user?.userId || 0;
});

// Validation schema
const schema = toTypedSchema(
  z.object({
    employeeName: z.string().min(1, 'Employee name is required'),
    department: z.string().min(1, 'Department is required'),
    reportingManager: z.string().min(1, 'Reporting manager is required'),
    resignationReason: z
      .string()
      .min(1, 'Resignation reason is required')
      .max(500, 'Resignation reason must not exceed 500 characters'),
  })
);

const { defineField, handleSubmit, errors, setValues, resetForm } = useForm({
  validationSchema: schema,
  initialValues: {
    employeeName: '',
    department: '',
    reportingManager: '',
    resignationReason: '',
  },
});

const [employeeName, employeeNameAttrs] = defineField('employeeName');
const [department, departmentAttrs] = defineField('department');
const [reportingManager, reportingManagerAttrs] = defineField('reportingManager');
const [resignationReason, resignationReasonAttrs] = defineField('resignationReason');

// Check if resignation exists and is active
const checkResignationStatus = async () => {
  try {
    loading.value = true;
    const response = await isResignationExist(targetEmployeeId.value);

    const resignationStatus = response.result?.resignationStatus;

    // Can create new resignation if:
    // - No resignation exists (result is null)
    // - Or status is cancelled (4) or revoked (2)
    const canCreateNew =
      !resignationStatus ||
      resignationStatus === ResignationStatus.cancelled ||
      resignationStatus === ResignationStatus.revoked;

    if (canCreateNew) {
      await fetchResignationForm();
    } else {
      // Redirect if active resignation exists
      router.replace('/not-found');
    }
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to check resignation status');
    router.replace('/');
  } finally {
    loading.value = false;
  }
};

// Fetch resignation form data
const fetchResignationForm = async () => {
  try {
    loading.value = true;
    const response = await getResignationForm(targetEmployeeId.value);

    if (response.result) {
      resignationData.value = response.result;

      // Populate form fields
      setValues({
        employeeName: response.result.employeeName,
        department: response.result.department,
        reportingManager: response.result.reportingManagerName,
        resignationReason: '',
      });
    }
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to fetch resignation form');
    router.push('/');
  } finally {
    loading.value = false;
  }
};

// Submit resignation
const onSubmit = handleSubmit(async (values) => {
  if (!resignationData.value) return;

  try {
    submitting.value = true;

    const requestData: AddResignationRequest = {
      employeeId: resignationData.value.id,
      departmentId: resignationData.value.departmentId,
      reportingManagerId: resignationData.value.reportingManagerId,
      jobType: resignationData.value.jobType,
      reason: values.resignationReason,
    };

    const response = await addResignation(requestData);

    showSuccess(response.message || 'Resignation submitted successfully');

    // Calculate dates for confirmation dialog
    const today = dayjs();
    resignationDate.value = formatDateForApi(today);
    lastWorkingDay.value = formatDateForApi(
      calculateLastWorkingDay(today, resignationData.value.jobType)
    );

    showConfirmDialog.value = true;
  } catch (error: any) {
    showError(error.response?.data?.message || 'Failed to submit resignation');
  } finally {
    submitting.value = false;
  }
});

// Handle confirmation dialog close
const handleDialogClose = () => {
  showConfirmDialog.value = false;
  router.push('/profile');
};

// Reset form
const handleReset = () => {
  resetForm();
  if (resignationData.value) {
    setValues({
      employeeName: resignationData.value.employeeName,
      department: resignationData.value.department,
      reportingManager: resignationData.value.reportingManagerName,
      resignationReason: '',
    });
  }
};

// Check permission for viewing other users' data
onMounted(() => {
  const paramId = route.params.userId as string | undefined;
  const currentUserId = authStore.user?.userId;

  // If viewing another user's form, check permission
  if (paramId && Number(paramId) !== currentUserId) {
    const hasPermission = authStore.hasPermission('Read.Employees');
    if (!hasPermission) {
      router.replace('/unauthorized');
      return;
    }
  }

  checkResignationStatus();
});
</script>

<template>
  <v-container fluid>
    <!-- Breadcrumbs -->
    <v-breadcrumbs
      :items="[
        { title: 'Home', disabled: false, href: '/' },
        { title: 'Resignation Form', disabled: true },
      ]"
    />

    <!-- Page Header -->
    <v-card elevation="3" class="mb-4">
      <v-card-title class="text-h5 pa-4">Resignation Form</v-card-title>
    </v-card>

    <!-- Loading State -->
    <v-progress-linear v-if="loading" indeterminate color="primary" />

    <!-- Form -->
    <v-card v-else elevation="3">
      <v-card-text class="pa-6">
        <form @submit.prevent="onSubmit">
          <v-row>
            <!-- Employee Name (Read-only) -->
            <v-col cols="12" sm="6" md="4">
              <v-text-field
                v-model="employeeName"
                v-bind="employeeNameAttrs"
                label="Employee Name"
                variant="outlined"
                readonly
                :error-messages="errors.employeeName"
              />
            </v-col>

            <!-- Department (Read-only) -->
            <v-col cols="12" sm="6" md="4">
              <v-text-field
                v-model="department"
                v-bind="departmentAttrs"
                label="Department"
                variant="outlined"
                readonly
                :error-messages="errors.department"
              />
            </v-col>

            <!-- Reporting Manager (Read-only) -->
            <v-col cols="12" sm="6" md="4">
              <v-text-field
                v-model="reportingManager"
                v-bind="reportingManagerAttrs"
                label="Reporting Manager"
                variant="outlined"
                readonly
                :error-messages="errors.reportingManager"
              />
            </v-col>

            <!-- Resignation Reason -->
            <v-col cols="12">
              <v-textarea
                v-model="resignationReason"
                v-bind="resignationReasonAttrs"
                label="Resignation Reason"
                variant="outlined"
                rows="4"
                counter="500"
                maxlength="500"
                :error-messages="errors.resignationReason"
                required
              />
            </v-col>
          </v-row>

          <!-- Action Buttons -->
          <v-row class="mt-4">
            <v-col>
              <v-btn
                type="submit"
                color="primary"
                :loading="submitting"
                :disabled="submitting"
                size="large"
              >
                Submit Resignation
              </v-btn>
              <v-btn
                type="button"
                color="secondary"
                variant="outlined"
                size="large"
                class="ml-2"
                @click="handleReset"
              >
                Reset
              </v-btn>
            </v-col>
          </v-row>
        </form>
      </v-card-text>
    </v-card>

    <!-- Confirmation Dialog -->
    <v-dialog v-model="showConfirmDialog" max-width="500">
      <v-card>
        <v-card-title class="text-h6 bg-primary text-white"> Resignation Submitted </v-card-title>
        <v-card-text class="pa-6">
          <p class="mb-2">Your resignation has been submitted successfully.</p>
          <v-divider class="my-4" />
          <v-row dense>
            <v-col cols="6">
              <strong>Resignation Date:</strong>
            </v-col>
            <v-col cols="6">
              {{ dayjs(resignationDate).format('MMM DD, YYYY') }}
            </v-col>
            <v-col cols="6">
              <strong>Last Working Day:</strong>
            </v-col>
            <v-col cols="6">
              {{ dayjs(lastWorkingDay).format('MMM DD, YYYY') }}
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="primary" variant="flat" @click="handleDialogClose"> OK </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<style scoped>
.v-breadcrumbs {
  padding-left: 0;
}
</style>

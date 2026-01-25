<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue';
import { useRoute } from 'vue-router';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import moment from 'moment';
import { useAuthStore } from '@/stores/auth.store';
import { useSnackbar } from '@/composables/useSnackbar';
import {
  getEmploymentDetailById,
  updateEmploymentDetail,
  getLatestEmployeeCode,
  type EmployeeDetailsType,
  type UpdateEmploymentDetailArgs,
} from '@/services/employment';
import {
  formatDuration,
  jobTypes,
  backgroundVerificationStatuses,
  criminalVerificationStatuses,
  CRIMINAL_VERIFICATION_STATUS,
  EMPLOYMENT_STATUS,
  EMPLOYMENT_STATUS_OPTIONS,
  convertApiValueToStr,
  convertFormStrToApiValue,
} from '../utils';
import ReportingManagerAutocomplete from './ReportingManagerAutocomplete.vue';
import DepartmentAutocomplete from './DepartmentAutocomplete.vue';
import DesignationAutocomplete from './DesignationAutocomplete.vue';
import TeamAutocomplete from './TeamAutocomplete.vue';
import BranchSelectField from './BranchSelectField.vue';
import RoleSelectField from './RoleSelectField.vue';
import EmployeeStatusSelectField from './EmployeeStatusSelectField.vue';
import NotFoundView from '@/views/error/NotFoundView.vue';

interface Props {
  isEditable: boolean;
}

const props = defineProps<Props>();

const route = useRoute();
const authStore = useAuthStore();
const { showSuccess, showError } = useSnackbar();

const employeeId = ref(route.query.employeeId as string || authStore.user?.userId.toString() || '');
const currentEmploymentDetails = ref<EmployeeDetailsType | null>(null);
const loading = ref(false);
const isUpdating = ref(false);
const isFetchingNewEmployeeCode = ref(false);
const isEmployeeCodeEditable = ref(false);

// Permission checks
const hasRolePermission = computed(() => {
  if (props.isEditable) {
    return authStore.hasPermission('Read.Role') && authStore.hasPermission('Edit.Role');
  }
  return authStore.hasPermission('Read.Role');
});

const hasEmployeePermission = computed(() => {
  if (props.isEditable) {
    return authStore.hasPermission('Read.Employees') && authStore.hasPermission('Edit.Employees');
  }
  return authStore.hasPermission('Read.Employees');
});

const hasReadPermission = authStore.hasPermission('Read.EmploymentDetails');

// LinkedIn profile regex
const linkedInProfileRegex =
  /(https?:\/\/)?(www\.)?linkedin\.([a-z]+)\/in\/([A-Za-z0-9_-]+)\/?/;

// Validation schema
const validationSchema = toTypedSchema(
  z.object({
    employeeId: z.string().min(1, 'Employee Id is required'),
    employeeCode: z.string().min(1, 'Employee Code is required'),
    email: z
      .string()
      .email('Invalid email')
      .min(8, 'Email must be at least 8 characters long.')
      .max(50, 'Email cannot exceed 50 characters.'),
    designationId: z.string().min(1, 'Designation is required'),
    departmentId: z.string().min(1, 'Department is required'),
    teamId: z.string().min(1, 'Team is required'),
    employmentStatus: z.string(),
    jobType: z.string(),
    branchId: z.string().min(1, 'Branch is required'),
    roleId: hasRolePermission.value
      ? z.string().min(1, 'Role is required')
      : z.string(),
    isReportingManager: z.boolean(),
    timeDoctorUserId: z
      .string()
      .max(20, 'Time Doctor User Id cannot exceed 20 characters')
      .nullable()
      .transform((val) => (val === '' ? null : val)),
    employeeStatus: z.string(),
    reportingManagerId: z.string().nullable(),
    backgroundVerificationstatus: z.string(),
    criminalVerification: z.string(),
    joiningDate: z.string().nullable(),
    probationMonths: z
      .number({ invalid_type_error: 'Probation months must be a number' })
      .int('Probation months must be an integer')
      .min(0, 'Probation months must be positive'),
    confirmationDate: z.string().nullable(),
    totalExperienceYears: z
      .number({ invalid_type_error: 'Total experience years must be a number' })
      .int('Total experience years must be an integer')
      .min(0, 'Total experience years must be positive')
      .max(40, 'Total experience years must not exceed 40'),
    totalExperienceMonths: z
      .number({ invalid_type_error: 'Total experience months must be a number' })
      .int('Total experience months must be an integer')
      .min(0, 'Total experience months must be positive')
      .max(11, 'Total experience months must not exceed 11'),
    relevantExperienceYears: z
      .number({ invalid_type_error: 'Relevant experience years must be a number' })
      .int('Relevant experience years must be an integer')
      .min(0, 'Relevant experience years must be positive')
      .max(40, 'Relevant experience years must not exceed 40'),
    relevantExperienceMonths: z
      .number({ invalid_type_error: 'Relevant experience months must be a number' })
      .int('Relevant experience months must be an integer')
      .min(0, 'Relevant experience months must be positive')
      .max(11, 'Relevant experience months must not exceed 11'),
    extendedConfirmationDate: z.string().nullable(),
    probExtendedWeeks: z
      .number({ invalid_type_error: 'Extended probation weeks must be a number' })
      .int('Extended probation weeks must be an integer')
      .nonnegative('Extended probation weeks must be positive'),
    linkedInUrl: z
      .string()
      .max(250, 'LinkedIn URL cannot exceed 250 characters')
      .refine(
        (val) => !val || linkedInProfileRegex.test(val),
        'Enter valid LinkedIn profile URL'
      ),
  })
);

const { handleSubmit, setValues, values, errors, setFieldValue, meta } = useForm({
  validationSchema,
  initialValues: {
    employeeId: '',
    employeeCode: '',
    email: '',
    designationId: '',
    departmentId: '',
    teamId: '',
    employmentStatus: '',
    jobType: '',
    branchId: '',
    roleId: '',
    isReportingManager: false,
    employeeStatus: '',
    reportingManagerId: '',
    joiningDate: null,
    backgroundVerificationstatus: '',
    criminalVerification: '',
    probationMonths: 0,
    confirmationDate: null,
    totalExperienceYears: 0,
    totalExperienceMonths: 0,
    relevantExperienceYears: 0,
    relevantExperienceMonths: 0,
    probExtendedWeeks: 0,
    extendedConfirmationDate: null,
    linkedInUrl: '',
    timeDoctorUserId: '',
  },
});

const isCriminalVerificationCompleted = computed(() => {
  return (
    !meta.value.touched.criminalVerification &&
    values.criminalVerification === CRIMINAL_VERIFICATION_STATUS.COMPLETED
  );
});

// Fetch employment details
const fetchEmploymentDetail = async () => {
  if (!hasReadPermission) {
    return;
  }

  loading.value = true;
  try {
    const response = await getEmploymentDetailById(employeeId.value);
    currentEmploymentDetails.value = response.result;

    // Set form values
    const criminalVerificationStatus =
      response.result.criminalVerification === null
        ? ''
        : response.result.criminalVerification
        ? CRIMINAL_VERIFICATION_STATUS.COMPLETED
        : CRIMINAL_VERIFICATION_STATUS.PENDING;

    setValues({
      employeeId: response.result.employeeId?.toString(),
      employeeCode: response.result.employeeCode,
      email: response.result.email,
      designationId: convertApiValueToStr(response.result.designationId),
      departmentId: convertApiValueToStr(response.result.departmentId),
      teamId: convertApiValueToStr(response.result.teamId),
      employmentStatus: convertApiValueToStr(response.result.employmentStatus),
      jobType: convertApiValueToStr(response.result.jobType),
      branchId: convertApiValueToStr(response.result.branchId),
      roleId: hasRolePermission.value
        ? convertApiValueToStr(response.result.roleId)
        : response.result.roleId.toString(),
      isReportingManager: response.result.isReportingManager ?? false,
      employeeStatus: convertApiValueToStr(response.result.employeeStatus),
      reportingManagerId: convertApiValueToStr(response.result.reportingManagerId),
      joiningDate: response.result.joiningDate,
      backgroundVerificationstatus: convertApiValueToStr(
        response.result.backgroundVerificationstatus
      ),
      criminalVerification: criminalVerificationStatus,
      probationMonths: response.result.probationMonths,
      confirmationDate: response.result.confirmationDate,
      totalExperienceYears: response.result.totalExperienceYear,
      totalExperienceMonths: response.result.totalExperienceMonth,
      relevantExperienceYears: response.result.relevantExperienceYear,
      relevantExperienceMonths: response.result.relevantExperienceMonth,
      probExtendedWeeks: response.result.probExtendedWeeks,
      extendedConfirmationDate: response.result.extendedConfirmationDate,
      linkedInUrl: response.result.linkedInUrl,
      timeDoctorUserId:
        typeof response.result.timeDoctorUserId === 'string'
          ? response.result.timeDoctorUserId?.trim()
          : '',
    });
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch employment details');
  } finally {
    loading.value = false;
  }
};

// Fetch latest employee code
const fetchLatestCode = async () => {
  isFetchingNewEmployeeCode.value = true;
  try {
    const response = await getLatestEmployeeCode();
    setFieldValue('employeeCode', response.result);
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch employee code');
  } finally {
    isFetchingNewEmployeeCode.value = false;
  }
};

// Watch employment status changes (internship -> full time)
watch(
  () => values.employmentStatus,
  (newStatus) => {
    if (!currentEmploymentDetails.value) return;

    const originalEmploymentStatus = currentEmploymentDetails.value.employmentStatus;
    const originalEmployeeCode = currentEmploymentDetails.value.employeeCode;

    const fromInternship = Number(originalEmploymentStatus) === EMPLOYMENT_STATUS.INTERNSHIP;
    const toFullTime = Number(newStatus) === EMPLOYMENT_STATUS.FULL_TIME;

    if (fromInternship && toFullTime) {
      fetchLatestCode();
      isEmployeeCodeEditable.value = true;
    } else {
      isEmployeeCodeEditable.value = false;
      setFieldValue('employeeCode', String(originalEmployeeCode));
    }
  }
);

// Submit handler
const onSubmit = handleSubmit(async (formValues) => {
  if (!currentEmploymentDetails.value) return;

  const criminalVerification =
    formValues.criminalVerification === ''
      ? null
      : formValues.criminalVerification === CRIMINAL_VERIFICATION_STATUS.COMPLETED;

  if (typeof formValues.roleId === 'undefined') {
    showError('roleId is undefined');
    return;
  }

  if (typeof formValues.employeeStatus === 'undefined') {
    showError('employeeStatus is undefined');
    return;
  }

  const updateArgs: UpdateEmploymentDetailArgs = {
    id: currentEmploymentDetails.value.id,
    employeeId: +formValues.employeeId,
    employeeCode: formValues.employeeCode,
    email: formValues.email,
    joiningDate: formValues.joiningDate,
    branchId: +formValues.branchId,
    roleId: +formValues.roleId,
    isReportingManager: formValues.isReportingManager,
    employeeStatus: convertFormStrToApiValue(formValues.employeeStatus),
    teamId: +formValues.teamId,
    designationId: +formValues.designationId,
    reportingManagerId: !formValues.reportingManagerId
      ? null
      : Number(formValues.reportingManagerId),
    employmentStatus: convertFormStrToApiValue(formValues.employmentStatus),
    linkedInUrl: formValues.linkedInUrl,
    backgroundVerificationstatus: convertFormStrToApiValue(
      formValues.backgroundVerificationstatus
    ),
    criminalVerification,
    departmentId: +formValues.departmentId,
    totalExperienceYear: formValues.totalExperienceYears,
    totalExperienceMonth: formValues.totalExperienceMonths,
    relevantExperienceYear: formValues.relevantExperienceYears,
    relevantExperienceMonth: formValues.relevantExperienceMonths,
    jobType: convertFormStrToApiValue(formValues.jobType),
    isProbExtended: false,
    probExtendedWeeks: formValues.probExtendedWeeks,
    probationMonths: formValues.probationMonths,
    confirmationDate: formValues.confirmationDate,
    extendedConfirmationDate: formValues.extendedConfirmationDate,
    timeDoctorUserId: formValues.timeDoctorUserId,
  };

  isUpdating.value = true;
  try {
    const response = await updateEmploymentDetail(updateArgs);
    showSuccess(response.message);
    window.close();
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to update employment details');
  } finally {
    isUpdating.value = false;
  }
});

onMounted(() => {
  fetchEmploymentDetail();
});
</script>

<template>
  <NotFoundView v-if="!hasReadPermission" />
  <div v-else-if="loading" class="d-flex justify-center align-center" style="min-height: 300px">
    <v-progress-circular indeterminate color="primary"></v-progress-circular>
  </div>
  <div v-else-if="!currentEmploymentDetails" class="text-center pa-4">No Data Found</div>
  <form v-else @submit.prevent="onSubmit">
    <v-container fluid>
      <!-- Row 1: Employee Code, Email, Designation -->
      <v-row>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="values.employeeCode"
            label="Employee Code*"
            :readonly="!isEditable || !isEmployeeCodeEditable"
            :error-messages="errors.employeeCode"
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="values.email"
            label="Email*"
            readonly
            :error-messages="errors.email"
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
        <v-col cols="12" md="4">
          <DesignationAutocomplete v-if="isEditable" required />
          <v-text-field
            v-else
            :model-value="currentEmploymentDetails.designation"
            label="Designation"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
      </v-row>

      <!-- Row 2: Department, Team, Reporting Manager -->
      <v-row>
        <v-col cols="12" md="4">
          <DepartmentAutocomplete v-if="isEditable" required />
          <v-text-field
            v-else
            :model-value="currentEmploymentDetails.departmentName"
            label="Department"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
        <v-col cols="12" md="4">
          <TeamAutocomplete v-if="isEditable" required />
          <v-text-field
            v-else
            :model-value="currentEmploymentDetails.teamName"
            label="Team"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
        <v-col cols="12" md="4">
          <ReportingManagerAutocomplete v-if="isEditable" label="Reporting Manager" />
          <v-text-field
            v-else
            :model-value="currentEmploymentDetails.reportingManagerName"
            label="Reporting Manager"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
      </v-row>

      <!-- Row 3: Employment Status, Joining Date, Job Type -->
      <v-row>
        <v-col cols="12" md="4">
          <v-select
            v-model="values.employmentStatus"
            label="Employment Status"
            :items="EMPLOYMENT_STATUS_OPTIONS"
            item-value="id"
            item-title="label"
            :readonly="!isEditable"
            :error-messages="errors.employmentStatus"
            variant="outlined"
            density="compact"
          ></v-select>
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-if="!isEditable"
            :model-value="
              currentEmploymentDetails.joiningDate
                ? moment(currentEmploymentDetails.joiningDate, 'YYYY-MM-DD').format('MMM Do, YYYY')
                : ''
            "
            label="Joining Date"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
          <v-text-field
            v-else
            v-model="values.joiningDate"
            label="Joining Date"
            type="date"
            :error-messages="errors.joiningDate"
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
        <v-col cols="12" md="4">
          <v-select
            v-model="values.jobType"
            label="Job Type"
            :items="jobTypes"
            item-value="id"
            item-title="label"
            :readonly="!isEditable"
            :error-messages="errors.jobType"
            variant="outlined"
            density="compact"
          ></v-select>
        </v-col>
      </v-row>

      <!-- Row 4: Branch, Employee Status, Role -->
      <v-row>
        <v-col cols="12" md="4">
          <BranchSelectField :is-editable="isEditable" required />
        </v-col>
        <v-col v-if="hasEmployeePermission" cols="12" md="4">
          <EmployeeStatusSelectField :is-editable="isEditable" />
        </v-col>
        <v-col v-if="hasRolePermission" cols="12" md="4">
          <RoleSelectField :is-editable="isEditable" required />
        </v-col>
      </v-row>

      <!-- Row 5: Time Doctor User Id, Reporting Manager Flag -->
      <v-row v-if="hasEmployeePermission">
        <v-col cols="12" md="4">
          <v-text-field
            v-if="isEditable"
            v-model="values.timeDoctorUserId"
            label="Time Doctor User Id"
            :error-messages="errors.timeDoctorUserId"
            variant="outlined"
            density="compact"
          ></v-text-field>
          <v-text-field
            v-else
            :model-value="currentEmploymentDetails.timeDoctorUserId ?? ''"
            label="Time Doctor User Id"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
        <v-col cols="12" md="4">
          <div v-if="isEditable" class="d-flex align-center">
            <v-checkbox
              v-model="values.isReportingManager"
              label="Assign Reporting Manager"
              hide-details
            ></v-checkbox>
            <v-tooltip text="The Reporting Manager handles leave approvals and views attendance">
              <template #activator="{ props: tooltipProps }">
                <v-icon v-bind="tooltipProps" color="primary" size="small" class="ml-2"
                  >mdi-information-outline</v-icon
                >
              </template>
            </v-tooltip>
          </div>
          <v-text-field
            v-else
            :model-value="values.isReportingManager ? 'Yes' : 'No'"
            label="Assign Reporting Manager"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
      </v-row>

      <v-divider class="my-4"></v-divider>

      <!-- Row 6: Background Verification, Criminal Verification -->
      <v-row>
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-select
            v-model="values.backgroundVerificationstatus"
            label="Background Verification"
            :items="backgroundVerificationStatuses"
            item-value="id"
            item-title="label"
            :readonly="!isEditable || values.backgroundVerificationstatus === '2'"
            :error-messages="errors.backgroundVerificationstatus"
            variant="outlined"
            density="compact"
          ></v-select>
        </v-col>
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-select
            v-model="values.criminalVerification"
            label="Criminal Verification"
            :items="criminalVerificationStatuses"
            item-value="id"
            item-title="label"
            :readonly="!isEditable || isCriminalVerificationCompleted"
            :error-messages="errors.criminalVerification"
            variant="outlined"
            density="compact"
          ></v-select>
        </v-col>
      </v-row>

      <!-- Row 7: Experience -->
      <v-row>
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-text-field
            v-if="!isEditable"
            :model-value="
              formatDuration(
                currentEmploymentDetails.totalExperienceYear,
                currentEmploymentDetails.totalExperienceMonth
              )
            "
            label="Total Experience"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
          <div v-else class="d-flex gap-2">
            <v-text-field
              v-model.number="values.totalExperienceYears"
              label="Total Experience Years"
              type="number"
              :error-messages="errors.totalExperienceYears"
              variant="outlined"
              density="compact"
            ></v-text-field>
            <v-text-field
              v-model.number="values.totalExperienceMonths"
              label="Total Experience Months"
              type="number"
              :error-messages="errors.totalExperienceMonths"
              variant="outlined"
              density="compact"
            ></v-text-field>
          </div>
        </v-col>
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-text-field
            v-if="!isEditable"
            :model-value="
              formatDuration(
                currentEmploymentDetails.relevantExperienceYear,
                currentEmploymentDetails.relevantExperienceMonth
              )
            "
            label="Relevant Experience"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
          <div v-else class="d-flex gap-2">
            <v-text-field
              v-model.number="values.relevantExperienceYears"
              label="Relevant Experience Years"
              type="number"
              :error-messages="errors.relevantExperienceYears"
              variant="outlined"
              density="compact"
            ></v-text-field>
            <v-text-field
              v-model.number="values.relevantExperienceMonths"
              label="Relevant Experience Months"
              type="number"
              :error-messages="errors.relevantExperienceMonths"
              variant="outlined"
              density="compact"
            ></v-text-field>
          </div>
        </v-col>
      </v-row>

      <!-- Row 8: Probation, Confirmation Date -->
      <v-row>
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-text-field
            v-model.number="values.probationMonths"
            label="Probation Months"
            type="number"
            :readonly="!isEditable"
            :error-messages="errors.probationMonths"
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-text-field
            v-if="!isEditable"
            :model-value="
              currentEmploymentDetails.confirmationDate
                ? moment(currentEmploymentDetails.confirmationDate, 'YYYY-MM-DD').format(
                    'MMM Do, YYYY'
                  )
                : ''
            "
            label="Confirmation Date"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
          <v-text-field
            v-else
            v-model="values.confirmationDate"
            label="Confirmation Date"
            type="date"
            :error-messages="errors.confirmationDate"
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
      </v-row>

      <!-- Row 9: Extended Probation (conditional) -->
      <v-row v-if="currentEmploymentDetails.isProbExtended">
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-text-field
            v-if="!isEditable"
            :model-value="
              currentEmploymentDetails.extendedConfirmationDate
                ? moment(currentEmploymentDetails.extendedConfirmationDate, 'YYYY-MM-DD').format(
                    'MMM Do, YYYY'
                  )
                : ''
            "
            label="Extended Confirmation Date"
            readonly
            variant="outlined"
            density="compact"
          ></v-text-field>
          <v-text-field
            v-else
            v-model="values.extendedConfirmationDate"
            label="Extended Confirmation Date"
            type="date"
            :error-messages="errors.extendedConfirmationDate"
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-text-field
            v-model.number="values.probExtendedWeeks"
            label="Probation Extended Weeks"
            type="number"
            :readonly="!isEditable"
            :error-messages="errors.probExtendedWeeks"
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
      </v-row>

      <!-- Row 10: LinkedIn URL -->
      <v-row>
        <v-col :cols="12" :md="isEditable ? 6 : 4">
          <v-text-field
            v-model="values.linkedInUrl"
            label="LinkedIn URL"
            :readonly="!isEditable"
            :error-messages="errors.linkedInUrl"
            variant="outlined"
            density="compact"
          ></v-text-field>
        </v-col>
      </v-row>

      <!-- Submit Buttons -->
      <v-row v-if="isEditable && authStore.hasPermission('Edit.EmploymentDetails')">
        <v-col cols="12" class="d-flex justify-center gap-3">
          <v-btn type="submit" color="primary" :loading="isUpdating">
            {{ isUpdating ? 'Updating' : 'Update' }}
          </v-btn>
          <v-btn type="reset" variant="outlined">Reset</v-btn>
        </v-col>
      </v-row>
    </v-container>

    <!-- Global Loader -->
    <v-overlay v-model="isUpdating || isFetchingNewEmployeeCode" class="align-center justify-center">
      <v-progress-circular indeterminate color="primary" size="64"></v-progress-circular>
    </v-overlay>
  </form>
</template>

<style scoped>
.gap-2 {
  gap: 8px;
}

.gap-3 {
  gap: 12px;
}
</style>

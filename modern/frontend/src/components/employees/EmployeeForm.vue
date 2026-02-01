<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useForm } from 'vee-validate';
import * as yup from 'yup';
import { format } from 'date-fns';
import {
  createEmployee,
  updateEmployee,
  getLatestEmployeeCode,
  getDepartmentList,
  getDesignationList,
  getTeamList,
  getBranchList,
  getReportingManagerList,
  getEmployeeById,
} from '@/services/employees/employeesService';
import {
  EMPLOYMENT_STATUS,
  EMPLOYMENT_STATUS_OPTIONS,
  JOB_TYPE_OPTIONS,
  BACKGROUND_VERIFICATION_OPTIONS,
  CRIMINAL_VERIFICATION_OPTIONS,
  CRIMINAL_VERIFICATION_STATUS,
  type CreateEmployeeRequest,
  type UpdateEmployeeRequest,
} from '@/services/employees/types';

interface Props {
  mode?: 'create' | 'edit';
  employeeId?: number;
}

const props = withDefaults(defineProps<Props>(), {
  mode: 'create',
});

const router = useRouter();
const route = useRoute();

// Validation Schema (matching legacy)
const validationSchema = yup.object({
  firstName: yup.string().required('First name is required'),
  middleName: yup.string(),
  lastName: yup.string().required('Last name is required'),
  email: yup.string().required('Email is required').email('Invalid email'),
  employeeCode: yup.string().when('employmentStatus', ([employmentStatus], schema) => {
    // Employee code not required for Internship
    if (Number(employmentStatus) === EMPLOYMENT_STATUS.INTERNSHIP) {
      return schema;
    }
    return schema.required('Employee code is required');
  }),
  designationId: yup.string().required('Designation is required'),
  departmentId: yup.string().required('Department is required'),
  teamId: yup.string().required('Team is required'),
  reportingManagerId: yup.number().required('Reporting manager is required'),
  employmentStatus: yup.string().required('Employment status is required'),
  joiningDate: yup.string().required('Joining date is required'),
  jobType: yup.string().required('Job type is required'),
  branchId: yup.string().required('Branch is required'),
  timeDoctorUserId: yup.string().nullable(),
  backgroundVerificationstatus: yup.string().required('Background verification status is required'),
  criminalVerification: yup.string().required('Criminal verification is required'),
  totalExperienceYear: yup.number().required('Total experience years is required').min(0),
  totalExperienceMonth: yup.number().required('Total experience months is required').min(0).max(11),
  relevantExperienceYear: yup.number().required('Relevant experience years is required').min(0),
  relevantExperienceMonth: yup.number().required('Relevant experience months is required').min(0).max(11),
  probationMonths: yup.number().required('Probation months is required').min(0),
});

const { values, errors, defineField, handleSubmit, setFieldValue, resetForm } = useForm({
  validationSchema,
  initialValues: {
    firstName: '',
    middleName: '',
    lastName: '',
    email: '',
    employeeCode: '',
    designationId: '',
    departmentId: '',
    teamId: '',
    reportingManagerId: 0,
    employmentStatus: '',
    joiningDate: '',
    jobType: '',
    branchId: '',
    timeDoctorUserId: '',
    backgroundVerificationstatus: '',
    criminalVerification: '',
    totalExperienceYear: 0,
    totalExperienceMonth: 0,
    relevantExperienceYear: 0,
    relevantExperienceMonth: 0,
    probationMonths: 0,
  },
});

// Define fields with vee-validate
const [firstName] = defineField('firstName');
const [middleName] = defineField('middleName');
const [lastName] = defineField('lastName');
const [email] = defineField('email');
const [employeeCode] = defineField('employeeCode');
const [designationId] = defineField('designationId');
const [departmentId] = defineField('departmentId');
const [teamId] = defineField('teamId');
const [reportingManagerId] = defineField('reportingManagerId');
const [employmentStatus] = defineField('employmentStatus');
const [joiningDate] = defineField('joiningDate');
const [jobType] = defineField('jobType');
const [branchId] = defineField('branchId');
const [timeDoctorUserId] = defineField('timeDoctorUserId');
const [backgroundVerificationstatus] = defineField('backgroundVerificationstatus');
const [criminalVerification] = defineField('criminalVerification');
const [totalExperienceYear] = defineField('totalExperienceYear');
const [totalExperienceMonth] = defineField('totalExperienceMonth');
const [relevantExperienceYear] = defineField('relevantExperienceYear');
const [relevantExperienceMonth] = defineField('relevantExperienceMonth');
const [probationMonths] = defineField('probationMonths');

// State
const loading = ref(false);
const saving = ref(false);
const departments = ref<Array<{ id: number; name: string }>>([]);
const designations = ref<Array<{ id: number; name: string }>>([]);
const teams = ref<Array<{ id: number; name: string }>>([]);
const branches = ref<Array<{ id: number; name: string }>>([]);
const reportingManagers = ref<Array<{ id: number; employeeName: string; employeeCode: string }>>([]);

// Save employee code when changing from non-Internship to Internship
const savedEmployeeCode = ref('');

// Computed
const isEditMode = computed(() => props.mode === 'edit');
const pageTitle = computed(() => (isEditMode.value ? 'Edit Employee' : 'Add Employee'));
const submitButtonText = computed(() => (isEditMode.value ? 'Update' : 'Save'));

const breadcrumbs = computed(() => [
  { title: 'Dashboard', to: '/dashboard' },
  { title: 'Employees', to: '/employees' },
  { title: pageTitle.value, to: '', disabled: true },
]);

// Watch employment status to handle employee code for Internship
watch(() => values.employmentStatus, (newStatus, oldStatus) => {
  const newStatusNum = Number(newStatus);
  const oldStatusNum = Number(oldStatus);

  // Changing TO Internship - clear employee code
  if (newStatusNum === EMPLOYMENT_STATUS.INTERNSHIP && oldStatusNum !== EMPLOYMENT_STATUS.INTERNSHIP) {
    savedEmployeeCode.value = values.employeeCode;
    setFieldValue('employeeCode', '');
  }

  // Changing FROM Internship - restore employee code
  if (oldStatusNum === EMPLOYMENT_STATUS.INTERNSHIP && newStatusNum !== EMPLOYMENT_STATUS.INTERNSHIP) {
    setFieldValue('employeeCode', savedEmployeeCode.value);
  }
});

// Load dropdown options
async function loadDropdownOptions() {
  loading.value = true;
  try {
    const [deptRes, desigRes, teamRes, branchRes, managerRes] = await Promise.all([
      getDepartmentList(),
      getDesignationList(),
      getTeamList(),
      getBranchList(),
      getReportingManagerList(),
    ]);

    departments.value = deptRes.result || [];
    designations.value = desigRes.result || [];
    teams.value = teamRes.result || [];
    branches.value = branchRes.result || [];
    reportingManagers.value = managerRes.result || [];
  } catch (error) {
    console.error('Error loading dropdown options:', error);
  } finally {
    loading.value = false;
  }
}

// Load employee data for edit mode
async function loadEmployeeData() {
  if (!props.employeeId) return;

  loading.value = true;
  try {
    const response = await getEmployeeById(props.employeeId);
    const employee = response.result;

    // Populate form with employee data
    setFieldValue('firstName', employee.employeeName.split(' ')[0] || '');
    setFieldValue('lastName', employee.employeeName.split(' ').pop() || '');
    setFieldValue('email', employee.email);
    setFieldValue('employeeCode', employee.employeeCode);
    setFieldValue('departmentName', employee.departmentName);
    setFieldValue('designation', employee.designation);
    // Note: API response doesn't have all employment detail fields
    // This would need to call GetEmploymentDetailById endpoint
  } catch (error) {
    console.error('Error loading employee data:', error);
  } finally {
    loading.value = false;
  }
}

// Get latest employee code (create mode only)
async function fetchLatestEmployeeCode() {
  if (isEditMode.value) return;

  try {
    const response = await getLatestEmployeeCode();
    setFieldValue('employeeCode', response.result);
  } catch (error) {
    console.error('Error fetching latest employee code:', error);
  }
}

// Submit form
const onSubmit = handleSubmit(async (formValues) => {
  saving.value = true;

  try {
    const criminalVerificationBool =
      formValues.criminalVerification === CRIMINAL_VERIFICATION_STATUS.COMPLETED;

    if (isEditMode.value) {
      // Update employee
      const updateData: UpdateEmployeeRequest = {
        id: props.employeeId!,
        employeeId: props.employeeId!,
        employeeCode: formValues.employeeCode,
        email: formValues.email,
        joiningDate: formValues.joiningDate,
        branchId: Number(formValues.branchId),
        teamId: Number(formValues.teamId),
        designationId: Number(formValues.designationId),
        reportingManagerId: Number(formValues.reportingManagerId),
        employmentStatus: Number(formValues.employmentStatus),
        linkedInUrl: '',
        backgroundVerificationstatus: Number(formValues.backgroundVerificationstatus),
        criminalVerification: criminalVerificationBool,
        departmentId: Number(formValues.departmentId),
        totalExperienceYear: Number(formValues.totalExperienceYear),
        totalExperienceMonth: Number(formValues.totalExperienceMonth),
        relevantExperienceYear: Number(formValues.relevantExperienceYear),
        relevantExperienceMonth: Number(formValues.relevantExperienceMonth),
        jobType: Number(formValues.jobType),
        isProbExtended: false,
        probationMonths: Number(formValues.probationMonths),
        timeDoctorUserId: formValues.timeDoctorUserId || null,
      };

      await updateEmployee(updateData);
      alert('Employee updated successfully');
    } else {
      // Create employee
      const createData: CreateEmployeeRequest = {
        firstName: formValues.firstName,
        middleName: formValues.middleName,
        lastName: formValues.lastName,
        employeeCode: formValues.employeeCode,
        email: formValues.email,
        joiningDate: formValues.joiningDate,
        branchId: Number(formValues.branchId),
        teamId: Number(formValues.teamId),
        designationId: Number(formValues.designationId),
        reportingManagerId: Number(formValues.reportingManagerId),
        employmentStatus: Number(formValues.employmentStatus),
        backgroundVerificationstatus: Number(formValues.backgroundVerificationstatus),
        criminalVerification: criminalVerificationBool,
        departmentId: Number(formValues.departmentId),
        totalExperienceYear: Number(formValues.totalExperienceYear),
        totalExperienceMonth: Number(formValues.totalExperienceMonth),
        relevantExperienceYear: Number(formValues.relevantExperienceYear),
        relevantExperienceMonth: Number(formValues.relevantExperienceMonth),
        jobType: Number(formValues.jobType),
        probationMonths: Number(formValues.probationMonths),
        timeDoctorUserId: formValues.timeDoctorUserId || null,
      };

      await createEmployee(createData);
      alert('Employee created successfully');
    }

    // Navigate back to employee list
    router.push('/employees');
  } catch (error: any) {
    console.error('Error saving employee:', error);
    const errorMessage = error?.response?.data?.message || 'Failed to save employee';
    alert(errorMessage);
  } finally {
    saving.value = false;
  }
});

function handleCancel() {
  router.back();
}

function handleReset() {
  resetForm();
  if (!isEditMode.value) {
    fetchLatestEmployeeCode();
  }
}

onMounted(async () => {
  await loadDropdownOptions();

  if (isEditMode.value) {
    await loadEmployeeData();
  } else {
    await fetchLatestEmployeeCode();
  }
});
</script>

<template>
  <v-container fluid>
    <v-breadcrumbs :items="breadcrumbs" divider=">" class="px-0" />

    <v-card elevation="3">
      <v-card-title class="d-flex align-center pa-4 border-b">
        <v-btn icon variant="text" size="small" @click="router.back()" class="mr-2">
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <h2 class="text-h5">{{ pageTitle }}</h2>
      </v-card-title>

      <v-card-text class="pa-6">
        <v-form @submit.prevent="onSubmit">
          <!-- Loading State -->
          <div v-if="loading" class="text-center py-12">
            <v-progress-circular indeterminate color="primary" size="64" />
            <p class="mt-4">Loading...</p>
          </div>

          <!-- Form Fields -->
          <template v-else>
            <!-- Personal Information -->
            <h3 class="text-h6 mb-4">Personal Information</h3>
            <v-row>
              <v-col cols="12" md="4">
                <v-text-field
                  v-model="firstName"
                  label="First Name"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.firstName"
                  required
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-text-field
                  v-model="middleName"
                  label="Middle Name"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.middleName"
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-text-field
                  v-model="lastName"
                  label="Last Name"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.lastName"
                  required
                />
              </v-col>
            </v-row>

            <v-divider class="my-6" />

            <!-- Employment Details -->
            <h3 class="text-h6 mb-4">Employment Details</h3>
            <v-row>
              <v-col cols="12" md="4">
                <v-text-field
                  v-model="email"
                  label="Email"
                  type="email"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.email"
                  required
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-autocomplete
                  v-model="designationId"
                  label="Designation"
                  :items="designations"
                  item-title="name"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.designationId"
                  required
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-autocomplete
                  v-model="departmentId"
                  label="Department"
                  :items="departments"
                  item-title="name"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.departmentId"
                  required
                />
              </v-col>
            </v-row>

            <v-row>
              <v-col cols="12" md="4">
                <v-autocomplete
                  v-model="teamId"
                  label="Team"
                  :items="teams"
                  item-title="name"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.teamId"
                  required
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-autocomplete
                  v-model="reportingManagerId"
                  label="Reporting Manager"
                  :items="reportingManagers"
                  item-title="employeeName"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.reportingManagerId"
                  required
                >
                  <template #item="{ props, item }">
                    <v-list-item v-bind="props">
                      <v-list-item-title>{{ item.raw.employeeName }}</v-list-item-title>
                      <v-list-item-subtitle>{{ item.raw.employeeCode }}</v-list-item-subtitle>
                    </v-list-item>
                  </template>
                </v-autocomplete>
              </v-col>
              <v-col cols="12" md="4">
                <v-select
                  v-model="employmentStatus"
                  label="Employment Status"
                  :items="EMPLOYMENT_STATUS_OPTIONS"
                  item-title="label"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.employmentStatus"
                  required
                />
              </v-col>
            </v-row>

            <v-row>
              <v-col cols="12" md="4">
                <v-text-field
                  v-model="joiningDate"
                  label="Joining Date"
                  type="date"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.joiningDate"
                  required
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-select
                  v-model="jobType"
                  label="Job Type"
                  :items="JOB_TYPE_OPTIONS"
                  item-title="label"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.jobType"
                  required
                />
              </v-col>
              <v-col cols="12" md="4">
                <v-autocomplete
                  v-model="branchId"
                  label="Branch"
                  :items="branches"
                  item-title="name"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.branchId"
                  required
                />
              </v-col>
            </v-row>

            <v-row>
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="employeeCode"
                  label="Employee Code"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.employeeCode"
                  :disabled="Number(employmentStatus) === EMPLOYMENT_STATUS.INTERNSHIP"
                  :required="Number(employmentStatus) !== EMPLOYMENT_STATUS.INTERNSHIP"
                />
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="timeDoctorUserId"
                  label="Time Doctor User ID"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.timeDoctorUserId"
                />
              </v-col>
            </v-row>

            <v-divider class="my-6" />

            <!-- Verification Details -->
            <h3 class="text-h6 mb-4">Verification Details</h3>
            <v-row>
              <v-col cols="12" md="6">
                <v-select
                  v-model="backgroundVerificationstatus"
                  label="Background Verification"
                  :items="BACKGROUND_VERIFICATION_OPTIONS"
                  item-title="label"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.backgroundVerificationstatus"
                  required
                />
              </v-col>
              <v-col cols="12" md="6">
                <v-select
                  v-model="criminalVerification"
                  label="Criminal Verification"
                  :items="CRIMINAL_VERIFICATION_OPTIONS"
                  item-title="label"
                  item-value="id"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.criminalVerification"
                  required
                />
              </v-col>
            </v-row>

            <v-divider class="my-6" />

            <!-- Experience Details -->
            <h3 class="text-h6 mb-4">Experience Details</h3>
            <v-row>
              <v-col cols="12" md="6">
                <div class="d-flex gap-2">
                  <v-text-field
                    v-model.number="totalExperienceYear"
                    label="Total Experience Years"
                    type="number"
                    min="0"
                    variant="outlined"
                    density="comfortable"
                    :error-messages="errors.totalExperienceYear"
                    required
                  />
                  <v-text-field
                    v-model.number="totalExperienceMonth"
                    label="Months"
                    type="number"
                    min="0"
                    max="11"
                    variant="outlined"
                    density="comfortable"
                    :error-messages="errors.totalExperienceMonth"
                    required
                  />
                </div>
              </v-col>
              <v-col cols="12" md="6">
                <div class="d-flex gap-2">
                  <v-text-field
                    v-model.number="relevantExperienceYear"
                    label="Relevant Experience Years"
                    type="number"
                    min="0"
                    variant="outlined"
                    density="comfortable"
                    :error-messages="errors.relevantExperienceYear"
                    required
                  />
                  <v-text-field
                    v-model.number="relevantExperienceMonth"
                    label="Months"
                    type="number"
                    min="0"
                    max="11"
                    variant="outlined"
                    density="comfortable"
                    :error-messages="errors.relevantExperienceMonth"
                    required
                  />
                </div>
              </v-col>
            </v-row>

            <v-row>
              <v-col cols="12" md="6">
                <v-text-field
                  v-model.number="probationMonths"
                  label="Probation Months"
                  type="number"
                  min="0"
                  variant="outlined"
                  density="comfortable"
                  :error-messages="errors.probationMonths"
                  required
                />
              </v-col>
            </v-row>

            <!-- Form Actions -->
            <v-row class="mt-6">
              <v-col cols="12" class="d-flex justify-center gap-3">
                <v-btn variant="outlined" size="large" min-width="120" @click="handleCancel">
                  Cancel
                </v-btn>
                <v-btn
                  variant="outlined"
                  color="secondary"
                  size="large"
                  min-width="120"
                  @click="handleReset"
                >
                  Reset
                </v-btn>
                <v-btn
                  type="submit"
                  color="primary"
                  size="large"
                  min-width="120"
                  :loading="saving"
                  :disabled="saving"
                >
                  {{ submitButtonText }}
                </v-btn>
              </v-col>
            </v-row>
          </template>
        </v-form>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<style scoped>
.border-b {
  border-bottom: 1px solid rgba(0, 0, 0, 0.12);
}

.gap-2 {
  gap: 8px;
}

.gap-3 {
  gap: 12px;
}
</style>

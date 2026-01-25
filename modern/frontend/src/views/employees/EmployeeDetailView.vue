<template>
  <v-container fluid>
    <v-breadcrumbs :items="breadcrumbs" divider=">" class="px-0"></v-breadcrumbs>

    <v-card elevation="3">
      <v-card-title class="d-flex align-center pa-4 border-b">
        <v-btn icon variant="text" size="small" @click="router.back()" class="mr-2">
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <h2 class="text-h5">Employee Details</h2>
      </v-card-title>

      <v-card-text v-if="loading" class="pa-5 text-center">
        <v-progress-circular indeterminate color="primary"></v-progress-circular>
      </v-card-text>

      <v-card-text v-else-if="employee" class="pa-5">
        <v-row>
          <v-col cols="12" md="6">
            <v-card variant="outlined">
              <v-card-title class="bg-grey-lighten-3">Personal Information</v-card-title>
              <v-card-text>
                <v-row dense>
                  <v-col cols="6"><strong>Employee Code:</strong></v-col>
                  <v-col cols="6">{{ employee.employeeCode }}</v-col>

                  <v-col cols="6"><strong>Name:</strong></v-col>
                  <v-col cols="6">{{ employee.employeeName }}</v-col>

                  <v-col cols="6"><strong>Father's Name:</strong></v-col>
                  <v-col cols="6">{{ employee.fatherName || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Gender:</strong></v-col>
                  <v-col cols="6">{{ getGenderLabel(employee.gender) }}</v-col>

                  <v-col cols="6"><strong>Date of Birth:</strong></v-col>
                  <v-col cols="6">{{ formatDate(employee.dob) }}</v-col>

                  <v-col cols="6"><strong>Blood Group:</strong></v-col>
                  <v-col cols="6">{{ employee.bloodGroup || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Marital Status:</strong></v-col>
                  <v-col cols="6">{{ getMaritalStatusLabel(employee.maritalStatus) }}</v-col>
                </v-row>
              </v-card-text>
            </v-card>
          </v-col>

          <v-col cols="12" md="6">
            <v-card variant="outlined">
              <v-card-title class="bg-grey-lighten-3">Contact Information</v-card-title>
              <v-card-text>
                <v-row dense>
                  <v-col cols="6"><strong>Email:</strong></v-col>
                  <v-col cols="6">{{ employee.email }}</v-col>

                  <v-col cols="6"><strong>Personal Email:</strong></v-col>
                  <v-col cols="6">{{ employee.personalEmail || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Phone:</strong></v-col>
                  <v-col cols="6">{{ employee.phone }}</v-col>

                  <v-col cols="6"><strong>Alternate Phone:</strong></v-col>
                  <v-col cols="6">{{ employee.alternatePhone || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Emergency Contact:</strong></v-col>
                  <v-col cols="6">{{ employee.emergencyContactNo || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Address:</strong></v-col>
                  <v-col cols="6">{{ employee.address || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>City:</strong></v-col>
                  <v-col cols="6">{{ employee.cityName || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>State:</strong></v-col>
                  <v-col cols="6">{{ employee.stateName || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>PIN Code:</strong></v-col>
                  <v-col cols="6">{{ employee.pinCode || 'N/A' }}</v-col>
                </v-row>
              </v-card-text>
            </v-card>
          </v-col>

          <v-col cols="12" md="6">
            <v-card variant="outlined">
              <v-card-title class="bg-grey-lighten-3">Employment Details</v-card-title>
              <v-card-text>
                <v-row dense>
                  <v-col cols="6"><strong>Department:</strong></v-col>
                  <v-col cols="6">{{ employee.departmentName }}</v-col>

                  <v-col cols="6"><strong>Designation:</strong></v-col>
                  <v-col cols="6">{{ employee.designation }}</v-col>

                  <v-col cols="6"><strong>Reporting Manager:</strong></v-col>
                  <v-col cols="6">{{ employee.reportingManagerName || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Joining Date:</strong></v-col>
                  <v-col cols="6">{{ formatDate(employee.joiningDate) }}</v-col>

                  <v-col cols="6"><strong>Confirmation Date:</strong></v-col>
                  <v-col cols="6">{{
                    employee.confirmationDate ? formatDate(employee.confirmationDate) : 'N/A'
                  }}</v-col>

                  <v-col cols="6"><strong>Branch:</strong></v-col>
                  <v-col cols="6">{{ getBranchLabel(employee.branch) }}</v-col>

                  <v-col cols="6"><strong>Job Type:</strong></v-col>
                  <v-col cols="6">{{ getJobTypeLabel(employee.jobType) }}</v-col>

                  <v-col cols="6"><strong>Status:</strong></v-col>
                  <v-col cols="6">{{ getStatusLabel(employee.employeeStatus) }}</v-col>
                </v-row>
              </v-card-text>
            </v-card>
          </v-col>

          <v-col cols="12" md="6">
            <v-card variant="outlined">
              <v-card-title class="bg-grey-lighten-3">Financial & Other Details</v-card-title>
              <v-card-text>
                <v-row dense>
                  <v-col cols="6"><strong>PAN Number:</strong></v-col>
                  <v-col cols="6">{{ employee.panNumber || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Aadhar Number:</strong></v-col>
                  <v-col cols="6">{{ employee.adharNumber || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Bank Name:</strong></v-col>
                  <v-col cols="6">{{ employee.bankName || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Account Number:</strong></v-col>
                  <v-col cols="6">{{ employee.accountNo || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Has PF:</strong></v-col>
                  <v-col cols="6">{{ employee.hasPF ? 'Yes' : 'No' }}</v-col>

                  <v-col cols="6"><strong>PF Number:</strong></v-col>
                  <v-col cols="6">{{ employee.pfNumber || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>UAN Number:</strong></v-col>
                  <v-col cols="6">{{ employee.uanNo || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Has ESI:</strong></v-col>
                  <v-col cols="6">{{ employee.hasESI ? 'Yes' : 'No' }}</v-col>

                  <v-col cols="6"><strong>ESI Number:</strong></v-col>
                  <v-col cols="6">{{ employee.esiNo || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Passport Number:</strong></v-col>
                  <v-col cols="6">{{ employee.passportNo || 'N/A' }}</v-col>

                  <v-col cols="6"><strong>Passport Expiry:</strong></v-col>
                  <v-col cols="6">{{
                    employee.passportExpiry ? formatDate(employee.passportExpiry) : 'N/A'
                  }}</v-col>
                </v-row>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>

        <div class="d-flex justify-end gap-3 mt-5">
          <v-btn @click="router.back()" variant="outlined">Back</v-btn>
          <v-btn :to="`/employees/edit/${employee.id}`" color="primary">Edit</v-btn>
        </div>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { getEmployeeById, type EmployeeType } from '@/services/employees';
import { useSnackbar } from '@/composables/useSnackbar';
import moment from 'moment';

const router = useRouter();
const route = useRoute();
const { showError } = useSnackbar();

const employee = ref<EmployeeType | null>(null);
const loading = ref(false);

const breadcrumbs = [
  { title: 'Dashboard', to: '/dashboard' },
  { title: 'Employees', to: '/employees' },
  { title: 'Employee Details', to: '', disabled: true },
];

// Label mappings
const getGenderLabel = (gender: number) => {
  const labels: Record<number, string> = { 1: 'Male', 2: 'Female', 3: 'Other' };
  return labels[gender] || 'N/A';
};

const getMaritalStatusLabel = (status: number) => {
  const labels: Record<number, string> = { 1: 'Single', 2: 'Married', 3: 'Divorced', 4: 'Widowed' };
  return labels[status] || 'N/A';
};

const getBranchLabel = (branch: number) => {
  const labels: Record<number, string> = { 1: 'Noida', 2: 'Jaipur', 3: 'US', 4: 'Remote' };
  return labels[branch] || 'N/A';
};

const getJobTypeLabel = (jobType: number) => {
  const labels: Record<number, string> = {
    1: 'Full Time',
    2: 'Part Time',
    3: 'Contract',
    4: 'Internship',
  };
  return labels[jobType] || 'N/A';
};

const getStatusLabel = (status: number) => {
  const labels: Record<number, string> = { 1: 'Active', 2: 'Inactive', 3: 'Exited' };
  return labels[status] || 'N/A';
};

const formatDate = (dateString: string) => {
  return moment(dateString, 'YYYY-MM-DD').format('MMM Do, YYYY');
};

const fetchEmployeeDetails = async () => {
  const employeeId = Number(route.params.id);
  if (!employeeId) {
    showError('Invalid employee ID');
    router.push('/employees');
    return;
  }

  loading.value = true;
  try {
    const response = await getEmployeeById(employeeId);
    employee.value = response.result;
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch employee details');
    router.push('/employees');
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchEmployeeDetails();
});
</script>

<style scoped>
.border-b {
  border-bottom: 1px solid rgba(0, 0, 0, 0.12);
}
</style>

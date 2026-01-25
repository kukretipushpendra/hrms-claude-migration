<template>
  <v-form ref="formRef" @submit.prevent="handleSubmit">
    <v-row>
      <v-col cols="12" md="4" lg="3">
        <v-select
          v-model="formData.roleId"
          :items="roles"
          item-title="name"
          item-value="id"
          label="Role"
          density="compact"
          clearable
        ></v-select>
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-autocomplete
          v-model="formData.departmentId"
          :items="departments"
          item-title="name"
          item-value="id"
          label="Department"
          density="compact"
          clearable
        ></v-autocomplete>
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-autocomplete
          v-model="formData.designationId"
          :items="designations"
          item-title="name"
          item-value="id"
          label="Designation"
          density="compact"
          clearable
        ></v-autocomplete>
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-select
          v-model="formData.employeeStatus"
          :items="employeeStatuses"
          item-title="name"
          item-value="id"
          label="Employee Status"
          density="compact"
          clearable
        ></v-select>
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-select
          v-model="formData.employmentStatus"
          :items="employmentStatuses"
          item-title="label"
          item-value="id"
          label="Employment Status"
          density="compact"
          clearable
        ></v-select>
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-select
          v-model="selectedDateRange"
          :items="dateRangeOptions"
          item-title="label"
          item-value="id"
          label="Select DOJ Range"
          density="compact"
          @update:model-value="handleDateRangeChange"
        ></v-select>
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-select
          v-model="formData.branchId"
          :items="branches"
          item-title="name"
          item-value="id"
          label="Branch"
          density="compact"
          clearable
        ></v-select>
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-select
          v-model="formData.countryId"
          :items="countries"
          item-title="name"
          item-value="id"
          label="Country"
          density="compact"
          clearable
        ></v-select>
      </v-col>

      <v-col v-if="selectedDateRange === 'custom'" cols="12" md="4" lg="3">
        <v-text-field
          v-model="formData.dojFrom"
          type="date"
          label="DOJ From"
          density="compact"
        ></v-text-field>
      </v-col>

      <v-col v-if="selectedDateRange === 'custom'" cols="12" md="4" lg="3">
        <v-text-field
          v-model="formData.dojTo"
          type="date"
          label="DOJ To"
          density="compact"
        ></v-text-field>
      </v-col>

      <v-col cols="12" class="pt-4">
        <div class="d-flex justify-center gap-3">
          <v-btn type="submit" color="primary" variant="flat">Search</v-btn>
          <v-btn @click="handleReset" variant="outlined">Reset</v-btn>
        </div>
      </v-col>
    </v-row>
  </v-form>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import moment from 'moment';
import { getDepartmentList, getDesignationList, type EmployeeSearchFilter } from '@/services/employees';
import { useSnackbar } from '@/composables/useSnackbar';

interface Props {
  roleId?: number;
}

const props = withDefaults(defineProps<Props>(), {
  roleId: 0,
});

const emit = defineEmits<{
  (e: 'search', filters: EmployeeSearchFilter): void;
  (e: 'has-active-filters', value: boolean): void;
}>();

const { showError } = useSnackbar();

// Form data
const formRef = ref();
const formData = ref<{
  departmentId: number;
  designationId: number;
  roleId: number;
  employeeStatus: number;
  employmentStatus: number;
  branchId: number;
  dojFrom: string | null;
  dojTo: string | null;
  countryId: number;
}>({
  departmentId: 0,
  designationId: 0,
  roleId: props.roleId,
  employeeStatus: 0,
  employmentStatus: 0,
  branchId: 0,
  dojFrom: null,
  dojTo: null,
  countryId: 0,
});

const selectedDateRange = ref<string>('');

// Data sources
const departments = ref<Array<{ id: number; name: string }>>([]);
const designations = ref<Array<{ id: number; name: string }>>([]);
const roles = ref<Array<{ id: number; name: string }>>([
  { id: 0, name: 'All' },
  // TODO: Fetch from API when roles service is available
]);

const employeeStatuses = [
  { id: 0, name: 'All' },
  { id: 1, name: 'Active' },
  { id: 2, name: 'Inactive' },
  { id: 3, name: 'Exited' },
];

const employmentStatuses = [
  { id: 0, label: 'All' },
  { id: 1, label: 'Full Time' },
  { id: 2, label: 'Part Time' },
  { id: 3, label: 'Contract' },
  { id: 4, label: 'Internship' },
];

const branches = [
  { id: 0, name: 'All' },
  { id: 1, name: 'Noida' },
  { id: 2, name: 'Jaipur' },
  { id: 3, name: 'US' },
  { id: 4, name: 'Remote' },
];

const countries = [
  { id: 0, name: 'All' },
  { id: 1, name: 'India' },
  { id: 2, name: 'USA' },
];

const dateRangeOptions = [
  { id: 'past7Days', label: 'Past 7 Days' },
  { id: 'past15Days', label: 'Past 15 Days' },
  { id: 'past30Days', label: 'Past 30 Days' },
  { id: 'thisMonth', label: 'This Month' },
  { id: 'previousMonth', label: 'Previous Month' },
  { id: 'custom', label: 'Custom' },
];

// Methods
const getDateRange = (range: string) => {
  const today = moment();

  switch (range) {
    case 'past7Days':
      return {
        from: today.clone().subtract(7, 'day').startOf('day').format('YYYY-MM-DD'),
        to: today.clone().endOf('day').format('YYYY-MM-DD'),
      };
    case 'past15Days':
      return {
        from: today.clone().subtract(15, 'day').startOf('day').format('YYYY-MM-DD'),
        to: today.clone().endOf('day').format('YYYY-MM-DD'),
      };
    case 'past30Days':
      return {
        from: today.clone().subtract(30, 'day').startOf('day').format('YYYY-MM-DD'),
        to: today.clone().endOf('day').format('YYYY-MM-DD'),
      };
    case 'thisMonth':
      return {
        from: today.clone().startOf('month').format('YYYY-MM-DD'),
        to: today.clone().endOf('month').format('YYYY-MM-DD'),
      };
    case 'previousMonth':
      return {
        from: today.clone().subtract(1, 'month').startOf('month').format('YYYY-MM-DD'),
        to: today.clone().subtract(1, 'month').endOf('month').format('YYYY-MM-DD'),
      };
    default:
      return null;
  }
};

const handleDateRangeChange = (value: string) => {
  if (value === 'custom') {
    formData.value.dojFrom = null;
    formData.value.dojTo = moment().format('YYYY-MM-DD');
  } else {
    const dateRange = getDateRange(value);
    if (dateRange) {
      formData.value.dojFrom = dateRange.from;
      formData.value.dojTo = dateRange.to;
    }
  }
};

const handleSubmit = () => {
  const filters: EmployeeSearchFilter = {
    departmentId: formData.value.departmentId || 0,
    designationId: formData.value.designationId || 0,
    roleId: formData.value.roleId || 0,
    employeeStatus: formData.value.employeeStatus || 0,
    employmentStatus: formData.value.employmentStatus || 0,
    branchId: formData.value.branchId || 0,
    countryId: formData.value.countryId || 0,
    dojFrom: formData.value.dojFrom,
    dojTo: formData.value.dojTo,
  };

  emit('search', filters);
  emit('has-active-filters', true);
};

const handleReset = () => {
  formData.value = {
    departmentId: 0,
    designationId: 0,
    roleId: 0,
    employeeStatus: 0,
    employmentStatus: 0,
    branchId: 0,
    dojFrom: null,
    dojTo: null,
    countryId: 0,
  };
  selectedDateRange.value = '';

  const filters: EmployeeSearchFilter = {
    departmentId: 0,
    designationId: 0,
    roleId: 0,
    employeeStatus: 0,
    employmentStatus: 0,
    branchId: 0,
    dojFrom: null,
    dojTo: null,
    countryId: 0,
  };

  emit('search', filters);
  emit('has-active-filters', false);
};

const resetForm = () => {
  handleReset();
};

// Expose for parent component
defineExpose({
  resetForm,
});

// Fetch data
const fetchDepartments = async () => {
  try {
    const response = await getDepartmentList();
    departments.value = [{ id: 0, name: 'All' }, ...response.result];
  } catch {
    showError('Failed to fetch departments');
  }
};

const fetchDesignations = async () => {
  try {
    const response = await getDesignationList();
    designations.value = [{ id: 0, name: 'All' }, ...response.result];
  } catch {
    showError('Failed to fetch designations');
  }
};

// Lifecycle
onMounted(() => {
  fetchDepartments();
  fetchDesignations();
  if (props.roleId) {
    formData.value.roleId = props.roleId;
  }
});

watch(
  () => props.roleId,
  (newVal) => {
    if (newVal) {
      formData.value.roleId = newVal;
    }
  }
);
</script>

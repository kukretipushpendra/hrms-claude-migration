<script setup lang="ts">
import { ref, onMounted } from 'vue';
import {
  ResignationStatus,
  RESIGNATION_STATUS_LABELS,
  EmployeeStatus,
  type ExitEmployeeSearchFilter,
} from '@/types/exit.types';

interface Props {
  initialFilters?: ExitEmployeeSearchFilter;
}

const props = defineProps<Props>();
const emit = defineEmits<{
  (e: 'apply', filters: ExitEmployeeSearchFilter): void;
  (e: 'reset'): void;
}>();

// State
const employeeCode = ref('');
const employeeName = ref('');
const resignationStatus = ref<number | null>(null);
const branchId = ref<number | null>(null);
const departmentId = ref<number | null>(null);
const itNoDue = ref<boolean | null>(null);
const accountsNoDue = ref<boolean | null>(null);
const lastWorkingDayFrom = ref('');
const lastWorkingDayTo = ref('');
const resignationDate = ref('');
const employeeStatus = ref<number | null>(null);

// Options
const resignationStatusOptions = [
  { value: ResignationStatus.pending, title: RESIGNATION_STATUS_LABELS[ResignationStatus.pending] },
  { value: ResignationStatus.revoked, title: RESIGNATION_STATUS_LABELS[ResignationStatus.revoked] },
  {
    value: ResignationStatus.accepted,
    title: RESIGNATION_STATUS_LABELS[ResignationStatus.accepted],
  },
  {
    value: ResignationStatus.cancelled,
    title: RESIGNATION_STATUS_LABELS[ResignationStatus.cancelled],
  },
  {
    value: ResignationStatus.completed,
    title: RESIGNATION_STATUS_LABELS[ResignationStatus.completed],
  },
];

const triStateOptions = [
  { value: null, title: 'All' },
  { value: true, title: 'Yes' },
  { value: false, title: 'No' },
];

const employeeStatusOptions = [
  { value: EmployeeStatus.active, title: 'Active' },
  { value: EmployeeStatus.fnfPending, title: 'F&F Pending' },
  { value: EmployeeStatus.onNotice, title: 'On Notice' },
  { value: EmployeeStatus.exEmployee, title: 'Ex-Employee' },
];

// Apply filters
const handleApply = () => {
  const filters: ExitEmployeeSearchFilter = {
    employeeCode: employeeCode.value || undefined,
    employeeName: employeeName.value || null,
    resignationStatus: resignationStatus.value || null,
    branchId: branchId.value || null,
    departmentId: departmentId.value || null,
    itNoDue: itNoDue.value,
    accountsNoDue: accountsNoDue.value,
    lastWorkingDayFrom: lastWorkingDayFrom.value || null,
    lastWorkingDayTo: lastWorkingDayTo.value || null,
    resignationDate: resignationDate.value || null,
    employeeStatus: employeeStatus.value || null,
  };
  emit('apply', filters);
};

// Reset filters
const handleReset = () => {
  employeeCode.value = '';
  employeeName.value = '';
  resignationStatus.value = null;
  branchId.value = null;
  departmentId.value = null;
  itNoDue.value = null;
  accountsNoDue.value = null;
  lastWorkingDayFrom.value = '';
  lastWorkingDayTo.value = '';
  resignationDate.value = '';
  employeeStatus.value = null;
  emit('reset');
};

// Initialize from props
onMounted(() => {
  if (props.initialFilters) {
    employeeCode.value = props.initialFilters.employeeCode || '';
    employeeName.value = props.initialFilters.employeeName || '';
    resignationStatus.value = props.initialFilters.resignationStatus || null;
    branchId.value = props.initialFilters.branchId || null;
    departmentId.value = props.initialFilters.departmentId || null;
    itNoDue.value = props.initialFilters.itNoDue ?? null;
    accountsNoDue.value = props.initialFilters.accountsNoDue ?? null;
    lastWorkingDayFrom.value = props.initialFilters.lastWorkingDayFrom || '';
    lastWorkingDayTo.value = props.initialFilters.lastWorkingDayTo || '';
    resignationDate.value = props.initialFilters.resignationDate || '';
    employeeStatus.value = props.initialFilters.employeeStatus || null;
  }
});
</script>

<template>
  <v-card elevation="3">
    <v-card-title class="text-h6 pa-4">Filters</v-card-title>
    <v-card-text>
      <v-row>
        <!-- Employee Code -->
        <v-col cols="12" md="4">
          <v-text-field
            v-model="employeeCode"
            label="Employee Code"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- Employee Name -->
        <v-col cols="12" md="4">
          <v-text-field
            v-model="employeeName"
            label="Employee Name"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- Resignation Status -->
        <v-col cols="12" md="4">
          <v-select
            v-model="resignationStatus"
            label="Resignation Status"
            :items="resignationStatusOptions"
            variant="outlined"
            density="compact"
            clearable
          />
        </v-col>

        <!-- Branch ID (Placeholder - replace with actual branch dropdown) -->
        <v-col cols="12" md="4">
          <v-text-field
            v-model.number="branchId"
            label="Branch ID"
            type="number"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- Department ID (Placeholder - replace with actual department dropdown) -->
        <v-col cols="12" md="4">
          <v-text-field
            v-model.number="departmentId"
            label="Department ID"
            type="number"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- IT No-Due -->
        <v-col cols="12" md="4">
          <v-select
            v-model="itNoDue"
            label="IT No-Due"
            :items="triStateOptions"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- Accounts No-Due -->
        <v-col cols="12" md="4">
          <v-select
            v-model="accountsNoDue"
            label="Accounts No-Due"
            :items="triStateOptions"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- Last Working Day From -->
        <v-col cols="12" md="4">
          <v-text-field
            v-model="lastWorkingDayFrom"
            label="Last Working Day From"
            type="date"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- Last Working Day To -->
        <v-col cols="12" md="4">
          <v-text-field
            v-model="lastWorkingDayTo"
            label="Last Working Day To"
            type="date"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- Resignation Date -->
        <v-col cols="12" md="4">
          <v-text-field
            v-model="resignationDate"
            label="Resignation Date"
            type="date"
            variant="outlined"
            density="compact"
          />
        </v-col>

        <!-- Employee Status -->
        <v-col cols="12" md="4">
          <v-select
            v-model="employeeStatus"
            label="Employee Status"
            :items="employeeStatusOptions"
            variant="outlined"
            density="compact"
            clearable
          />
        </v-col>
      </v-row>

      <!-- Action Buttons -->
      <v-row class="mt-2">
        <v-col>
          <v-btn color="primary" @click="handleApply">Apply Filters</v-btn>
          <v-btn color="secondary" variant="outlined" class="ml-2" @click="handleReset">
            Reset
          </v-btn>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

<template>
  <v-autocomplete
    :model-value="modelValue"
    :items="employeesWithDisplayName"
    :loading="loading"
    :disabled="disabled"
    :error-messages="error"
    item-title="displayName"
    item-value="id"
    label="Select Employee"
    variant="outlined"
    density="comfortable"
    clearable
    @update:model-value="handleChange"
  >
    <template #item="{ props: itemProps, item }">
      <v-list-item v-bind="itemProps" :title="item.raw.displayName" :subtitle="item.raw.email" />
    </template>
  </v-autocomplete>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { toast } from 'vue3-toastify';
import httpClient from '@/services/api/http-client';

interface Employee {
  id: number;
  email: string;
  firstName: string;
  middleName?: string;
  lastName: string;
}

interface Props {
  modelValue?: number | null;
  disabled?: boolean;
  error?: string;
}

withDefaults(defineProps<Props>(), {
  modelValue: null,
  disabled: false,
  error: undefined,
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: number | null): void;
}>();

const employees = ref<Employee[]>([]);
const loading = ref(false);

// Computed property to format employee display name
const employeesWithDisplayName = computed(() =>
  employees.value.map((emp) => ({
    ...emp,
    displayName: `${emp.firstName} ${emp.lastName} (${emp.email})`,
  }))
);

onMounted(() => {
  fetchEmployees();
});

async function fetchEmployees() {
  try {
    loading.value = true;
    // Using the same endpoint as React app (getReportingManagers)
    const response = await httpClient.get('/EmploymentDetails/GetReportingManagerList');

    if (response.data?.statusCode === 200 && response.data?.result) {
      employees.value = response.data.result;
    }
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Failed to fetch employees';
    toast.error(message);
  } finally {
    loading.value = false;
  }
}

function handleChange(value: number | null) {
  emit('update:modelValue', value);
}
</script>

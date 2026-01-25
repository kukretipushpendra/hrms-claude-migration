<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useField } from 'vee-validate';
import { getReportingManagerList, type ReportingManagerType } from '@/services/employment';
import { useSnackbar } from '@/composables/useSnackbar';

interface Props {
  label: string;
  name?: string;
  required?: boolean;
  placeholder?: string;
}

const props = withDefaults(defineProps<Props>(), {
  name: 'reportingManagerId',
  required: false,
});

const { showError } = useSnackbar();
const { errorMessage, setValue } = useField<string>(props.name);

const reportingManagerList = ref<ReportingManagerType[]>([]);
const loading = ref(false);

const getFullName = (manager: ReportingManagerType) => {
  const parts = [manager.firstName, manager.middleName, manager.lastName].filter(Boolean);
  return parts.join(' ');
};

const fetchReportingManagers = async (searchName?: string) => {
  loading.value = true;
  try {
    const response = await getReportingManagerList({ name: searchName });
    reportingManagerList.value = response.result;
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch reporting managers');
  } finally {
    loading.value = false;
  }
};

const selectedManager = ref<ReportingManagerType | null>(null);

const handleChange = (manager: ReportingManagerType | null) => {
  selectedManager.value = manager;
  setValue(manager ? manager.id.toString() : '');
};

onMounted(() => {
  fetchReportingManagers();
});
</script>

<template>
  <v-autocomplete
    :model-value="selectedManager"
    :items="reportingManagerList"
    :label="required ? `${label}*` : label"
    :placeholder="placeholder"
    :loading="loading"
    :error-messages="errorMessage"
    :item-title="getFullName"
    item-value="id"
    return-object
    variant="outlined"
    density="compact"
    @update:model-value="handleChange"
  >
    <template v-if="loading" #append>
      <v-progress-circular size="20" indeterminate color="primary"></v-progress-circular>
    </template>
  </v-autocomplete>
</template>

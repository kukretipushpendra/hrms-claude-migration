<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useField } from 'vee-validate';
import { getDepartments, type DepartmentType } from '@/services/employment';
import { useSnackbar } from '@/composables/useSnackbar';

interface Props {
  required?: boolean;
  name?: string;
}

const props = withDefaults(defineProps<Props>(), {
  required: false,
  name: 'departmentId',
});

const { showError } = useSnackbar();
const { value, errorMessage, setValue } = useField<string>(props.name);

const departmentList = ref<DepartmentType[]>([]);
const loading = ref(false);

const fetchDepartments = async () => {
  loading.value = true;
  try {
    const response = await getDepartments({
      SortColumnName: 'Name',
      SortDirection: 'asc',
      StartIndex: 1,
      PageSize: 1000,
      Filters: {
        Name: '',
      },
    });
    departmentList.value = response.result.departmentList;
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch departments');
  } finally {
    loading.value = false;
  }
};

const selectedId = ref<number | null>(null);

// Watch value changes and sync with selectedId
watch(value, (newValue) => {
  if (newValue) {
    selectedId.value = Number(newValue);
  } else {
    selectedId.value = null;
  }
}, { immediate: true });

const handleChange = (id: number | null) => {
  setValue(id ? id.toString() : '');
};

onMounted(() => {
  fetchDepartments();
});
</script>

<template>
  <v-autocomplete
    v-model="selectedId"
    :items="departmentList"
    :label="required ? 'Department*' : 'Department'"
    :loading="loading"
    :error-messages="errorMessage"
    item-title="name"
    item-value="id"
    variant="outlined"
    density="compact"
    @update:model-value="handleChange"
  />
</template>

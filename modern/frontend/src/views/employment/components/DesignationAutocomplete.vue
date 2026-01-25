<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useField } from 'vee-validate';
import { getDesignationList, type DesignationType } from '@/services/employment';
import { useSnackbar } from '@/composables/useSnackbar';

interface Props {
  required?: boolean;
  name?: string;
}

const props = withDefaults(defineProps<Props>(), {
  required: false,
  name: 'designationId',
});

const { showError } = useSnackbar();
const { value, errorMessage, setValue } = useField<string>(props.name);

const designationList = ref<DesignationType[]>([]);
const loading = ref(false);

const fetchDesignations = async () => {
  loading.value = true;
  try {
    const response = await getDesignationList();
    designationList.value = response.result;
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch designations');
  } finally {
    loading.value = false;
  }
};

const selectedId = ref<number | null>(null);

// Watch value changes and sync with selectedId
watch(
  value,
  (newValue) => {
    if (newValue) {
      selectedId.value = Number(newValue);
    } else {
      selectedId.value = null;
    }
  },
  { immediate: true }
);

const handleChange = (id: number | null) => {
  setValue(id ? id.toString() : '');
};

onMounted(() => {
  fetchDesignations();
});
</script>

<template>
  <v-autocomplete
    v-model="selectedId"
    :items="designationList"
    :label="required ? 'Designation*' : 'Designation'"
    :loading="loading"
    :error-messages="errorMessage"
    item-title="name"
    item-value="id"
    variant="outlined"
    density="compact"
    @update:model-value="handleChange"
  />
</template>

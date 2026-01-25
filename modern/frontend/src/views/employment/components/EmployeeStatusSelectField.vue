<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import { useField } from 'vee-validate';
import { EMPLOYEE_STATUS_OPTIONS, EMPLOYEE_STATUS_LABEL } from '../utils';

interface Props {
  isEditable: boolean;
  name?: string;
}

const props = withDefaults(defineProps<Props>(), {
  name: 'employeeStatus',
});

const { value, errorMessage, setValue } = useField<string>(props.name);

const selectedId = ref<number | null>(null);

// Computed display value for readonly mode
const displayValue = computed(() => {
  if (selectedId.value !== null) {
    return EMPLOYEE_STATUS_LABEL[selectedId.value] || '';
  }
  return '';
});

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
</script>

<template>
  <v-select
    v-if="isEditable"
    v-model="selectedId"
    :items="EMPLOYEE_STATUS_OPTIONS"
    label="Employee Status"
    :error-messages="errorMessage"
    item-title="label"
    item-value="id"
    variant="outlined"
    density="compact"
    @update:model-value="handleChange"
  />
  <v-text-field
    v-else
    :model-value="displayValue"
    label="Employee Status"
    readonly
    variant="outlined"
    density="compact"
  />
</template>

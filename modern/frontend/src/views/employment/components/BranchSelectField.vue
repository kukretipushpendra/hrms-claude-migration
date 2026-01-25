<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import { useField } from 'vee-validate';
import { BRANCH_LOCATION_OPTIONS, BRANCH_LOCATION_LABEL } from '../utils';

interface Props {
  isEditable: boolean;
  required?: boolean;
  name?: string;
}

const props = withDefaults(defineProps<Props>(), {
  required: false,
  name: 'branchId',
});

const { value, errorMessage, setValue } = useField<string>(props.name);

const selectedId = ref<number | null>(null);

// Computed display value for readonly mode
const displayValue = computed(() => {
  if (selectedId.value !== null) {
    return BRANCH_LOCATION_LABEL[selectedId.value] || '';
  }
  return '';
});

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
</script>

<template>
  <v-select
    v-if="isEditable"
    v-model="selectedId"
    :items="BRANCH_LOCATION_OPTIONS"
    :label="required ? 'Branch*' : 'Branch'"
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
    :label="required ? 'Branch*' : 'Branch'"
    readonly
    variant="outlined"
    density="compact"
  />
</template>

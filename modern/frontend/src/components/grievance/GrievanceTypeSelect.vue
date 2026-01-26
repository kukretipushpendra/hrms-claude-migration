<template>
  <v-select
    v-model="selectedType"
    :items="grievanceTypes"
    item-title="grievanceName"
    item-value="id"
    :label="label"
    :disabled="loading || disabled"
    :error-messages="errorMessage"
    :required="required"
    variant="outlined"
    density="comfortable"
    clearable
  >
    <template #item="{ props: itemProps, item }">
      <v-list-item v-bind="itemProps">
        <v-list-item-title>{{ item.raw.grievanceName }}</v-list-item-title>
        <v-list-item-subtitle v-if="item.raw.description">
          {{ item.raw.description }}
        </v-list-item-subtitle>
      </v-list-item>
    </template>
  </v-select>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { getAllGrievanceTypeList } from '@/services/grievance/grievance.service';
import type { GrievanceTypeSimple } from '@/types/grievance.types';

interface Props {
  modelValue?: number | null;
  label?: string;
  disabled?: boolean;
  required?: boolean;
  errorMessage?: string;
}

const props = withDefaults(defineProps<Props>(), {
  label: 'Grievance Type',
  disabled: false,
  required: false,
  errorMessage: '',
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: number | null): void;
}>();

const grievanceTypes = ref<GrievanceTypeSimple[]>([]);
const loading = ref(false);

const selectedType = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value ?? null),
});

const fetchTypes = async () => {
  loading.value = true;
  try {
    grievanceTypes.value = await getAllGrievanceTypeList();
  } catch (error) {
    console.error('Failed to load grievance types:', error);
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchTypes();
});
</script>

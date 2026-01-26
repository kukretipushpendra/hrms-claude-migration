<template>
  <v-card flat>
    <v-card-text>
      <v-form ref="formRef" @submit.prevent="handleSubmit">
        <v-row>
          <v-col cols="12" md="6">
            <GrievanceTypeSelect v-model="filters.grievanceTypeId" label="Grievance Type" />
          </v-col>
          <v-col cols="12" md="6">
            <v-select
              v-model="filters.status"
              :items="statusOptions"
              label="Status"
              variant="outlined"
              density="comfortable"
              clearable
            />
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" class="d-flex justify-end gap-2">
            <v-btn color="secondary" variant="outlined" @click="handleReset"> Reset </v-btn>
            <v-btn color="primary" type="submit"> Search </v-btn>
          </v-col>
        </v-row>
      </v-form>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import GrievanceTypeSelect from './GrievanceTypeSelect.vue';
import type { EmployeeGrievanceFilter } from '@/types/grievance.types';
import { GrievanceStatus, GRIEVANCE_STATUS_LABEL } from '@/types/grievance.types';

interface Props {
  modelValue: EmployeeGrievanceFilter;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'update:modelValue', value: EmployeeGrievanceFilter): void;
  (e: 'search', value: EmployeeGrievanceFilter): void;
  (e: 'reset'): void;
}>();

const formRef = ref<any>(null);
const filters = ref<EmployeeGrievanceFilter>({ ...props.modelValue });

const statusOptions = [
  { title: GRIEVANCE_STATUS_LABEL[GrievanceStatus.Open], value: GrievanceStatus.Open },
  {
    title: GRIEVANCE_STATUS_LABEL[GrievanceStatus.InProgress],
    value: GrievanceStatus.InProgress,
  },
  {
    title: GRIEVANCE_STATUS_LABEL[GrievanceStatus.Resolved],
    value: GrievanceStatus.Resolved,
  },
  {
    title: GRIEVANCE_STATUS_LABEL[GrievanceStatus.Closed],
    value: GrievanceStatus.Closed,
  },
  {
    title: GRIEVANCE_STATUS_LABEL[GrievanceStatus.Escalated],
    value: GrievanceStatus.Escalated,
  },
];

const handleSubmit = () => {
  emit('update:modelValue', filters.value);
  emit('search', filters.value);
};

const handleReset = () => {
  filters.value = {
    grievanceTypeId: null,
    status: null,
  };
  emit('update:modelValue', filters.value);
  emit('reset');
};

watch(
  () => props.modelValue,
  (newValue) => {
    filters.value = { ...newValue };
  },
  { deep: true }
);

defineExpose({
  handleReset,
});
</script>

<style scoped>
.gap-2 {
  gap: 8px;
}
</style>

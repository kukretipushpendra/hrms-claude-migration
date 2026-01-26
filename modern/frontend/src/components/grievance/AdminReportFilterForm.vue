<template>
  <v-card flat>
    <v-card-text>
      <v-form ref="formRef" @submit.prevent="handleSubmit">
        <v-row>
          <v-col cols="12" md="4">
            <GrievanceTypeSelect v-model="filters.grievanceTypeId" label="Grievance Type" />
          </v-col>
          <v-col cols="12" md="4">
            <v-select
              v-model="filters.status"
              :items="statusOptions"
              label="Status"
              variant="outlined"
              density="comfortable"
              clearable
            />
          </v-col>
          <v-col cols="12" md="4">
            <v-select
              v-model="filters.level"
              :items="levelOptions"
              label="Level"
              variant="outlined"
              density="comfortable"
              clearable
            />
          </v-col>
          <v-col cols="12" md="4">
            <v-select
              v-model="filters.tatStatus"
              :items="tatStatusOptions"
              label="TAT Status"
              variant="outlined"
              density="comfortable"
              clearable
            />
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="filters.fromDate"
              type="date"
              label="From Date"
              variant="outlined"
              density="comfortable"
              clearable
            />
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="filters.toDate"
              type="date"
              label="To Date"
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
import type { AdminGrievanceFilter } from '@/types/grievance.types';
import {
  GrievanceStatus,
  GrievanceLevel,
  GRIEVANCE_STATUS_LABEL,
  GRIEVANCE_LEVEL_LABEL,
} from '@/types/grievance.types';

interface Props {
  modelValue: AdminGrievanceFilter;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'update:modelValue', value: AdminGrievanceFilter): void;
  (e: 'search', value: AdminGrievanceFilter): void;
  (e: 'reset'): void;
}>();

const filters = ref<AdminGrievanceFilter>({ ...props.modelValue });

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

const levelOptions = [
  { title: GRIEVANCE_LEVEL_LABEL[GrievanceLevel.L1], value: GrievanceLevel.L1 },
  { title: GRIEVANCE_LEVEL_LABEL[GrievanceLevel.L2], value: GrievanceLevel.L2 },
  { title: GRIEVANCE_LEVEL_LABEL[GrievanceLevel.L3], value: GrievanceLevel.L3 },
];

const tatStatusOptions = [
  { title: 'Within TAT', value: true },
  { title: 'Breached', value: false },
];

const handleSubmit = () => {
  emit('update:modelValue', filters.value);
  emit('search', filters.value);
};

const handleReset = () => {
  filters.value = {
    grievanceTypeId: null,
    status: null,
    level: null,
    tatStatus: null,
    fromDate: null,
    toDate: null,
    createdById: null,
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

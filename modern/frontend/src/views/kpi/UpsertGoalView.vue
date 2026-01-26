<template>
  <div class="upsert-goal-view">
    <v-breadcrumbs :items="breadcrumbs" />

    <v-card>
      <v-card-title class="text-h4 pa-4">
        {{ isEditMode ? 'Edit Goal' : 'Add Goal' }}
      </v-card-title>

      <v-card-text>
        <v-form ref="formRef" @submit.prevent="handleSubmit">
          <v-row>
            <!-- Title -->
            <v-col cols="12" md="6">
              <v-text-field
                v-model="formData.title"
                label="Title *"
                variant="outlined"
                :rules="[(v: string) => !!v || 'Title is required']"
                required
              />
            </v-col>

            <!-- Department -->
            <v-col cols="12" md="6">
              <v-select
                v-model="formData.departmentId"
                :items="[]"
                label="Department *"
                variant="outlined"
                :rules="[(v: number | null) => !!v || 'Department is required']"
                required
              />
            </v-col>

            <!-- Description -->
            <v-col cols="12">
              <v-textarea
                v-model="formData.description"
                label="Description *"
                variant="outlined"
                rows="4"
                :maxlength="600"
                counter
                :rules="[
                  (v: string) => !!v || 'Description is required',
                  (v: string) => (v && v.length <= 600) || 'Maximum 600 characters allowed',
                ]"
                required
              />
            </v-col>

            <!-- Employee IDs (comma-separated) -->
            <v-col cols="12">
              <v-text-field
                v-model="formData.employeeIds"
                label="Employee IDs (comma-separated)"
                variant="outlined"
                hint="Enter employee IDs separated by commas, e.g., 101,102,103"
                persistent-hint
              />
            </v-col>
          </v-row>

          <!-- Action Buttons -->
          <v-row class="mt-4">
            <v-col cols="12" class="d-flex justify-center gap-2">
              <v-btn color="primary" type="submit" :loading="loading">
                {{ isEditMode ? 'Update' : 'Create' }}
              </v-btn>
              <v-btn color="secondary" variant="outlined" @click="handleReset"> Reset </v-btn>
              <v-btn color="default" variant="outlined" @click="handleCancel"> Cancel </v-btn>
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import kpiService from '@/services/kpi/kpi.service';
import type { UpsertRequestGoal } from '@/types/kpi.types';
import { useSnackbar } from '@/composables/useSnackbar';

const router = useRouter();
const route = useRoute();
const { showSuccess, showError } = useSnackbar();

const formRef = ref();
const loading = ref(false);

const goalId = computed(() => {
  const id = route.params.id;
  return id ? Number(id) : null;
});

const isEditMode = computed(() => !!goalId.value);

const formData = ref<Omit<UpsertRequestGoal, 'employeeId'> & { employeeId?: number }>({
  id: goalId.value || 0,
  title: '',
  description: '',
  departmentId: 0,
  employeeId: 0,
  employeeIds: '',
});

const breadcrumbs = computed(() => [
  { title: 'KPI', disabled: false },
  { title: 'Goals', disabled: false, to: '/KPI/Goals' },
  { title: isEditMode.value ? 'Edit Goal' : 'Add Goal', disabled: true },
]);

const fetchGoalDetails = async () => {
  if (!goalId.value) return;

  try {
    loading.value = true;
    const response = await kpiService.getGoalById(goalId.value);

    const goal = response.result;
    formData.value = {
      id: goal.goalId,
      title: goal.title,
      description: goal.description,
      departmentId: goal.departmentId,
      employeeId: goal.employeeId,
      employeeIds: goal.employeeIds,
    };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to fetch goal details';
    showError(message);
  } finally {
    loading.value = false;
  }
};

const handleReset = () => {
  if (isEditMode.value) {
    fetchGoalDetails();
  } else {
    formData.value = {
      id: 0,
      title: '',
      description: '',
      departmentId: 0,
      employeeId: 0,
      employeeIds: '',
    };
    formRef.value?.resetValidation();
  }
};

const handleCancel = () => {
  router.push('/KPI/Goals');
};

const handleSubmit = async () => {
  const { valid } = await formRef.value?.validate();
  if (!valid) return;

  try {
    loading.value = true;

    const payload: UpsertRequestGoal = {
      id: formData.value.id,
      title: formData.value.title,
      description: formData.value.description,
      departmentId: formData.value.departmentId,
      employeeId: formData.value.employeeId || 0,
      employeeIds: formData.value.employeeIds,
    };

    if (isEditMode.value) {
      const response = await kpiService.updateGoal(payload);
      showSuccess(response.message);
    } else {
      const response = await kpiService.createGoal(payload);
      showSuccess(response.message);
    }

    router.push('/KPI/Goals');
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to save goal';
    showError(message);
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  if (isEditMode.value) {
    fetchGoalDetails();
  }
});
</script>

<style scoped>
.gap-2 {
  gap: 8px;
}
</style>

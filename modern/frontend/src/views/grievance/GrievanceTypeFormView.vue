<template>
  <div>
    <v-breadcrumbs :items="breadcrumbs" />
    <v-card>
      <v-card-title class="bg-primary text-white">
        <h3>{{ isEdit ? 'Edit' : 'Add' }} Grievance Type</h3>
      </v-card-title>
      <v-card-text class="pa-6">
        <v-form ref="formRef" @submit.prevent="handleSubmit">
          <v-row>
            <v-col cols="12" md="6">
              <v-text-field
                v-model="formData.grievanceName"
                label="Grievance Name"
                variant="outlined"
                required
                :error-messages="errors.grievanceName"
              />
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field
                v-model="formData.description"
                label="Description"
                variant="outlined"
                required
                :error-messages="errors.description"
              />
            </v-col>
            <v-col cols="12" md="4">
              <v-text-field
                v-model.number="formData.l1TatHours"
                label="L1 TAT (Hours)"
                type="number"
                variant="outlined"
                required
                :error-messages="errors.l1TatHours"
              />
            </v-col>
            <v-col cols="12" md="4">
              <v-text-field
                v-model.number="formData.l2TatHours"
                label="L2 TAT (Hours)"
                type="number"
                variant="outlined"
                required
                :error-messages="errors.l2TatHours"
              />
            </v-col>
            <v-col cols="12" md="4">
              <v-text-field
                v-model.number="formData.l3TatDays"
                label="L3 TAT (Days)"
                type="number"
                variant="outlined"
                required
                :error-messages="errors.l3TatDays"
              />
            </v-col>
            <v-col cols="12" md="6">
              <v-switch v-model="formData.isActive" label="Active" color="primary" hide-details />
            </v-col>
            <v-col cols="12" md="6">
              <v-switch
                v-model="formData.isAutoEscalation"
                label="Auto Escalation"
                color="primary"
                hide-details
              />
            </v-col>
          </v-row>

          <v-divider class="my-4" />

          <h4 class="mb-4">Owner Assignment (Note: Implement owner selection)</h4>
          <v-alert type="info" variant="tonal">
            Owner assignment UI to be implemented. For now, owners should be managed via backend.
          </v-alert>

          <v-row class="mt-4">
            <v-col cols="12" class="d-flex justify-center gap-4">
              <v-btn
                color="primary"
                type="submit"
                :loading="submitting"
                prepend-icon="mdi-content-save"
              >
                {{ isEdit ? 'Update' : 'Create' }}
              </v-btn>
              <v-btn
                color="secondary"
                variant="outlined"
                @click="handleCancel"
                prepend-icon="mdi-cancel"
              >
                Cancel
              </v-btn>
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>
    </v-card>

    <v-snackbar v-model="showError" color="error" timeout="5000">
      {{ errorMessage }}
    </v-snackbar>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import {
  getGrievanceTypeById,
  addGrievanceType,
  updateGrievanceType,
} from '@/services/grievance/grievance.service';
import type { GrievanceTypeRequest } from '@/types/grievance.types';

const route = useRoute();
const router = useRouter();

const isEdit = computed(() => !!route.params.id);

const breadcrumbs = [
  { title: 'Grievance', disabled: false, href: '/Grievance' },
  { title: 'Configuration', disabled: false, href: '/Grievance/configuration' },
  { title: isEdit.value ? 'Edit Type' : 'Add Type', disabled: true },
];

const formRef = ref<any>(null);
const submitting = ref(false);
const showError = ref(false);
const errorMessage = ref('');

const formData = reactive({
  id: undefined as number | undefined,
  grievanceName: '',
  description: '',
  l1TatHours: 4,
  l2TatHours: 8,
  l3TatDays: 2,
  isActive: true,
  isAutoEscalation: false,
  owners: [] as any[],
});

const errors = reactive({
  grievanceName: '',
  description: '',
  l1TatHours: '',
  l2TatHours: '',
  l3TatDays: '',
});

const validateForm = (): boolean => {
  errors.grievanceName = '';
  errors.description = '';
  errors.l1TatHours = '';
  errors.l2TatHours = '';
  errors.l3TatDays = '';

  let valid = true;

  if (!formData.grievanceName.trim()) {
    errors.grievanceName = 'Grievance name is required';
    valid = false;
  }

  if (!formData.description.trim()) {
    errors.description = 'Description is required';
    valid = false;
  }

  if (formData.l1TatHours <= 0) {
    errors.l1TatHours = 'L1 TAT must be greater than 0';
    valid = false;
  }

  if (formData.l2TatHours <= 0) {
    errors.l2TatHours = 'L2 TAT must be greater than 0';
    valid = false;
  }

  if (formData.l3TatDays <= 0) {
    errors.l3TatDays = 'L3 TAT must be greater than 0';
    valid = false;
  }

  return valid;
};

const handleSubmit = async () => {
  if (!validateForm()) {
    return;
  }

  submitting.value = true;
  try {
    const payload: GrievanceTypeRequest = {
      id: formData.id,
      grievanceName: formData.grievanceName,
      description: formData.description,
      l1TatHours: formData.l1TatHours,
      l2TatHours: formData.l2TatHours,
      l3TatDays: formData.l3TatDays,
      isActive: formData.isActive,
      isAutoEscalation: formData.isAutoEscalation,
      owners: formData.owners,
    };

    if (isEdit.value) {
      await updateGrievanceType(payload);
    } else {
      await addGrievanceType(payload);
    }

    router.push('/Grievance/configuration');
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value =
      err.response?.data?.message ||
      `Failed to ${isEdit.value ? 'update' : 'create'} grievance type`;
    showError.value = true;
  } finally {
    submitting.value = false;
  }
};

const handleCancel = () => {
  router.push('/Grievance/configuration');
};

const loadType = async () => {
  const id = route.params.id;
  if (!id) {
    return;
  }

  try {
    const type = await getGrievanceTypeById(Number(id));
    if (type) {
      formData.id = type.id;
      formData.grievanceName = type.grievanceName;
      formData.description = type.description;
      formData.l1TatHours = type.l1TatHours;
      formData.l2TatHours = type.l2TatHours;
      formData.l3TatDays = type.l3TatDays;
      formData.isActive = type.isActive;
      formData.isAutoEscalation = type.isAutoEscalation;
      formData.owners = type.owners || [];
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'Failed to load grievance type';
    showError.value = true;
  }
};

onMounted(() => {
  if (isEdit.value) {
    loadType();
  }
});
</script>

<style scoped>
.gap-4 {
  gap: 16px;
}
</style>

<template>
  <div>
    <v-breadcrumbs :items="breadcrumbs" />
    <v-card>
      <v-card-title class="bg-primary text-white">
        <h3>Add Grievance</h3>
      </v-card-title>
      <v-card-text class="pa-6">
        <v-form ref="formRef" @submit.prevent="handleSubmit">
          <v-row>
            <v-col cols="12">
              <GrievanceTypeSelect
                v-model="formData.grievanceTypeId"
                label="Grievance Type"
                required
                :error-message="errors.grievanceTypeId"
              />
            </v-col>
            <v-col cols="12">
              <v-text-field
                v-model="formData.title"
                label="Title"
                variant="outlined"
                required
                counter="200"
                maxlength="200"
                :error-messages="errors.title"
              />
            </v-col>
            <v-col cols="12">
              <v-textarea
                v-model="formData.description"
                label="Description"
                variant="outlined"
                rows="6"
                :error-messages="errors.description"
              />
            </v-col>
            <v-col cols="12">
              <v-file-input
                v-model="formData.attachment"
                label="Attachment (optional)"
                variant="outlined"
                prepend-icon=""
                prepend-inner-icon="mdi-paperclip"
                clearable
                show-size
                accept="*/*"
                :error-messages="errors.attachment"
              />
            </v-col>
            <v-col cols="12" class="d-flex justify-center gap-4">
              <v-btn
                color="primary"
                type="submit"
                :loading="submitting"
                prepend-icon="mdi-content-save"
              >
                Submit
              </v-btn>
              <v-btn
                color="secondary"
                variant="outlined"
                @click="handleReset"
                prepend-icon="mdi-refresh"
              >
                Reset
              </v-btn>
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>
    </v-card>

    <SuccessDialog
      v-if="successData"
      :open="!!successData"
      :grievance-id="successData.id"
      :ticket-no="successData.ticketNo"
      @update:open="successData = null"
    />

    <v-snackbar v-model="showError" color="error" timeout="5000">
      {{ errorMessage }}
    </v-snackbar>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import GrievanceTypeSelect from '@/components/grievance/GrievanceTypeSelect.vue';
import SuccessDialog from '@/components/grievance/SuccessDialog.vue';
import { submitGrievance } from '@/services/grievance/grievance.service';
import { validateFile } from '@/utils/grievance.utils';

const breadcrumbs = [
  { title: 'Grievance', disabled: false, href: '/Grievance' },
  { title: 'Add Grievance', disabled: true },
];

const formRef = ref<any>(null);
const submitting = ref(false);
const showError = ref(false);
const errorMessage = ref('');
const successData = ref<{ id: number; ticketNo: string } | null>(null);

const formData = reactive({
  grievanceTypeId: null as number | null,
  title: '',
  description: '',
  attachment: null as File[] | null,
});

const errors = reactive({
  grievanceTypeId: '',
  title: '',
  description: '',
  attachment: '',
});

const validateForm = (): boolean => {
  errors.grievanceTypeId = '';
  errors.title = '';
  errors.description = '';
  errors.attachment = '';

  let valid = true;

  if (!formData.grievanceTypeId) {
    errors.grievanceTypeId = 'Grievance type is required';
    valid = false;
  }

  if (!formData.title.trim()) {
    errors.title = 'Title is required';
    valid = false;
  } else if (formData.title.length > 200) {
    errors.title = 'Title must not exceed 200 characters';
    valid = false;
  }

  // Validate file if attached
  const file =
    formData.attachment && formData.attachment.length > 0 ? formData.attachment[0] : null;
  if (file) {
    const validation = validateFile(file, 5);
    if (!validation.valid) {
      errors.attachment = validation.error || 'Invalid file';
      valid = false;
    }
  }

  return valid;
};

const handleSubmit = async () => {
  if (!validateForm()) {
    return;
  }

  submitting.value = true;
  try {
    const file =
      formData.attachment && formData.attachment.length > 0 ? formData.attachment[0] : undefined;

    const result = await submitGrievance({
      grievanceTypeId: formData.grievanceTypeId!,
      title: formData.title,
      description: formData.description || undefined,
      attachment: file,
    });

    successData.value = result;
    handleReset();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'Failed to submit grievance';
    showError.value = true;
  } finally {
    submitting.value = false;
  }
};

const handleReset = () => {
  formData.grievanceTypeId = null;
  formData.title = '';
  formData.description = '';
  formData.attachment = null;
  errors.grievanceTypeId = '';
  errors.title = '';
  errors.description = '';
  errors.attachment = '';
};
</script>

<style scoped>
.gap-4 {
  gap: 16px;
}
</style>

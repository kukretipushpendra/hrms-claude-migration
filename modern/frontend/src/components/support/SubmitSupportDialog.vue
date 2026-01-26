<script setup lang="ts">
import { ref, computed } from 'vue';
import { useForm, useField } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import { useAuthStore } from '@/stores/auth.store';
import { addFeedback } from '@/services/support/support.service';
import { FEEDBACK_TYPE_OPTIONS } from '@/types/support.types';
import type { AddFeedbackRequest } from '@/types/support.types';

interface Props {
  open: boolean;
}

interface Emits {
  (e: 'close'): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();

const authStore = useAuthStore();
const loading = ref(false);
const snackbar = ref(false);
const snackbarMessage = ref('');

// Validation schema matching legacy
const schema = toTypedSchema(
  z.object({
    bugType: z.number({ required_error: 'Bug Type is required' }),
    subject: z
      .string()
      .min(1, 'Subject is required')
      .max(200, 'Subject must be at most 200 characters'),
    description: z
      .string()
      .min(1, 'Description is required')
      .max(600, 'Description must be at most 600 characters'),
    attachment: z
      .instanceof(File)
      .nullable()
      .optional()
      .refine(
        (file) => {
          if (!file) return true;
          return file.size <= 5 * 1024 * 1024; // 5MB
        },
        { message: 'File size should not exceed 5 MB' }
      ),
  })
);

const { handleSubmit, errors, resetForm } = useForm({
  validationSchema: schema,
  initialValues: {
    bugType: undefined as number | undefined,
    subject: '',
    description: '',
    attachment: null,
  },
});

const { value: bugType } = useField<number | undefined>('bugType');
const { value: subject } = useField<string>('subject');
const { value: description } = useField<string>('description');
const { value: attachment } = useField<File | null>('attachment');

// Pre-filled user data from auth store
const userName = computed(() => {
  const user = authStore.user;
  if (!user) return '';
  return `${user.firstName} ${user.lastName}`.trim();
});

const userEmail = computed(() => authStore.user?.email || '');

// File handling
const fileInput = ref<HTMLInputElement | null>(null);

function handleFileChange(event: Event) {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    attachment.value = target.files[0];
  }
}

function removeFile() {
  attachment.value = null;
  if (fileInput.value) {
    fileInput.value.value = '';
  }
}

// Submit handler
const onSubmit = handleSubmit(async (values) => {
  if (!authStore.user?.id) {
    snackbarMessage.value = 'User not authenticated';
    snackbar.value = true;
    return;
  }

  loading.value = true;

  try {
    const request: AddFeedbackRequest = {
      employeeId: Number(authStore.user.id),
      feedbackType: values.bugType!,
      subject: values.subject,
      description: values.description,
      attachment: values.attachment || null,
    };

    await addFeedback(request);

    snackbarMessage.value = 'FeedBack Added Successfully';
    snackbar.value = true;

    // Close dialog after short delay
    setTimeout(() => {
      emit('close');
    }, 500);
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    snackbarMessage.value = err.response?.data?.message || 'Failed to submit feedback';
    snackbar.value = true;
  } finally {
    loading.value = false;
  }
});

function handleReset() {
  resetForm();
  removeFile();
}

function handleClose() {
  emit('close');
}
</script>

<template>
  <v-dialog :model-value="props.open" max-width="800" persistent @update:model-value="handleClose">
    <v-card>
      <v-card-title class="d-flex align-center pa-4">
        <span class="text-h5 text-primary">Send Support Query</span>
        <v-spacer />
        <v-btn icon variant="text" @click="handleClose">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>

      <v-divider />

      <v-card-text class="pa-6">
        <v-form @submit.prevent="onSubmit">
          <v-row>
            <!-- Name (disabled, pre-filled) -->
            <v-col cols="12" md="4">
              <v-text-field
                :model-value="userName"
                label="Name"
                disabled
                variant="outlined"
                density="comfortable"
              />
            </v-col>

            <!-- Email (disabled, pre-filled) -->
            <v-col cols="12" md="4">
              <v-text-field
                :model-value="userEmail"
                label="Email"
                disabled
                variant="outlined"
                density="comfortable"
              />
            </v-col>

            <!-- Bug Type -->
            <v-col cols="12" md="4">
              <v-select
                v-model="bugType"
                label="Bug Type"
                :items="FEEDBACK_TYPE_OPTIONS"
                item-title="label"
                item-value="value"
                :error-messages="errors.bugType"
                variant="outlined"
                density="comfortable"
                required
              />
            </v-col>

            <!-- Subject -->
            <v-col cols="12">
              <v-text-field
                v-model="subject"
                label="Subject"
                :error-messages="errors.subject"
                variant="outlined"
                density="comfortable"
                counter="200"
                maxlength="200"
                required
              />
            </v-col>

            <!-- Description -->
            <v-col cols="12">
              <v-textarea
                v-model="description"
                label="Description"
                :error-messages="errors.description"
                variant="outlined"
                rows="4"
                counter="600"
                maxlength="600"
                required
              />
            </v-col>

            <!-- File Upload -->
            <v-col cols="12">
              <input ref="fileInput" type="file" style="display: none" @change="handleFileChange" />

              <v-card variant="outlined" class="pa-4">
                <div class="d-flex align-center justify-space-between">
                  <div v-if="attachment" class="d-flex align-center">
                    <v-icon color="primary" class="mr-2">mdi-file</v-icon>
                    <span class="text-body-2">{{ attachment.name }}</span>
                  </div>
                  <span v-else class="text-body-2 text-grey-600">No file selected</span>

                  <div>
                    <v-btn
                      v-if="attachment"
                      variant="text"
                      color="error"
                      size="small"
                      @click="removeFile"
                    >
                      Remove
                    </v-btn>
                    <v-btn
                      variant="outlined"
                      color="primary"
                      size="small"
                      @click="fileInput?.click()"
                    >
                      {{ attachment ? 'Change File' : 'Choose File' }}
                    </v-btn>
                  </div>
                </div>
                <div v-if="errors.attachment" class="text-error text-caption mt-2">
                  {{ errors.attachment }}
                </div>
              </v-card>
            </v-col>

            <!-- Action Buttons -->
            <v-col cols="12" class="d-flex justify-center gap-4 pt-4">
              <v-btn
                type="submit"
                color="primary"
                variant="flat"
                :loading="loading"
                :disabled="loading"
                size="large"
              >
                Submit
              </v-btn>
              <v-btn
                variant="outlined"
                color="grey"
                size="large"
                :disabled="loading"
                @click="handleReset"
              >
                Reset
              </v-btn>
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>
    </v-card>

    <!-- Success/Error Snackbar -->
    <v-snackbar v-model="snackbar" :timeout="3000" location="top">
      {{ snackbarMessage }}
      <template #actions>
        <v-btn color="white" variant="text" @click="snackbar = false">Close</v-btn>
      </template>
    </v-snackbar>
  </v-dialog>
</template>

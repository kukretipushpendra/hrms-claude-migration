<script setup lang="ts">
import { ref } from 'vue';
import { useForm, useField } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import { modifyFeedbackStatus } from '@/services/support/support.service';
import { FEEDBACK_STATUS_OPTIONS } from '@/types/support.types';
import type { FeedbackStatusType, Feedback } from '@/types/support.types';

interface Props {
  open: boolean;
  feedback: Feedback;
}

interface Emits {
  (e: 'close'): void;
  (e: 'updated'): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();

const loading = ref(false);
const snackbar = ref(false);
const snackbarMessage = ref('');

// Validation schema
const schema = toTypedSchema(
  z.object({
    ticketStatus: z.number({ required_error: 'Status is required' }),
    adminComment: z
      .string()
      .min(1, 'Admin Comment is required')
      .max(600, 'Admin Comment must be at most 600 characters'),
  })
);

const { handleSubmit, errors } = useForm({
  validationSchema: schema,
  initialValues: {
    ticketStatus: props.feedback.ticketStatus,
    adminComment: props.feedback.adminComment || '',
  },
});

const { value: ticketStatus } = useField<FeedbackStatusType>('ticketStatus');
const { value: adminComment } = useField<string>('adminComment');

// Submit handler
const onSubmit = handleSubmit(async (values) => {
  loading.value = true;

  try {
    await modifyFeedbackStatus({
      id: props.feedback.id,
      ticketStatus: values.ticketStatus,
      adminComment: values.adminComment,
    });

    snackbarMessage.value = 'Status Update Successfully';
    snackbar.value = true;

    // Close dialog and notify parent after short delay
    setTimeout(() => {
      emit('updated');
      emit('close');
    }, 500);
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    snackbarMessage.value = err.response?.data?.message || 'Failed to update status';
    snackbar.value = true;
  } finally {
    loading.value = false;
  }
});

function handleClose() {
  emit('close');
}
</script>

<template>
  <v-dialog :model-value="props.open" max-width="600" persistent @update:model-value="handleClose">
    <v-card>
      <v-card-title class="d-flex align-center pa-4">
        <span class="text-h5 text-primary">Update Support Query Status</span>
        <v-spacer />
        <v-btn icon variant="text" @click="handleClose">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>

      <v-divider />

      <v-card-text class="pa-6">
        <v-form @submit.prevent="onSubmit">
          <v-row>
            <!-- Status Dropdown -->
            <v-col cols="12">
              <v-select
                v-model="ticketStatus"
                label="Ticket Status"
                :items="FEEDBACK_STATUS_OPTIONS"
                item-title="label"
                item-value="value"
                :error-messages="errors.ticketStatus"
                variant="outlined"
                density="comfortable"
                required
              />
            </v-col>

            <!-- Admin Comment -->
            <v-col cols="12">
              <v-textarea
                v-model="adminComment"
                label="Admin Comment"
                :error-messages="errors.adminComment"
                variant="outlined"
                rows="4"
                counter="600"
                maxlength="600"
                required
              />
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
                Update
              </v-btn>
              <v-btn
                variant="outlined"
                color="grey"
                size="large"
                :disabled="loading"
                @click="handleClose"
              >
                Cancel
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

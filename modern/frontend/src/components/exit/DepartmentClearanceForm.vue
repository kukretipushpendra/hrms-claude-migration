<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import { useSnackbar } from '@/composables/useSnackbar';
import { getDepartmentClearance, upsertDepartmentClearance } from '@/services/exit/exit.service';
import { KTStatus, KT_STATUS_LABELS } from '@/types/exit.types';
import type { UpsertDepartmentClearanceRequest } from '@/types/exit.types';

interface Props {
  resignationId: number;
  employeeId: number;
  canEdit: boolean;
}

const props = defineProps<Props>();
const { showSuccess, showError } = useSnackbar();

// State
const loading = ref(false);
const submitting = ref(false);
const attachmentFile = ref<File | null>(null);
const existingAttachment = ref<string | null>(null);

// KT Status options
const ktStatusOptions = [
  { value: KTStatus.pending, title: KT_STATUS_LABELS[KTStatus.pending] },
  { value: KTStatus.inProgress, title: KT_STATUS_LABELS[KTStatus.inProgress] },
  { value: KTStatus.completed, title: KT_STATUS_LABELS[KTStatus.completed] },
];

// Validation schema
const schema = toTypedSchema(
  z.object({
    ktStatus: z.number(),
    ktNotes: z.string(),
    ktUsers: z.array(z.number()).default([]),
  })
);

const { defineField, handleSubmit, errors, setValues, resetForm } = useForm({
  validationSchema: schema,
  initialValues: {
    ktStatus: KTStatus.pending,
    ktNotes: '',
    ktUsers: [],
  },
});

const [ktStatus, ktStatusAttrs] = defineField('ktStatus');
const [ktNotes, ktNotesAttrs] = defineField('ktNotes');
const [ktUsers, ktUsersAttrs] = defineField('ktUsers');

// Fetch clearance data
const fetchClearance = async () => {
  try {
    loading.value = true;
    const response = await getDepartmentClearance(props.resignationId);

    if (response.result) {
      const data = response.result;
      setValues({
        ktStatus: data.ktStatus,
        ktNotes: data.ktNotes,
        ktUsers: data.ktUsers,
      });
      existingAttachment.value = data.attachment;
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    showError(err.response?.data?.message || 'Failed to fetch department clearance');
  } finally {
    loading.value = false;
  }
};

// Handle file selection
const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    attachmentFile.value = target.files[0];
  }
};

// Submit form
const onSubmit = handleSubmit(async (values) => {
  try {
    submitting.value = true;

    const request: UpsertDepartmentClearanceRequest = {
      employeeId: props.employeeId,
      resignationId: props.resignationId,
      ktStatus: values.ktStatus,
      ktNotes: values.ktNotes,
      ktUsers: values.ktUsers,
      attachment: attachmentFile.value || existingAttachment.value,
    };

    const response = await upsertDepartmentClearance(request);
    showSuccess(response.message || 'Department clearance saved successfully');
    await fetchClearance();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    showError(err.response?.data?.message || 'Failed to save department clearance');
  } finally {
    submitting.value = false;
  }
});

// Reset form
const handleReset = () => {
  resetForm();
  attachmentFile.value = null;
  fetchClearance();
};

// Watch for resignationId changes
watch(
  () => props.resignationId,
  () => {
    fetchClearance();
  }
);

onMounted(() => {
  fetchClearance();
});
</script>

<template>
  <div>
    <v-progress-linear v-if="loading" indeterminate color="primary" />

    <form v-else @submit.prevent="onSubmit">
      <v-row>
        <!-- KT Status -->
        <v-col cols="12" md="6">
          <v-select
            v-model="ktStatus"
            v-bind="ktStatusAttrs"
            label="KT Status"
            :items="ktStatusOptions"
            variant="outlined"
            :readonly="!canEdit"
            :error-messages="errors.ktStatus"
          />
        </v-col>

        <!-- KT Users (Multi-select) -->
        <v-col cols="12" md="6">
          <v-combobox
            v-model="ktUsers"
            v-bind="ktUsersAttrs"
            label="KT Users"
            multiple
            chips
            closable-chips
            variant="outlined"
            :readonly="!canEdit"
            :error-messages="errors.ktUsers"
            hint="Enter employee IDs and press Enter"
            persistent-hint
          />
        </v-col>

        <!-- KT Notes -->
        <v-col cols="12">
          <v-textarea
            v-model="ktNotes"
            v-bind="ktNotesAttrs"
            label="KT Notes"
            variant="outlined"
            rows="4"
            :readonly="!canEdit"
            :error-messages="errors.ktNotes"
          />
        </v-col>

        <!-- File Upload -->
        <v-col cols="12">
          <v-file-input
            label="Attachment"
            variant="outlined"
            :readonly="!canEdit"
            @change="handleFileChange"
          />
          <div v-if="existingAttachment" class="text-caption mt-1">
            Current file: {{ existingAttachment }}
          </div>
        </v-col>
      </v-row>

      <!-- Action Buttons -->
      <v-row v-if="canEdit" class="mt-4">
        <v-col>
          <v-btn type="submit" color="primary" :loading="submitting" :disabled="submitting">
            Save Department Clearance
          </v-btn>
          <v-btn
            type="button"
            color="secondary"
            variant="outlined"
            class="ml-2"
            @click="handleReset"
          >
            Reset
          </v-btn>
        </v-col>
      </v-row>
    </form>
  </div>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import { useSnackbar } from '@/composables/useSnackbar';
import { getAccountClearance, upsertAccountClearance } from '@/services/exit/exit.service';
import type { UpsertAccountClearanceRequest } from '@/types/exit.types';

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

// Validation schema
const schema = toTypedSchema(
  z
    .object({
      fnFStatus: z.boolean(),
      fnFAmount: z.number().nullable(),
      issueNoDueCertificate: z.boolean(),
      note: z.string(),
    })
    .superRefine((val, ctx) => {
      if (val.fnFStatus && (val.fnFAmount === null || val.fnFAmount === undefined)) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: 'F&F amount is required when F&F status is checked',
          path: ['fnFAmount'],
        });
      }
    })
);

const { defineField, handleSubmit, errors, setValues, resetForm, values } = useForm({
  validationSchema: schema,
  initialValues: {
    fnFStatus: false,
    fnFAmount: null as number | null,
    issueNoDueCertificate: false,
    note: '',
  },
});

const [fnFStatus, fnFStatusAttrs] = defineField('fnFStatus');
const [fnFAmount, fnFAmountAttrs] = defineField('fnFAmount');
const [issueNoDueCertificate, issueNoDueCertificateAttrs] = defineField('issueNoDueCertificate');
const [note, noteAttrs] = defineField('note');

// Computed
const isFnFAmountRequired = computed(() => values.fnFStatus);

// Fetch clearance data
const fetchClearance = async () => {
  try {
    loading.value = true;
    const response = await getAccountClearance(props.resignationId);

    if (response.result) {
      const data = response.result;
      setValues({
        fnFStatus: data.fnFStatus,
        fnFAmount: data.fnFAmount,
        issueNoDueCertificate: data.issueNoDueCertificate,
        note: data.note,
      });
      existingAttachment.value = data.accountAttachment;
    }
  } catch (error: unknown) {
    showError(error.response?.data?.message || 'Failed to fetch account clearance');
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
const onSubmit = handleSubmit(async (formValues) => {
  try {
    submitting.value = true;

    const request: UpsertAccountClearanceRequest = {
      employeeId: props.employeeId,
      resignationId: props.resignationId,
      fnFStatus: formValues.fnFStatus,
      fnFAmount: formValues.fnFAmount,
      issueNoDueCertificate: formValues.issueNoDueCertificate,
      note: formValues.note,
      accountAttachment: attachmentFile.value || existingAttachment.value,
    };

    const response = await upsertAccountClearance(request);
    showSuccess(response.message || 'Account clearance saved successfully');
    await fetchClearance();
  } catch (error: unknown) {
    showError(error.response?.data?.message || 'Failed to save account clearance');
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
        <!-- F&F Status -->
        <v-col cols="12">
          <v-checkbox
            v-model="fnFStatus"
            v-bind="fnFStatusAttrs"
            label="F&F Status"
            :readonly="!canEdit"
          />
        </v-col>

        <!-- F&F Amount -->
        <v-col v-if="fnFStatus" cols="12" md="6">
          <v-text-field
            v-model.number="fnFAmount"
            v-bind="fnFAmountAttrs"
            label="F&F Amount"
            type="number"
            variant="outlined"
            :readonly="!canEdit"
            :error-messages="errors.fnFAmount"
            :required="isFnFAmountRequired"
          />
        </v-col>

        <!-- Issue No-Due Certificate -->
        <v-col cols="12">
          <v-checkbox
            v-model="issueNoDueCertificate"
            v-bind="issueNoDueCertificateAttrs"
            label="Issue No-Due Certificate"
            :readonly="!canEdit"
          />
        </v-col>

        <!-- Note -->
        <v-col cols="12">
          <v-textarea
            v-model="note"
            v-bind="noteAttrs"
            label="Note"
            variant="outlined"
            rows="3"
            :readonly="!canEdit"
            :error-messages="errors.note"
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
            Save Account Clearance
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

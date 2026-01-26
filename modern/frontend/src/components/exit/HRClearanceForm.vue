<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import { useSnackbar } from '@/composables/useSnackbar';
import { getHRClearance, upsertHRClearance } from '@/services/exit/exit.service';
import type { UpsertHRClearanceRequest } from '@/types/exit.types';

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
      advanceBonusRecoveryAmount: z.number().min(0, 'Amount must be non-negative'),
      serviceAgreementDetails: z.string(),
      currentEL: z.number().min(0, 'Current EL must be non-negative'),
      numberOfBuyOutDays: z.number().min(0, 'Buy-out days must be non-negative'),
      exitInterviewStatus: z.boolean(),
      exitInterviewDetails: z.string(),
    })
    .superRefine((val, ctx) => {
      if (val.exitInterviewStatus && !val.exitInterviewDetails.trim()) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: 'Exit interview details are required when status is completed',
          path: ['exitInterviewDetails'],
        });
      }
    })
);

const { defineField, handleSubmit, errors, setValues, resetForm } = useForm({
  validationSchema: schema,
  initialValues: {
    advanceBonusRecoveryAmount: 0,
    serviceAgreementDetails: '',
    currentEL: 0,
    numberOfBuyOutDays: 0,
    exitInterviewStatus: false,
    exitInterviewDetails: '',
  },
});

const [advanceBonusRecoveryAmount, advanceBonusRecoveryAmountAttrs] = defineField(
  'advanceBonusRecoveryAmount'
);
const [serviceAgreementDetails, serviceAgreementDetailsAttrs] =
  defineField('serviceAgreementDetails');
const [currentEL, currentELAttrs] = defineField('currentEL');
const [numberOfBuyOutDays, numberOfBuyOutDaysAttrs] = defineField('numberOfBuyOutDays');
const [exitInterviewStatus, exitInterviewStatusAttrs] = defineField('exitInterviewStatus');
const [exitInterviewDetails, exitInterviewDetailsAttrs] = defineField('exitInterviewDetails');

// Fetch clearance data
const fetchClearance = async () => {
  try {
    loading.value = true;
    const response = await getHRClearance(props.resignationId);

    if (response.result) {
      const data = response.result;
      setValues({
        advanceBonusRecoveryAmount: data.advanceBonusRecoveryAmount,
        serviceAgreementDetails: data.serviceAgreementDetails,
        currentEL: data.currentEL,
        numberOfBuyOutDays: data.numberOfBuyOutDays,
        exitInterviewStatus: data.exitInterviewStatus,
        exitInterviewDetails: data.exitInterviewDetails,
      });
      existingAttachment.value = data.attachment;
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    showError(err.response?.data?.message || 'Failed to fetch HR clearance');
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

    const request: UpsertHRClearanceRequest = {
      employeeId: props.employeeId,
      resignationId: props.resignationId,
      advanceBonusRecoveryAmount: values.advanceBonusRecoveryAmount,
      serviceAgreementDetails: values.serviceAgreementDetails,
      currentEL: values.currentEL,
      numberOfBuyOutDays: values.numberOfBuyOutDays,
      attachment: attachmentFile.value || existingAttachment.value,
      exitInterviewStatus: values.exitInterviewStatus,
      exitInterviewDetails: values.exitInterviewDetails,
    };

    const response = await upsertHRClearance(request);
    showSuccess(response.message || 'HR clearance saved successfully');
    await fetchClearance();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    showError(err.response?.data?.message || 'Failed to save HR clearance');
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
        <!-- Advance Bonus Recovery Amount -->
        <v-col cols="12" md="6">
          <v-text-field
            v-model.number="advanceBonusRecoveryAmount"
            v-bind="advanceBonusRecoveryAmountAttrs"
            label="Advance Bonus Recovery Amount"
            type="number"
            variant="outlined"
            :readonly="!canEdit"
            :error-messages="errors.advanceBonusRecoveryAmount"
          />
        </v-col>

        <!-- Current EL -->
        <v-col cols="12" md="6">
          <v-text-field
            v-model.number="currentEL"
            v-bind="currentELAttrs"
            label="Current EL (Days)"
            type="number"
            variant="outlined"
            :readonly="!canEdit"
            :error-messages="errors.currentEL"
          />
        </v-col>

        <!-- Number of Buy-Out Days -->
        <v-col cols="12" md="6">
          <v-text-field
            v-model.number="numberOfBuyOutDays"
            v-bind="numberOfBuyOutDaysAttrs"
            label="Number of Buy-Out Days"
            type="number"
            variant="outlined"
            :readonly="!canEdit"
            :error-messages="errors.numberOfBuyOutDays"
          />
        </v-col>

        <!-- Service Agreement Details -->
        <v-col cols="12">
          <v-textarea
            v-model="serviceAgreementDetails"
            v-bind="serviceAgreementDetailsAttrs"
            label="Service Agreement Details"
            variant="outlined"
            rows="3"
            :readonly="!canEdit"
            :error-messages="errors.serviceAgreementDetails"
          />
        </v-col>

        <!-- Exit Interview Status -->
        <v-col cols="12">
          <v-checkbox
            v-model="exitInterviewStatus"
            v-bind="exitInterviewStatusAttrs"
            label="Exit Interview Completed"
            :readonly="!canEdit"
          />
        </v-col>

        <!-- Exit Interview Details -->
        <v-col v-if="exitInterviewStatus" cols="12">
          <v-textarea
            v-model="exitInterviewDetails"
            v-bind="exitInterviewDetailsAttrs"
            label="Exit Interview Details"
            variant="outlined"
            rows="4"
            :readonly="!canEdit"
            :error-messages="errors.exitInterviewDetails"
            required
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
            Save HR Clearance
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

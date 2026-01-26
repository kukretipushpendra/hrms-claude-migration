<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import { useSnackbar } from '@/composables/useSnackbar';
import { getITClearance, upsertITClearance } from '@/services/exit/exit.service';
import {
  AssetCondition,
  ASSET_CONDITION_LABELS,
  type UpsertITClearanceRequest,
} from '@/types/exit.types';

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

// Asset condition options
const assetConditionOptions = [
  { value: AssetCondition.ok, title: ASSET_CONDITION_LABELS[AssetCondition.ok] },
  { value: AssetCondition.damage, title: ASSET_CONDITION_LABELS[AssetCondition.damage] },
  { value: AssetCondition.missing, title: ASSET_CONDITION_LABELS[AssetCondition.missing] },
];

// Validation schema
const schema = toTypedSchema(
  z
    .object({
      accessRevoked: z.boolean(),
      assetReturned: z.boolean(),
      assetCondition: z.number(),
      note: z.string(),
      itClearanceCertification: z.boolean(),
    })
    .refine(
      (data) => {
        // If condition is damaged or faulty, note is required
        if (
          data.assetCondition === AssetCondition.damage ||
          data.assetCondition === AssetCondition.missing
        ) {
          return data.note && data.note.trim().length > 0;
        }
        return true;
      },
      {
        message: 'Note is required when asset condition is damaged or faulty',
        path: ['note'],
      }
    )
);

const { defineField, handleSubmit, errors, setValues, resetForm, values } = useForm({
  validationSchema: schema,
  initialValues: {
    accessRevoked: false,
    assetReturned: false,
    assetCondition: AssetCondition.ok,
    note: '',
    itClearanceCertification: false,
  },
});

const [accessRevoked, accessRevokedAttrs] = defineField('accessRevoked');
const [assetReturned, assetReturnedAttrs] = defineField('assetReturned');
const [assetCondition, assetConditionAttrs] = defineField('assetCondition');
const [note, noteAttrs] = defineField('note');
const [itClearanceCertification, itClearanceCertificationAttrs] = defineField(
  'itClearanceCertification'
);

// Computed
const isNoteRequired = computed(() => {
  return (
    values.assetCondition === AssetCondition.damage ||
    values.assetCondition === AssetCondition.missing
  );
});

// Fetch clearance data
const fetchClearance = async () => {
  try {
    loading.value = true;
    const response = await getITClearance(props.resignationId);

    if (response.result) {
      const data = response.result;
      setValues({
        accessRevoked: data.accessRevoked,
        assetReturned: data.assetReturned,
        assetCondition: data.assetCondition,
        note: data.note,
        itClearanceCertification: data.itClearanceCertification,
      });
      existingAttachment.value = data.attachmentUrl;
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    showError(err.response?.data?.message || 'Failed to fetch IT clearance');
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

    const request: UpsertITClearanceRequest = {
      employeeId: props.employeeId,
      resignationId: props.resignationId,
      accessRevoked: formValues.accessRevoked,
      assetReturned: formValues.assetReturned,
      assetCondition: formValues.assetCondition,
      note: formValues.note,
      itClearanceCertification: formValues.itClearanceCertification,
      attachmentUrl: attachmentFile.value || existingAttachment.value,
    };

    const response = await upsertITClearance(request);
    showSuccess(response.message || 'IT clearance saved successfully');
    await fetchClearance();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    showError(err.response?.data?.message || 'Failed to save IT clearance');
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
        <!-- Access Revoked -->
        <v-col cols="12" md="6">
          <v-checkbox
            v-model="accessRevoked"
            v-bind="accessRevokedAttrs"
            label="Access Revoked"
            :readonly="!canEdit"
          />
        </v-col>

        <!-- Asset Returned -->
        <v-col cols="12" md="6">
          <v-checkbox
            v-model="assetReturned"
            v-bind="assetReturnedAttrs"
            label="Asset Returned"
            :readonly="!canEdit"
          />
        </v-col>

        <!-- Asset Condition -->
        <v-col cols="12" md="6">
          <v-select
            v-model="assetCondition"
            v-bind="assetConditionAttrs"
            label="Asset Condition"
            :items="assetConditionOptions"
            variant="outlined"
            :readonly="!canEdit"
            :error-messages="errors.assetCondition"
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
            :required="isNoteRequired"
            :hint="isNoteRequired ? 'Note is required for damaged or faulty assets' : ''"
            persistent-hint
          />
        </v-col>

        <!-- IT Clearance Certification -->
        <v-col cols="12">
          <v-checkbox
            v-model="itClearanceCertification"
            v-bind="itClearanceCertificationAttrs"
            label="IT Clearance Certification"
            :readonly="!canEdit"
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
            Save IT Clearance
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

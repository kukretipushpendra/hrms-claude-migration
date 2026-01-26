<template>
  <v-card flat class="response-composer-card">
    <v-card-title class="bg-grey-lighten-4">Add Response</v-card-title>
    <v-card-text>
      <v-form ref="formRef" @submit.prevent="handleSubmit">
        <v-textarea
          v-model="remarks"
          label="Remarks"
          variant="outlined"
          rows="4"
          :error-messages="remarksError"
          required
          counter="2000"
          maxlength="2000"
        />

        <v-file-input
          v-model="attachment"
          label="Attachment (optional)"
          variant="outlined"
          prepend-icon=""
          prepend-inner-icon="mdi-paperclip"
          :error-messages="attachmentError"
          clearable
          show-size
          accept="*/*"
        />

        <v-row class="mt-2">
          <v-col cols="12" class="d-flex justify-end gap-2">
            <v-btn
              color="warning"
              variant="outlined"
              prepend-icon="mdi-trending-up"
              :disabled="loading || cannotEscalate"
              @click="handleEscalate"
            >
              Escalate
            </v-btn>
            <v-btn
              color="success"
              variant="outlined"
              prepend-icon="mdi-check-circle"
              :disabled="loading"
              @click="handleResolve"
            >
              Resolve
            </v-btn>
            <v-btn color="primary" prepend-icon="mdi-send" type="submit" :loading="loading">
              Add Remark
            </v-btn>
          </v-col>
        </v-row>
      </v-form>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { GrievanceStatus, GrievanceLevel } from '@/types/grievance.types';
import type { GrievanceLevelType, GrievanceStatusType } from '@/types/grievance.types';
import { validateFile } from '@/utils/grievance.utils';

interface Props {
  level: GrievanceLevelType;
  loading?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
});

const emit = defineEmits<{
  (
    e: 'submit',
    payload: { remarks: string; status?: GrievanceStatusType; attachment?: File }
  ): void;
}>();

const remarks = ref('');
const attachment = ref<File[] | null>(null);
const remarksError = ref('');
const attachmentError = ref('');

const cannotEscalate = computed(() => {
  return props.level >= GrievanceLevel.L3;
});

const validateForm = (): boolean => {
  remarksError.value = '';
  attachmentError.value = '';

  if (!remarks.value.trim()) {
    remarksError.value = 'Remarks are required';
    return false;
  }

  if (remarks.value.length > 2000) {
    remarksError.value = 'Remarks must not exceed 2000 characters';
    return false;
  }

  // Validate file if attached
  const file = attachment.value && attachment.value.length > 0 ? attachment.value[0] : null;
  if (file) {
    const validation = validateFile(file, 5);
    if (!validation.valid) {
      attachmentError.value = validation.error || 'Invalid file';
      return false;
    }
  }

  return true;
};

const handleSubmit = () => {
  if (!validateForm()) {
    return;
  }

  const file = attachment.value && attachment.value.length > 0 ? attachment.value[0] : undefined;

  emit('submit', {
    remarks: remarks.value,
    attachment: file,
  });

  resetForm();
};

const handleEscalate = () => {
  if (!validateForm()) {
    return;
  }

  const file = attachment.value && attachment.value.length > 0 ? attachment.value[0] : undefined;

  emit('submit', {
    remarks: remarks.value,
    status: GrievanceStatus.Escalated,
    attachment: file,
  });

  resetForm();
};

const handleResolve = () => {
  if (!validateForm()) {
    return;
  }

  const file = attachment.value && attachment.value.length > 0 ? attachment.value[0] : undefined;

  emit('submit', {
    remarks: remarks.value,
    status: GrievanceStatus.Resolved,
    attachment: file,
  });

  resetForm();
};

const resetForm = () => {
  remarks.value = '';
  attachment.value = null;
  remarksError.value = '';
  attachmentError.value = '';
};
</script>

<style scoped>
.response-composer-card {
  border: 1px solid rgba(0, 0, 0, 0.12);
  margin-top: 16px;
}

.gap-2 {
  gap: 8px;
}
</style>

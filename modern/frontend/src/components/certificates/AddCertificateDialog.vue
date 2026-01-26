<template>
  <v-dialog
    :model-value="modelValue"
    max-width="600"
    persistent
    @update:model-value="$emit('update:modelValue', $event)"
  >
    <v-card>
      <v-card-title class="d-flex align-center justify-space-between pa-4">
        <h2 class="text-h5">{{ certificateId ? 'Edit' : 'Add' }} Certificate</h2>
        <v-btn icon variant="text" @click="handleClose">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>

      <v-divider></v-divider>

      <!-- Loading State -->
      <div
        v-if="isLoadingCertificate"
        class="d-flex justify-center align-center pa-10"
        style="min-height: 300px"
      >
        <v-progress-circular indeterminate size="64"></v-progress-circular>
      </div>

      <!-- Form -->
      <v-card-text v-else class="pa-6">
        <v-form ref="formRef" @submit.prevent="handleSubmit">
          <v-row>
            <v-col cols="12" md="6">
              <v-text-field
                v-model="formData.certificateName"
                label="Certificate Name"
                :rules="certificateNameRules"
                :error-messages="formErrors.certificateName"
                required
                density="comfortable"
                variant="outlined"
              ></v-text-field>
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="formData.certificateExpiry"
                label="Expiry Date"
                type="date"
                :rules="expiryDateRules"
                :error-messages="formErrors.certificateExpiry"
                :min="minDate"
                density="comfortable"
                variant="outlined"
              ></v-text-field>
            </v-col>

            <v-col cols="12">
              <div class="d-flex align-center gap-3">
                <v-file-input
                  v-model="formData.file"
                  label="Upload Certificate"
                  :rules="fileRules"
                  :error-messages="formErrors.file"
                  accept=".pdf,.jpg,.jpeg,.png,.doc,.docx"
                  prepend-icon="mdi-file-upload"
                  density="comfortable"
                  variant="outlined"
                  show-size
                  clearable
                ></v-file-input>

                <!-- View existing file for edit mode -->
                <v-tooltip
                  v-if="certificateId && certificateData?.fileName"
                  text="View Current Document"
                  location="bottom"
                >
                  <template #activator="{ props }">
                    <v-btn
                      v-bind="props"
                      icon
                      variant="text"
                      color="primary"
                      @click="handleViewExistingDocument"
                    >
                      <v-icon>mdi-eye</v-icon>
                    </v-btn>
                  </template>
                </v-tooltip>
              </div>
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>

      <v-divider></v-divider>

      <v-card-actions class="pa-4">
        <v-spacer></v-spacer>
        <v-btn text @click="handleReset">Reset</v-btn>
        <v-btn color="primary" :loading="isSaving" @click="handleSubmit">
          {{ certificateId ? 'Update' : 'Save' }}
        </v-btn>
      </v-card-actions>
    </v-card>

    <!-- Preview existing document dialog -->
    <v-dialog v-model="previewExistingOpen" max-width="900px">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center">
          <span>Current Certificate Document</span>
          <v-btn icon variant="text" @click="previewExistingOpen = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <iframe
            v-if="existingByteArray"
            :src="`data:application/pdf;base64,${existingByteArray}`"
            width="100%"
            height="600px"
            style="border: none"
          ></iframe>
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import { useAuthStore } from '@/stores/auth.store';
import { useSnackbar } from '@/composables/useSnackbar';
import { certificateService, type Certificate } from '@/services/certificates';
import moment from 'moment';

interface Props {
  modelValue: boolean;
  certificateId: number;
  existingCertificates: string[];
  currentCertificate: string;
  employeeId?: number;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  certificateId: 0,
  existingCertificates: () => [],
  currentCertificate: '',
  employeeId: 0,
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'close'): void;
  (e: 'success'): void;
}>();

const authStore = useAuthStore();
const { showSuccess, showError } = useSnackbar();

// Form data
const formRef = ref();
const formData = ref({
  certificateName: '',
  certificateExpiry: '',
  file: [] as File[],
});

const formErrors = ref({
  certificateName: [],
  certificateExpiry: [],
  file: [],
});

// Loading states
const isLoadingCertificate = ref(false);
const isSaving = ref(false);

// Certificate data
const certificateData = ref<Certificate | null>(null);

// Preview
const previewExistingOpen = ref(false);
const existingByteArray = ref('');

// Computed
const minDate = computed(() => moment().format('YYYY-MM-DD'));

const effectiveEmployeeId = computed(() => {
  return props.employeeId || Number(authStore.user?.id || 0);
});

// Validation rules
const certificateNameRules = computed(() => [
  (v: string) => !!v || 'Certificate name is required.',
  (v: string) => {
    if (!v) return true;
    // Not only numbers
    if (/^\d+$/.test(v)) return 'Certificate name cannot contain only numbers.';
    return true;
  },
  (v: string) => {
    if (!v) return true;
    // At least 2 characters
    if (v.length < 2) return 'Certificate name must have at least 2 characters.';
    return true;
  },
  (v: string) => {
    if (!v) return true;
    // Max 50 characters
    if (v.length > 50) return 'Certificate name must not exceed 50 characters.';
    return true;
  },
  (v: string) => {
    if (!v) return true;
    // Check uniqueness
    if (v === props.currentCertificate) return true;
    if (props.existingCertificates.includes(v)) {
      return 'This certificate already exists';
    }
    return true;
  },
]);

const expiryDateRules = computed(() => [
  (v: string) => {
    if (!v) return true; // Optional field
    // Check if date is in the past
    const selectedDate = moment(v, 'YYYY-MM-DD');
    if (selectedDate.isBefore(moment(), 'day')) {
      return 'Expiry date cannot be in the past';
    }
    return true;
  },
]);

const fileRules = computed(() => [
  (v: File[]) => {
    // File is required only when adding new certificate
    if (!props.certificateId && (!v || v.length === 0)) {
      return 'File is required';
    }
    return true;
  },
  (v: File[]) => {
    if (!v || v.length === 0) return true;
    const file = v[0];
    // Max 5MB
    if (file.size > 5 * 1024 * 1024) {
      return 'File size must not exceed 5MB';
    }
    return true;
  },
]);

// Methods
const loadCertificateData = async () => {
  if (!props.certificateId) return;

  isLoadingCertificate.value = true;
  try {
    const response = await certificateService.getCertificateById(props.certificateId);
    certificateData.value = response.result;

    // Populate form
    formData.value.certificateName = certificateData.value.certificateName;
    formData.value.certificateExpiry = certificateData.value.certificateExpiry
      ? moment(certificateData.value.certificateExpiry, 'YYYY-MM-DD').format('YYYY-MM-DD')
      : '';
    formData.value.file = [];
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to load certificate');
  } finally {
    isLoadingCertificate.value = false;
  }
};

const handleSubmit = async () => {
  // Validate form
  const { valid } = await formRef.value.validate();
  if (!valid) return;

  isSaving.value = true;
  try {
    const file =
      formData.value.file && formData.value.file.length > 0 ? formData.value.file[0] : null;

    if (props.certificateId) {
      // Update
      await certificateService.updateCertificate({
        Id: props.certificateId,
        EmployeeId: effectiveEmployeeId.value,
        CertificateName: formData.value.certificateName,
        CertificateExpiry: formData.value.certificateExpiry || '',
        File: file || '',
      });
      showSuccess('Certificate updated successfully');
    } else {
      // Create
      await certificateService.addCertificate({
        EmployeeId: effectiveEmployeeId.value,
        CertificateName: formData.value.certificateName,
        CertificateExpiry: formData.value.certificateExpiry || '',
        File: file,
      });
      showSuccess('Certificate added successfully');
    }

    emit('success');
    emit('close');
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to save certificate');
  } finally {
    isSaving.value = false;
  }
};

const handleReset = () => {
  if (props.certificateId && certificateData.value) {
    // Reset to original values
    formData.value.certificateName = certificateData.value.certificateName;
    formData.value.certificateExpiry = certificateData.value.certificateExpiry
      ? moment(certificateData.value.certificateExpiry, 'YYYY-MM-DD').format('YYYY-MM-DD')
      : '';
    formData.value.file = [];
  } else {
    // Reset to empty
    formData.value.certificateName = '';
    formData.value.certificateExpiry = '';
    formData.value.file = [];
  }
  formRef.value?.resetValidation();
};

const handleClose = () => {
  emit('update:modelValue', false);
  emit('close');
};

const handleViewExistingDocument = async () => {
  if (!certificateData.value?.fileName) return;

  try {
    const response = await certificateService.downloadCertificateDocument(
      certificateData.value.fileName
    );
    existingByteArray.value = response.result;
    previewExistingOpen.value = true;
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to preview document');
  }
};

// Watchers
watch(
  () => props.modelValue,
  (isOpen) => {
    if (isOpen) {
      if (props.certificateId) {
        loadCertificateData();
      } else {
        // Reset form for new certificate
        formData.value.certificateName = '';
        formData.value.certificateExpiry = '';
        formData.value.file = [];
        formRef.value?.resetValidation();
      }
    }
  }
);
</script>

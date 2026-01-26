<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import { useForm, useField } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import DocumentTypeSelect from './DocumentTypeSelect.vue';
import ViewDocumentButton from './ViewDocumentButton.vue';
import { documentService } from '@/services/document/document.service';
import { PERSONAL_DETAIL_DOCUMENT_TYPES } from '@/types/document.types';
import type { GovtDocumentType, UserDocument } from '@/types/document.types';

interface Props {
  open: boolean;
  userDocumentId: number;
  existingDocTypes: number[];
  currentDocType: number | null;
  employeeId: number;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'close'): void;
  (e: 'saved'): void;
}>();

// State
const loading = ref(false);
const saving = ref(false);
const selectedDocumentType = ref<GovtDocumentType | null>(null);
const documentData = ref<UserDocument | null>(null);

// Is edit mode
const isEditMode = computed(() => props.userDocumentId > 0);

// Validation schema
const getValidationSchema = (isFileRequired: boolean, isExpiryRequired: boolean) => {
  return toTypedSchema(
    z.object({
      documentTypeId: z
        .number({ required_error: 'Document Type is required' })
        .min(1, 'Document Type is required'),
      documentNumber: z
        .string({ required_error: 'Document Number is required' })
        .min(1, 'Document Number is required')
        .superRefine((val, ctx) => {
          if (!selectedDocumentType.value) return;

          const typeId = selectedDocumentType.value.id;

          // PAN Card validation
          if (typeId === PERSONAL_DETAIL_DOCUMENT_TYPES.PAN_NUMBER) {
            const panRegex = /^[A-Z]{5}[0-9]{4}[A-Z]{1}$/;
            if (!panRegex.test(val)) {
              ctx.addIssue({
                code: z.ZodIssueCode.custom,
                message:
                  'PAN Card must have 5 uppercase letters, 4 digits, and 1 uppercase letter (e.g., ABCDE1234F).',
              });
            }
          }

          // Aadhar Card validation
          if (typeId === PERSONAL_DETAIL_DOCUMENT_TYPES.AADHAR_NUMBER) {
            if (val.length > 20) {
              ctx.addIssue({
                code: z.ZodIssueCode.custom,
                message: 'Aadhar Card number must not exceed 20 characters',
              });
            }
          }

          // Passport, Voter Card, Driving License validation
          if (
            typeId === PERSONAL_DETAIL_DOCUMENT_TYPES.PASSPORT_NUMBER ||
            typeId === PERSONAL_DETAIL_DOCUMENT_TYPES.VOTER_CARD_NUMBER ||
            typeId === PERSONAL_DETAIL_DOCUMENT_TYPES.DRIVING_LICENSE_NUMBER
          ) {
            if (val.length > 20) {
              ctx.addIssue({
                code: z.ZodIssueCode.custom,
                message: 'Document number must not exceed 20 characters',
              });
            }
            if (/^\d+$/.test(val)) {
              ctx.addIssue({
                code: z.ZodIssueCode.custom,
                message: 'Document number cannot contain only numbers',
              });
            }
          }
        }),
      documentExpiry: isExpiryRequired
        ? z
            .string({ required_error: 'Document Expiry Date is required' })
            .min(1, 'Document Expiry Date is required')
            .refine(
              (val) => {
                const date = new Date(val);
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                return date > today;
              },
              { message: 'Expiry date cannot be in the past' }
            )
        : z.string().optional(),
      file: isFileRequired
        ? z
            .instanceof(File, { message: 'File is required' })
            .refine((file) => file.size > 0, 'File is required')
            .refine(
              (file) => {
                const allowedTypes = ['application/pdf', 'image/jpeg', 'image/jpg', 'image/png'];
                return allowedTypes.includes(file.type);
              },
              { message: 'Only PDF, JPG, JPEG, PNG files are allowed' }
            )
            .refine((file) => file.name.length <= 100, 'File name must not exceed 100 characters')
        : z.instanceof(File).optional().nullable(),
    })
  );
};

// Form setup
const { handleSubmit, resetForm, setValues } = useForm({
  validationSchema: getValidationSchema(
    !isEditMode.value || !documentData.value?.location,
    selectedDocumentType.value?.isExpiryDateRequired || false
  ),
});

// Form fields
const { value: documentNumber, errorMessage: documentNumberError } =
  useField<string>('documentNumber');
const { value: documentExpiry, errorMessage: documentExpiryError } =
  useField<string>('documentExpiry');
const { value: file, errorMessage: fileError } = useField<File | null>('file');

// Load document data for edit mode
const loadDocumentData = async () => {
  if (!isEditMode.value) return;

  try {
    loading.value = true;
    const data = await documentService.getUserDocumentById(props.userDocumentId);
    documentData.value = data;

    // Set form values
    setValues({
      documentTypeId: data.documentTypeId,
      documentNumber: data.documentNumber,
      documentExpiry: data.documentExpiry || '',
      file: null,
    });
  } catch (error) {
    console.error('Error loading document:', error);
    alert('Failed to load document data');
  } finally {
    loading.value = false;
  }
};

// Watch dialog open
watch(
  () => props.open,
  (isOpen) => {
    if (isOpen) {
      if (isEditMode.value) {
        loadDocumentData();
      } else {
        resetForm();
        documentData.value = null;
      }
    }
  }
);

// Submit handler
const onSubmit = handleSubmit(async (values) => {
  try {
    saving.value = true;

    if (isEditMode.value) {
      // Update
      await documentService.updateUserDocument({
        Id: props.userDocumentId,
        EmployeeId: props.employeeId,
        DocumentTypeId: values.documentTypeId,
        DocumentNumber: values.documentNumber,
        DocumentExpiry: values.documentExpiry || '',
        File: values.file || '',
      });
    } else {
      // Create
      await documentService.uploadUserDocument({
        EmployeeId: props.employeeId,
        DocumentTypeId: values.documentTypeId,
        DocumentNumber: values.documentNumber,
        DocumentExpiry: values.documentExpiry || '',
        File: values.file,
      });
    }

    emit('saved');
    handleClose();
  } catch (error) {
    console.error('Error saving document:', error);
    alert('Failed to save document. Please try again.');
  } finally {
    saving.value = false;
  }
});

// Close handler
const handleClose = () => {
  if (!saving.value) {
    emit('close');
  }
};

// Reset handler
const handleReset = () => {
  if (isEditMode.value && documentData.value) {
    setValues({
      documentTypeId: documentData.value.documentTypeId,
      documentNumber: documentData.value.documentNumber,
      documentExpiry: documentData.value.documentExpiry || '',
      file: null,
    });
  } else {
    resetForm();
  }
};

// File change handler
const handleFileChange = (files: File[] | undefined) => {
  const selectedFile = files && files.length > 0 ? files[0] : null;
  file.value = selectedFile;
};
</script>

<template>
  <v-dialog :model-value="open" max-width="600px" persistent @update:model-value="handleClose">
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <span>{{ isEditMode ? 'Edit User Document' : 'Add User Document' }}</span>
        <v-btn icon variant="text" :disabled="saving" @click="handleClose">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>

      <v-card-text>
        <v-progress-circular
          v-if="loading"
          indeterminate
          color="primary"
          class="mx-auto d-block my-4"
        />

        <form v-else @submit.prevent="onSubmit">
          <v-row>
            <v-col cols="12">
              <DocumentTypeSelect
                name="documentTypeId"
                :required="true"
                :disabled="saving"
                :existing-doc-types="existingDocTypes"
                :current-doc-type="currentDocType"
                @update:selected-type="selectedDocumentType = $event"
              />
            </v-col>

            <v-col cols="12">
              <v-text-field
                v-model="documentNumber"
                label="Document Number"
                variant="outlined"
                density="comfortable"
                :required="true"
                :disabled="saving"
                :error-messages="documentNumberError"
              />
            </v-col>

            <v-col v-if="selectedDocumentType?.isExpiryDateRequired" cols="12">
              <v-text-field
                v-model="documentExpiry"
                label="Document Expiry"
                type="date"
                variant="outlined"
                density="comfortable"
                :required="true"
                :disabled="saving"
                :error-messages="documentExpiryError"
              />
            </v-col>

            <v-col cols="12">
              <div class="file-upload-section">
                <v-file-input
                  :model-value="file ? [file] : []"
                  label="Upload Document"
                  variant="outlined"
                  density="comfortable"
                  accept=".pdf,.jpg,.jpeg,.png"
                  :required="!isEditMode || !documentData?.location"
                  :disabled="saving"
                  :error-messages="fileError"
                  prepend-icon=""
                  prepend-inner-icon="mdi-paperclip"
                  @update:model-value="handleFileChange"
                />

                <div v-if="isEditMode && documentData?.location" class="d-flex align-center mt-2">
                  <span class="text-caption mr-2">Current file:</span>
                  <ViewDocumentButton :file-name="documentData.location" :has-permission="true" />
                </div>
              </div>
            </v-col>
          </v-row>
        </form>
      </v-card-text>

      <v-card-actions>
        <v-spacer />
        <v-btn variant="text" :disabled="saving || loading" @click="handleReset"> Reset </v-btn>
        <v-btn
          color="primary"
          variant="elevated"
          :loading="saving"
          :disabled="loading"
          @click="onSubmit"
        >
          {{ isEditMode ? 'Update' : 'Save' }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
.file-upload-section {
  width: 100%;
}
</style>

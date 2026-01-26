<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue';
import { nomineeService } from '@/services/nominee/nominee.service';
import type { NomineeRelationship, NomineeItem } from '@/types/nominee.types';
import { toast } from 'vue3-toastify';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';

// Props
interface Props {
  open: boolean;
  nomineeId?: number;
  totalPercentage?: number;
  nomineePercentage?: number;
  employeeId: number;
}

const props = withDefaults(defineProps<Props>(), {
  nomineeId: 0,
  totalPercentage: 0,
  nomineePercentage: 0,
});

// Emits
const emit = defineEmits<{
  (e: 'close'): void;
}>();

// Constants
const OTHER_RELATIONSHIP_ID = 13;

// State
const relationshipOptions = ref<NomineeRelationship[]>([]);
const documentTypeOptions = ref<{ id: number; name: string }[]>([]);
const loadingRelationships = ref(false);
const loadingNominee = ref(false);
const saving = ref(false);
const nomineeData = ref<NomineeItem | null>(null);

// Computed
const isEditMode = computed(() => props.nomineeId > 0);
const dialogTitle = computed(() =>
  isEditMode.value ? 'Edit Nominee Details' : 'Add Nominee Details'
);
const remainingPercentage = computed(() => {
  return (
    100 -
    (props.nomineePercentage
      ? props.totalPercentage - props.nomineePercentage
      : props.totalPercentage)
  );
});

// Validation schema
const schema = computed(() => {
  const isFileRequired = !(props.nomineeId && nomineeData.value?.fileName);

  return toTypedSchema(
    z
      .object({
        nomineeName: z.string().min(1, 'Nominee name is required').max(35, 'Maximum 35 characters'),
        relationshipId: z.string().min(1, 'Relationship is required'),
        others: z.string().max(35, 'Maximum 35 characters').optional(),
        dob: z.string().min(1, 'Date of birth is required'),
        age: z.number().min(0, 'Age must be positive'),
        careOf: z.string().max(35, 'Maximum 35 characters').optional(),
        percentage: z
          .number()
          .min(1, 'Percentage must be at least 1')
          .max(remainingPercentage.value, `Percentage cannot exceed ${remainingPercentage.value}%`),
        idProofDocType: z.string().min(1, 'Document type is required'),
        file: isFileRequired
          ? z.instanceof(File, { message: 'Document is required' })
          : z.instanceof(File).optional().nullable(),
      })
      .refine(
        (data) => {
          // If "Others" is selected, others field is required
          if (Number(data.relationshipId) === OTHER_RELATIONSHIP_ID) {
            return !!data.others && data.others.trim().length > 0;
          }
          return true;
        },
        {
          message: 'Please specify the relationship',
          path: ['others'],
        }
      )
      .refine(
        (data) => {
          // If age < 18, careOf is required
          if (data.age < 18) {
            return !!data.careOf && data.careOf.trim().length > 0;
          }
          return true;
        },
        {
          message: 'Care of is required for minors',
          path: ['careOf'],
        }
      )
  );
});

// Form setup
const { errors, defineField, handleSubmit, resetForm, setFieldValue } = useForm({
  validationSchema: schema,
  initialValues: {
    nomineeName: '',
    relationshipId: '',
    others: '',
    dob: '',
    age: 0,
    careOf: '',
    percentage: 0,
    idProofDocType: '',
    file: null as File | null,
  },
});

const [nomineeName] = defineField('nomineeName');
const [relationshipId] = defineField('relationshipId');
const [others] = defineField('others');
const [dob] = defineField('dob');
const [age] = defineField('age');
const [careOf] = defineField('careOf');
const [percentage] = defineField('percentage');
const [idProofDocType] = defineField('idProofDocType');
// File is handled via handleFileChange, no need for defineField binding

// Computed flags
const showOtherRelationship = computed(
  () => Number(relationshipId.value) === OTHER_RELATIONSHIP_ID
);
const isRequiredCareOf = computed(() => Number(age.value) < 18);

// Calculate age from DOB
function calculateAge(birthDate: Date): number {
  const today = new Date();
  let calculatedAge = today.getFullYear() - birthDate.getFullYear();
  const monthDiff = today.getMonth() - birthDate.getMonth();

  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
    calculatedAge--;
  }

  return calculatedAge;
}

// Fetch relationships
async function fetchRelationships() {
  loadingRelationships.value = true;
  try {
    const response = await nomineeService.getRelationshipList();
    relationshipOptions.value = response.result || [];
  } catch (error) {
    console.error('Failed to fetch relationships:', error);
    toast.error('Failed to load relationship options');
  } finally {
    loadingRelationships.value = false;
  }
}

// Fetch document types (mock for now - in real app, would call API)
function loadDocumentTypes() {
  // These would come from API in real implementation
  documentTypeOptions.value = [
    { id: 1, name: 'Aadhar Card' },
    { id: 2, name: 'PAN Card' },
    { id: 3, name: 'Passport' },
    { id: 4, name: 'Driving License' },
    { id: 5, name: 'Voter ID' },
  ];
}

// Fetch nominee data for edit
async function fetchNomineeData() {
  if (!props.nomineeId) return;

  loadingNominee.value = true;
  try {
    const response = await nomineeService.getNomineeById(props.nomineeId);
    nomineeData.value = response.result;

    // Populate form
    setFieldValue('nomineeName', response.result.nomineeName);
    setFieldValue('relationshipId', String(response.result.relationshipId || ''));
    setFieldValue('others', response.result.others || '');
    setFieldValue('dob', response.result.dob?.split('T')[0] || '');
    setFieldValue('age', response.result.age);
    setFieldValue('careOf', response.result.careOf || '');
    setFieldValue('percentage', response.result.percentage);
    setFieldValue('idProofDocType', String(response.result.idProofDocType || ''));
  } catch (error) {
    console.error('Failed to fetch nominee:', error);
    toast.error('Failed to load nominee data');
  } finally {
    loadingNominee.value = false;
  }
}

// Handle file change
function handleFileChange(event: Event) {
  const target = event.target as HTMLInputElement;
  const selectedFile = target.files?.[0];
  setFieldValue('file', selectedFile || null);
}

// Handle form submit
const onSubmit = handleSubmit(async (formValues) => {
  saving.value = true;
  try {
    if (isEditMode.value) {
      // Update nominee
      await nomineeService.updateNominee({
        Id: props.nomineeId,
        EmployeeId: props.employeeId,
        NomineeName: formValues.nomineeName,
        DOB: formValues.dob,
        Age: formValues.age,
        CareOf: formValues.careOf || '',
        Relationship: Number(formValues.relationshipId),
        Others: formValues.others || '',
        Percentage: formValues.percentage,
        File: formValues.file || '',
        IdProofDocType: Number(formValues.idProofDocType),
      });
      toast.success('Nominee updated successfully');
    } else {
      // Add nominee
      await nomineeService.addNominee({
        EmployeeId: props.employeeId,
        NomineeName: formValues.nomineeName,
        DOB: formValues.dob,
        Age: formValues.age,
        CareOf: formValues.careOf || '',
        Relationship: Number(formValues.relationshipId),
        Others: formValues.others || '',
        Percentage: formValues.percentage,
        File: formValues.file || null,
        IdProofDocType: Number(formValues.idProofDocType),
      });
      toast.success('Nominee added successfully');
    }
    emit('close');
  } catch (error) {
    console.error('Failed to save nominee:', error);
    toast.error(isEditMode.value ? 'Failed to update nominee' : 'Failed to add nominee');
  } finally {
    saving.value = false;
  }
});

// Handle reset
function handleResetForm() {
  if (isEditMode.value && nomineeData.value) {
    // Reset to original values
    setFieldValue('nomineeName', nomineeData.value.nomineeName);
    setFieldValue('relationshipId', String(nomineeData.value.relationshipId || ''));
    setFieldValue('others', nomineeData.value.others || '');
    setFieldValue('dob', nomineeData.value.dob?.split('T')[0] || '');
    setFieldValue('age', nomineeData.value.age);
    setFieldValue('careOf', nomineeData.value.careOf || '');
    setFieldValue('percentage', nomineeData.value.percentage);
    setFieldValue('idProofDocType', String(nomineeData.value.idProofDocType || ''));
  } else {
    resetForm();
  }
}

// Handle dialog close
function handleClose() {
  emit('close');
}

// Watch DOB to calculate age
watch(
  () => dob.value,
  (newDob) => {
    if (newDob) {
      const birthDate = new Date(newDob);
      const calculatedAge = calculateAge(birthDate);
      setFieldValue('age', calculatedAge);
    }
  }
);

// Watch age to manage careOf requirement
watch(
  () => age.value,
  (newAge) => {
    if (newAge >= 18) {
      setFieldValue('careOf', '');
    }
  }
);

// Watch relationship to clear others
watch(
  () => relationshipId.value,
  (newVal) => {
    if (Number(newVal) !== OTHER_RELATIONSHIP_ID) {
      setFieldValue('others', '');
    }
  }
);

// Initialize
onMounted(() => {
  fetchRelationships();
  loadDocumentTypes();
  if (isEditMode.value) {
    fetchNomineeData();
  }
});
</script>

<template>
  <div v-if="open" class="dialog-overlay" @click.self="handleClose">
    <div class="dialog-container">
      <!-- Header -->
      <div class="dialog-header">
        <h4>{{ dialogTitle }}</h4>
        <button class="close-button" @click="handleClose" aria-label="Close">✕</button>
      </div>

      <!-- Loading state -->
      <div v-if="loadingNominee" class="dialog-loading">
        <div class="spinner"></div>
      </div>

      <!-- Form -->
      <form v-else @submit.prevent="onSubmit" class="dialog-content">
        <!-- Nominee Name -->
        <div class="form-group">
          <label for="nomineeName">Nominee Name <span class="required">*</span></label>
          <input
            id="nomineeName"
            v-model="nomineeName"
            type="text"
            placeholder="Enter nominee name"
            maxlength="35"
          />
          <span v-if="errors.nomineeName" class="error">{{ errors.nomineeName }}</span>
        </div>

        <!-- Relationship and Others -->
        <div class="form-row">
          <div class="form-group half">
            <label for="relationshipId">Relationship <span class="required">*</span></label>
            <select id="relationshipId" v-model="relationshipId">
              <option value="">Select Relationship</option>
              <option
                v-for="relation in relationshipOptions"
                :key="relation.id"
                :value="relation.id"
              >
                {{ relation.name }}
              </option>
            </select>
            <span v-if="errors.relationshipId" class="error">{{ errors.relationshipId }}</span>
          </div>

          <div v-if="showOtherRelationship" class="form-group half">
            <label for="others">Specify Relationship <span class="required">*</span></label>
            <input
              id="others"
              v-model="others"
              type="text"
              placeholder="Enter relationship"
              maxlength="35"
            />
            <span v-if="errors.others" class="error">{{ errors.others }}</span>
          </div>
        </div>

        <!-- DOB and Age -->
        <div class="form-row">
          <div class="form-group half">
            <label for="dob">Date of Birth <span class="required">*</span></label>
            <input
              id="dob"
              v-model="dob"
              type="date"
              :max="new Date().toISOString().split('T')[0]"
            />
            <span v-if="errors.dob" class="error">{{ errors.dob }}</span>
          </div>

          <div class="form-group half">
            <label for="age">Age <span class="required">*</span></label>
            <input id="age" v-model="age" type="number" readonly />
            <span v-if="errors.age" class="error">{{ errors.age }}</span>
          </div>
        </div>

        <!-- Care Of and Percentage -->
        <div class="form-row">
          <div class="form-group half">
            <label for="careOf">
              Care Of (Incase Minor)
              <span v-if="isRequiredCareOf" class="required">*</span>
            </label>
            <input
              id="careOf"
              v-model="careOf"
              type="text"
              placeholder="Enter guardian name"
              maxlength="35"
              :disabled="!isRequiredCareOf"
            />
            <span v-if="errors.careOf" class="error">{{ errors.careOf }}</span>
          </div>

          <div class="form-group half">
            <label for="percentage">Percentage <span class="required">*</span></label>
            <input
              id="percentage"
              v-model="percentage"
              type="number"
              min="1"
              :max="remainingPercentage"
            />
            <span v-if="errors.percentage" class="error">{{ errors.percentage }}</span>
          </div>
        </div>

        <!-- Document Type and File Upload -->
        <div class="form-row">
          <div class="form-group half">
            <label for="idProofDocType">Document Type <span class="required">*</span></label>
            <select id="idProofDocType" v-model="idProofDocType">
              <option value="">Select Document Type</option>
              <option v-for="docType in documentTypeOptions" :key="docType.id" :value="docType.id">
                {{ docType.name }}
              </option>
            </select>
            <span v-if="errors.idProofDocType" class="error">{{ errors.idProofDocType }}</span>
          </div>

          <div class="form-group half">
            <label for="file">
              Upload Document
              <span v-if="!(nomineeId && nomineeData?.fileName)" class="required">*</span>
            </label>
            <input id="file" type="file" accept=".pdf,.jpg,.jpeg,.png" @change="handleFileChange" />
            <span v-if="errors.file" class="error">{{ errors.file }}</span>
            <span v-if="nomineeData?.fileName" class="file-info">
              Current: {{ nomineeData.fileName }}
            </span>
          </div>
        </div>

        <!-- Actions -->
        <div class="dialog-actions">
          <button type="submit" class="btn-primary" :disabled="saving">
            {{ saving ? 'Saving...' : isEditMode ? 'Update' : 'Save' }}
          </button>
          <button type="button" class="btn-secondary" @click="handleResetForm">Reset</button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.dialog-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 600px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
}

.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #e0e0e0;
}

.dialog-header h4 {
  margin: 0;
  color: #1e75bb;
  font-size: 20px;
}

.close-button {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #666;
  padding: 0;
  width: 32px;
  height: 32px;
}

.close-button:hover {
  color: #333;
}

.dialog-loading {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 60px;
}

.spinner {
  border: 4px solid #f3f3f3;
  border-top: 4px solid #1e75bb;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.dialog-content {
  padding: 30px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-row {
  display: flex;
  gap: 16px;
}

.form-group.half {
  flex: 1;
}

.form-group label {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.required {
  color: #d32f2f;
}

.form-group input,
.form-group select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-group input:focus,
.form-group select:focus {
  outline: none;
  border-color: #1e75bb;
}

.form-group input:disabled {
  background-color: #f5f5f5;
  cursor: not-allowed;
}

.form-group input[readonly] {
  background-color: #f5f5f5;
}

.error {
  color: #d32f2f;
  font-size: 12px;
}

.file-info {
  font-size: 12px;
  color: #666;
}

.dialog-actions {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top: 10px;
}

.btn-primary,
.btn-secondary {
  padding: 10px 24px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background-color: #1e75bb;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background-color: #165a93;
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-secondary {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-secondary:hover {
  background-color: #e0e0e0;
}
</style>

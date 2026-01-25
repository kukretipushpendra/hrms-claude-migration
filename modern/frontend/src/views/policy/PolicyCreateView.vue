<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import {
  getCompanyPolicyById,
  createCompanyPolicy,
  updateCompanyPolicy,
  getPolicyCategories,
  getPolicyStatuses,
  type CompanyPolicyDetail,
  type PolicyCategory,
  type PolicyStatus,
} from '@/services/policy';
import { useAuthStore } from '@/stores/auth.store';

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();

// State
const loading = ref(false);
const saving = ref(false);
const categories = ref<PolicyCategory[]>([]);
const statuses = ref<PolicyStatus[]>([]);
const policy = ref<CompanyPolicyDetail | null>(null);
const documentFile = ref<File | null>(null);
const showEmailDialog = ref(false);
const emailConfirmed = ref(false);

// Check if edit mode
const isEditMode = computed(() => !!route.params.id);
const policyId = computed(() =>
  route.params.id ? Number(route.params.id) : null
);

// Permission checks
const hasUpdatePermission = computed(() =>
  authStore.hasPermission('Update.CompanyPolicy')
);

// Validation schema
const schema = toTypedSchema(
  z.object({
    policyTitle: z.string().min(1, 'Policy title is required'),
    policyCategoryId: z.number({ required_error: 'Category is required' }),
    statusId: z.number({ required_error: 'Status is required' }),
    policyContent: z.string().min(1, 'Policy content is required').max(600),
    effectiveDate: z.string().min(1, 'Effective date is required'),
    accessibility: z.boolean().optional(),
    emailRequest: z.boolean().optional(),
  })
);

// Form setup
const { handleSubmit, defineField, errors, resetForm, setValues } = useForm({
  validationSchema: schema,
  initialValues: {
    policyTitle: '',
    policyCategoryId: undefined as number | undefined,
    statusId: undefined as number | undefined,
    policyContent: '',
    effectiveDate: '',
    accessibility: false,
    emailRequest: false,
  },
});

const [policyTitle] = defineField('policyTitle');
const [policyCategoryId] = defineField('policyCategoryId');
const [statusId] = defineField('statusId');
const [policyContent] = defineField('policyContent');
const [effectiveDate] = defineField('effectiveDate');
const [accessibility] = defineField('accessibility');
const [emailRequest] = defineField('emailRequest');

// Character count for description
const characterCount = computed(() => policyContent.value?.length || 0);
const maxCharacters = 600;

// Fetch categories and statuses
const fetchMetadata = async () => {
  try {
    const [categoriesRes, statusesRes] = await Promise.all([
      getPolicyCategories(),
      getPolicyStatuses(),
    ]);

    if (categoriesRes.statusCode === 200 && categoriesRes.result) {
      categories.value = categoriesRes.result;
    }

    if (statusesRes.statusCode === 200 && statusesRes.result) {
      statuses.value = statusesRes.result;
    }
  } catch (error) {
    console.error('Failed to fetch metadata:', error);
  }
};

// Fetch policy for editing
const fetchPolicy = async () => {
  if (!policyId.value || !hasUpdatePermission.value) {
    return;
  }

  loading.value = true;
  try {
    const response = await getCompanyPolicyById(policyId.value);
    if (response.statusCode === 200 && response.result) {
      policy.value = response.result;

      // Populate form
      setValues({
        policyTitle: policy.value.policyTitle,
        policyCategoryId: policy.value.policyCategoryId,
        statusId: policy.value.statusId,
        policyContent: policy.value.policyContent,
        effectiveDate: policy.value.effectiveDate.split('T')[0],
        accessibility: policy.value.accessibility || false,
        emailRequest: false,
      });
    }
  } catch (error) {
    console.error('Failed to fetch policy:', error);
  } finally {
    loading.value = false;
  }
};

// Handle file selection
const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];

  if (file) {
    // Validate file type
    const allowedTypes = ['application/pdf'];
    if (!allowedTypes.includes(file.type)) {
      alert('Only PDF files are allowed');
      target.value = '';
      return;
    }

    // Validate file size (5MB max)
    const maxSize = 5 * 1024 * 1024; // 5MB in bytes
    if (file.size > maxSize) {
      alert('File size must not exceed 5MB');
      target.value = '';
      return;
    }

    documentFile.value = file;
  }
};

// Handle form submission
const onSubmit = handleSubmit(async (values) => {
  // Check for email notification
  if (values.emailRequest && !emailConfirmed.value) {
    showEmailDialog.value = true;
    return;
  }

  saving.value = true;
  try {
    const requestData = {
      policyTitle: values.policyTitle,
      policyCategoryId: values.policyCategoryId!,
      policyContent: values.policyContent,
      effectiveDate: values.effectiveDate,
      statusId: values.statusId,
      accessibility: values.accessibility,
      emailRequest: values.emailRequest,
      document: documentFile.value || undefined,
    };

    let response;
    if (isEditMode.value && policyId.value) {
      response = await updateCompanyPolicy(policyId.value, requestData);
    } else {
      response = await createCompanyPolicy(requestData);
    }

    if (response.statusCode === 200) {
      router.push({ name: 'company-policy' });
    } else {
      alert(response.message || 'Failed to save policy');
    }
  } catch (error) {
    console.error('Failed to save policy:', error);
    alert('An error occurred while saving the policy');
  } finally {
    saving.value = false;
    emailConfirmed.value = false;
  }
});

// Confirm email notification
const handleConfirmEmail = () => {
  emailConfirmed.value = true;
  showEmailDialog.value = false;
  onSubmit();
};

// Cancel email notification
const handleCancelEmail = () => {
  showEmailDialog.value = false;
};

// Reset form
const handleReset = () => {
  if (isEditMode.value && policy.value) {
    fetchPolicy();
  } else {
    resetForm();
    documentFile.value = null;
  }
};

// Go back
const handleBack = () => {
  router.push({ name: 'company-policy' });
};

// Lifecycle
onMounted(async () => {
  await fetchMetadata();
  if (isEditMode.value) {
    await fetchPolicy();
  }
});
</script>

<template>
  <v-container fluid class="pa-6">
    <v-card :loading="loading">
      <!-- Header -->
      <v-card-title class="d-flex align-center gap-2">
        <v-btn icon variant="text" @click="handleBack">
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <h2 class="text-h5">
          {{ isEditMode ? 'Edit' : 'Add' }} Policy Documents
        </h2>
      </v-card-title>

      <v-divider />

      <!-- Form -->
      <v-card-text v-if="!loading">
        <form @submit="onSubmit">
          <v-row>
            <!-- Policy Title -->
            <v-col cols="12" md="6">
              <v-text-field
                v-model="policyTitle"
                label="Name"
                variant="outlined"
                :error-messages="errors.policyTitle"
                required
              />
            </v-col>

            <!-- Category -->
            <v-col cols="12" md="6">
              <v-select
                v-model="policyCategoryId"
                :items="categories"
                item-title="name"
                item-value="id"
                label="Category"
                variant="outlined"
                :error-messages="errors.policyCategoryId"
                required
              />
            </v-col>

            <!-- Status -->
            <v-col cols="12">
              <v-select
                v-model="statusId"
                :items="statuses"
                item-title="name"
                item-value="id"
                label="Status"
                variant="outlined"
                :error-messages="errors.statusId"
                required
              />
            </v-col>

            <!-- Policy Content -->
            <v-col cols="12">
              <v-textarea
                v-model="policyContent"
                label="Description"
                variant="outlined"
                rows="5"
                :counter="maxCharacters"
                :error-messages="errors.policyContent"
                required
              >
                <template #counter>
                  <span>{{ characterCount }}/{{ maxCharacters }}</span>
                </template>
              </v-textarea>
            </v-col>

            <!-- Effective Date -->
            <v-col cols="12" md="6">
              <v-text-field
                v-model="effectiveDate"
                label="Effective Date"
                type="date"
                variant="outlined"
                :error-messages="errors.effectiveDate"
                required
              />
            </v-col>

            <!-- Accessibility Checkbox -->
            <v-col cols="12">
              <v-checkbox v-model="accessibility" label="Accessibility" hide-details />
            </v-col>

            <!-- Email Request Checkbox -->
            <v-col cols="12">
              <v-checkbox
                v-model="emailRequest"
                label="Notify via Email"
                :disabled="isEditMode"
                hide-details
              />
            </v-col>

            <!-- File Upload -->
            <v-col cols="12" md="6">
              <v-file-input
                label="Upload Document (PDF only, max 5MB)"
                variant="outlined"
                accept="application/pdf"
                prepend-icon="mdi-file-pdf-box"
                @change="handleFileChange"
              />
            </v-col>

            <!-- View Existing Document -->
            <v-col v-if="isEditMode && policy?.documentUrl" cols="12" md="6">
              <v-btn
                variant="outlined"
                color="primary"
                prepend-icon="mdi-eye"
                :href="policy.documentUrl"
                target="_blank"
              >
                View Current Document
              </v-btn>
            </v-col>
          </v-row>

          <!-- Action Buttons -->
          <v-row class="mt-4">
            <v-col cols="12" class="d-flex justify-center gap-2">
              <v-btn
                type="submit"
                color="primary"
                :loading="saving"
                min-width="120"
              >
                {{ saving ? 'Saving...' : isEditMode ? 'Update' : 'Save' }}
              </v-btn>
              <v-btn variant="outlined" @click="handleReset" min-width="120">
                Reset
              </v-btn>
            </v-col>
          </v-row>
        </form>
      </v-card-text>

      <!-- Loading state -->
      <v-card-text v-else>
        <div class="d-flex justify-center align-center" style="min-height: 300px">
          <v-progress-circular indeterminate color="primary" />
        </div>
      </v-card-text>
    </v-card>

    <!-- Email Confirmation Dialog -->
    <v-dialog v-model="showEmailDialog" max-width="500">
      <v-card>
        <v-card-title>Send Email Notification?</v-card-title>
        <v-card-text>
          You are about to send an email notification to affected users when you save
          these changes. This may notify a large audience. Are you sure you want to
          proceed?
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn variant="text" @click="handleCancelEmail"> Cancel </v-btn>
          <v-btn color="primary" @click="handleConfirmEmail"> Confirm </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<style scoped>
.gap-2 {
  gap: 8px;
}
</style>

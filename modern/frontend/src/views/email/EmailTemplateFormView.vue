<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import { toast } from 'vue3-toastify';
import EmailTemplateTypeSelect from '@/components/email/EmailTemplateTypeSelect.vue';
import EmailBodyEditor from '@/components/email/EmailBodyEditor.vue';
import type {
  EmailTemplateTypeOption,
  AddEmailTemplateRequest,
  UpdateEmailTemplateRequest,
} from '@/types/email.types';
import {
  getEmailTemplateById,
  getDefaultTemplate,
  addEmailTemplate,
  updateEmailTemplate,
  getEmailTemplateNameList,
} from '@/services/email/email.service';

const router = useRouter();
const route = useRoute();

const mode = ref<'add' | 'edit'>('add');
const templateId = ref<number | null>(null);
const loading = ref(false);
const submitting = ref(false);
const templateTypeOptions = ref<EmailTemplateTypeOption[]>([]);

// Validation schema
const schema = toTypedSchema(
  z.object({
    type: z.number({ required_error: 'Template type is required' }),
    templateName: z.string().min(1, 'Template name is required').max(100),
    subject: z.string().min(1, 'Subject is required').max(200),
    senderName: z.string().min(1, 'Sender name is required'),
    senderEmail: z.string().email('Invalid email address').min(1, 'Sender email is required'),
    cc: z.string().optional(),
    bcc: z.string().optional(),
    body: z.string().min(1, 'Mail body is required'),
    isSelected: z.boolean().optional(),
  })
);

const { handleSubmit, defineField, setValues, errors, values } = useForm({
  validationSchema: schema,
  initialValues: {
    type: 1,
    templateName: '',
    subject: '',
    senderName: '',
    senderEmail: '',
    cc: '',
    bcc: '',
    body: '',
    isSelected: false,
  },
});

const [type] = defineField('type');
const [templateName] = defineField('templateName');
const [subject] = defineField('subject');
const [senderName] = defineField('senderName');
const [senderEmail] = defineField('senderEmail');
const [cc] = defineField('cc');
const [bcc] = defineField('bcc');
const [body] = defineField('body');
const [isSelected] = defineField('isSelected');

// Fetch template type options
const fetchTemplateTypeOptions = async () => {
  try {
    templateTypeOptions.value = await getEmailTemplateNameList();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch template types');
  }
};

// Fetch template by ID (edit mode)
const fetchTemplate = async (id: number) => {
  loading.value = true;
  try {
    const template = await getEmailTemplateById(id);
    if (template) {
      setValues({
        type: template.type,
        templateName: template.templateName,
        subject: template.subject,
        senderName: template.senderName,
        senderEmail: template.senderEmail,
        cc: template.ccEmails || '',
        bcc: template.bccEmails || '',
        body: template.content || '',
        isSelected: false,
      });
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch template');
  } finally {
    loading.value = false;
  }
};

// Fetch default template for selected type (add mode only)
const fetchDefaultTemplateForType = async (typeId: number) => {
  if (mode.value !== 'add') return;

  loading.value = true;
  try {
    const template = await getDefaultTemplate(typeId);
    if (template) {
      setValues({
        type: template.type,
        templateName: template.templateName || '',
        subject: template.subject || '',
        senderName: template.senderName || '',
        senderEmail: template.senderEmail || '',
        cc: template.ccEmails || '',
        bcc: template.bccEmails || '',
        body: template.content || '',
        isSelected: false,
      });
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch default template');
  } finally {
    loading.value = false;
  }
};

// Watch type changes in add mode
watch(
  () => values.type,
  (newType) => {
    if (mode.value === 'add' && newType) {
      fetchDefaultTemplateForType(newType);
    }
  }
);

// Submit form
const onSubmit = handleSubmit(async (formValues) => {
  submitting.value = true;
  try {
    if (mode.value === 'edit' && templateId.value) {
      const payload: UpdateEmailTemplateRequest = {
        id: templateId.value,
        templateName: formValues.templateName,
        subject: formValues.subject,
        content: formValues.body,
        type: formValues.type,
        senderName: formValues.senderName,
        senderEmail: formValues.senderEmail,
        ccEmails: formValues.cc || '',
        bccEmails: formValues.bcc || '',
        toEmail: '',
      };
      await updateEmailTemplate(payload);
      toast.success('Template Updated Successfully');
    } else {
      const payload: AddEmailTemplateRequest = {
        templateName: formValues.templateName,
        subject: formValues.subject,
        content: formValues.body,
        type: formValues.type,
        senderName: formValues.senderName,
        senderEmail: formValues.senderEmail,
        ccEmails: formValues.cc || '',
        bccEmails: formValues.bcc || '',
        toEmail: '',
        isDefault: formValues.isSelected || false,
      };
      await addEmailTemplate(payload);
      toast.success('Template Added Successfully');
    }
    router.push('/settings/email-and-notification');
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to save template');
  } finally {
    submitting.value = false;
  }
});

// Handle cancel
const handleCancel = () => {
  router.back();
};

onMounted(() => {
  // Determine mode from route
  if (route.params.id) {
    mode.value = 'edit';
    templateId.value = Number(route.params.id);
    fetchTemplate(templateId.value);
  } else {
    mode.value = 'add';
  }
  fetchTemplateTypeOptions();
});
</script>

<template>
  <div class="email-template-form">
    <!-- Page Header -->
    <v-card class="mb-4" elevation="2">
      <v-card-title>
        <h2>{{ mode === 'edit' ? 'Edit' : 'Add' }} Email Template</h2>
      </v-card-title>
    </v-card>

    <!-- Form Card -->
    <v-card elevation="2">
      <v-card-text>
        <v-overlay :model-value="loading" contained class="align-center justify-center">
          <v-progress-circular indeterminate size="64" />
        </v-overlay>

        <form @submit="onSubmit">
          <v-row>
            <!-- Template Type -->
            <v-col cols="12" md="6">
              <EmailTemplateTypeSelect
                v-model="type"
                :options="templateTypeOptions"
                label="Template Type *"
                :disabled="mode === 'edit'"
                :error="errors.type"
              />
            </v-col>

            <!-- Template Name -->
            <v-col cols="12" md="6">
              <v-text-field
                v-model="templateName"
                label="Template Name *"
                variant="outlined"
                density="comfortable"
                :error-messages="errors.templateName"
              />
            </v-col>

            <!-- Sender Name -->
            <v-col cols="12">
              <v-text-field
                v-model="senderName"
                label="Sender Name *"
                variant="outlined"
                density="comfortable"
                :error-messages="errors.senderName"
              />
            </v-col>

            <!-- Subject -->
            <v-col cols="12">
              <v-text-field
                v-model="subject"
                label="Subject *"
                variant="outlined"
                density="comfortable"
                :error-messages="errors.subject"
              />
            </v-col>

            <!-- Sender Email -->
            <v-col cols="12">
              <v-text-field
                v-model="senderEmail"
                label="Sender Email *"
                variant="outlined"
                density="comfortable"
                :error-messages="errors.senderEmail"
              />
            </v-col>

            <!-- CC -->
            <v-col cols="12">
              <v-text-field
                v-model="cc"
                label="CC"
                variant="outlined"
                density="comfortable"
                placeholder="Semicolon-separated email addresses"
                :error-messages="errors.cc"
              />
            </v-col>

            <!-- BCC -->
            <v-col cols="12">
              <v-text-field
                v-model="bcc"
                label="BCC"
                variant="outlined"
                density="comfortable"
                placeholder="Semicolon-separated email addresses"
                :error-messages="errors.bcc"
              />
            </v-col>

            <!-- Email Body Editor -->
            <v-col cols="12">
              <EmailBodyEditor v-model="body" label="Mail Body *" :error="errors.body" />
            </v-col>

            <!-- Set as Default (Add mode only) -->
            <v-col v-if="mode === 'add'" cols="12">
              <v-checkbox
                v-model="isSelected"
                label="Select this template"
                color="primary"
                hide-details
              />
            </v-col>

            <!-- Action Buttons -->
            <v-col cols="12" class="d-flex justify-center gap-2">
              <v-btn type="submit" color="primary" :loading="submitting" :disabled="loading">
                Save
              </v-btn>
              <v-btn type="button" color="secondary" variant="outlined" @click="handleCancel">
                Cancel
              </v-btn>
            </v-col>
          </v-row>
        </form>
      </v-card-text>
    </v-card>
  </div>
</template>

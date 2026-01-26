<script setup lang="ts">
import { ref } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import EmailTemplateTypeSelect from './EmailTemplateTypeSelect.vue';
import type { EmailTemplateTypeOption, EmailTemplateSearchFilter } from '@/types/email.types';

interface Props {
  templateTypeOptions: EmailTemplateTypeOption[];
}

defineProps<Props>();

const emit = defineEmits<{
  (e: 'search', filters: EmailTemplateSearchFilter): void;
  (e: 'reset'): void;
}>();

// Validation schema
const schema = toTypedSchema(
  z.object({
    templateName: z.string().optional(),
    templateType: z.number().nullable().optional(),
    senderName: z.string().optional(),
    senderEmail: z.string().optional(),
    status: z.number().nullable().optional(),
  })
);

const { handleSubmit, defineField, resetForm } = useForm({
  validationSchema: schema,
  initialValues: {
    templateName: '',
    templateType: null,
    senderName: '',
    senderEmail: '',
    status: null,
  },
});

const [templateName] = defineField('templateName');
const [templateType] = defineField('templateType');
const [senderName] = defineField('senderName');
const [senderEmail] = defineField('senderEmail');
const [status] = defineField('status');

const statusOptions = ref([
  { id: 1, name: 'Active' },
  { id: 0, name: 'Inactive' },
  { id: 2, name: 'Default' },
]);

const onSubmit = handleSubmit((values) => {
  emit('search', {
    templateName: values.templateName || '',
    templateType: values.templateType || null,
    senderName: values.senderName || '',
    senderEmail: values.senderEmail || '',
    status: values.status === 2 ? null : (values.status as number | null),
  });
});

const handleReset = () => {
  resetForm();
  emit('reset');
};

// Expose reset method for parent component
defineExpose({
  handleReset,
});
</script>

<template>
  <form @submit="onSubmit">
    <v-row>
      <v-col cols="12" md="4" lg="3">
        <v-text-field
          v-model="templateName"
          label="Template Name"
          variant="outlined"
          density="comfortable"
          clearable
        />
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <EmailTemplateTypeSelect
          v-model="templateType"
          :options="templateTypeOptions"
          label="Template Type"
        />
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-text-field
          v-model="senderName"
          label="Sender Name"
          variant="outlined"
          density="comfortable"
          clearable
        />
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-text-field
          v-model="senderEmail"
          label="Sender Email"
          variant="outlined"
          density="comfortable"
          clearable
        />
      </v-col>

      <v-col cols="12" md="4" lg="3">
        <v-select
          v-model="status"
          :items="statusOptions"
          label="Status"
          item-title="name"
          item-value="id"
          variant="outlined"
          density="comfortable"
          clearable
        />
      </v-col>

      <v-col cols="12" class="d-flex justify-center gap-2">
        <v-btn type="submit" color="primary" variant="flat">Search</v-btn>
        <v-btn type="button" color="secondary" variant="outlined" @click="handleReset">
          Reset
        </v-btn>
      </v-col>
    </v-row>
  </form>
</template>

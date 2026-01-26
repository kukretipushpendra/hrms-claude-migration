<script setup lang="ts">
import type { EmailTemplate, EmailTemplateTypeOption } from '@/types/email.types';
import { EMAIL_TEMPLATE_TYPE_LABEL, EMAIL_TEMPLATE_STATUS_LABEL } from '@/types/email.types';

interface Props {
  templates: EmailTemplate[];
  loading?: boolean;
  templateTypeOptions: EmailTemplateTypeOption[];
}

defineProps<Props>();

const emit = defineEmits<{
  (e: 'edit', template: EmailTemplate): void;
  (e: 'delete', templateId: number): void;
  (e: 'toggle-status', template: EmailTemplate): void;
}>();

// Format date helper
const formatDate = (dateString?: string | null): string => {
  if (!dateString) return '-';
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};

// Get status color
const getStatusColor = (status: number | null): string => {
  if (status === 1) return 'success';
  if (status === 0) return 'grey';
  return 'info'; // default/null
};

// Get status text
const getStatusText = (status: number | null): string => {
  if (status === null) return 'Default';
  return EMAIL_TEMPLATE_STATUS_LABEL[status] || 'Unknown';
};
</script>

<template>
  <v-data-table
    :items="templates"
    :loading="loading"
    :headers="[
      { title: 'Template Name', key: 'templateName', sortable: true },
      { title: 'Type', key: 'type', sortable: true },
      { title: 'Subject', key: 'subject', sortable: false },
      { title: 'Sender Name', key: 'senderName', sortable: true },
      { title: 'Sender Email', key: 'senderEmail', sortable: true },
      { title: 'Status', key: 'status', sortable: true, align: 'center' },
      { title: 'Modified On', key: 'modifiedOn', sortable: true },
      { title: 'Actions', key: 'actions', sortable: false, align: 'center' },
    ]"
    item-value="id"
    class="elevation-1"
  >
    <template #item.type="{ item }">
      {{ EMAIL_TEMPLATE_TYPE_LABEL[item.type] || item.type }}
    </template>

    <template #item.subject="{ item }">
      <div class="text-truncate" style="max-width: 300px">
        {{ item.subject }}
      </div>
    </template>

    <template #item.status="{ item }">
      <v-chip :color="getStatusColor(item.status)" size="small">
        {{ getStatusText(item.status) }}
      </v-chip>
    </template>

    <template #item.modifiedOn="{ item }">
      {{ formatDate(item.modifiedOn) }}
    </template>

    <template #item.actions="{ item }">
      <div class="d-flex justify-center align-center gap-1">
        <!-- Toggle Status Switch -->
        <v-tooltip text="Toggle Active/Inactive">
          <template #activator="{ props: tooltipProps }">
            <v-switch
              v-bind="tooltipProps"
              :model-value="item.status === 1"
              :disabled="item.status === null"
              color="success"
              hide-details
              density="compact"
              @update:model-value="() => emit('toggle-status', item)"
            />
          </template>
        </v-tooltip>

        <!-- Edit Button -->
        <v-tooltip text="Edit Template">
          <template #activator="{ props: tooltipProps }">
            <v-btn
              v-bind="tooltipProps"
              icon="mdi-pencil"
              size="small"
              variant="text"
              color="primary"
              @click="emit('edit', item)"
            />
          </template>
        </v-tooltip>

        <!-- Delete Button -->
        <v-tooltip text="Delete Template">
          <template #activator="{ props: tooltipProps }">
            <v-btn
              v-bind="tooltipProps"
              icon="mdi-delete"
              size="small"
              variant="text"
              color="error"
              :disabled="item.status === null"
              @click="emit('delete', item.id)"
            />
          </template>
        </v-tooltip>
      </div>
    </template>

    <template #loading>
      <v-skeleton-loader type="table-row@5" />
    </template>

    <template #no-data>
      <div class="text-center py-8">
        <v-icon size="64" color="grey-lighten-1">mdi-email-outline</v-icon>
        <p class="text-h6 mt-4 text-grey">No email templates found</p>
        <p class="text-body-2 text-grey-darken-1">Create a new template to get started</p>
      </div>
    </template>
  </v-data-table>
</template>

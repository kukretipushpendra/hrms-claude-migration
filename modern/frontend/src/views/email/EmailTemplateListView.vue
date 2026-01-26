<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { toast } from 'vue3-toastify';
import EmailTemplateTable from '@/components/email/EmailTemplateTable.vue';
import EmailTemplateFilterForm from '@/components/email/EmailTemplateFilterForm.vue';
import type {
  EmailTemplate,
  EmailTemplateTypeOption,
  EmailTemplateSearchFilter,
  EmailTemplateStatusValue,
} from '@/types/email.types';
import {
  getEmailTemplates,
  getEmailTemplateNameList,
  toggleEmailTemplateStatus,
  deleteTemplate,
} from '@/services/email/email.service';
import { EmailTemplateStatus } from '@/types/email.types';

const router = useRouter();

const templates = ref<EmailTemplate[]>([]);
const filteredTemplates = ref<EmailTemplate[]>([]);
const templateTypeOptions = ref<EmailTemplateTypeOption[]>([]);
const loading = ref(false);
const showFilters = ref(false);
const hasActiveFilters = ref(false);
const deleteDialogOpen = ref(false);
const templateToDelete = ref<number | null>(null);

// Filter state
const filters = ref<EmailTemplateSearchFilter>({
  templateName: '',
  senderName: '',
  senderEmail: '',
  templateType: null,
  status: null,
});

const filterFormRef = ref<InstanceType<typeof EmailTemplateFilterForm> | null>(null);

// Fetch templates
const fetchTemplates = async () => {
  loading.value = true;
  try {
    const response = await getEmailTemplates({
      pageNumber: 1,
      pageSize: 1000,
      sortColumn: 'modifiedOn',
      sortDirection: 'desc',
      filter: {
        templateName: '',
        senderName: '',
        senderEmail: '',
        templateType: null,
        status: null,
      },
    });
    templates.value = response.templates || [];
    applyFilters();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch email templates');
  } finally {
    loading.value = false;
  }
};

// Fetch template type options
const fetchTemplateTypeOptions = async () => {
  try {
    templateTypeOptions.value = await getEmailTemplateNameList();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch template types');
  }
};

// Apply client-side filters
const applyFilters = () => {
  if (!templates.value || templates.value.length === 0) {
    filteredTemplates.value = [];
    return;
  }

  const filtered = templates.value.filter((template) => {
    const matchesName =
      !filters.value.templateName ||
      template.templateName.toLowerCase().includes(filters.value.templateName.toLowerCase());

    const matchesType =
      filters.value.templateType === null || template.type === filters.value.templateType;

    const matchesSenderName =
      !filters.value.senderName ||
      template.senderName.toLowerCase().includes(filters.value.senderName.toLowerCase());

    const matchesSenderEmail =
      !filters.value.senderEmail ||
      template.senderEmail.toLowerCase().includes(filters.value.senderEmail.toLowerCase());

    // Status filter: null means show all (Active/Inactive), status value matches directly
    // Special handling: if filtering for "Default" templates (status === null in DB),
    // we detect this by checking if the filter doesn't match 0 or 1
    const filterStatus = filters.value.status;
    const matchesStatus =
      filterStatus === null
        ? template.status === 1 || template.status === 0
        : filterStatus === (2 as unknown as EmailTemplateStatusValue)
          ? template.status === null
          : template.status === filterStatus;

    return matchesName && matchesType && matchesSenderName && matchesSenderEmail && matchesStatus;
  });

  // Sort by modifiedOn descending
  filteredTemplates.value = filtered.sort((a, b) => {
    const dateA = a.modifiedOn ? new Date(a.modifiedOn).getTime() : 0;
    const dateB = b.modifiedOn ? new Date(b.modifiedOn).getTime() : 0;
    return dateB - dateA;
  });
};

// Handle search
const handleSearch = (searchFilters: EmailTemplateSearchFilter) => {
  filters.value = searchFilters;
  hasActiveFilters.value =
    !!searchFilters.templateName ||
    searchFilters.templateType !== null ||
    !!searchFilters.senderName ||
    !!searchFilters.senderEmail ||
    searchFilters.status !== null;
  applyFilters();
};

// Handle reset
const handleReset = () => {
  filterFormRef.value?.handleReset();
  filters.value = {
    templateName: '',
    senderName: '',
    senderEmail: '',
    templateType: null,
    status: null,
  };
  hasActiveFilters.value = false;
  applyFilters();
};

// Toggle status
const handleToggleStatus = async (template: EmailTemplate) => {
  try {
    const newStatus =
      template.status === 1 ? EmailTemplateStatus.Inactive : EmailTemplateStatus.Active;
    await toggleEmailTemplateStatus({
      id: template.id,
      status: newStatus,
    });

    // Update local state
    const index = templates.value.findIndex((t) => t.id === template.id);
    if (index !== -1 && templates.value[index]) {
      templates.value[index].status = newStatus;
    }
    applyFilters();
    toast.success('Status updated successfully');
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(
      err.response?.data?.message ||
        'Failed to update status. Another template may already be active for this type.'
    );
  }
};

// Handle edit
const handleEdit = (template: EmailTemplate) => {
  router.push(`/settings/email-and-notification/edit/${template.id}`);
};

// Handle delete confirmation
const confirmDelete = (templateId: number) => {
  templateToDelete.value = templateId;
  deleteDialogOpen.value = true;
};

// Handle delete
const handleDelete = async () => {
  if (!templateToDelete.value) return;

  try {
    await deleteTemplate(templateToDelete.value);
    templates.value = templates.value.filter((t) => t.id !== templateToDelete.value);
    applyFilters();
    toast.success('Email Template Deleted Successfully');
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to delete template');
  } finally {
    deleteDialogOpen.value = false;
    templateToDelete.value = null;
  }
};

// Navigate to add template
const handleAdd = () => {
  router.push('/settings/email-and-notification/add');
};

onMounted(() => {
  fetchTemplates();
  fetchTemplateTypeOptions();
});
</script>

<template>
  <div class="email-template-list">
    <!-- Page Header -->
    <v-card class="mb-4" elevation="2">
      <v-card-title class="d-flex justify-space-between align-center">
        <h2>Email and Notification</h2>
        <v-btn color="primary" prepend-icon="mdi-plus" @click="handleAdd"> Add Template </v-btn>
      </v-card-title>
    </v-card>

    <!-- Main Content Card -->
    <v-card elevation="2">
      <!-- Toolbar -->
      <v-card-text class="pb-0">
        <div class="d-flex justify-space-between align-center mb-4">
          <div class="d-flex gap-2">
            <v-btn
              :variant="showFilters ? 'flat' : 'outlined'"
              :color="showFilters ? 'primary' : 'default'"
              prepend-icon="mdi-filter"
              @click="showFilters = !showFilters"
            >
              {{ showFilters ? 'Hide Filters' : 'Show Filters' }}
            </v-btn>
            <v-chip v-if="hasActiveFilters" color="primary" closable @click:close="handleReset">
              Filters Active
            </v-chip>
          </div>

          <div class="text-body-2 text-grey-darken-1">
            Showing {{ filteredTemplates.length }} of {{ templates.length }} templates
          </div>
        </div>

        <!-- Filter Form -->
        <v-expand-transition>
          <div v-show="showFilters" class="mb-4">
            <EmailTemplateFilterForm
              ref="filterFormRef"
              :template-type-options="templateTypeOptions"
              @search="handleSearch"
              @reset="handleReset"
            />
          </div>
        </v-expand-transition>
      </v-card-text>

      <!-- Table -->
      <v-card-text>
        <EmailTemplateTable
          :templates="filteredTemplates"
          :loading="loading"
          :template-type-options="templateTypeOptions"
          @edit="handleEdit"
          @delete="confirmDelete"
          @toggle-status="handleToggleStatus"
        />
      </v-card-text>
    </v-card>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="deleteDialogOpen" max-width="500">
      <v-card>
        <v-card-title class="text-h5">Delete Email Template</v-card-title>
        <v-card-text>
          Are you sure you want to proceed? The selected item will be permanently deleted.
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="grey" variant="text" @click="deleteDialogOpen = false">Cancel</v-btn>
          <v-btn color="error" variant="flat" @click="handleDelete">Delete</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

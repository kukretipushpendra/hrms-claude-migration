<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { format } from 'date-fns';
import AddEditDocumentDialog from '@/components/documents/AddEditDocumentDialog.vue';
import ViewDocumentButton from '@/components/documents/ViewDocumentButton.vue';
import { documentService } from '@/services/document/document.service';
import { useAuthStore } from '@/stores/auth';
import type { UserDocument } from '@/types/document.types';

// Store and route
const authStore = useAuthStore();
const route = useRoute();

// State
const documents = ref<UserDocument[]>([]);
const loading = ref(true);
const dialogOpen = ref(false);
const selectedDocumentId = ref(0);
const page = ref(1);
const itemsPerPage = ref(10);

// Get employee ID (from query param or current user)
const employeeId = computed(() => {
  const queryEmployeeId = route.query.employeeId;
  if (queryEmployeeId) {
    return parseInt(queryEmployeeId as string, 10);
  }
  return authStore.user?.userId || 0;
});

// Permissions
const hasReadPermission = computed(() => authStore.hasPermission('Read.PersonalDetails'));
const hasCreatePermission = computed(() => authStore.hasPermission('Create.PersonalDetails'));
const hasEditPermission = computed(() => authStore.hasPermission('Edit.PersonalDetails'));
const hasViewPermission = computed(() => authStore.hasPermission('View.PersonalDetails'));

// Existing document types (for duplicate prevention)
const existingDocTypes = computed(() => documents.value.map((doc) => doc.documentTypeId));

// Current document type (when editing)
const currentDocType = computed(() => {
  if (selectedDocumentId.value === 0) return null;
  const doc = documents.value.find((d) => d.id === selectedDocumentId.value);
  return doc?.documentTypeId || null;
});

// Table headers
const headers = [
  { title: 'S.No', key: 'sno', sortable: false },
  { title: 'Document Type', key: 'documentType', sortable: true },
  { title: 'Document Number', key: 'documentNumber', sortable: true },
  { title: 'Expiry', key: 'documentExpiry', sortable: true },
  { title: 'Attachment', key: 'attachment', sortable: false },
];

// Add Actions column if user has edit permission
if (hasEditPermission.value) {
  headers.push({ title: 'Actions', key: 'actions', sortable: false });
}

// Paginated documents
const paginatedDocuments = computed(() => {
  const start = (page.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return documents.value.slice(start, end);
});

// Total pages
const totalPages = computed(() => Math.ceil(documents.value.length / itemsPerPage.value));

// Format date
const formatDate = (dateString: string | null): string => {
  if (!dateString) return '-';
  try {
    return format(new Date(dateString), 'MMM dd, yyyy');
  } catch {
    return '-';
  }
};

// Get serial number
const getSerialNumber = (index: number): number => {
  return (page.value - 1) * itemsPerPage.value + index + 1;
};

// Fetch documents
const fetchDocuments = async () => {
  if (!hasReadPermission.value) {
    return;
  }

  try {
    loading.value = true;
    const data = await documentService.getUserDocumentList(employeeId.value);
    documents.value = data;
  } catch (error) {
    console.error('Error fetching documents:', error);
    documents.value = [];
  } finally {
    loading.value = false;
  }
};

// Open add dialog
const handleAddDocument = () => {
  selectedDocumentId.value = 0;
  dialogOpen.value = true;
};

// Open edit dialog
const handleEditDocument = (documentId: number) => {
  selectedDocumentId.value = documentId;
  dialogOpen.value = true;
};

// Close dialog
const handleCloseDialog = () => {
  dialogOpen.value = false;
  selectedDocumentId.value = 0;
};

// Handle document saved
const handleDocumentSaved = () => {
  fetchDocuments();
};

// Initialize
onMounted(() => {
  fetchDocuments();
});
</script>

<template>
  <div class="documents-page">
    <v-container fluid>
      <v-row>
        <v-col cols="12">
          <v-card>
            <v-card-title class="d-flex justify-space-between align-center">
              <span class="text-h5">Documents</span>
              <v-btn
                v-if="hasCreatePermission"
                color="primary"
                variant="elevated"
                prepend-icon="mdi-plus"
                @click="handleAddDocument"
              >
                Add Document
              </v-btn>
            </v-card-title>

            <v-card-text>
              <v-data-table
                :headers="headers"
                :items="paginatedDocuments"
                :loading="loading"
                :items-per-page="itemsPerPage"
                hide-default-footer
              >
                <!-- Serial Number -->
                <template #item.sno="{ index }">
                  {{ getSerialNumber(index) }}
                </template>

                <!-- Expiry Date -->
                <template #item.documentExpiry="{ item }">
                  {{ formatDate(item.documentExpiry) }}
                </template>

                <!-- Attachment -->
                <template #item.attachment="{ item }">
                  <ViewDocumentButton
                    :file-name="item.location"
                    :has-permission="hasViewPermission"
                  />
                </template>

                <!-- Actions -->
                <template v-if="hasEditPermission" #item.actions="{ item }">
                  <v-btn icon size="small" variant="text" @click="handleEditDocument(item.id)">
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn>
                </template>

                <!-- Loading -->
                <template #loading>
                  <v-skeleton-loader type="table-row@5" />
                </template>

                <!-- No data -->
                <template #no-data>
                  <div class="text-center py-4">
                    <p class="text-body-1">No documents found</p>
                  </div>
                </template>
              </v-data-table>

              <!-- Pagination -->
              <div v-if="documents.length > itemsPerPage" class="text-center mt-4">
                <v-pagination v-model="page" :length="totalPages" :total-visible="7" />
              </div>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>

    <!-- Add/Edit Dialog -->
    <AddEditDocumentDialog
      :open="dialogOpen"
      :user-document-id="selectedDocumentId"
      :existing-doc-types="existingDocTypes"
      :current-doc-type="currentDocType"
      :employee-id="employeeId"
      @close="handleCloseDialog"
      @saved="handleDocumentSaved"
    />
  </div>
</template>

<style scoped>
.documents-page {
  padding: 20px 0;
}
</style>

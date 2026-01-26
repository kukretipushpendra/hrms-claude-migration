<template>
  <v-container fluid>
    <v-card elevation="3">
      <v-card-title class="d-flex align-center justify-space-between pa-4 border-b">
        <h2 class="text-h5">Certificate Details</h2>
        <v-btn
          v-if="hasPermission('Create.Certificate')"
          color="primary"
          prepend-icon="mdi-plus"
          size="small"
          @click="handleOpenPopup"
        >
          Add Certificate
        </v-btn>
      </v-card-title>

      <v-card-text class="pa-5">
        <!-- Loading State -->
        <div v-if="loading" class="d-flex justify-center align-center" style="min-height: 400px">
          <v-progress-circular indeterminate size="64"></v-progress-circular>
        </div>

        <!-- Data Table -->
        <v-data-table-server
          v-else
          v-model:items-per-page="itemsPerPage"
          v-model:page="page"
          v-model:sort-by="sortBy"
          :headers="headers"
          :items="certificates"
          :items-length="totalRecords"
          :loading="loading"
          class="elevation-1"
          item-value="id"
        >
          <template #item.sNo="{ index }">
            {{ (page - 1) * itemsPerPage + index + 1 }}
          </template>

          <template #item.certificateName="{ item }">
            <v-tooltip :text="item.certificateName" location="bottom">
              <template #activator="{ props }">
                <span v-bind="props">
                  {{ truncateText(item.certificateName, 20) }}
                </span>
              </template>
            </v-tooltip>
          </template>

          <template #item.certificateExpiry="{ item }">
            {{ item.certificateExpiry ? formatDate(item.certificateExpiry) : '' }}
          </template>

          <template #item.attachment="{ item }">
            <v-tooltip
              :text="
                hasPermission('Read.Certificate') ? 'View Attachment' : 'No permission to view'
              "
              location="bottom"
            >
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  icon
                  size="small"
                  variant="text"
                  :color="hasPermission('Read.Certificate') ? 'primary' : 'grey'"
                  :disabled="!hasPermission('Read.Certificate') || viewingDocument"
                  @click="handlePreviewDocument(item.fileName || '')"
                >
                  <v-icon>{{
                    hasPermission('Read.Certificate') ? 'mdi-eye' : 'mdi-eye-off'
                  }}</v-icon>
                </v-btn>
              </template>
            </v-tooltip>
          </template>

          <template #item.actions="{ item }">
            <div class="d-flex gap-2">
              <v-tooltip
                v-if="hasPermission('Update.Certificate')"
                text="Edit Certificate"
                location="bottom"
              >
                <template #activator="{ props }">
                  <v-btn
                    v-bind="props"
                    icon
                    size="small"
                    variant="text"
                    color="primary"
                    @click="handleEditClick(item)"
                  >
                    <v-icon size="20">mdi-pencil</v-icon>
                  </v-btn>
                </template>
              </v-tooltip>

              <v-tooltip
                v-if="hasPermission('Delete.Certificate')"
                text="Delete Certificate"
                location="bottom"
              >
                <template #activator="{ props }">
                  <v-btn
                    v-bind="props"
                    icon
                    size="small"
                    variant="text"
                    color="error"
                    @click="openDeleteDialog(item.id)"
                  >
                    <v-icon size="20">mdi-delete</v-icon>
                  </v-btn>
                </template>
              </v-tooltip>
            </div>
          </template>
        </v-data-table-server>
      </v-card-text>
    </v-card>

    <!-- Add/Edit Certificate Dialog -->
    <AddCertificateDialog
      v-model="isPopupOpen"
      :certificate-id="selectedCertificateId"
      :existing-certificates="existingCertificates"
      :current-certificate="currentCertificate"
      :employee-id="employeeId"
      @close="handleClosePopup"
      @success="handleClosePopup"
    />

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="isConfirmationDialogOpen" max-width="500">
      <v-card>
        <v-card-title>Delete Certificate Detail</v-card-title>
        <v-card-text>
          Are you sure you want to proceed? The selected certificate detail will be deleted.
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="handleConfirmationDialogClose">Cancel</v-btn>
          <v-btn color="error" @click="handleCertificateDetailDelete(certificateDetailToDeleteId)">
            Delete
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- File Preview Dialog -->
    <v-dialog v-model="previewOpen" max-width="900px">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center">
          <span>Certificate Document Preview</span>
          <v-btn icon variant="text" @click="previewOpen = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text>
          <iframe
            v-if="byteArray"
            :src="`data:application/pdf;base64,${byteArray}`"
            width="100%"
            height="600px"
            style="border: none"
          ></iframe>
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import { useSnackbar } from '@/composables/useSnackbar';
import { certificateService, type Certificate } from '@/services/certificates';
import AddCertificateDialog from '@/components/certificates/AddCertificateDialog.vue';
import moment from 'moment';

const route = useRoute();
const authStore = useAuthStore();
const { showSuccess, showError } = useSnackbar();

// Employee ID from query params or current user
const employeeId = computed(() => {
  const queryId = route.query.employeeId;
  return queryId ? Number(queryId) : Number(authStore.user?.id || 0);
});

// Data
const certificates = ref<Certificate[]>([]);
const totalRecords = ref(0);
const loading = ref(false);
const page = ref(1);
const itemsPerPage = ref(10);
const sortBy = ref<Array<{ key: string; order: 'asc' | 'desc' }>>([
  { key: 'certificateName', order: 'asc' },
]);

// Dialog states
const isPopupOpen = ref(false);
const selectedCertificateId = ref(0);
const currentCertificate = ref('');
const isConfirmationDialogOpen = ref(false);
const certificateDetailToDeleteId = ref<number | null>(null);

// File preview
const byteArray = ref<string>('');
const previewOpen = ref(false);
const viewingDocument = ref(false);

// Table headers
const headers = computed(() => {
  const baseHeaders = [
    { title: 'S.No', key: 'sNo', sortable: false, width: 80 },
    { title: 'Certificate Name', key: 'certificateName', sortable: true, width: 250 },
    { title: 'Expiry Date', key: 'certificateExpiry', sortable: false, width: 150 },
    { title: 'Attachment', key: 'attachment', sortable: false, width: 100 },
  ];

  const hasEditOrDelete =
    hasPermission('Update.Certificate') || hasPermission('Delete.Certificate');

  if (hasEditOrDelete) {
    baseHeaders.push({ title: 'Actions', key: 'actions', sortable: false, width: 120 });
  }

  return baseHeaders;
});

// Computed
const existingCertificates = computed(() => certificates.value.map((cert) => cert.certificateName));

// Methods
const hasPermission = (permission: string): boolean => {
  return authStore.hasPermission(permission);
};

const formatDate = (dateString: string) => {
  return moment(dateString, 'YYYY-MM-DD').format('MMM Do, YYYY');
};

const truncateText = (text: string, maxLength: number) => {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
};

const mapSortingToApiParams = () => {
  if (sortBy.value.length === 0) {
    return { sortColumnName: 'certificateName', sortDirection: 'asc' };
  }
  const sort = sortBy.value[0];
  return {
    sortColumnName: sort.key,
    sortDirection: sort.order,
  };
};

const fetchCertificates = async () => {
  if (!employeeId.value) return;

  loading.value = true;
  try {
    const response = await certificateService.getCertificateList({
      ...mapSortingToApiParams(),
      startIndex: page.value,
      pageSize: itemsPerPage.value,
      filters: {
        employeeId: employeeId.value,
      },
    });

    certificates.value = response.result?.userCertificateResponseList || [];
    totalRecords.value = response.result?.totalRecords || 0;
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch certificates');
  } finally {
    loading.value = false;
  }
};

const handleOpenPopup = () => {
  isPopupOpen.value = true;
};

const handleClosePopup = () => {
  isPopupOpen.value = false;
  selectedCertificateId.value = 0;
  currentCertificate.value = '';
  fetchCertificates();
};

const handleEditClick = (certificate: Certificate) => {
  if (certificate) {
    selectedCertificateId.value = certificate.id;
    isPopupOpen.value = true;
    currentCertificate.value = certificate.certificateName;
  } else {
    selectedCertificateId.value = 0;
    isPopupOpen.value = false;
    currentCertificate.value = '';
    showError('Certificate Id not found');
  }
};

const openDeleteDialog = (id: number) => {
  isConfirmationDialogOpen.value = true;
  certificateDetailToDeleteId.value = id;
};

const handleConfirmationDialogClose = () => {
  isConfirmationDialogOpen.value = false;
};

const handleCertificateDetailDelete = async (id: number | null) => {
  try {
    if (!id) {
      throw new Error('The provided id is invalid. Expected a number. Instead got null value');
    }
    const payload = {
      id,
      isArchived: true,
    };
    await certificateService.deleteCertificateDetail(payload);
    showSuccess('Certificate detail deleted successfully');
    fetchCertificates();
    isConfirmationDialogOpen.value = false;
  } catch (error) {
    if (error instanceof Error) {
      console.error(error.stack);
      showError('Something went wrong. Please try again.');
    }
  }
};

const handlePreviewDocument = async (fileName: string) => {
  if (!fileName) {
    showError('File name is not available');
    return;
  }

  const fileExt = fileName?.split('.').pop();
  if (!fileExt) {
    showError('Invalid file');
    return;
  }

  viewingDocument.value = true;
  try {
    const response = await certificateService.downloadCertificateDocument(fileName);
    const fileContent = response.result;
    if (fileContent) {
      byteArray.value = fileContent;
      previewOpen.value = true;
    }
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to preview document');
  } finally {
    viewingDocument.value = false;
  }
};

// Watchers
watch([page, itemsPerPage, sortBy], () => {
  fetchCertificates();
});

watch(
  () => employeeId.value,
  () => {
    if (employeeId.value) {
      fetchCertificates();
    }
  }
);

// Lifecycle
onMounted(() => {
  if (employeeId.value) {
    fetchCertificates();
  }
});
</script>

<style scoped>
.border-b {
  border-bottom: 1px solid rgba(0, 0, 0, 0.12);
}
</style>

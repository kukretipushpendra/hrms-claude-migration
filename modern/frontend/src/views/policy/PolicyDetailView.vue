<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import {
  getCompanyPolicyById,
  publishCompanyPolicy,
  getDocumentDownloadUrl,
  type CompanyPolicyDetail,
} from '@/services/policy';
import { useAuthStore } from '@/stores/auth.store';

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();

// State
const policy = ref<CompanyPolicyDetail | null>(null);
const loading = ref(false);
const publishing = ref(false);

// Permission checks
const hasReadPermission = computed(() => authStore.hasPermission('Read.CompanyPolicy'));
const hasUpdatePermission = computed(() => authStore.hasPermission('Update.CompanyPolicy'));

// Document URL
const documentUrl = computed(() => {
  if (policy.value?.companyPolicyId) {
    return getDocumentDownloadUrl(policy.value.companyPolicyId);
  }
  return null;
});

// Fetch policy details
const fetchPolicy = async () => {
  const id = Number(route.params.id);
  if (!id || !hasReadPermission.value) {
    return;
  }

  loading.value = true;
  try {
    const response = await getCompanyPolicyById(id);
    if (response.statusCode === 200 && response.result) {
      policy.value = response.result;
    }
  } catch (error) {
    console.error('Failed to fetch policy:', error);
  } finally {
    loading.value = false;
  }
};

// Toggle publish status
const handlePublish = async () => {
  if (!policy.value || !hasUpdatePermission.value) {
    return;
  }

  publishing.value = true;
  try {
    const response = await publishCompanyPolicy(policy.value.companyPolicyId);
    if (response.statusCode === 200) {
      // Refresh to get updated status
      await fetchPolicy();
    }
  } catch (error) {
    console.error('Failed to publish policy:', error);
  } finally {
    publishing.value = false;
  }
};

// Edit policy
const handleEdit = () => {
  if (policy.value) {
    router.push({ name: 'policy-edit', params: { id: policy.value.companyPolicyId } });
  }
};

// Go back
const handleBack = () => {
  router.push({ name: 'company-policy' });
};

// Format date
const formatDate = (dateString: string) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
};

// Download document
const handleDownload = () => {
  if (documentUrl.value) {
    window.open(documentUrl.value, '_blank');
  }
};

// Lifecycle
onMounted(() => {
  fetchPolicy();
});
</script>

<template>
  <v-container fluid class="pa-6">
    <v-card :loading="loading">
      <!-- Header -->
      <v-card-title class="d-flex justify-space-between align-center">
        <div class="d-flex align-center gap-2">
          <v-btn icon variant="text" @click="handleBack">
            <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
          <h2 class="text-h5">Policy Document Details</h2>
        </div>
        <div class="d-flex gap-2">
          <v-btn
            v-if="hasUpdatePermission && policy"
            color="primary"
            variant="outlined"
            prepend-icon="mdi-pencil"
            @click="handleEdit"
          >
            Edit
          </v-btn>
          <v-btn
            v-if="hasUpdatePermission && policy"
            :color="policy.status === 'Published' ? 'warning' : 'success'"
            :loading="publishing"
            @click="handlePublish"
          >
            {{ policy.status === 'Published' ? 'Unpublish' : 'Publish' }}
          </v-btn>
        </div>
      </v-card-title>

      <v-divider />

      <!-- Content -->
      <v-card-text v-if="!loading && policy">
        <v-row>
          <v-col cols="12" md="6">
            <div class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Policy Title</div>
              <div class="text-body-1">{{ policy.policyTitle }}</div>
            </div>

            <div class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Category</div>
              <div class="text-body-1">{{ policy.policyCategory }}</div>
            </div>

            <div class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Status</div>
              <v-chip
                :color="
                  policy.status === 'Published'
                    ? 'success'
                    : policy.status === 'Draft'
                      ? 'warning'
                      : 'default'
                "
                size="small"
              >
                {{ policy.status }}
              </v-chip>
            </div>

            <div class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Version</div>
              <div class="text-body-1">{{ policy.version }}</div>
            </div>
          </v-col>

          <v-col cols="12" md="6">
            <div class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Effective Date</div>
              <div class="text-body-1">{{ formatDate(policy.effectiveDate) }}</div>
            </div>

            <div v-if="policy.publishedDate" class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Published Date</div>
              <div class="text-body-1">{{ formatDate(policy.publishedDate) }}</div>
            </div>

            <div class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Created By</div>
              <div class="text-body-1">{{ policy.createdBy }}</div>
            </div>

            <div class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Created On</div>
              <div class="text-body-1">{{ formatDate(policy.createdOn) }}</div>
            </div>

            <div v-if="policy.modifiedBy" class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Modified By</div>
              <div class="text-body-1">{{ policy.modifiedBy }}</div>
            </div>

            <div v-if="policy.modifiedOn" class="mb-4">
              <div class="text-caption text-medium-emphasis mb-1">Modified On</div>
              <div class="text-body-1">{{ formatDate(policy.modifiedOn) }}</div>
            </div>
          </v-col>
        </v-row>

        <v-divider class="my-4" />

        <!-- Policy Content -->
        <div class="mb-4">
          <div class="text-caption text-medium-emphasis mb-1">Policy Content</div>
          <div class="text-body-1" style="white-space: pre-wrap">
            {{ policy.policyContent }}
          </div>
        </div>

        <!-- Document -->
        <v-divider v-if="documentUrl" class="my-4" />

        <div v-if="documentUrl" class="mb-4">
          <div class="text-caption text-medium-emphasis mb-2">Attached Document</div>
          <v-btn
            color="primary"
            variant="outlined"
            prepend-icon="mdi-download"
            @click="handleDownload"
          >
            Download {{ policy.fileOriginalName || 'Document' }}
          </v-btn>
        </div>
      </v-card-text>

      <!-- Loading state -->
      <v-card-text v-else-if="loading">
        <div class="d-flex justify-center align-center" style="min-height: 300px">
          <v-progress-circular indeterminate color="primary" />
        </div>
      </v-card-text>

      <!-- No data -->
      <v-card-text v-else>
        <v-alert type="warning" variant="tonal"> Policy not found </v-alert>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<style scoped>
.gap-2 {
  gap: 8px;
}
</style>

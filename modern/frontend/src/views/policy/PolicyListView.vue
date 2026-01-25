<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { getCompanyPolicies, type CompanyPolicyItem } from '@/services/policy';
import { useAuthStore } from '@/stores/auth.store';

const router = useRouter();
const authStore = useAuthStore();

// State
const policies = ref<CompanyPolicyItem[]>([]);
const loading = ref(false);
const totalRecords = ref(0);
const page = ref(1);
const itemsPerPage = ref(10);
const searchTitle = ref('');
const searchStatus = ref('');
const sortBy = ref<{ key: string; order: 'asc' | 'desc' }[]>([
  { key: 'createdOn', order: 'desc' },
]);

// Permission checks
const hasReadPermission = computed(() =>
  authStore.hasPermission('Read.CompanyPolicy')
);
const hasCreatePermission = computed(() =>
  authStore.hasPermission('Create.CompanyPolicy')
);
const hasUpdatePermission = computed(() =>
  authStore.hasPermission('Update.CompanyPolicy')
);

// Data table headers
const headers = computed(() => {
  const baseHeaders = [
    { title: 'S.No', key: 'sNo', sortable: false, width: '80px' },
    { title: 'Document Name', key: 'name', sortable: true, width: '250px' },
    { title: 'Version', key: 'versionNo', sortable: false, width: '100px' },
    { title: 'Category', key: 'documentCategory', sortable: true, width: '150px' },
    { title: 'Created By', key: 'createdBy', sortable: false, width: '150px' },
    { title: 'Created On', key: 'createdOn', sortable: true, width: '150px' },
    { title: 'Updated By', key: 'modifiedBy', sortable: false, width: '150px' },
    { title: 'Status', key: 'status', sortable: true, width: '120px' },
  ];

  if (hasReadPermission.value || hasUpdatePermission.value) {
    baseHeaders.push({
      title: 'Actions',
      key: 'actions',
      sortable: false,
      width: '120px',
    });
  }

  return baseHeaders;
});

// Computed items with serial numbers
const policiesWithSerial = computed(() => {
  return policies.value.map((policy, index) => ({
    ...policy,
    sNo: (page.value - 1) * itemsPerPage.value + index + 1,
  }));
});

// Status options
const statusOptions = [
  { value: '', title: 'All' },
  { value: 'Draft', title: 'Draft' },
  { value: 'Published', title: 'Published' },
  { value: 'Archived', title: 'Archived' },
];

// Fetch policies
const fetchPolicies = async () => {
  if (!hasReadPermission.value) {
    return;
  }

  loading.value = true;
  try {
    const sortColumn = sortBy.value[0]?.key || 'publishedDate';
    const sortDirection = sortBy.value[0]?.order || 'desc';

    const response = await getCompanyPolicies({
      Filters: {
        Name: searchTitle.value || undefined,
      },
      PageSize: itemsPerPage.value,
      StartIndex: page.value,
      SortColumnName: sortColumn,
      SortDirection: sortDirection,
    });

    if (response.statusCode === 200 && response.data) {
      policies.value = response.data.companyPolicyList || [];
      totalRecords.value = response.data.totalRecords || 0;
    }
  } catch (error) {
    console.error('Failed to fetch policies:', error);
  } finally {
    loading.value = false;
  }
};

// Event handlers
const handleSearch = () => {
  page.value = 1;
  fetchPolicies();
};

const handleReset = () => {
  searchTitle.value = '';
  searchStatus.value = '';
  page.value = 1;
  fetchPolicies();
};

const handlePageChange = (newPage: number) => {
  page.value = newPage;
  fetchPolicies();
};

const handleItemsPerPageChange = (newItemsPerPage: number) => {
  itemsPerPage.value = newItemsPerPage;
  page.value = 1;
  fetchPolicies();
};

const handleSortChange = (newSortBy: { key: string; order: 'asc' | 'desc' }[]) => {
  sortBy.value = newSortBy;
  fetchPolicies();
};

const viewPolicy = (id: number) => {
  router.push({ name: 'policy-detail', params: { id } });
};

const editPolicy = (id: number) => {
  router.push({ name: 'policy-edit', params: { id } });
};

const createPolicy = () => {
  router.push({ name: 'policy-create' });
};

const formatDate = (dateString: string) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};

// Lifecycle
onMounted(() => {
  fetchPolicies();
});
</script>

<template>
  <v-container fluid class="pa-6">
    <v-card>
      <!-- Header -->
      <v-card-title class="d-flex justify-space-between align-center">
        <h2 class="text-h5">Company Policy</h2>
        <v-btn
          v-if="hasCreatePermission"
          color="primary"
          prepend-icon="mdi-plus"
          @click="createPolicy"
        >
          Add Policy
        </v-btn>
      </v-card-title>

      <v-divider />

      <!-- Search Filters -->
      <v-card-text>
        <v-row>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="searchTitle"
              label="Search by Title"
              density="compact"
              variant="outlined"
              clearable
              hide-details
              @keyup.enter="handleSearch"
            />
          </v-col>
          <v-col cols="12" md="3">
            <v-select
              v-model="searchStatus"
              :items="statusOptions"
              label="Status"
              density="compact"
              variant="outlined"
              hide-details
            />
          </v-col>
          <v-col cols="12" md="5" class="d-flex gap-2">
            <v-btn color="primary" @click="handleSearch"> Search </v-btn>
            <v-btn variant="outlined" @click="handleReset"> Reset </v-btn>
          </v-col>
        </v-row>
      </v-card-text>

      <v-divider />

      <!-- Data Table -->
      <v-data-table
        :headers="headers"
        :items="policiesWithSerial"
        :loading="loading"
        :items-length="totalRecords"
        :page="page"
        :items-per-page="itemsPerPage"
        :sort-by="sortBy"
        @update:page="handlePageChange"
        @update:items-per-page="handleItemsPerPageChange"
        @update:sort-by="handleSortChange"
        class="elevation-0"
      >
        <!-- Document Name Column -->
        <template #item.name="{ item }">
          <v-tooltip v-if="hasReadPermission" :text="item.name">
            <template #activator="{ props }">
              <a
                v-bind="props"
                class="text-primary text-decoration-none"
                @click.prevent="viewPolicy(item.id)"
              >
                {{
                  item.name.length > 30
                    ? item.name.substring(0, 30) + '...'
                    : item.name
                }}
              </a>
            </template>
          </v-tooltip>
          <span v-else>
            {{
              item.name.length > 30
                ? item.name.substring(0, 30) + '...'
                : item.name
            }}
          </span>
        </template>

        <!-- Created On Column -->
        <template #item.createdOn="{ item }">
          {{ formatDate(item.createdOn) }}
        </template>

        <!-- Status Column -->
        <template #item.status="{ item }">
          <v-chip
            :color="
              item.status === 'Published'
                ? 'success'
                : item.status === 'Draft'
                  ? 'warning'
                  : 'default'
            "
            size="small"
          >
            {{ item.status }}
          </v-chip>
        </template>

        <!-- Actions Column -->
        <template #item.actions="{ item }">
          <div class="d-flex gap-1">
            <v-tooltip v-if="hasReadPermission" text="View Document Details">
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  icon
                  size="small"
                  variant="text"
                  color="primary"
                  @click="viewPolicy(item.id)"
                >
                  <v-icon>mdi-eye</v-icon>
                </v-btn>
              </template>
            </v-tooltip>

            <v-tooltip v-if="hasUpdatePermission" text="Edit Document">
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  icon
                  size="small"
                  variant="text"
                  color="primary"
                  @click="editPolicy(item.id)"
                >
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
              </template>
            </v-tooltip>
          </div>
        </template>

        <!-- No data -->
        <template #no-data>
          <v-alert v-if="!loading" type="info" variant="tonal" class="ma-4">
            No company policies found
          </v-alert>
        </template>
      </v-data-table>
    </v-card>
  </v-container>
</template>

<style scoped>
.text-primary {
  cursor: pointer;
}
</style>

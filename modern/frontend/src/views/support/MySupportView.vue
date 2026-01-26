<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { getFeedbackByEmployee } from '@/services/support/support.service';
import EmployeeFilterForm from '@/components/support/EmployeeFilterForm.vue';
import SupportStatusChip from '@/components/support/SupportStatusChip.vue';
import { FEEDBACK_TYPE_LABEL } from '@/types/support.types';
import type { EmployeeFeedback, EmployeeFeedbackFilter } from '@/types/support.types';

const router = useRouter();

// Table data
const feedbackList = ref<EmployeeFeedback[]>([]);
const loading = ref(false);
const totalRecords = ref(0);

// Pagination
const page = ref(1);
const itemsPerPage = ref(10);

// Sorting
const sortBy = ref<{ key: string; order: 'asc' | 'desc' }[]>([{ key: 'createdOn', order: 'desc' }]);

// Filters
const showFilters = ref(false);
const filterFormRef = ref<InstanceType<typeof EmployeeFilterForm> | null>(null);
const filters = ref<EmployeeFeedbackFilter>({
  ticketStatus: undefined,
  feedbackType: undefined,
});

// Table headers (employee view has fewer columns)
const headers = [
  { title: 'ID', key: 'id', sortable: true },
  { title: 'Type', key: 'feedbackType', sortable: true },
  { title: 'Status', key: 'ticketStatus', sortable: true },
  { title: 'Subject', key: 'subject', sortable: true },
  { title: 'Created On', key: 'createdOn', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false, align: 'center' as const },
];

// Fetch data
async function fetchData() {
  loading.value = true;

  try {
    const sortColumn = sortBy.value[0]?.key || 'createdOn';
    const sortDirection = sortBy.value[0]?.order || 'desc';

    const response = await getFeedbackByEmployee({
      searchValue: '',
      pageNumber: page.value,
      pageSize: itemsPerPage.value,
      sortColumn,
      sortDirection,
      filter: filters.value,
    });

    feedbackList.value = response.feedbackList;
    totalRecords.value = response.totalRecords;
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    console.error('Failed to fetch feedback list:', err.response?.data?.message || error);
  } finally {
    loading.value = false;
  }
}

// Handle search from filter form
function handleSearch(newFilters: EmployeeFeedbackFilter) {
  filters.value = newFilters;
  page.value = 1; // Reset to first page
  fetchData();
}

// Handle filter reset
function handleFilterReset() {
  filters.value = {
    ticketStatus: undefined,
    feedbackType: undefined,
  };
  page.value = 1;
  fetchData();
}

// View details
function viewDetails(id: number) {
  router.push(`/Support/Support-Details/${id}`);
}

// Format date
function formatDate(dateString: string): string {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
}

// Watch for pagination/sorting changes
watch([page, itemsPerPage, sortBy], () => {
  fetchData();
});

// Initial fetch
onMounted(() => {
  fetchData();
});
</script>

<template>
  <div>
    <!-- Breadcrumbs -->
    <v-breadcrumbs
      :items="[
        { title: 'Home', to: '/dashboard' },
        { title: 'My Support', disabled: true },
      ]"
      class="pa-0 mb-4"
    />

    <!-- Page Card -->
    <v-card>
      <!-- Page Header -->
      <v-card-title class="pa-6 pb-0">
        <h2 class="text-h4 text-primary">My Support</h2>
      </v-card-title>

      <v-card-text class="pa-6">
        <!-- Filter Toggle Button -->
        <div class="d-flex justify-end mb-4">
          <v-btn
            variant="outlined"
            color="primary"
            prepend-icon="mdi-filter-variant"
            @click="showFilters = !showFilters"
          >
            {{ showFilters ? 'Hide' : 'Show' }} Filters
          </v-btn>
        </div>

        <!-- Filter Form -->
        <div v-if="showFilters" class="mb-4">
          <EmployeeFilterForm
            ref="filterFormRef"
            @search="handleSearch"
            @reset="handleFilterReset"
          />
        </div>

        <!-- Data Table -->
        <v-data-table-server
          :headers="headers"
          :items="feedbackList"
          :items-length="totalRecords"
          :loading="loading"
          v-model:page="page"
          v-model:items-per-page="itemsPerPage"
          v-model:sort-by="sortBy"
          :items-per-page-options="[10, 25, 50, 100]"
          class="elevation-1"
        >
          <!-- Type Column -->
          <template #item.feedbackType="{ item }">
            <v-chip size="small" color="primary" variant="outlined">
              {{ FEEDBACK_TYPE_LABEL[item.feedbackType] }}
            </v-chip>
          </template>

          <!-- Status Column -->
          <template #item.ticketStatus="{ item }">
            <SupportStatusChip :status="item.ticketStatus" />
          </template>

          <!-- Created On Column -->
          <template #item.createdOn="{ item }">
            {{ formatDate(item.createdOn) }}
          </template>

          <!-- Actions Column -->
          <template #item.actions="{ item }">
            <v-btn
              variant="text"
              color="primary"
              size="small"
              prepend-icon="mdi-eye"
              @click="viewDetails(item.id)"
            >
              View
            </v-btn>
          </template>

          <!-- No data -->
          <template #no-data>
            <div class="text-center py-8">
              <v-icon size="64" color="grey-lighten-1">mdi-inbox</v-icon>
              <p class="text-h6 mt-4">No support tickets found</p>
            </div>
          </template>
        </v-data-table-server>
      </v-card-text>
    </v-card>
  </div>
</template>

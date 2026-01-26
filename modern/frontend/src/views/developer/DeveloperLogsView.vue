<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import LogsFilterForm from '@/components/developer/LogsFilterForm.vue';
import { getDeveloperLogs } from '@/services/developer/developer.service';
import type { DeveloperLog, DeveloperLogsFilter } from '@/types/developer.types';
import { LogLevel } from '@/types/developer.types';
import { format } from 'date-fns';

const router = useRouter();

// State
const logs = ref<DeveloperLog[]>([]);
const loading = ref(false);
const totalRecords = ref(0);
const page = ref(1);
const itemsPerPage = ref(25);
const sortBy = ref<{ key: string; order: 'asc' | 'desc' }[]>([{ key: 'timestamp', order: 'desc' }]);

const showFilters = ref(false);
const filters = ref<DeveloperLogsFilter>({
  message: undefined,
  requestId: undefined,
  logLevel: null,
  fromDate: null,
  toDate: null,
});

// Table headers
const headers = [
  { title: 'ID', key: 'id', sortable: true },
  { title: 'Message', key: 'message', sortable: true },
  { title: 'Log Level', key: 'logLevel', sortable: true },
  { title: 'Timestamp', key: 'timestamp', sortable: true },
  { title: 'Request ID', key: 'requestId', sortable: false },
  { title: 'Log Event', key: 'logEvent', sortable: false },
  { title: 'Actions', key: 'actions', sortable: false },
];

// Fetch logs
const fetchLogs = async () => {
  loading.value = true;
  try {
    const sortColumn = sortBy.value[0]?.key || 'timestamp';
    const sortDirection = sortBy.value[0]?.order || 'desc';

    const response = await getDeveloperLogs({
      pageNumber: page.value,
      pageSize: itemsPerPage.value,
      sortColumn,
      sortDirection,
      filter: filters.value,
    });

    logs.value = response.logs;
    totalRecords.value = response.totalRecords;
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    console.error('Failed to fetch logs:', err.response?.data?.message || error);
    logs.value = [];
    totalRecords.value = 0;
  } finally {
    loading.value = false;
  }
};

// Format date
const formatDate = (dateString: string | null): string => {
  if (!dateString) return 'N/A';
  try {
    return format(new Date(dateString), 'yyyy MMM dd HH:mm:ss');
  } catch {
    return dateString;
  }
};

// Log level color
const getLogLevelColor = (level: string): string => {
  if (level === LogLevel.Error) return 'error';
  if (level === LogLevel.Warning) return 'warning';
  return 'default';
};

// Handle search
const handleSearch = (newFilters: DeveloperLogsFilter) => {
  filters.value = newFilters;
  page.value = 1; // Reset to first page
};

// Handle reset
const handleReset = () => {
  filters.value = {
    message: undefined,
    requestId: undefined,
    logLevel: null,
    fromDate: null,
    toDate: null,
  };
  page.value = 1;
};

// View log details
const viewLogDetails = (log: DeveloperLog) => {
  router.push({ name: 'developer-log-detail', params: { id: log.id } });
};

// Toggle filters
const toggleFilters = () => {
  showFilters.value = !showFilters.value;
};

// Watch for changes
watch([page, itemsPerPage, sortBy], () => {
  fetchLogs();
});

watch(filters, () => {
  fetchLogs();
});

onMounted(() => {
  fetchLogs();
});
</script>

<template>
  <v-container fluid>
    <v-card>
      <v-card-title class="d-flex justify-space-between align-center">
        <span>Developer Logs</span>
        <v-btn :color="showFilters ? 'primary' : 'default'" @click="toggleFilters">
          <v-icon start>{{ showFilters ? 'mdi-filter-off' : 'mdi-filter' }}</v-icon>
          {{ showFilters ? 'Hide Filters' : 'Show Filters' }}
        </v-btn>
      </v-card-title>

      <v-card-text>
        <LogsFilterForm
          v-if="showFilters"
          :initial-filters="filters"
          @search="handleSearch"
          @reset="handleReset"
        />

        <v-data-table-server
          :headers="headers"
          :items="logs"
          :loading="loading"
          :items-length="totalRecords"
          v-model:page="page"
          v-model:items-per-page="itemsPerPage"
          v-model:sort-by="sortBy"
          class="elevation-1"
        >
          <template #item.message="{ item }">
            <span class="text-truncate" style="max-width: 300px; display: block">
              {{ item.message || 'N/A' }}
            </span>
          </template>

          <template #item.logLevel="{ item }">
            <v-chip :color="getLogLevelColor(item.logLevel)" size="small">
              {{ item.logLevel }}
            </v-chip>
          </template>

          <template #item.timestamp="{ item }">
            {{ formatDate(item.timestamp) }}
          </template>

          <template #item.requestId="{ item }">
            <code class="request-id">{{ item.requestId || 'N/A' }}</code>
          </template>

          <template #item.actions="{ item }">
            <v-btn color="primary" size="small" variant="text" @click="viewLogDetails(item)">
              View
            </v-btn>
          </template>
        </v-data-table-server>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<style scoped>
.request-id {
  font-family: 'Courier New', monospace;
  font-size: 0.75rem;
  background-color: #f5f5f5;
  padding: 2px 4px;
  border-radius: 4px;
}

.text-truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>

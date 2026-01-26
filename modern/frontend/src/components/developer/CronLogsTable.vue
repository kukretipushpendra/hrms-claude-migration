<script setup lang="ts">
import { computed } from 'vue';
import type { CronLog } from '@/types/developer.types';
import { format } from 'date-fns';

interface Props {
  logs: CronLog[];
  loading: boolean;
  totalRecords: number;
  page: number;
  itemsPerPage: number;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'update:page', value: number): void;
  (e: 'update:itemsPerPage', value: number): void;
  (e: 'viewLog', logId: number): void;
}>();

// Table headers
const headers = [
  { title: 'ID', key: 'id', sortable: true },
  { title: 'Cron Name', key: 'cronName', sortable: false },
  { title: 'Payload', key: 'payload', sortable: false },
  { title: 'Started At', key: 'startedAt', sortable: true },
  { title: 'Completed At', key: 'completedAt', sortable: true },
  { title: 'Status', key: 'status', sortable: false },
  { title: 'Actions', key: 'actions', sortable: false },
];

// Format date
const formatDate = (dateString: string | null): string => {
  if (!dateString) return 'N/A';
  try {
    return format(new Date(dateString), 'yyyy MMM dd HH:mm:ss');
  } catch {
    return dateString;
  }
};

// Status color
const getStatusColor = (status: string): string => {
  if (status === 'Success') return 'success';
  if (status === 'Failed') return 'error';
  return 'warning';
};

// Computed items for table
const tableItems = computed(() => props.logs);
</script>

<template>
  <v-data-table-server
    :headers="headers"
    :items="tableItems"
    :loading="loading"
    :items-length="totalRecords"
    :page="page"
    :items-per-page="itemsPerPage"
    @update:page="emit('update:page', $event)"
    @update:items-per-page="emit('update:itemsPerPage', $event)"
  >
    <template #item.payload="{ item }">
      <pre class="payload-text">{{ item.payload || 'N/A' }}</pre>
    </template>

    <template #item.startedAt="{ item }">
      {{ formatDate(item.startedAt) }}
    </template>

    <template #item.completedAt="{ item }">
      {{ formatDate(item.completedAt) }}
    </template>

    <template #item.status="{ item }">
      <v-chip :color="getStatusColor(item.status)" size="small">
        {{ item.status }}
      </v-chip>
    </template>

    <template #item.actions="{ item }">
      <v-btn
        v-if="item.logId"
        color="primary"
        size="small"
        variant="text"
        @click="emit('viewLog', item.logId)"
      >
        View Log
      </v-btn>
    </template>
  </v-data-table-server>
</template>

<style scoped>
.payload-text {
  font-family: 'Courier New', monospace;
  font-size: 0.875rem;
  background-color: #f5f5f5;
  padding: 4px 8px;
  border-radius: 4px;
  max-width: 300px;
  overflow-x: auto;
  white-space: pre-wrap;
  word-break: break-word;
}
</style>

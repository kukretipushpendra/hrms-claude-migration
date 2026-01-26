<script setup lang="ts">
import { ref, computed } from 'vue';
import {
  FEEDBACK_TYPE_OPTIONS,
  FEEDBACK_STATUS_OPTIONS,
  DATE_RANGE_OPTIONS,
} from '@/types/support.types';
import type {
  FeedbackSearchFilter,
  DateRangeType,
  FeedbackStatusType,
  FeedbackTypeValue,
} from '@/types/support.types';

interface Emits {
  (e: 'search', filters: FeedbackSearchFilter): void;
  (e: 'reset'): void;
}

const emit = defineEmits<Emits>();

// Filter values
const ticketStatus = ref<number | null>(null);
const feedbackType = ref<number | null>(null);
const searchQuery = ref('');
const dateRange = ref<DateRangeType>('previous30Days');
const customDateFrom = ref<string | null>(null);
const customDateTo = ref<string | null>(null);

// Show custom date pickers when 'custom' is selected
const showCustomDates = computed(() => dateRange.value === 'custom');

// Calculate date range based on selection
function getDateRange(): { from: string | null; to: string | null } {
  const today = new Date();

  switch (dateRange.value) {
    case 'previous15Days': {
      const from = new Date(today);
      from.setDate(from.getDate() - 15);
      return {
        from: from.toISOString().split('T')[0] ?? null,
        to: today.toISOString().split('T')[0] ?? null,
      };
    }
    case 'previous30Days': {
      const from = new Date(today);
      from.setDate(from.getDate() - 30);
      return {
        from: from.toISOString().split('T')[0] ?? null,
        to: today.toISOString().split('T')[0] ?? null,
      };
    }
    case 'previous90Days': {
      const from = new Date(today);
      from.setDate(from.getDate() - 90);
      return {
        from: from.toISOString().split('T')[0] ?? null,
        to: today.toISOString().split('T')[0] ?? null,
      };
    }
    case 'custom':
      return {
        from: customDateFrom.value,
        to: customDateTo.value,
      };
    default:
      return { from: null, to: null };
  }
}

function handleSearch() {
  const { from, to } = getDateRange();

  const filters: FeedbackSearchFilter = {
    ticketStatus: ticketStatus.value as FeedbackStatusType | null ?? undefined,
    feedbackType: feedbackType.value as FeedbackTypeValue | null ?? undefined,
    searchQuery: searchQuery.value || '',
    createdOnFrom: from,
    createdOnTo: to,
    employeeCodes: [],
  };

  emit('search', filters);
}

function handleReset() {
  ticketStatus.value = null;
  feedbackType.value = null;
  searchQuery.value = '';
  dateRange.value = 'previous30Days';
  customDateFrom.value = null;
  customDateTo.value = null;

  emit('reset');
}

defineExpose({
  handleReset,
});
</script>

<template>
  <v-card variant="outlined" class="pa-4">
    <v-row>
      <!-- Status Filter -->
      <v-col cols="12" md="3">
        <v-select
          v-model="ticketStatus"
          label="Status"
          :items="FEEDBACK_STATUS_OPTIONS"
          item-title="label"
          item-value="value"
          clearable
          variant="outlined"
          density="comfortable"
        />
      </v-col>

      <!-- Type Filter -->
      <v-col cols="12" md="3">
        <v-select
          v-model="feedbackType"
          label="Type"
          :items="FEEDBACK_TYPE_OPTIONS"
          item-title="label"
          item-value="value"
          clearable
          variant="outlined"
          density="comfortable"
        />
      </v-col>

      <!-- Search Query -->
      <v-col cols="12" md="3">
        <v-text-field
          v-model="searchQuery"
          label="Search"
          placeholder="Search by subject, employee..."
          clearable
          variant="outlined"
          density="comfortable"
        />
      </v-col>

      <!-- Date Range -->
      <v-col cols="12" md="3">
        <v-select
          v-model="dateRange"
          label="Date Range"
          :items="DATE_RANGE_OPTIONS"
          item-title="label"
          item-value="id"
          variant="outlined"
          density="comfortable"
        />
      </v-col>

      <!-- Custom Date From (shown when custom selected) -->
      <v-col v-if="showCustomDates" cols="12" md="3">
        <v-text-field
          v-model="customDateFrom"
          label="From Date"
          type="date"
          variant="outlined"
          density="comfortable"
        />
      </v-col>

      <!-- Custom Date To (shown when custom selected) -->
      <v-col v-if="showCustomDates" cols="12" md="3">
        <v-text-field
          v-model="customDateTo"
          label="To Date"
          type="date"
          variant="outlined"
          density="comfortable"
        />
      </v-col>

      <!-- Action Buttons -->
      <v-col cols="12" class="d-flex justify-end gap-2">
        <v-btn variant="outlined" color="grey" @click="handleReset">Reset</v-btn>
        <v-btn variant="flat" color="primary" @click="handleSearch">Search</v-btn>
      </v-col>
    </v-row>
  </v-card>
</template>

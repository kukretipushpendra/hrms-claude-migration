<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import type {
  DeveloperLogsFilter,
  LogLevelType,
  DateRangePreset,
  DateRangePresetOption,
} from '@/types/developer.types';
import { LogLevel } from '@/types/developer.types';

interface Props {
  initialFilters?: DeveloperLogsFilter;
}

const props = withDefaults(defineProps<Props>(), {
  initialFilters: () => ({
    message: '',
    requestId: '',
    logLevel: null,
    fromDate: null,
    toDate: null,
  }),
});

const emit = defineEmits<{
  (e: 'search', filters: DeveloperLogsFilter): void;
  (e: 'reset'): void;
}>();

// Form state
const message = ref(props.initialFilters.message || '');
const requestId = ref(props.initialFilters.requestId || '');
const logLevel = ref<LogLevelType | null>(props.initialFilters.logLevel || null);
const selectedPreset = ref<DateRangePreset>('custom');
const fromDate = ref(props.initialFilters.fromDate || null);
const toDate = ref(props.initialFilters.toDate || null);

// Date range presets
const datePresets: DateRangePresetOption[] = [
  { value: 'last-15-min', label: 'Last 15 Minutes' },
  { value: 'last-1-hour', label: 'Last 1 Hour' },
  { value: 'today', label: 'Today' },
  { value: 'yesterday', label: 'Yesterday' },
  { value: 'last-7-days', label: 'Last 7 Days' },
  { value: 'custom', label: 'Custom' },
];

// Log level options
const logLevelOptions = [
  { title: 'All', value: null },
  { title: 'Warning', value: LogLevel.Warning },
  { title: 'Error', value: LogLevel.Error },
];

// Calculate date range based on preset
const calculateDateRange = (preset: DateRangePreset) => {
  const now = new Date();
  let from: Date | null = null;
  let to: Date | null = null;

  switch (preset) {
    case 'last-15-min':
      from = new Date(now.getTime() - 15 * 60 * 1000);
      to = now;
      break;
    case 'last-1-hour':
      from = new Date(now.getTime() - 60 * 60 * 1000);
      to = now;
      break;
    case 'today':
      from = new Date(now.setHours(0, 0, 0, 0));
      to = new Date();
      break;
    case 'yesterday':
      from = new Date(now.setDate(now.getDate() - 1));
      from.setHours(0, 0, 0, 0);
      to = new Date(from);
      to.setHours(23, 59, 59, 999);
      break;
    case 'last-7-days':
      from = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
      to = new Date();
      break;
    case 'custom':
      // Keep existing values
      return;
  }

  if (from && to) {
    fromDate.value = from.toISOString();
    toDate.value = to.toISOString();
  }
};

// Watch preset changes
watch(selectedPreset, (newPreset) => {
  calculateDateRange(newPreset);
});

// Computed: is custom date range
const isCustomDateRange = computed(() => selectedPreset.value === 'custom');

const handleSearch = () => {
  const filters: DeveloperLogsFilter = {
    message: message.value || undefined,
    requestId: requestId.value || undefined,
    logLevel: logLevel.value || null,
    fromDate: fromDate.value,
    toDate: toDate.value,
  };

  emit('search', filters);
};

const handleReset = () => {
  message.value = '';
  requestId.value = '';
  logLevel.value = null;
  selectedPreset.value = 'custom';
  fromDate.value = null;
  toDate.value = null;

  emit('reset');
  emit('search', {
    message: undefined,
    requestId: undefined,
    logLevel: null,
    fromDate: null,
    toDate: null,
  });
};

// Expose methods to parent
defineExpose({
  handleReset,
});
</script>

<template>
  <v-card class="mb-4">
    <v-card-text>
      <v-row>
        <v-col cols="12" md="6">
          <v-text-field
            v-model="message"
            label="Message"
            density="compact"
            clearable
            variant="outlined"
          />
        </v-col>

        <v-col cols="12" md="6">
          <v-text-field
            v-model="requestId"
            label="Request ID"
            density="compact"
            clearable
            variant="outlined"
          />
        </v-col>

        <v-col cols="12" md="4">
          <v-select
            v-model="logLevel"
            :items="logLevelOptions"
            label="Log Level"
            density="compact"
            variant="outlined"
            clearable
          />
        </v-col>

        <v-col cols="12" md="4">
          <v-select
            v-model="selectedPreset"
            :items="datePresets"
            item-title="label"
            item-value="value"
            label="Date Range"
            density="compact"
            variant="outlined"
          />
        </v-col>

        <v-col v-if="isCustomDateRange" cols="12" md="2">
          <v-text-field
            v-model="fromDate"
            label="From Date"
            type="datetime-local"
            density="compact"
            variant="outlined"
          />
        </v-col>

        <v-col v-if="isCustomDateRange" cols="12" md="2">
          <v-text-field
            v-model="toDate"
            label="To Date"
            type="datetime-local"
            density="compact"
            variant="outlined"
          />
        </v-col>

        <v-col cols="12" class="d-flex gap-2">
          <v-btn color="primary" @click="handleSearch">Search</v-btn>
          <v-btn variant="outlined" @click="handleReset">Reset</v-btn>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<style scoped>
.gap-2 {
  gap: 0.5rem;
}
</style>

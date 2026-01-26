<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue';
import { useRouter } from 'vue-router';
import CronLogsTable from '@/components/developer/CronLogsTable.vue';
import { getCronTypes, getCronLogs, runCron } from '@/services/developer/developer.service';
import type {
  CronTypeOption,
  CronLog,
  CronLogsFilter,
  CronTypeValue,
} from '@/types/developer.types';
import { CronType, CRON_TYPE_LABEL } from '@/types/developer.types';

const router = useRouter();

// Cron Types state
const cronTypes = ref<CronTypeOption[]>([]);
const selectedCronType = ref<CronTypeValue | null>(null);
const cronPayload = ref<Record<string, unknown>>({});

// Cron form state
const isRunning = ref(false);
const runSuccess = ref<string | null>(null);
const runError = ref<string | null>(null);

// Logs state
const logs = ref<CronLog[]>([]);
const logsLoading = ref(false);
const totalRecords = ref(0);
const page = ref(1);
const itemsPerPage = ref(25);

// Filters
const logsFilter = ref<CronLogsFilter>({
  cronId: null,
  fromDate: null,
  toDate: null,
});

// Fetch cron types
const fetchCronTypes = async () => {
  try {
    cronTypes.value = await getCronTypes();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    console.error('Failed to fetch cron types:', err.response?.data?.message || error);
  }
};

// Fetch cron logs
const fetchCronLogs = async () => {
  logsLoading.value = true;
  try {
    const response = await getCronLogs({
      pageNumber: page.value,
      pageSize: itemsPerPage.value,
      sortColumn: 'startedAt',
      sortDirection: 'desc',
      filter: logsFilter.value,
    });

    logs.value = response.cronLogs;
    totalRecords.value = response.totalRecords;
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    console.error('Failed to fetch cron logs:', err.response?.data?.message || error);
    logs.value = [];
    totalRecords.value = 0;
  } finally {
    logsLoading.value = false;
  }
};

// Run cron job
const handleRunCron = async () => {
  if (!selectedCronType.value) {
    runError.value = 'Please select a cron type';
    return;
  }

  isRunning.value = true;
  runSuccess.value = null;
  runError.value = null;

  try {
    const response = await runCron({
      cronId: selectedCronType.value,
      payload: cronPayload.value,
    });

    runSuccess.value = `Cron job started successfully. Execution ID: ${response.executionId}`;

    // Refresh logs after 2 seconds
    setTimeout(() => {
      fetchCronLogs();
    }, 2000);
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    runError.value = err.response?.data?.message || 'Failed to run cron job';
  } finally {
    isRunning.value = false;
  }
};

// View log details
const viewLogDetails = (logId: number) => {
  router.push({ name: 'developer-log-detail', params: { id: logId } });
};

// Computed: Cron type options for select
const cronTypeOptions = computed(() => {
  return cronTypes.value.map((cron) => ({
    title: CRON_TYPE_LABEL[cron.id] || cron.name,
    value: cron.id,
  }));
});

// Computed: Show payload fields based on selected cron
const showTimeDoctorForm = computed(
  () => selectedCronType.value === CronType.FetchTimeDoctorTimeSheetStats
);
const showLeaveCreditForm = computed(() => selectedCronType.value === CronType.MonthlyLeaveCredit);

// Reset payload when cron type changes
watch(selectedCronType, () => {
  cronPayload.value = {};
  runSuccess.value = null;
  runError.value = null;
});

// Watch page changes
watch([page, itemsPerPage], () => {
  fetchCronLogs();
});

watch(logsFilter, () => {
  fetchCronLogs();
});

onMounted(() => {
  fetchCronTypes();
  fetchCronLogs();
});
</script>

<template>
  <v-container fluid>
    <!-- Cron Run Section -->
    <v-card class="mb-4">
      <v-card-title>Cron Run</v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12" md="6">
            <v-select
              v-model="selectedCronType"
              :items="cronTypeOptions"
              label="Select Cron Type"
              variant="outlined"
              density="compact"
              clearable
            />
          </v-col>

          <!-- TimedDoctor Form -->
          <v-col v-if="showTimeDoctorForm" cols="12" md="6">
            <v-text-field
              v-model="cronPayload.date"
              label="Date (YYYY-MM-DD)"
              type="date"
              variant="outlined"
              density="compact"
              placeholder="2026-01-26"
            />
          </v-col>

          <!-- Monthly Leave Credit Form -->
          <v-col v-if="showLeaveCreditForm" cols="12" md="6">
            <v-text-field
              v-model="cronPayload.month"
              label="Month (1-12)"
              type="number"
              variant="outlined"
              density="compact"
              placeholder="1"
              min="1"
              max="12"
            />
          </v-col>

          <v-col v-if="showLeaveCreditForm" cols="12" md="6">
            <v-text-field
              v-model="cronPayload.year"
              label="Year"
              type="number"
              variant="outlined"
              density="compact"
              placeholder="2026"
            />
          </v-col>

          <v-col cols="12">
            <v-btn
              color="primary"
              :loading="isRunning"
              :disabled="!selectedCronType"
              @click="handleRunCron"
            >
              Run Cron
            </v-btn>
          </v-col>

          <v-col v-if="runSuccess" cols="12">
            <v-alert type="success" closable @click:close="runSuccess = null">
              {{ runSuccess }}
            </v-alert>
          </v-col>

          <v-col v-if="runError" cols="12">
            <v-alert type="error" closable @click:close="runError = null">
              {{ runError }}
            </v-alert>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- Cron Logs Table -->
    <v-card>
      <v-card-title>Cron Jobs History</v-card-title>
      <v-card-text>
        <CronLogsTable
          :logs="logs"
          :loading="logsLoading"
          :total-records="totalRecords"
          :page="page"
          :items-per-page="itemsPerPage"
          @update:page="page = $event"
          @update:items-per-page="itemsPerPage = $event"
          @view-log="viewLogDetails"
        />
      </v-card-text>
    </v-card>
  </v-container>
</template>

<style scoped>
/* Add any additional styles if needed */
</style>

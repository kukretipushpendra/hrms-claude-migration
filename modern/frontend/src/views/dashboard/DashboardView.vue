<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useAuthStore } from '@/stores/auth.store';
import { useFeatureFlagStore } from '@/stores/featureFlag.store';
import { format, subDays } from 'date-fns';

//Dashboard service (matching legacy endpoints)
import {
  getEmployeesCount,
  getBirthdayList,
  getWorkAnniversaryList,
  getUpcomingHolidayList,
  getHolidayList,
  getUpcomingEvents,
  getPublishedCompanyPolicies,
} from '@/services/dashboard';
import type {
  EmployeeCount,
  EmployeeBirthday,
  WorkAnniversary,
  Holiday,
  UpcomingEvent,
  CompanyPolicyDocument,
} from '@/services/dashboard';

// Components
import AnalyticsCard from '@/components/dashboard/AnalyticsCard.vue';
import DashboardTile from '@/components/dashboard/DashboardTile.vue';
import HolidayCalendarTile from '@/components/dashboard/HolidayCalendarTile.vue';
import CustomDatePicker from '@/components/dashboard/CustomDatePicker.vue';

const authStore = useAuthStore();
const featureFlagStore = useFeatureFlagStore();

// State
const loading = ref(true);
const error = ref<string | null>(null);
const selectedDays = ref('30');
const showCustomDatePicker = ref(false);
const customDateRange = ref<{ from: string; to: string; days: number } | null>(null);
const customLabel = ref('');

// Dashboard data (separate state for each section, like legacy)
const employeeCount = ref<EmployeeCount>({
  activeEmployeeCount: 0,
  newEmployeeCount: 0,
  exitOrgEmployeeCount: 0,
});
const birthdays = ref<EmployeeBirthday[]>([]);
const workAnniversaries = ref<WorkAnniversary[]>([]);
// Separate India and USA holidays (matching legacy)
const indiaHolidays = ref<Holiday[]>([]);
const usaHolidays = ref<Holiday[]>([]);
// All holidays for modal (not just upcoming)
const allIndiaHolidays = ref<Holiday[]>([]);
const allUsaHolidays = ref<Holiday[]>([]);
const upcomingEventsList = ref<UpcomingEvent[]>([]);
const companyPolicies = ref<CompanyPolicyDocument[]>([]);

// Day filter options (matching legacy exactly)
const dayOptions = [
  { title: 'Past 7 Days', value: '7' },
  { title: 'Past 15 Days', value: '15' },
  { title: 'Past 30 Days', value: '30' },
  { title: 'Custom', value: '-1' },
];

// Show "Apply New" tile if attendance OR leave enabled
const showApplyNewTile = computed(() => {
  const enableAttendance = featureFlagStore.flags.enableAttendance;
  const enableLeave = featureFlagStore.flags.enableLeave;
  return enableAttendance || enableLeave;
});

// Calculate from/to dates based on selected days or custom range
const dateRange = computed(() => {
  if (customDateRange.value) {
    return customDateRange.value;
  }

  const days = parseInt(selectedDays.value, 10);
  const today = new Date();
  const fromDate = subDays(today, days - 1); // Subtract 1 to make fromDate inclusive

  return {
    from: format(fromDate, 'yyyy-MM-dd'),
    to: format(today, 'yyyy-MM-dd'),
    days,
  };
});

// Display value for the dropdown (show custom label when active)
const displayDayOptions = computed(() => {
  if (customLabel.value) {
    return [...dayOptions.slice(0, 3), { title: customLabel.value, value: '-1' }];
  }
  return dayOptions;
});

// Fetch dashboard data using separate endpoints (matching legacy)
async function fetchDashboardData() {
  loading.value = true;
  error.value = null;

  try {
    // Fetch all data in parallel (like legacy)
    const [birthdayRes, workAnniversaryRes, upcomingHolidaysRes, allHolidaysRes] = await Promise.all([
      getBirthdayList(),
      getWorkAnniversaryList(),
      getUpcomingHolidayList(),
      getHolidayList(),
    ]);

    // Set public data
    birthdays.value = birthdayRes.result || [];
    workAnniversaries.value = workAnniversaryRes.result || [];

    // Store upcoming holidays separately (for preview in tile)
    if (upcomingHolidaysRes.result) {
      indiaHolidays.value = upcomingHolidaysRes.result.india || [];
      usaHolidays.value = upcomingHolidaysRes.result.usa || [];
    }

    // Store all holidays (for modal display)
    if (allHolidaysRes.result) {
      allIndiaHolidays.value = allHolidaysRes.result.india || [];
      allUsaHolidays.value = allHolidaysRes.result.usa || [];
    }

    // Fetch permission-gated data
    await fetchPermissionGatedData();
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'Failed to load dashboard data';
    console.error('Dashboard error:', e);
  } finally {
    loading.value = false;
  }
}

// Fetch data for all sections (no permission checks)
async function fetchPermissionGatedData() {
  const { from, to, days } = dateRange.value;

  // Fetch all data in parallel
  const promises: Promise<void>[] = [];

  // Employee count (all roles)
  // Legacy sends all three params: { from, to, days }
  promises.push(
    getEmployeesCount({ from, to, days })
      .then((res) => {
        if (res.result) {
          employeeCount.value = res.result;
        }
      })
      .catch((e) => console.error('Employee count error:', e))
  );

  // Upcoming events (always fetch)
  promises.push(
    getUpcomingEvents()
      .then((res) => {
        upcomingEventsList.value = res.result || [];
      })
      .catch((e) => console.error('Events error:', e))
  );

  // Company policies (always fetch)
  // Legacy sends only { from, to } - NOT days
  promises.push(
    getPublishedCompanyPolicies({ from, to })
      .then((res) => {
        companyPolicies.value = res.result || [];
      })
      .catch((e) => console.error('Policies error:', e))
  );

  await Promise.all(promises);
}

// Handle day filter change
async function handleDayChange(value: string) {
  if (value === '-1') {
    // Show custom date picker
    showCustomDatePicker.value = true;
    return;
  }

  // Clear custom range
  customDateRange.value = null;
  customLabel.value = '';
  selectedDays.value = value;

  // Refetch permission-gated data
  loading.value = true;
  try {
    await fetchPermissionGatedData();
  } finally {
    loading.value = false;
  }
}

// Handle custom date picker close
function handleCustomDatePickerClose() {
  showCustomDatePicker.value = false;

  // If no custom range was applied, reset to previous selection
  if (!customDateRange.value) {
    selectedDays.value = selectedDays.value === '-1' ? '30' : selectedDays.value;
  }
}

// Handle custom date range confirmation
async function handleCustomDateConfirm(data: {
  from: string;
  to: string;
  days: number;
  label: string;
}) {
  customDateRange.value = {
    from: data.from,
    to: data.to,
    days: data.days,
  };
  customLabel.value = data.label;
  selectedDays.value = '-1';
  showCustomDatePicker.value = false;

  // Refetch permission-gated data with custom range
  loading.value = true;
  try {
    await fetchPermissionGatedData();
  } finally {
    loading.value = false;
  }
}

// Helper to format name from first/middle/last
function formatName(first: string, middle?: string, last?: string): string {
  return [first, middle, last].filter(Boolean).join(' ');
}

// Helper to calculate years from date
function calculateYears(dateStr: string): number {
  const date = new Date(dateStr);
  const now = new Date();
  return now.getFullYear() - date.getFullYear();
}

// Helper to format date for display
function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
  });
}

onMounted(() => {
  fetchDashboardData();
});
</script>

<template>
  <div class="dashboard-page">
    <!-- Dashboard Header -->
    <v-row class="mb-6">
      <v-col cols="6">
        <h2 class="dashboard-heading">Dashboard</h2>
      </v-col>
      <v-col cols="6" class="d-flex justify-end">
        <v-select
          v-model="selectedDays"
          :items="displayDayOptions"
          item-title="title"
          item-value="value"
          variant="outlined"
          density="compact"
          hide-details
          style="max-width: 240px"
          @update:model-value="handleDayChange"
        />
      </v-col>
    </v-row>

    <!-- Custom Date Picker Dialog -->
    <CustomDatePicker
      :open="showCustomDatePicker"
      @close="handleCustomDatePickerClose"
      @confirm="handleCustomDateConfirm"
    />

    <!-- Loading State -->
    <v-row v-if="loading">
      <v-col cols="12" class="text-center py-12">
        <v-progress-circular indeterminate color="primary" size="64" />
        <p class="mt-4 text-grey-600">Loading dashboard...</p>
      </v-col>
    </v-row>

    <!-- Error State -->
    <v-row v-else-if="error">
      <v-col cols="12">
        <v-alert type="error" variant="tonal" class="mb-4">
          {{ error }}
          <template #append>
            <v-btn variant="text" size="small" @click="fetchDashboardData"> Retry </v-btn>
          </template>
        </v-alert>
      </v-col>
    </v-row>

    <!-- Dashboard Content -->
    <template v-else>
      <!-- Analytics Section (All users can see) -->
      <v-row class="mb-6">
        <v-col cols="12" md="4">
          <AnalyticsCard
            title="Total Active Employees"
            :count="employeeCount.activeEmployeeCount"
            icon="mdi-account-group"
          />
        </v-col>
        <v-col cols="12" md="4">
          <AnalyticsCard
            title="New Employees Enrolled"
            :count="employeeCount.newEmployeeCount"
            icon="mdi-account-plus"
          />
        </v-col>
        <v-col cols="12" md="4">
          <AnalyticsCard
            title="Employee Exit Organization"
            :count="employeeCount.exitOrgEmployeeCount"
            icon="mdi-account-remove"
          />
        </v-col>
      </v-row>

      <!-- Dashboard Tiles Grid (3 columns on md/lg) -->
      <v-row>
        <!-- Work Anniversary -->
        <v-col cols="12" md="4">
          <DashboardTile
            title="Work Anniversary"
            background-class="background-0"
            icon="mdi-cake-variant"
          >
            <template #content>
              <div v-if="workAnniversaries.length === 0" class="no-data">
                No work anniversaries this week
              </div>
              <v-list v-else density="compact" class="pa-0">
                <v-list-item
                  v-for="item in workAnniversaries.slice(0, 5)"
                  :key="item.id"
                  class="px-0"
                >
                  <template #prepend>
                    <v-avatar size="32" color="primary" class="mr-3">
                      <v-img v-if="item.profilePicPath" :src="item.profilePicPath" />
                      <span v-else class="text-caption">{{ item.firstName?.charAt(0) }}</span>
                    </v-avatar>
                  </template>
                  <v-list-item-title class="text-body-2">
                    {{ formatName(item.firstName, item.middleName, item.lastName) }}
                  </v-list-item-title>
                  <v-list-item-subtitle class="text-caption">
                    {{ calculateYears(item.joiningDate) }} years
                  </v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
          </DashboardTile>
        </v-col>

        <!-- Upcoming Holidays -->
        <v-col cols="12" md="4">
          <HolidayCalendarTile 
            :india-holidays="indiaHolidays" 
            :usa-holidays="usaHolidays"
            :all-india-holidays="allIndiaHolidays"
            :all-usa-holidays="allUsaHolidays"
          />
        </v-col>

        <!-- Apply New (if attendance OR leave enabled) -->
        <v-col v-if="showApplyNewTile" cols="12" md="4">
          <DashboardTile title="Apply New" background-class="background-0" icon="mdi-plus-circle">
            <template #content>
              <div class="d-flex flex-column gap-3">
                <v-btn
                  color="primary"
                  variant="outlined"
                  to="/leave/apply-leave"
                  block
                >
                  <v-icon start>mdi-calendar-remove</v-icon>
                  Apply Leave
                </v-btn>
                <v-btn
                  color="primary"
                  variant="outlined"
                  to="/attendance/my-attendance"
                  block
                >
                  <v-icon start>mdi-clock-check</v-icon>
                  View Attendance
                </v-btn>
              </div>
            </template>
          </DashboardTile>
        </v-col>

        <!-- Birthdays -->
        <v-col cols="12" md="4">
          <DashboardTile title="Birthdays" background-class="background-0" icon="mdi-cake">
            <template #content>
              <div v-if="birthdays.length === 0" class="no-data">No birthdays this week</div>
              <v-list v-else density="compact" class="pa-0">
                <v-list-item v-for="item in birthdays.slice(0, 5)" :key="item.id" class="px-0">
                  <template #prepend>
                    <v-avatar size="32" color="warning" class="mr-3">
                      <v-img v-if="item.profileImagePath" :src="item.profileImagePath" />
                      <span v-else class="text-caption">{{ item.firstName?.charAt(0) }}</span>
                    </v-avatar>
                  </template>
                  <v-list-item-title class="text-body-2">
                    {{ formatName(item.firstName, item.middleName, item.lastName) }}
                  </v-list-item-title>
                  <v-list-item-subtitle class="text-caption">
                    {{ formatDate(item.dob) }}
                  </v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
          </DashboardTile>
        </v-col>

        <!-- Company Policy Document -->
        <v-col cols="12" md="4">
          <DashboardTile
            title="Company Policy Document"
            background-class="background-0"
            icon="mdi-file-document"
          >
            <template #content>
              <div v-if="companyPolicies.length === 0" class="no-data">
                No policy documents available
              </div>
              <v-list v-else density="compact" class="pa-0">
                <v-list-item
                  v-for="item in companyPolicies.slice(0, 5)"
                  :key="item.id"
                  class="px-0"
                >
                  <template #prepend>
                    <v-icon size="20" color="primary" class="mr-2"> mdi-file-pdf-box </v-icon>
                  </template>
                  <v-list-item-title class="text-body-2">
                    {{ item.name }}
                  </v-list-item-title>
                  <v-list-item-subtitle class="text-caption">
                    {{ formatDate(item.updatedOn) }}
                  </v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
          </DashboardTile>
        </v-col>

        <!-- Upcoming Events -->
        <v-col cols="12" md="4">
          <DashboardTile
            title="Upcoming Events"
            background-class="background-0"
            icon="mdi-calendar-text"
          >
            <template #content>
              <div v-if="upcomingEventsList.length === 0" class="no-data">No upcoming events</div>
              <v-list v-else density="compact" class="pa-0">
                <v-list-item
                  v-for="item in upcomingEventsList.slice(0, 5)"
                  :key="item.id"
                  class="px-0"
                >
                  <v-list-item-title class="text-body-2">
                    {{ item.eventName }}
                  </v-list-item-title>
                  <v-list-item-subtitle class="text-caption">
                    {{ formatDate(item.startDate) }} - {{ item.venue }}
                  </v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
          </DashboardTile>
        </v-col>
      </v-row>
    </template>
  </div>
</template>

<style scoped lang="scss">
.dashboard-page {
  padding: 8px;
}

.dashboard-heading {
  font-size: 1.75rem;
  font-weight: 600;
  color: #273a50;
}

.no-data {
  color: #8c8c8c;
  font-size: 0.875rem;
  text-align: center;
  padding: 24px 16px;
}

.gap-3 {
  gap: 12px;
}
</style>

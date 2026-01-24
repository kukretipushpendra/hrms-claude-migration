<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useAuthStore } from '@/stores/auth.store';

// Dashboard service (matching legacy endpoints)
import {
  getEmployeesCount,
  getBirthdayList,
  getWorkAnniversaryList,
  getUpcomingHolidayList,
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

const authStore = useAuthStore();

// State
const loading = ref(true);
const error = ref<string | null>(null);
const selectedDays = ref('30');

// Dashboard data (separate state for each section, like legacy)
const employeeCount = ref<EmployeeCount>({
  activeEmployeeCount: 0,
  newEmployeeCount: 0,
  exitOrgEmployeeCount: 0,
});
const birthdays = ref<EmployeeBirthday[]>([]);
const workAnniversaries = ref<WorkAnniversary[]>([]);
const upcomingHolidays = ref<Holiday[]>([]);
const upcomingEventsList = ref<UpcomingEvent[]>([]);
const companyPolicies = ref<CompanyPolicyDocument[]>([]);

// Day filter options (matching legacy)
const dayOptions = [
  { title: 'Last 7 Days', value: '7' },
  { title: 'Last 30 Days', value: '30' },
  { title: 'Last 90 Days', value: '90' },
];

// Check if user is Employee role (for hiding analytics)
const isEmployee = computed(() => {
  return authStore.user?.roleName === 'EMPLOYEE';
});

// Check permissions for tiles
const hasAttendancePermission = computed(() =>
  authStore.hasPermission('ATTENDANCE.READ')
);
const hasLeavePermission = computed(() => authStore.hasPermission('LEAVE.READ'));
const hasCompanyPolicyPermission = computed(() =>
  authStore.hasPermission('COMPANY_POLICY.READ')
);
const hasEventsPermission = computed(() => authStore.hasPermission('EVENTS.READ'));

// Show "Apply New" tile if attendance OR leave enabled
const showApplyNewTile = computed(
  () => hasAttendancePermission.value || hasLeavePermission.value
);

// Fetch dashboard data using separate endpoints (matching legacy)
async function fetchDashboardData() {
  loading.value = true;
  error.value = null;

  try {
    // Fetch all data in parallel (like legacy)
    const [
      birthdayRes,
      workAnniversaryRes,
      holidaysRes,
    ] = await Promise.all([
      getBirthdayList(),
      getWorkAnniversaryList(),
      getUpcomingHolidayList(),
    ]);

    // Set public data
    birthdays.value = birthdayRes.result || [];
    workAnniversaries.value = workAnniversaryRes.result || [];

    // Merge India + USA holidays into single list
    if (holidaysRes.result) {
      upcomingHolidays.value = [
        ...(holidaysRes.result.india || []),
        ...(holidaysRes.result.usa || []),
      ].sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime());
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

// Fetch data that requires permissions
async function fetchPermissionGatedData() {
  const days = parseInt(selectedDays.value, 10);

  const promises: Promise<void>[] = [];

  // Employee count (non-employee roles only)
  if (!isEmployee.value) {
    promises.push(
      getEmployeesCount({ days })
        .then((res) => {
          if (res.result) {
            employeeCount.value = res.result;
          }
        })
        .catch((e) => console.error('Employee count error:', e))
    );
  }

  // Upcoming events (requires permission)
  if (hasEventsPermission.value) {
    promises.push(
      getUpcomingEvents()
        .then((res) => {
          upcomingEventsList.value = res.result || [];
        })
        .catch((e) => console.error('Events error:', e))
    );
  }

  // Company policies (requires permission)
  if (hasCompanyPolicyPermission.value) {
    promises.push(
      getPublishedCompanyPolicies({ days })
        .then((res) => {
          companyPolicies.value = res.result || [];
        })
        .catch((e) => console.error('Policies error:', e))
    );
  }

  await Promise.all(promises);
}

// Handle day filter change (refetch permission-gated data)
async function handleDayChange() {
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
          :items="dayOptions"
          item-title="title"
          item-value="value"
          variant="outlined"
          density="compact"
          hide-details
          style="max-width: 180px"
          @update:model-value="handleDayChange"
        />
      </v-col>
    </v-row>

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
            <v-btn variant="text" size="small" @click="fetchDashboardData">
              Retry
            </v-btn>
          </template>
        </v-alert>
      </v-col>
    </v-row>

    <!-- Dashboard Content -->
    <template v-else>
      <!-- Analytics Section (Non-Employee roles only) -->
      <v-row v-if="!isEmployee" class="mb-6">
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
          <DashboardTile
            title="Upcoming Holidays"
            background-class="background-1"
            icon="mdi-calendar-star"
          >
            <template #content>
              <div v-if="upcomingHolidays.length === 0" class="no-data">
                No upcoming holidays
              </div>
              <v-list v-else density="compact" class="pa-0">
                <v-list-item
                  v-for="(item, index) in upcomingHolidays.slice(0, 5)"
                  :key="index"
                  class="px-0"
                >
                  <v-list-item-title class="text-body-2">
                    {{ item.title }}
                  </v-list-item-title>
                  <v-list-item-subtitle class="text-caption">
                    {{ formatDate(item.date) }} ({{ item.location }})
                  </v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </template>
          </DashboardTile>
        </v-col>

        <!-- Apply New (if attendance OR leave enabled) -->
        <v-col v-if="showApplyNewTile" cols="12" md="4">
          <DashboardTile
            title="Apply New"
            background-class="background-2"
            icon="mdi-plus-circle"
          >
            <template #content>
              <div class="d-flex flex-column gap-3">
                <v-btn
                  v-if="hasLeavePermission"
                  color="primary"
                  variant="outlined"
                  to="/leave/apply-leave"
                  block
                >
                  <v-icon start>mdi-calendar-remove</v-icon>
                  Apply Leave
                </v-btn>
                <v-btn
                  v-if="hasAttendancePermission"
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
          <DashboardTile
            title="Birthdays"
            background-class="background-3"
            icon="mdi-cake"
          >
            <template #content>
              <div v-if="birthdays.length === 0" class="no-data">
                No birthdays this week
              </div>
              <v-list v-else density="compact" class="pa-0">
                <v-list-item
                  v-for="item in birthdays.slice(0, 5)"
                  :key="item.id"
                  class="px-0"
                >
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

        <!-- Company Policy Document (if permission) -->
        <v-col v-if="hasCompanyPolicyPermission" cols="12" md="4">
          <DashboardTile
            title="Company Policy Document"
            background-class="background-4"
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
                    <v-icon size="20" color="primary" class="mr-2">
                      mdi-file-pdf-box
                    </v-icon>
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

        <!-- Upcoming Events (if permission) -->
        <v-col v-if="hasEventsPermission" cols="12" md="4">
          <DashboardTile
            title="Upcoming Events"
            background-class="background-5"
            icon="mdi-calendar-text"
          >
            <template #content>
              <div v-if="upcomingEventsList.length === 0" class="no-data">
                No upcoming events
              </div>
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

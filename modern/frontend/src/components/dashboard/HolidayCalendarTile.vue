<script setup lang="ts">
/**
 * Holiday Calendar Tile - Matches Legacy React DashboardTile Exactly
 * Features:
 * - SVG flag icons for India/USA (not emoji)
 * - Flag selector in tile header with opacity toggle
 * - View More arrow icon to open modal
 * - Modal with full calendar table
 */
import { ref, computed, withDefaults } from 'vue';
import type { Holiday } from '@/services/dashboard';

interface Props {
  indiaHolidays: Holiday[];
  usaHolidays: Holiday[];
  allIndiaHolidays?: Holiday[];
  allUsaHolidays?: Holiday[];
}

const props = withDefaults(defineProps<Props>(), {
  allIndiaHolidays: () => [],
  allUsaHolidays: () => [],
});

// State
const selectedLocation = ref<'india' | 'usa'>('india');
const showDialog = ref(false);

// Get holidays based on selected location
// For tile preview: use upcoming holidays
// For modal: use all holidays if available, otherwise use upcoming
const filteredHolidays = computed(() => {
  let holidays: Holiday[];
  
  if (selectedLocation.value === 'india') {
    // Use all holidays for modal if available, otherwise use upcoming
    holidays = props.allIndiaHolidays && props.allIndiaHolidays.length > 0 
      ? props.allIndiaHolidays 
      : props.indiaHolidays;
  } else {
    // Use all holidays for modal if available, otherwise use upcoming
    holidays = props.allUsaHolidays && props.allUsaHolidays.length > 0 
      ? props.allUsaHolidays 
      : props.usaHolidays;
  }
  
  return [...holidays].sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime());
});

// Preview holidays (first 5)
const previewHolidays = computed(() => filteredHolidays.value.slice(0, 5));

// Format date for display
function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
  });
}

// Format date with year for table
function formatDateWithYear(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
}

// Get day of week
function getDayOfWeek(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', {
    weekday: 'long',
  });
}

// Handle flag selection
function selectLocation(location: 'india' | 'usa') {
  selectedLocation.value = location;
}

// Open dialog
function openDialog() {
  showDialog.value = true;
}
</script>

<template>
  <v-card flat class="dashboard-tile background-0">
    <!-- Tile Header - matching legacy exactly -->
    <div class="tile-header">
      <div class="d-flex align-center">
        <v-icon size="20" color="primary" class="mr-2">mdi-calendar-star</v-icon>
        <span class="tile-title">Upcoming Holidays</span>
      </div>

      <!-- Flag Selector & View More (right side) -->
      <div class="flag-container">
        <!-- India Flag -->
        <v-tooltip location="top">
          <template #activator="{ props: tooltipProps }">
            <div
              v-bind="tooltipProps"
              class="flag-wrapper"
              :class="{ selected: selectedLocation === 'india' }"
              @click="selectLocation('india')"
            >
              <img src="/icons/india.svg" alt="India" class="flag-icon" />
            </div>
          </template>
          <span>India</span>
        </v-tooltip>

        <!-- USA Flag -->
        <v-tooltip location="top">
          <template #activator="{ props: tooltipProps }">
            <div
              v-bind="tooltipProps"
              class="flag-wrapper"
              :class="{ selected: selectedLocation === 'usa' }"
              @click="selectLocation('usa')"
            >
              <img src="/icons/american.svg" alt="USA" class="flag-icon" />
            </div>
          </template>
          <span>USA</span>
        </v-tooltip>

        <!-- View More Arrow -->
        <v-tooltip location="top">
          <template #activator="{ props: tooltipProps }">
            <v-icon
              v-bind="tooltipProps"
              class="view-more-icon"
              size="20"
              color="primary"
              @click="openDialog"
            >
              mdi-arrow-top-right
            </v-icon>
          </template>
          <span>View More</span>
        </v-tooltip>
      </div>
    </div>

    <!-- Tile Content -->
    <div class="tile-content">
      <div v-if="previewHolidays.length === 0" class="no-data">No upcoming holidays</div>
      <v-list v-else density="compact" class="pa-0 bg-transparent">
        <v-list-item
          v-for="(item, index) in previewHolidays"
          :key="index"
          class="px-0 holiday-item"
        >
          <v-list-item-title class="text-body-2">
            {{ item.title }}
          </v-list-item-title>
          <v-list-item-subtitle class="text-caption">
            {{ formatDate(item.date) }}
          </v-list-item-subtitle>
        </v-list-item>
      </v-list>
    </div>

    <!-- Dialog for Full Calendar -->
    <v-dialog v-model="showDialog" max-width="800" scrollable>
      <v-card>
        <!-- Dialog Header -->
        <v-card-title class="dialog-header d-flex align-center justify-space-between">
          <span class="text-h6">Holiday Calendar</span>
          <div class="d-flex align-center gap-3">
            <!-- Flag Selector in Dialog -->
            <div class="flag-container">
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <div
                    v-bind="tooltipProps"
                    class="flag-wrapper"
                    :class="{ selected: selectedLocation === 'india' }"
                    @click="selectLocation('india')"
                  >
                    <img src="/icons/india.svg" alt="India" class="flag-icon" />
                  </div>
                </template>
                <span>India</span>
              </v-tooltip>

              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <div
                    v-bind="tooltipProps"
                    class="flag-wrapper"
                    :class="{ selected: selectedLocation === 'usa' }"
                    @click="selectLocation('usa')"
                  >
                    <img src="/icons/american.svg" alt="USA" class="flag-icon" />
                  </div>
                </template>
                <span>USA</span>
              </v-tooltip>
            </div>

            <v-btn icon variant="text" size="small" @click="showDialog = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </div>
        </v-card-title>

        <v-divider />

        <!-- Dialog Content - Table -->
        <v-card-text class="pa-0">
          <v-table class="holiday-table">
            <thead>
              <tr>
                <th class="text-left table-header-cell" style="width: 50px">SNO</th>
                <th class="text-left table-header-cell" style="width: 120px">DATE</th>
                <th class="text-left table-header-cell" style="width: 100px">DAY</th>
                <th class="text-left table-header-cell">REMARKS</th>
                <th class="text-left table-header-cell" style="width: 80px">LOCATION</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in filteredHolidays" :key="index" class="table-row">
                <td class="table-cell">{{ index + 1 }}</td>
                <td class="table-cell">{{ formatDateWithYear(item.date) }}</td>
                <td class="table-cell">{{ getDayOfWeek(item.date) }}</td>
                <td class="table-cell">{{ item.title }}</td>
                <td class="table-cell">{{ item.location }}</td>
              </tr>
            </tbody>
          </v-table>

          <div v-if="filteredHolidays.length === 0" class="text-center py-8 text-grey-600">
            No holidays for {{ selectedLocation === 'india' ? 'India' : 'USA' }}
          </div>
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-card>
</template>

<style scoped lang="scss">
.dashboard-tile {
  border-radius: 15px;
  min-height: 250px;
  height: 250px;
  border: 1px solid #c7d9eb;
  background: #f4fafd;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  filter: drop-shadow(2.939px 4.045px 5px rgba(0, 0, 0, 0.08));

  &.background-0 {
    background-color: #f4fafd;
  }
}

.tile-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.tile-title {
  font-size: 0.9375rem;
  font-weight: 600;
  color: #1e75bb;
}

.flag-container {
  display: flex;
  gap: 5px;
  align-items: center;
}

.flag-wrapper {
  cursor: pointer;
  opacity: 0.4;
  transition: opacity 0.3s ease;
  padding: 2px;

  &:hover {
    opacity: 0.7;
  }

  &.selected {
    opacity: 1;
  }
}

.flag-icon {
  width: 30px;
  height: auto;
  display: block;
}

.view-more-icon {
  cursor: pointer;
  margin-left: 8px;

  &:hover {
    opacity: 0.7;
  }
}

.tile-content {
  flex: 1;
  padding: 10px 15px;
  overflow-y: auto;

  // Custom scrollbar
  &::-webkit-scrollbar {
    width: 4px;
  }

  &::-webkit-scrollbar-track {
    background: transparent;
  }

  &::-webkit-scrollbar-thumb {
    background: #d9d9d9;
    border-radius: 2px;
  }
}

.holiday-item {
  margin-bottom: 4px;
}

.no-data {
  color: #8c8c8c;
  font-size: 0.875rem;
  text-align: center;
  padding: 24px 16px;
}

.dialog-header {
  padding: 16px 24px;
}

.gap-3 {
  gap: 12px;
}

.holiday-table {
  .table-row:hover {
    background-color: #f1f1f1;
    transition: background-color 0.3s;
  }

  .table-cell {
    font-size: 11px;
    padding: 8px 16px;
  }

  .table-header-cell {
    font-weight: bold;
    font-size: 10.5px;
    padding: 12px 16px;
    background: #1e75bb !important; // Blue header matching legacy
    color: #ffffff !important;
  }
}

.bg-transparent {
  background: transparent !important;
}
</style>

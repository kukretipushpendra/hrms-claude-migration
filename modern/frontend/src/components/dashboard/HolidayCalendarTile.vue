<script setup lang="ts">
import { ref, computed } from 'vue';
import type { Holiday } from '@/services/dashboard';

interface Props {
  holidays: Holiday[];
}

const props = defineProps<Props>();

// State
const selectedLocation = ref<'india' | 'usa'>('india');
const showDialog = ref(false);

// Filter holidays by selected location
const filteredHolidays = computed(() => {
  return props.holidays
    .filter((h) => h.location.toLowerCase() === selectedLocation.value)
    .sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime());
});

// Preview holidays (first 5)
const previewHolidays = computed(() => filteredHolidays.value.slice(0, 5));

// All holidays for dialog
const allHolidays = computed(() => filteredHolidays.value);

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
  <v-card class="holiday-tile" elevation="2">
    <!-- Header -->
    <v-card-title class="tile-header d-flex align-center justify-space-between">
      <div class="d-flex align-center gap-2">
        <v-icon color="white">mdi-calendar-star</v-icon>
        <span>Upcoming Holidays</span>
      </div>
      <!-- Flag Selector -->
      <div class="flag-selector d-flex gap-2">
        <button
          class="flag-btn"
          :class="{ 'flag-selected': selectedLocation === 'india' }"
          @click="selectLocation('india')"
        >
          🇮🇳
        </button>
        <button
          class="flag-btn"
          :class="{ 'flag-selected': selectedLocation === 'usa' }"
          @click="selectLocation('usa')"
        >
          🇺🇸
        </button>
      </div>
    </v-card-title>

    <!-- Content -->
    <v-card-text class="tile-content">
      <div v-if="previewHolidays.length === 0" class="no-data">No upcoming holidays</div>
      <v-list v-else density="compact" class="pa-0">
        <v-list-item
          v-for="(item, index) in previewHolidays"
          :key="index"
          class="px-0 holiday-item"
        >
          <v-list-item-title class="text-body-2">
            {{ item.title }}
          </v-list-item-title>
          <v-list-item-subtitle class="text-caption">
            {{ formatDate(item.date) }} ({{ item.location }})
          </v-list-item-subtitle>
        </v-list-item>
      </v-list>

      <!-- View More Button -->
      <v-btn
        v-if="filteredHolidays.length > 5"
        variant="text"
        color="primary"
        size="small"
        class="mt-2 view-more-btn"
        @click="openDialog"
      >
        View More
        <v-icon end>mdi-arrow-right</v-icon>
      </v-btn>
    </v-card-text>

    <!-- Dialog for Full Calendar -->
    <v-dialog v-model="showDialog" max-width="800px">
      <v-card>
        <!-- Dialog Header -->
        <v-card-title class="dialog-header d-flex align-center justify-space-between">
          <span class="text-h6">Holiday Calendar</span>
          <div class="d-flex align-center gap-3">
            <!-- Flag Selector in Dialog -->
            <div class="flag-selector d-flex gap-2">
              <button
                class="flag-btn"
                :class="{ 'flag-selected': selectedLocation === 'india' }"
                @click="selectLocation('india')"
              >
                🇮🇳
              </button>
              <button
                class="flag-btn"
                :class="{ 'flag-selected': selectedLocation === 'usa' }"
                @click="selectLocation('usa')"
              >
                🇺🇸
              </button>
            </div>
            <v-btn icon variant="text" @click="showDialog = false">
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </div>
        </v-card-title>

        <v-divider />

        <!-- Dialog Content - Table -->
        <v-card-text class="pa-4">
          <v-table>
            <thead>
              <tr>
                <th class="text-left">SNO</th>
                <th class="text-left">DATE</th>
                <th class="text-left">DAY</th>
                <th class="text-left">REMARKS</th>
                <th class="text-left">LOCATION</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in allHolidays" :key="index">
                <td>{{ index + 1 }}</td>
                <td>{{ formatDateWithYear(item.date) }}</td>
                <td>{{ getDayOfWeek(item.date) }}</td>
                <td>{{ item.title }}</td>
                <td>{{ item.location }}</td>
              </tr>
            </tbody>
          </v-table>

          <div v-if="allHolidays.length === 0" class="text-center py-8 text-grey-600">
            No holidays for {{ selectedLocation === 'india' ? 'India' : 'USA' }}
          </div>
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-card>
</template>

<style scoped lang="scss">
.holiday-tile {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.tile-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 16px;
  font-weight: 600;
}

.flag-selector {
  display: flex;
  gap: 8px;
}

.flag-btn {
  background: transparent;
  border: none;
  cursor: pointer;
  font-size: 24px;
  line-height: 1;
  padding: 4px;
  opacity: 0.4;
  transition: opacity 0.2s ease;

  &:hover {
    opacity: 0.7;
  }

  &.flag-selected {
    opacity: 1;
  }
}

.tile-content {
  flex: 1;
  padding: 16px;
}

.holiday-item {
  margin-bottom: 8px;
}

.no-data {
  color: #8c8c8c;
  font-size: 0.875rem;
  text-align: center;
  padding: 24px 16px;
}

.view-more-btn {
  width: 100%;
}

.dialog-header {
  padding: 16px 24px;
}

.gap-2 {
  gap: 8px;
}

.gap-3 {
  gap: 12px;
}
</style>

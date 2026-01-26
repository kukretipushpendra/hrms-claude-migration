<script setup lang="ts">
import { ref, computed } from 'vue';
import { format, parse } from 'date-fns';

interface Props {
  open: boolean;
}

defineProps<Props>();

const emit = defineEmits<{
  (e: 'close'): void;
  (e: 'confirm', data: { from: string; to: string; days: number; label: string }): void;
}>();

// Local state (using string for v-text-field type="date")
const startDateStr = ref('');
const endDateStr = ref('');
const hasError = ref(false);

// Computed
const todayStr = computed(() => format(new Date(), 'yyyy-MM-dd'));

const minEndDateStr = computed(() => {
  if (startDateStr.value) {
    return startDateStr.value;
  }
  return '';
});

// Methods
function handleClose() {
  // Reset error state on close
  hasError.value = false;
  emit('close');
}

function handleConfirm() {
  // Validate dates
  if (!startDateStr.value || !endDateStr.value) {
    hasError.value = true;
    return;
  }

  // Parse dates
  const start = parse(startDateStr.value, 'yyyy-MM-dd', new Date());
  const end = parse(endDateStr.value, 'yyyy-MM-dd', new Date());

  // Calculate days (end date - start date + 1)
  const diffTime = end.getTime() - start.getTime();
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;

  // Create display label (MMM Do, YYYY - MMM Do, YYYY) - matching legacy format
  const label = `${format(start, 'MMM do, yyyy')} - ${format(end, 'MMM do, yyyy')}`;

  // Emit data
  emit('confirm', {
    from: startDateStr.value,
    to: endDateStr.value,
    days: diffDays,
    label,
  });

  // Reset error state
  hasError.value = false;
}

// Reset dates when dialog closes
function handleDialogClose() {
  startDateStr.value = '';
  endDateStr.value = '';
  hasError.value = false;
  emit('close');
}
</script>

<template>
  <v-dialog :model-value="open" max-width="500px" persistent @update:model-value="handleClose">
    <v-card>
      <!-- Header with close button -->
      <v-card-title class="d-flex justify-space-between align-center pa-4 border-b">
        <span class="text-h5">Date Range</span>
        <v-btn icon variant="text" size="small" @click="handleDialogClose">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>

      <!-- Content -->
      <v-card-text class="pa-4">
        <v-row>
          <!-- Start Date -->
          <v-col cols="6">
            <v-text-field
              v-model="startDateStr"
              label="Start Date"
              type="date"
              :max="todayStr"
              variant="outlined"
              density="comfortable"
              hide-details="auto"
              :error="hasError && !startDateStr"
              :error-messages="hasError && !startDateStr ? 'Start date cannot be empty' : ''"
            />
          </v-col>

          <!-- End Date -->
          <v-col cols="6">
            <v-text-field
              v-model="endDateStr"
              label="End Date"
              type="date"
              :min="minEndDateStr"
              :max="todayStr"
              variant="outlined"
              density="comfortable"
              hide-details="auto"
              :error="hasError && !endDateStr"
              :error-messages="hasError && !endDateStr ? 'End date cannot be empty' : ''"
            />
          </v-col>
        </v-row>
      </v-card-text>

      <!-- Actions -->
      <v-card-actions class="pa-4 pt-0">
        <v-spacer />
        <v-btn variant="outlined" color="grey" min-width="120" @click="handleDialogClose">
          Cancel
        </v-btn>
        <v-btn variant="flat" color="primary" min-width="120" @click="handleConfirm">
          Confirm
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
.border-b {
  border-bottom: 1px solid rgba(0, 0, 0, 0.12);
}
</style>

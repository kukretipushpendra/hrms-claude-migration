<script setup lang="ts">
import { ref } from 'vue';
import { FEEDBACK_TYPE_OPTIONS, FEEDBACK_STATUS_OPTIONS } from '@/types/support.types';
import type { EmployeeFeedbackFilter } from '@/types/support.types';

interface Emits {
  (e: 'search', filters: EmployeeFeedbackFilter): void;
  (e: 'reset'): void;
}

const emit = defineEmits<Emits>();

// Filter values
const ticketStatus = ref<number | null>(null);
const feedbackType = ref<number | null>(null);

function handleSearch() {
  const filters: EmployeeFeedbackFilter = {
    ticketStatus: ticketStatus.value ?? undefined,
    feedbackType: feedbackType.value ?? undefined,
  };

  emit('search', filters);
}

function handleReset() {
  ticketStatus.value = null;
  feedbackType.value = null;

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
      <v-col cols="12" md="4">
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
      <v-col cols="12" md="4">
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

      <!-- Action Buttons -->
      <v-col cols="12" md="4" class="d-flex align-center gap-2">
        <v-btn variant="outlined" color="grey" @click="handleReset">Reset</v-btn>
        <v-btn variant="flat" color="primary" @click="handleSearch">Search</v-btn>
      </v-col>
    </v-row>
  </v-card>
</template>

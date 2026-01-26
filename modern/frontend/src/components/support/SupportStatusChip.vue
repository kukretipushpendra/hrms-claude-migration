<script setup lang="ts">
import { computed } from 'vue';
import { FeedbackStatus, FEEDBACK_STATUS_LABEL } from '@/types/support.types';
import type { FeedbackStatusType } from '@/types/support.types';

interface Props {
  status: FeedbackStatusType;
}

const props = defineProps<Props>();

// Status color mapping
const statusColor = computed(() => {
  switch (props.status) {
    case FeedbackStatus.Open:
      return 'info'; // Blue
    case FeedbackStatus.InProgress:
      return 'warning'; // Orange
    case FeedbackStatus.UnableToReproduce:
      return 'grey'; // Grey
    case FeedbackStatus.NotFixing:
      return 'error'; // Red
    case FeedbackStatus.NotApplicable:
      return 'grey'; // Grey
    case FeedbackStatus.Closed:
      return 'success'; // Green
    default:
      return 'grey';
  }
});

// Status icon mapping
const statusIcon = computed(() => {
  switch (props.status) {
    case FeedbackStatus.Open:
      return 'mdi-circle-outline';
    case FeedbackStatus.InProgress:
      return 'mdi-progress-clock';
    case FeedbackStatus.UnableToReproduce:
      return 'mdi-help-circle';
    case FeedbackStatus.NotFixing:
      return 'mdi-close-circle';
    case FeedbackStatus.NotApplicable:
      return 'mdi-minus-circle';
    case FeedbackStatus.Closed:
      return 'mdi-check-circle';
    default:
      return 'mdi-circle';
  }
});

const statusLabel = computed(() => FEEDBACK_STATUS_LABEL[props.status]);
</script>

<template>
  <v-chip :color="statusColor" size="small" :prepend-icon="statusIcon" variant="flat">
    {{ statusLabel }}
  </v-chip>
</template>

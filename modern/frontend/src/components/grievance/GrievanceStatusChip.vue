<template>
  <v-chip
    :color="statusMeta.color"
    :prepend-icon="statusMeta.icon"
    variant="flat"
    :class="['grievance-status-chip', `status-${status}`]"
    v-bind="$attrs"
  >
    {{ statusMeta.label }}
  </v-chip>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { getGrievanceStatusMeta } from '@/utils/grievance.utils';
import type { GrievanceStatusType, GrievanceLevelType } from '@/types/grievance.types';

interface Props {
  status: GrievanceStatusType;
  level?: GrievanceLevelType;
}

const props = defineProps<Props>();

const statusMeta = computed(() => getGrievanceStatusMeta(props.status, props.level));
</script>

<style scoped>
.grievance-status-chip {
  font-weight: 500;
  border-radius: 16px;
}
</style>

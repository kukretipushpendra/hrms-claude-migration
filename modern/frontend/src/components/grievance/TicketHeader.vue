<template>
  <v-card flat class="ticket-header-card">
    <v-card-text>
      <div class="d-flex justify-space-between align-start mb-4">
        <div>
          <div class="text-h5 mb-2">{{ title }}</div>
          <div class="text-subtitle-1 text-medium-emphasis">Ticket #{{ ticketNumber }}</div>
        </div>
        <GrievanceStatusChip :status="status" :level="level" size="large" />
      </div>

      <v-divider class="my-4" />

      <v-row dense>
        <v-col cols="12" sm="6" md="3">
          <div class="text-caption text-medium-emphasis">Grievance Type</div>
          <div class="text-body-1">{{ grievanceTypeName }}</div>
        </v-col>
        <v-col cols="12" sm="6" md="3">
          <div class="text-caption text-medium-emphasis">Level</div>
          <div class="text-body-1">
            <v-chip size="small" variant="outlined">
              {{ getLevelLabel(level) }}
            </v-chip>
          </div>
        </v-col>
        <v-col cols="12" sm="6" md="3">
          <div class="text-caption text-medium-emphasis">Created At</div>
          <div class="text-body-1">{{ formatDate(createdAt) }}</div>
        </v-col>
        <v-col v-if="resolvedDate" cols="12" sm="6" md="3">
          <div class="text-caption text-medium-emphasis">Resolved At</div>
          <div class="text-body-1">{{ formatDate(resolvedDate) }}</div>
        </v-col>
      </v-row>

      <v-row v-if="currentLevelOwners && currentLevelOwners.length > 0" dense class="mt-2">
        <v-col cols="12">
          <div class="text-caption text-medium-emphasis">Current Level Owners</div>
          <div class="text-body-1">
            <v-chip
              v-for="(owner, index) in currentLevelOwners"
              :key="index"
              size="small"
              class="mr-2 mt-1"
            >
              {{ owner }}
            </v-chip>
          </div>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import GrievanceStatusChip from './GrievanceStatusChip.vue';
import { getGrievanceLevelLabel } from '@/utils/grievance.utils';
import type { GrievanceStatusType, GrievanceLevelType } from '@/types/grievance.types';

interface Props {
  title: string;
  ticketNumber: string;
  createdAt: string;
  status: GrievanceStatusType;
  level: GrievanceLevelType;
  grievanceTypeName: string;
  currentLevelOwners?: string[];
  resolvedDate?: string | null;
}

defineProps<Props>();

const getLevelLabel = (level: GrievanceLevelType) => {
  return getGrievanceLevelLabel(level);
};

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr);
  return date.toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};
</script>

<style scoped>
.ticket-header-card {
  border: 1px solid rgba(0, 0, 0, 0.12);
  margin-bottom: 16px;
}
</style>

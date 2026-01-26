<template>
  <div>
    <v-breadcrumbs :items="breadcrumbs" />
    <v-card v-if="loading" class="pa-6">
      <v-progress-circular indeterminate color="primary" />
    </v-card>
    <v-card v-else-if="grievance">
      <v-card-title class="bg-primary text-white">
        <h3>Grievance Details</h3>
      </v-card-title>
      <v-card-text class="pa-6">
        <v-row>
          <v-col cols="12" md="6">
            <div class="detail-item">
              <div class="label">Ticket No</div>
              <div class="value">{{ grievance.ticketNo }}</div>
            </div>
          </v-col>
          <v-col cols="12" md="6">
            <div class="detail-item">
              <div class="label">Status</div>
              <div class="value">
                <GrievanceStatusChip :status="grievance.status" :level="grievance.level" />
              </div>
            </div>
          </v-col>
          <v-col cols="12" md="6">
            <div class="detail-item">
              <div class="label">Grievance Type</div>
              <div class="value">{{ grievance.grievanceTypeName }}</div>
            </div>
          </v-col>
          <v-col cols="12" md="6">
            <div class="detail-item">
              <div class="label">Level</div>
              <div class="value">
                <v-chip size="small">{{ getLevelLabel(grievance.level) }}</v-chip>
              </div>
            </div>
          </v-col>
          <v-col cols="12">
            <div class="detail-item">
              <div class="label">Title</div>
              <div class="value">{{ grievance.title }}</div>
            </div>
          </v-col>
          <v-col cols="12">
            <div class="detail-item">
              <div class="label">Description</div>
              <div class="value" v-html="grievance.description || 'N/A'"></div>
            </div>
          </v-col>
          <v-col v-if="grievance.attachmentPath && grievance.fileOriginalName" cols="12">
            <div class="detail-item">
              <div class="label">Attachment</div>
              <div class="value">
                <v-chip
                  prepend-icon="mdi-paperclip"
                  variant="outlined"
                  :href="grievance.attachmentPath"
                  target="_blank"
                >
                  {{ grievance.fileOriginalName }}
                </v-chip>
              </div>
            </div>
          </v-col>
          <v-col cols="12" md="6">
            <div class="detail-item">
              <div class="label">Created Date</div>
              <div class="value">{{ formatDate(grievance.createdDate) }}</div>
            </div>
          </v-col>
          <v-col v-if="grievance.resolvedDate" cols="12" md="6">
            <div class="detail-item">
              <div class="label">Resolved Date</div>
              <div class="value">{{ formatDate(grievance.resolvedDate) }}</div>
            </div>
          </v-col>
          <v-col v-if="grievance.managedBy" cols="12">
            <div class="detail-item">
              <div class="label">Managed By</div>
              <div class="value">{{ grievance.managedBy }}</div>
            </div>
          </v-col>
        </v-row>

        <v-divider class="my-4" />

        <div class="d-flex justify-end gap-2">
          <v-btn
            color="primary"
            variant="outlined"
            prepend-icon="mdi-arrow-left"
            :to="'/Grievance/My-Grievance'"
          >
            Back to List
          </v-btn>
          <v-btn color="primary" prepend-icon="mdi-eye" :to="`/Grievance/tickets/${grievance.id}`">
            View Full Ticket
          </v-btn>
        </div>
      </v-card-text>
    </v-card>
    <v-card v-else class="pa-6">
      <v-alert type="error">Grievance not found</v-alert>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import GrievanceStatusChip from '@/components/grievance/GrievanceStatusChip.vue';
import { getEmployeeGrievanceDetail } from '@/services/grievance/grievance.service';
import { getGrievanceLevelLabel } from '@/utils/grievance.utils';
import type { EmployeeGrievance } from '@/types/grievance.types';

const route = useRoute();

const breadcrumbs = [
  { title: 'Grievance', disabled: false, href: '/Grievance' },
  { title: 'My Grievances', disabled: false, href: '/Grievance/My-Grievance' },
  { title: 'Details', disabled: true },
];

const grievance = ref<EmployeeGrievance | null>(null);
const loading = ref(false);

const getLevelLabel = getGrievanceLevelLabel;

const loadGrievance = async () => {
  const id = route.params.id;
  if (!id) {
    return;
  }

  loading.value = true;
  try {
    grievance.value = await getEmployeeGrievanceDetail(Number(id));
  } catch (error) {
    console.error('Failed to load grievance:', error);
  } finally {
    loading.value = false;
  }
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

onMounted(() => {
  loadGrievance();
});
</script>

<style scoped>
.detail-item {
  margin-bottom: 16px;
}

.detail-item .label {
  font-size: 0.875rem;
  color: rgba(0, 0, 0, 0.6);
  margin-bottom: 4px;
}

.detail-item .value {
  font-size: 1rem;
  font-weight: 500;
}

.gap-2 {
  gap: 8px;
}
</style>

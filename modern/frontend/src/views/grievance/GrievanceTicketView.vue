<template>
  <div>
    <v-breadcrumbs :items="breadcrumbs" />

    <v-progress-linear v-if="loading" indeterminate color="primary" />

    <template v-else-if="!isAllowed">
      <v-card class="pa-6">
        <v-alert type="error" icon="mdi-alert-circle">
          You do not have permission to view this ticket, or it does not exist.
        </v-alert>
      </v-card>
    </template>

    <template v-else-if="ticketData">
      <v-card>
        <v-card-text class="pa-4">
          <!-- Ticket Header -->
          <TicketHeader
            :title="ticketData.grievance.title"
            :ticket-number="ticketData.grievance.ticketNo"
            :created-at="ticketData.grievance.createdDate"
            :status="ticketData.grievance.status"
            :level="ticketData.grievance.level"
            :grievance-type-name="ticketData.grievance.grievanceTypeName || ''"
            :current-level-owners="parseCsvOwners(ticketData.grievance.managedBy)"
            :resolved-date="ticketData.grievance.resolvedDate"
          />

          <!-- Read-only notice for resolved tickets -->
          <v-alert
            v-if="ticketData.grievance.status === GrievanceStatus.Resolved"
            type="success"
            variant="tonal"
            class="my-4"
          >
            This ticket has been resolved. Conversations are read-only.
          </v-alert>

          <!-- Original Message -->
          <MessageCard
            :actor="{
              name: ticketData.grievance.employeeName || 'Unknown',
              email: '',
            }"
            :timestamp="ticketData.grievance.createdDate"
            :body-html="ticketData.grievance.description || ''"
            :attachment="
              ticketData.grievance.attachmentPath && ticketData.grievance.fileOriginalName
                ? {
                    name: ticketData.grievance.fileOriginalName,
                    url: ticketData.grievance.attachmentPath,
                  }
                : undefined
            "
            origin="requester"
          />

          <!-- Remarks Thread -->
          <MessageCard
            v-for="remark in ticketData.remarks"
            :key="remark.id"
            :actor="{
              name: remark.createdByName || 'System',
              email: '',
            }"
            :timestamp="remark.createdDate"
            :body-html="remark.remarks"
            :attachment="
              remark.attachmentPath
                ? {
                    name: 'Attachment',
                    url: remark.attachmentPath,
                  }
                : undefined
            "
            origin="owner"
          />

          <!-- Response Composer (for owners only) -->
          <ResponseComposer
            v-if="canAddRemark"
            :level="ticketData.grievance.level"
            :loading="submittingRemark"
            @submit="handleRemarkSubmit"
          />
        </v-card-text>
      </v-card>
    </template>

    <v-snackbar v-model="showSuccess" color="success" timeout="3000">
      {{ successMessage }}
    </v-snackbar>

    <v-snackbar v-model="showError" color="error" timeout="5000">
      {{ errorMessage }}
    </v-snackbar>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import TicketHeader from '@/components/grievance/TicketHeader.vue';
import MessageCard from '@/components/grievance/MessageCard.vue';
import ResponseComposer from '@/components/grievance/ResponseComposer.vue';
import {
  getGrievanceTicketRemarks,
  updateEmployeeGrievanceRemarks,
  checkGrievanceViewAllowed,
  checkUpdateRemarksAllowed,
} from '@/services/grievance/grievance.service';
import { GrievanceStatus } from '@/types/grievance.types';
import { parseCsv, canAddRemarks } from '@/utils/grievance.utils';
import type { GrievanceTicketData, GrievanceStatusType } from '@/types/grievance.types';

const route = useRoute();

const breadcrumbs = [
  { title: 'Grievance', disabled: false, href: '/Grievance' },
  { title: 'Ticket', disabled: true },
];

const ticketData = ref<GrievanceTicketData | null>(null);
const loading = ref(false);
const isAllowed = ref<boolean | null>(null);
const isCurrentOwner = ref<boolean | null>(null);
const submittingRemark = ref(false);
const showSuccess = ref(false);
const showError = ref(false);
const successMessage = ref('');
const errorMessage = ref('');

const canAddRemark = computed(() => {
  return (
    ticketData.value &&
    canAddRemarks(ticketData.value.grievance.status) &&
    isCurrentOwner.value === true
  );
});

const parseCsvOwners = (csv: string | undefined) => {
  return parseCsv(csv);
};

const loadTicket = async () => {
  const ticketId = route.params.ticketId;
  if (!ticketId) {
    return;
  }

  loading.value = true;
  try {
    // Check if user can view
    const allowed = await checkGrievanceViewAllowed(Number(ticketId));
    isAllowed.value = allowed;

    if (!allowed) {
      loading.value = false;
      return;
    }

    // Load ticket data
    const data = await getGrievanceTicketRemarks(Number(ticketId));
    ticketData.value = data;

    // Check if user can add remarks
    if (data.grievance) {
      const canUpdate = await checkUpdateRemarksAllowed(
        data.grievance.grievanceTypeId,
        data.grievance.level
      );
      isCurrentOwner.value = canUpdate;
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'Failed to load ticket';
    showError.value = true;
    isAllowed.value = false;
  } finally {
    loading.value = false;
  }
};

const handleRemarkSubmit = async (payload: {
  remarks: string;
  status?: GrievanceStatusType;
  attachment?: File;
}) => {
  if (!ticketData.value) {
    return;
  }

  submittingRemark.value = true;
  try {
    await updateEmployeeGrievanceRemarks({
      grievanceId: ticketData.value.grievance.id,
      remarks: payload.remarks,
      status: payload.status,
      attachment: payload.attachment,
    });

    successMessage.value = 'Remark added successfully';
    showSuccess.value = true;

    // Reload ticket
    await loadTicket();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'Failed to add remark';
    showError.value = true;
  } finally {
    submittingRemark.value = false;
  }
};

onMounted(() => {
  loadTicket();
});
</script>

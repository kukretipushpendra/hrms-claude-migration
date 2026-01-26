<template>
  <v-dialog v-model="isOpen" max-width="600" persistent>
    <v-card>
      <v-card-text class="pa-6">
        <div class="d-flex align-start mb-4">
          <v-icon icon="mdi-check-circle" color="success" size="64" class="mr-4" />
          <div>
            <div class="text-h5 mb-2">Grievance Submitted Successfully</div>
            <div class="text-body-1 mb-3">Your grievance has been submitted successfully.</div>
            <div class="text-body-1 mb-3">
              Ticket ID: <strong>{{ ticketNo }}</strong>
            </div>
            <div class="text-body-1">
              A confirmation email has been sent to your registered email address with the details.
            </div>
          </div>
        </div>
      </v-card-text>
      <v-card-actions class="px-6 pb-4">
        <v-spacer />
        <v-btn color="primary" variant="flat" :to="`/Grievance/tickets/${grievanceId}`">
          View Details
        </v-btn>
        <v-btn color="inherit" variant="outlined" :to="'/Grievance/My-Grievance'"> Close </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  open: boolean;
  grievanceId: number;
  ticketNo: string;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'update:open', value: boolean): void;
}>();

const isOpen = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value),
});
</script>

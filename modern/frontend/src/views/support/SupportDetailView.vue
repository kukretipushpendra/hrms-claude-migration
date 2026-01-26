<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import { getFeedbackById } from '@/services/support/support.service';
import UpdateStatusDialog from '@/components/support/UpdateStatusDialog.vue';
import { FEEDBACK_TYPE_LABEL, FEEDBACK_STATUS_LABEL } from '@/types/support.types';
import type { Feedback } from '@/types/support.types';

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();

const feedback = ref<Feedback | null>(null);
const loading = ref(false);
const updateDialogOpen = ref(false);

// Check if user can edit (admin or other employee)
const canEdit = computed(() => {
  if (!authStore.user || !feedback.value) return false;

  // Super admin can edit all
  if (authStore.user.roleName === 'SuperAdmin') return true;

  // Other users can edit if it's NOT their own ticket
  return feedback.value.employeeId !== Number(authStore.user.id);
});

// Fetch feedback details
async function fetchDetails() {
  const id = Number(route.params.id);
  if (!id) {
    router.push('/Support/My-Support');
    return;
  }

  loading.value = true;

  try {
    feedback.value = await getFeedbackById(id);
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    console.error('Failed to fetch feedback details:', err.response?.data?.message || error);
    router.push('/Support/My-Support');
  } finally {
    loading.value = false;
  }
}

// Handle status update
function handleUpdateStatus() {
  updateDialogOpen.value = true;
}

// Handle update success
function handleUpdated() {
  updateDialogOpen.value = false;
  fetchDetails(); // Refresh details
}

// Format date
function formatDate(dateString?: string): string {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

// Go back
function goBack() {
  router.back();
}

// Initial fetch
onMounted(() => {
  fetchDetails();
});
</script>

<template>
  <div>
    <!-- Breadcrumbs -->
    <v-breadcrumbs
      :items="[
        { title: 'Home', to: '/dashboard' },
        { title: 'Support', to: '/Support/My-Support' },
        { title: 'Details', disabled: true },
      ]"
      class="pa-0 mb-4"
    />

    <!-- Loading -->
    <v-card v-if="loading">
      <v-card-text class="text-center py-12">
        <v-progress-circular indeterminate color="primary" size="64" />
        <p class="mt-4 text-h6">Loading...</p>
      </v-card-text>
    </v-card>

    <!-- Detail Card -->
    <v-card v-else-if="feedback">
      <!-- Page Header -->
      <v-card-title class="pa-6 d-flex align-center">
        <v-btn icon variant="text" @click="goBack" class="mr-2">
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <h2 class="text-h4 text-primary">Support Details</h2>
      </v-card-title>

      <v-divider />

      <v-card-text class="pa-8">
        <!-- Details Grid -->
        <v-row>
          <!-- Support ID -->
          <v-col cols="12" md="6" class="d-flex">
            <span class="font-weight-bold mr-2">Support Id:</span>
            <span>{{ feedback.id }}</span>
          </v-col>

          <!-- Name (if available) -->
          <v-col v-if="feedback.employeeName" cols="12" md="6" class="d-flex">
            <span class="font-weight-bold mr-2">Name:</span>
            <span>{{ feedback.employeeName }}</span>
          </v-col>

          <!-- Email (if available) -->
          <v-col v-if="feedback.employeeEmail" cols="12" md="6" class="d-flex">
            <span class="font-weight-bold mr-2">Email:</span>
            <span>{{ feedback.employeeEmail }}</span>
          </v-col>

          <!-- Type -->
          <v-col cols="12" md="6" class="d-flex">
            <span class="font-weight-bold mr-2">Type:</span>
            <v-chip size="small" color="primary" variant="outlined">
              {{ FEEDBACK_TYPE_LABEL[feedback.feedbackType] }}
            </v-chip>
          </v-col>

          <!-- Ticket Status -->
          <v-col cols="12" md="6" class="d-flex">
            <span class="font-weight-bold mr-2">Ticket Status:</span>
            <span>{{ FEEDBACK_STATUS_LABEL[feedback.ticketStatus] }}</span>
          </v-col>

          <!-- Created On -->
          <v-col cols="12" md="6" class="d-flex">
            <span class="font-weight-bold mr-2">Created On:</span>
            <span>{{ formatDate(feedback.createdOn) }}</span>
          </v-col>

          <!-- Subject -->
          <v-col cols="12" class="d-flex">
            <span class="font-weight-bold mr-2">Subject:</span>
            <span>{{ feedback.subject }}</span>
          </v-col>

          <!-- Description -->
          <v-col cols="12" class="d-flex">
            <span class="font-weight-bold mr-2">Description:</span>
            <span class="text-pre-wrap">{{ feedback.description }}</span>
          </v-col>

          <!-- Admin Comment (if exists) -->
          <v-col v-if="feedback.adminComment" cols="12" class="d-flex">
            <span class="font-weight-bold mr-2">Admin Comment:</span>
            <span class="text-pre-wrap">{{ feedback.adminComment }}</span>
          </v-col>

          <!-- File Name -->
          <v-col cols="12" class="d-flex align-center">
            <span class="font-weight-bold mr-2">File Name:</span>
            <div v-if="feedback.fileOriginalName">
              <v-chip size="small" prepend-icon="mdi-file" color="primary" variant="outlined">
                {{ feedback.fileOriginalName }}
              </v-chip>
            </div>
            <span v-else>No file uploaded</span>
          </v-col>
        </v-row>
      </v-card-text>

      <!-- Edit Button (if allowed) -->
      <v-card-actions v-if="canEdit" class="pa-6 pt-0 justify-end">
        <v-btn
          variant="outlined"
          color="primary"
          prepend-icon="mdi-pencil"
          @click="handleUpdateStatus"
        >
          Support Query Status
        </v-btn>
      </v-card-actions>
    </v-card>

    <!-- No data -->
    <v-card v-else>
      <v-card-text class="text-center py-12">
        <v-icon size="64" color="grey-lighten-1">mdi-alert-circle</v-icon>
        <p class="text-h6 mt-4">No Data Found</p>
      </v-card-text>
    </v-card>

    <!-- Update Status Dialog -->
    <UpdateStatusDialog
      v-if="updateDialogOpen && feedback"
      :open="updateDialogOpen"
      :feedback="feedback"
      @close="updateDialogOpen = false"
      @updated="handleUpdated"
    />
  </div>
</template>

<style scoped>
.text-pre-wrap {
  white-space: pre-wrap;
  word-break: break-word;
}
</style>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { getEventById, type EventDetail } from '@/services/events';

const router = useRouter();
const route = useRoute();

// State
const event = ref<EventDetail | null>(null);
const loading = ref(false);
const error = ref<string | null>(null);

// Fetch event details
const fetchEvent = async () => {
  const id = Number(route.params.id);
  if (!id) {
    error.value = 'Invalid event ID';
    return;
  }

  loading.value = true;
  error.value = null;
  try {
    const response = await getEventById(id);
    if (response.statusCode === 200 && response.data) {
      event.value = response.data;
    } else {
      error.value = response.message || 'Failed to load event';
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load event';
  } finally {
    loading.value = false;
  }
};

const formatDate = (dateString: string) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
};

const goBack = () => {
  router.push({ name: 'events' });
};

const editEvent = () => {
  if (event.value) {
    router.push({ name: 'event-edit', params: { id: event.value.eventId } });
  }
};

// Lifecycle
onMounted(() => {
  fetchEvent();
});
</script>

<template>
  <v-container fluid class="pa-6">
    <v-card>
      <!-- Header -->
      <v-card-title class="d-flex justify-space-between align-center">
        <div class="d-flex align-center">
          <v-btn icon variant="text" @click="goBack" class="mr-2">
            <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
          <h2 class="text-h5">Event Details</h2>
        </div>
        <v-btn v-if="event" color="primary" prepend-icon="mdi-pencil" @click="editEvent">
          Edit Event
        </v-btn>
      </v-card-title>

      <v-divider />

      <!-- Loading State -->
      <v-card-text v-if="loading">
        <v-progress-circular indeterminate color="primary" />
        <span class="ml-3">Loading event details...</span>
      </v-card-text>

      <!-- Error State -->
      <v-card-text v-else-if="error">
        <v-alert type="error" variant="tonal">
          {{ error }}
        </v-alert>
      </v-card-text>

      <!-- Event Details -->
      <v-card-text v-else-if="event">
        <v-row>
          <v-col cols="12" md="6">
            <v-card variant="outlined">
              <v-card-text>
                <h3 class="text-h6 mb-4">Basic Information</h3>
                <v-list density="compact">
                  <v-list-item>
                    <template #prepend>
                      <v-icon>mdi-calendar-text</v-icon>
                    </template>
                    <v-list-item-title class="font-weight-bold">Event Name</v-list-item-title>
                    <v-list-item-subtitle>{{ event.eventName }}</v-list-item-subtitle>
                  </v-list-item>

                  <v-list-item>
                    <template #prepend>
                      <v-icon>mdi-calendar</v-icon>
                    </template>
                    <v-list-item-title class="font-weight-bold">Event Date</v-list-item-title>
                    <v-list-item-subtitle>{{ formatDate(event.eventDate) }}</v-list-item-subtitle>
                  </v-list-item>

                  <v-list-item>
                    <template #prepend>
                      <v-icon>mdi-shape</v-icon>
                    </template>
                    <v-list-item-title class="font-weight-bold">Category</v-list-item-title>
                    <v-list-item-subtitle>{{ event.eventCategory }}</v-list-item-subtitle>
                  </v-list-item>

                  <v-list-item>
                    <template #prepend>
                      <v-icon>mdi-map-marker</v-icon>
                    </template>
                    <v-list-item-title class="font-weight-bold">Location</v-list-item-title>
                    <v-list-item-subtitle>{{ event.location }}</v-list-item-subtitle>
                  </v-list-item>

                  <v-list-item>
                    <template #prepend>
                      <v-icon>mdi-information</v-icon>
                    </template>
                    <v-list-item-title class="font-weight-bold">Status</v-list-item-title>
                    <v-list-item-subtitle>
                      <v-chip
                        :color="
                          event.status === 'Upcoming'
                            ? 'info'
                            : event.status === 'Ongoing'
                              ? 'success'
                              : event.status === 'Completed'
                                ? 'default'
                                : 'error'
                        "
                        size="small"
                      >
                        {{ event.status }}
                      </v-chip>
                    </v-list-item-subtitle>
                  </v-list-item>
                </v-list>
              </v-card-text>
            </v-card>
          </v-col>

          <v-col cols="12" md="6">
            <v-card variant="outlined">
              <v-card-text>
                <h3 class="text-h6 mb-4">Description</h3>
                <p class="text-body-1">{{ event.description }}</p>
              </v-card-text>
            </v-card>

            <v-card
              v-if="event.documents && event.documents.length > 0"
              variant="outlined"
              class="mt-4"
            >
              <v-card-text>
                <h3 class="text-h6 mb-4">Documents</h3>
                <v-list density="compact">
                  <v-list-item v-for="(doc, index) in event.documents" :key="index">
                    <template #prepend>
                      <v-icon>mdi-file-document</v-icon>
                    </template>
                    <v-list-item-title>{{ doc }}</v-list-item-title>
                    <template #append>
                      <v-btn
                        icon
                        size="small"
                        variant="text"
                        color="primary"
                        :href="doc"
                        target="_blank"
                      >
                        <v-icon>mdi-download</v-icon>
                      </v-btn>
                    </template>
                  </v-list-item>
                </v-list>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

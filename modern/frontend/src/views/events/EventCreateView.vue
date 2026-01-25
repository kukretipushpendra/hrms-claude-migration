<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import {
  getEventById,
  createEvent,
  updateEvent,
  getEventCategories,
  type EventRequest,
  type EventCategory,
} from '@/services/events';

const router = useRouter();
const route = useRoute();

// State
const isEditMode = computed(() => !!route.params.id);
const loading = ref(false);
const submitting = ref(false);
const error = ref<string | null>(null);
const categories = ref<EventCategory[]>([]);

// Form data
const formData = ref<EventRequest>({
  eventName: '',
  eventDate: '',
  eventCategoryId: 0,
  location: '',
  description: '',
  documents: [],
});

// File input
const fileInput = ref<File[]>([]);

// Form validation
const formValid = ref(false);
const rules = {
  required: (v: string) => !!v || 'This field is required',
  categoryRequired: (v: number) => v > 0 || 'Please select a category',
};

// Fetch event categories
const fetchCategories = async () => {
  try {
    const response = await getEventCategories();
    if (response.statusCode === 200 && response.data) {
      categories.value = response.data;
    }
  } catch (err) {
    console.error('Failed to fetch categories:', err);
  }
};

// Fetch event details for editing
const fetchEvent = async () => {
  const id = Number(route.params.id);
  if (!id) return;

  loading.value = true;
  error.value = null;
  try {
    const response = await getEventById(id);
    if (response.statusCode === 200 && response.data) {
      const event = response.data;
      formData.value = {
        eventName: event.eventName,
        eventDate: event.eventDate.split('T')[0], // Format for date input
        eventCategoryId: event.eventCategoryId,
        location: event.location,
        description: event.description,
        documents: [],
      };
    } else {
      error.value = response.message || 'Failed to load event';
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load event';
  } finally {
    loading.value = false;
  }
};

// Submit form
const handleSubmit = async () => {
  if (!formValid.value) return;

  submitting.value = true;
  error.value = null;
  try {
    // Add files from file input
    formData.value.documents = fileInput.value;

    let response;
    if (isEditMode.value) {
      const id = Number(route.params.id);
      response = await updateEvent(id, formData.value);
    } else {
      response = await createEvent(formData.value);
    }

    if (response.statusCode === 200) {
      router.push({ name: 'events' });
    } else {
      error.value = response.message || 'Failed to save event';
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save event';
  } finally {
    submitting.value = false;
  }
};

const cancel = () => {
  router.push({ name: 'events' });
};

// Lifecycle
onMounted(async () => {
  await fetchCategories();
  if (isEditMode.value) {
    await fetchEvent();
  }
});
</script>

<template>
  <v-container fluid class="pa-6">
    <v-card>
      <!-- Header -->
      <v-card-title class="d-flex justify-space-between align-center">
        <div class="d-flex align-center">
          <v-btn icon variant="text" @click="cancel" class="mr-2">
            <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
          <h2 class="text-h5">{{ isEditMode ? 'Edit Event' : 'Create Event' }}</h2>
        </div>
      </v-card-title>

      <v-divider />

      <!-- Loading State -->
      <v-card-text v-if="loading">
        <v-progress-circular indeterminate color="primary" />
        <span class="ml-3">Loading event details...</span>
      </v-card-text>

      <!-- Error Alert -->
      <v-card-text v-if="error">
        <v-alert type="error" variant="tonal" closable @click:close="error = null">
          {{ error }}
        </v-alert>
      </v-card-text>

      <!-- Form -->
      <v-card-text v-if="!loading">
        <v-form v-model="formValid" @submit.prevent="handleSubmit">
          <v-row>
            <v-col cols="12" md="6">
              <v-text-field
                v-model="formData.eventName"
                label="Event Name *"
                variant="outlined"
                :rules="[rules.required]"
                required
              />
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="formData.eventDate"
                label="Event Date *"
                type="date"
                variant="outlined"
                :rules="[rules.required]"
                required
              />
            </v-col>

            <v-col cols="12" md="6">
              <v-select
                v-model="formData.eventCategoryId"
                :items="categories"
                item-title="name"
                item-value="id"
                label="Event Category *"
                variant="outlined"
                :rules="[rules.categoryRequired]"
                required
              />
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="formData.location"
                label="Location *"
                variant="outlined"
                :rules="[rules.required]"
                required
              />
            </v-col>

            <v-col cols="12">
              <v-textarea
                v-model="formData.description"
                label="Description *"
                variant="outlined"
                rows="4"
                :rules="[rules.required]"
                required
              />
            </v-col>

            <v-col cols="12">
              <v-file-input
                v-model="fileInput"
                label="Upload Documents"
                variant="outlined"
                multiple
                chips
                prepend-icon="mdi-paperclip"
                accept="image/*,application/pdf"
                hint="You can upload multiple images or PDF files"
                persistent-hint
              />
            </v-col>
          </v-row>

          <v-divider class="my-4" />

          <div class="d-flex justify-end gap-2">
            <v-btn variant="outlined" @click="cancel"> Cancel </v-btn>
            <v-btn type="submit" color="primary" :loading="submitting" :disabled="!formValid">
              {{ isEditMode ? 'Update Event' : 'Create Event' }}
            </v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

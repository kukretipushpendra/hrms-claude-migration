<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { getEvents, deleteEvent, type EventItem } from '@/services/events';
import { useAuthStore } from '@/stores/auth.store';

const router = useRouter();
const authStore = useAuthStore();

// State
const events = ref<EventItem[]>([]);
const loading = ref(false);
const totalRecords = ref(0);
const page = ref(1);
const itemsPerPage = ref(10);
const searchName = ref('');
const searchCategory = ref('');
const searchStatus = ref('');
const sortBy = ref<{ key: string; order: 'asc' | 'desc' }[]>([{ key: 'eventDate', order: 'desc' }]);

// Delete dialog state
const deleteDialog = ref(false);
const eventToDelete = ref<EventItem | null>(null);
const deleting = ref(false);

// Permission checks
const hasReadPermission = computed(() => authStore.hasPermission('Read.Events'));
const hasCreatePermission = computed(() => authStore.hasPermission('Create.Events'));
const hasEditPermission = computed(() => authStore.hasPermission('Edit.Events'));
const hasDeletePermission = computed(() => authStore.hasPermission('Delete.Events'));

// Data table headers
const headers = computed(() => {
  const baseHeaders = [
    { title: 'S.No', key: 'sNo', sortable: false, width: '80px' },
    { title: 'Event Name', key: 'eventName', sortable: true, width: '250px' },
    { title: 'Event Date', key: 'eventDate', sortable: true, width: '150px' },
    { title: 'Category', key: 'eventCategory', sortable: true, width: '150px' },
    { title: 'Location', key: 'location', sortable: false, width: '200px' },
    { title: 'Status', key: 'status', sortable: true, width: '120px' },
  ];

  if (hasReadPermission.value || hasEditPermission.value || hasDeletePermission.value) {
    baseHeaders.push({
      title: 'Actions',
      key: 'actions',
      sortable: false,
      width: '150px',
    });
  }

  return baseHeaders;
});

// Computed items with serial numbers
const eventsWithSerial = computed(() => {
  return events.value.map((event, index) => ({
    ...event,
    sNo: (page.value - 1) * itemsPerPage.value + index + 1,
  }));
});

// Status options
const statusOptions = [
  { value: '', title: 'All' },
  { value: 'Upcoming', title: 'Upcoming' },
  { value: 'Ongoing', title: 'Ongoing' },
  { value: 'Completed', title: 'Completed' },
  { value: 'Cancelled', title: 'Cancelled' },
];

// Category options (mock - replace with API call if available)
const categoryOptions = [
  { value: '', title: 'All' },
  { value: 'Conference', title: 'Conference' },
  { value: 'Workshop', title: 'Workshop' },
  { value: 'Team Building', title: 'Team Building' },
  { value: 'Training', title: 'Training' },
  { value: 'Social', title: 'Social' },
];

// Fetch events
const fetchEvents = async () => {
  if (!hasReadPermission.value) {
    return;
  }

  loading.value = true;
  try {
    const sortColumn = sortBy.value[0]?.key || 'eventDate';
    const sortDirection = sortBy.value[0]?.order || 'desc';

    const response = await getEvents({
      Filters: {
        EventName: searchName.value || undefined,
        EventCategory: searchCategory.value || undefined,
        Status: searchStatus.value || undefined,
      },
      PageSize: itemsPerPage.value,
      StartIndex: page.value,
      SortColumnName: sortColumn,
      SortDirection: sortDirection,
    });

    if (response.statusCode === 200 && response.data) {
      events.value = response.data.eventList || [];
      totalRecords.value = response.data.totalRecords || 0;
    }
  } catch (error) {
    console.error('Failed to fetch events:', error);
  } finally {
    loading.value = false;
  }
};

// Event handlers
const handleSearch = () => {
  page.value = 1;
  fetchEvents();
};

const handleReset = () => {
  searchName.value = '';
  searchCategory.value = '';
  searchStatus.value = '';
  page.value = 1;
  fetchEvents();
};

const handlePageChange = (newPage: number) => {
  page.value = newPage;
  fetchEvents();
};

const handleItemsPerPageChange = (newItemsPerPage: number) => {
  itemsPerPage.value = newItemsPerPage;
  page.value = 1;
  fetchEvents();
};

const handleSortChange = (newSortBy: { key: string; order: 'asc' | 'desc' }[]) => {
  sortBy.value = newSortBy;
  fetchEvents();
};

const viewEvent = (id: number) => {
  router.push({ name: 'event-detail', params: { id } });
};

const editEvent = (id: number) => {
  router.push({ name: 'event-edit', params: { id } });
};

const createEvent = () => {
  router.push({ name: 'event-create' });
};

const confirmDelete = (event: EventItem) => {
  eventToDelete.value = event;
  deleteDialog.value = true;
};

const handleDelete = async () => {
  if (!eventToDelete.value) return;

  deleting.value = true;
  try {
    const response = await deleteEvent(eventToDelete.value.eventId);
    if (response.statusCode === 200) {
      deleteDialog.value = false;
      eventToDelete.value = null;
      fetchEvents();
    }
  } catch (error) {
    console.error('Failed to delete event:', error);
  } finally {
    deleting.value = false;
  }
};

const formatDate = (dateString: string) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};

// Lifecycle
onMounted(() => {
  fetchEvents();
});
</script>

<template>
  <v-container fluid class="pa-6">
    <v-card>
      <!-- Header -->
      <v-card-title class="d-flex justify-space-between align-center">
        <h2 class="text-h5">Events Management</h2>
        <v-btn
          v-if="hasCreatePermission"
          color="primary"
          prepend-icon="mdi-plus"
          @click="createEvent"
        >
          Create Event
        </v-btn>
      </v-card-title>

      <v-divider />

      <!-- Search Filters -->
      <v-card-text>
        <v-row>
          <v-col cols="12" md="3">
            <v-text-field
              v-model="searchName"
              label="Search by Name"
              density="compact"
              variant="outlined"
              clearable
              hide-details
              @keyup.enter="handleSearch"
            />
          </v-col>
          <v-col cols="12" md="3">
            <v-select
              v-model="searchCategory"
              :items="categoryOptions"
              label="Category"
              density="compact"
              variant="outlined"
              hide-details
            />
          </v-col>
          <v-col cols="12" md="3">
            <v-select
              v-model="searchStatus"
              :items="statusOptions"
              label="Status"
              density="compact"
              variant="outlined"
              hide-details
            />
          </v-col>
          <v-col cols="12" md="3" class="d-flex gap-2">
            <v-btn color="primary" @click="handleSearch"> Search </v-btn>
            <v-btn variant="outlined" @click="handleReset"> Reset </v-btn>
          </v-col>
        </v-row>
      </v-card-text>

      <v-divider />

      <!-- Data Table -->
      <v-data-table
        :headers="headers"
        :items="eventsWithSerial"
        :loading="loading"
        :items-length="totalRecords"
        :page="page"
        :items-per-page="itemsPerPage"
        :sort-by="sortBy"
        @update:page="handlePageChange"
        @update:items-per-page="handleItemsPerPageChange"
        @update:sort-by="handleSortChange"
        class="elevation-0"
      >
        <!-- Event Name Column -->
        <template #item.eventName="{ item }">
          <v-tooltip v-if="hasReadPermission" :text="item.eventName">
            <template #activator="{ props }">
              <a
                v-bind="props"
                class="text-primary text-decoration-none"
                @click.prevent="viewEvent(item.eventId)"
              >
                {{
                  item.eventName.length > 40
                    ? item.eventName.substring(0, 40) + '...'
                    : item.eventName
                }}
              </a>
            </template>
          </v-tooltip>
          <span v-else>
            {{
              item.eventName.length > 40 ? item.eventName.substring(0, 40) + '...' : item.eventName
            }}
          </span>
        </template>

        <!-- Event Date Column -->
        <template #item.eventDate="{ item }">
          {{ formatDate(item.eventDate) }}
        </template>

        <!-- Location Column -->
        <template #item.location="{ item }">
          <v-tooltip :text="item.location">
            <template #activator="{ props }">
              <span v-bind="props">
                {{
                  item.location.length > 30 ? item.location.substring(0, 30) + '...' : item.location
                }}
              </span>
            </template>
          </v-tooltip>
        </template>

        <!-- Status Column -->
        <template #item.status="{ item }">
          <v-chip
            :color="
              item.status === 'Upcoming'
                ? 'info'
                : item.status === 'Ongoing'
                  ? 'success'
                  : item.status === 'Completed'
                    ? 'default'
                    : 'error'
            "
            size="small"
          >
            {{ item.status }}
          </v-chip>
        </template>

        <!-- Actions Column -->
        <template #item.actions="{ item }">
          <div class="d-flex gap-1">
            <v-tooltip v-if="hasReadPermission" text="View Event Details">
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  icon
                  size="small"
                  variant="text"
                  color="primary"
                  @click="viewEvent(item.eventId)"
                >
                  <v-icon>mdi-eye</v-icon>
                </v-btn>
              </template>
            </v-tooltip>

            <v-tooltip v-if="hasEditPermission" text="Edit Event">
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  icon
                  size="small"
                  variant="text"
                  color="primary"
                  @click="editEvent(item.eventId)"
                >
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
              </template>
            </v-tooltip>

            <v-tooltip v-if="hasDeletePermission" text="Delete Event">
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  icon
                  size="small"
                  variant="text"
                  color="error"
                  @click="confirmDelete(item)"
                >
                  <v-icon>mdi-delete</v-icon>
                </v-btn>
              </template>
            </v-tooltip>
          </div>
        </template>

        <!-- No data -->
        <template #no-data>
          <v-alert v-if="!loading" type="info" variant="tonal" class="ma-4">
            No events found
          </v-alert>
        </template>
      </v-data-table>
    </v-card>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="deleteDialog" max-width="500">
      <v-card>
        <v-card-title class="text-h6">Confirm Delete</v-card-title>
        <v-card-text>
          Are you sure you want to delete the event "{{ eventToDelete?.eventName }}"? This action
          cannot be undone.
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn variant="text" @click="deleteDialog = false"> Cancel </v-btn>
          <v-btn color="error" :loading="deleting" @click="handleDelete"> Delete </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<style scoped>
.text-primary {
  cursor: pointer;
}
</style>

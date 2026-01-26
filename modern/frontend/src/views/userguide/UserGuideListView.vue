<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { toast } from 'vue3-toastify';
import UserGuideFilterForm from '@/components/userguide/UserGuideFilterForm.vue';
import type { UserGuide, UserGuideFilter, MenuOption } from '@/types/userguide.types';
import { USER_GUIDE_STATUS_LABEL } from '@/types/userguide.types';
import {
  getAllUserGuide,
  getAllMenu,
  deleteUserGuideById,
} from '@/services/userguide/userguide.service';

const router = useRouter();

const userGuides = ref<UserGuide[]>([]);
const menuOptions = ref<MenuOption[]>([]);
const loading = ref(false);
const showFilters = ref(false);
const hasActiveFilters = ref(false);
const deleteDialogOpen = ref(false);
const guideToDelete = ref<number | null>(null);
const totalRecords = ref(0);

// Pagination
const page = ref(1);
const itemsPerPage = ref(25);

// Filter state
const filters = ref<UserGuideFilter>({
  title: '',
  menuName: '',
  status: null,
});

const filterFormRef = ref<InstanceType<typeof UserGuideFilterForm> | null>(null);

// Headers for data table
const headers = [
  { title: 'Menu', key: 'menuName', sortable: true },
  { title: 'Title', key: 'title', sortable: true },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Created On', key: 'createdOn', sortable: true },
  { title: 'Created By', key: 'createdBy', sortable: true },
  { title: 'Last Updated On', key: 'modifiedOn', sortable: true },
  { title: 'Last Updated By', key: 'modifiedBy', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false, align: 'end' as const },
];

// Fetch user guides
const fetchUserGuides = async () => {
  loading.value = true;
  try {
    const response = await getAllUserGuide({
      pageNumber: page.value,
      pageSize: itemsPerPage.value,
      sortColumn: 'createdOn',
      sortDirection: 'desc',
      filter: filters.value,
    });
    userGuides.value = response.userGuides || [];
    totalRecords.value = response.totalRecords || 0;
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch user guides');
  } finally {
    loading.value = false;
  }
};

// Fetch menu options
const fetchMenuOptions = async () => {
  try {
    menuOptions.value = await getAllMenu();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch menu options');
  }
};

// Handle search
const handleSearch = (searchFilters: UserGuideFilter) => {
  filters.value = searchFilters;
  hasActiveFilters.value =
    !!searchFilters.title || !!searchFilters.menuName || searchFilters.status !== null;
  page.value = 1; // Reset to first page
  fetchUserGuides();
};

// Handle reset
const handleReset = () => {
  filterFormRef.value?.handleReset();
  filters.value = {
    title: '',
    menuName: '',
    status: null,
  };
  hasActiveFilters.value = false;
  page.value = 1; // Reset to first page
  fetchUserGuides();
};

// Handle edit
const handleEdit = (guide: UserGuide) => {
  router.push(`/settings/user-guides/${guide.id}/edit`);
};

// Handle delete confirmation
const confirmDelete = (guideId: number) => {
  guideToDelete.value = guideId;
  deleteDialogOpen.value = true;
};

// Handle delete
const handleDelete = async () => {
  if (!guideToDelete.value) return;

  try {
    await deleteUserGuideById(guideToDelete.value);
    toast.success('User Guide Deleted Successfully');
    fetchUserGuides();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to delete user guide');
  } finally {
    deleteDialogOpen.value = false;
    guideToDelete.value = null;
  }
};

// Navigate to add guide
const handleAdd = () => {
  router.push('/settings/user-guides/add');
};

// Format date
const formatDate = (date: string | null) => {
  if (!date) return '-';
  return new Date(date).toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};

// Get status color
const getStatusColor = (status: number) => {
  return status === 1 ? 'success' : 'grey';
};

// Computed page count
const pageCount = computed(() => Math.ceil(totalRecords.value / itemsPerPage.value));

// Watch page changes
const handlePageChange = () => {
  fetchUserGuides();
};

onMounted(() => {
  fetchUserGuides();
  fetchMenuOptions();
});
</script>

<template>
  <div class="user-guide-list">
    <!-- Page Header -->
    <v-card class="mb-4" elevation="2">
      <v-card-title class="d-flex justify-space-between align-center">
        <h2>User Guides</h2>
        <v-btn color="primary" prepend-icon="mdi-plus" @click="handleAdd"> Add Guide </v-btn>
      </v-card-title>
    </v-card>

    <!-- Main Content Card -->
    <v-card elevation="2">
      <!-- Toolbar -->
      <v-card-text class="pb-0">
        <div class="d-flex justify-space-between align-center mb-4">
          <div class="d-flex gap-2">
            <v-btn
              :variant="showFilters ? 'flat' : 'outlined'"
              :color="showFilters ? 'primary' : 'default'"
              prepend-icon="mdi-filter"
              @click="showFilters = !showFilters"
            >
              {{ showFilters ? 'Hide Filters' : 'Show Filters' }}
            </v-btn>
            <v-chip v-if="hasActiveFilters" color="primary" closable @click:close="handleReset">
              Filters Active
            </v-chip>
          </div>

          <div class="text-body-2 text-grey-darken-1">
            Showing {{ userGuides.length }} of {{ totalRecords }} guides
          </div>
        </div>

        <!-- Filter Form -->
        <v-expand-transition>
          <div v-show="showFilters" class="mb-4">
            <UserGuideFilterForm
              ref="filterFormRef"
              :menu-options="menuOptions"
              @search="handleSearch"
              @reset="handleReset"
            />
          </div>
        </v-expand-transition>
      </v-card-text>

      <!-- Table -->
      <v-card-text>
        <v-data-table
          :headers="headers"
          :items="userGuides"
          :loading="loading"
          :items-per-page="itemsPerPage"
          :page="page"
          hide-default-footer
        >
          <!-- Status column -->
          <template #item.status="{ item }">
            <v-chip :color="getStatusColor(item.status)" size="small">
              {{ USER_GUIDE_STATUS_LABEL[item.status] }}
            </v-chip>
          </template>

          <!-- Created On column -->
          <template #item.createdOn="{ item }">
            {{ formatDate(item.createdOn) }}
          </template>

          <!-- Modified On column -->
          <template #item.modifiedOn="{ item }">
            {{ formatDate(item.modifiedOn) }}
          </template>

          <!-- Actions column -->
          <template #item.actions="{ item }">
            <div class="d-flex justify-end gap-1">
              <v-btn
                icon="mdi-pencil"
                size="small"
                variant="text"
                color="primary"
                @click="handleEdit(item)"
              />
              <v-btn
                icon="mdi-delete"
                size="small"
                variant="text"
                color="error"
                @click="confirmDelete(item.id)"
              />
            </div>
          </template>

          <!-- Loading state -->
          <template #loading>
            <v-skeleton-loader type="table-row@5" />
          </template>

          <!-- No data state -->
          <template #no-data>
            <div class="text-center py-8">
              <v-icon size="64" color="grey-lighten-2">mdi-book-open-page-variant</v-icon>
              <p class="text-h6 text-grey mt-4">No user guides found</p>
              <p class="text-body-2 text-grey">
                {{
                  hasActiveFilters
                    ? 'Try adjusting your filters'
                    : 'Click "Add Guide" to create one'
                }}
              </p>
            </div>
          </template>
        </v-data-table>

        <!-- Pagination -->
        <div v-if="totalRecords > 0" class="d-flex justify-center mt-4">
          <v-pagination
            v-model="page"
            :length="pageCount"
            :total-visible="7"
            @update:model-value="handlePageChange"
          />
        </div>
      </v-card-text>
    </v-card>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="deleteDialogOpen" max-width="500">
      <v-card>
        <v-card-title class="text-h5">Delete User Guide</v-card-title>
        <v-card-text>
          Are you sure you want to proceed? The selected guide will be permanently deleted.
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="grey" variant="text" @click="deleteDialogOpen = false">Cancel</v-btn>
          <v-btn color="error" variant="flat" @click="handleDelete">Delete</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

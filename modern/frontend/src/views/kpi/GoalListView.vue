<template>
  <div class="goal-list-view">
    <v-breadcrumbs :items="breadcrumbs" />

    <v-card elevation="3">
      <v-card-title class="text-h4 pa-4">Goals</v-card-title>

      <v-card-text>
        <!-- Toolbar -->
        <div class="d-flex justify-space-between align-center mb-4">
          <v-btn color="primary" prepend-icon="mdi-plus" @click="goToAddGoal"> Add Goal </v-btn>

          <v-btn
            :color="hasActiveFilters ? 'primary' : 'default'"
            prepend-icon="mdi-filter"
            @click="toggleFilters"
          >
            {{ showFilters ? 'Hide Filters' : 'Show Filters' }}
          </v-btn>
        </div>

        <!-- Filter Form -->
        <v-expand-transition>
          <v-card v-if="showFilters" class="mb-4" elevation="1">
            <v-card-text>
              <v-form @submit.prevent="handleSearch">
                <v-row>
                  <v-col cols="12" sm="6" md="3">
                    <v-text-field
                      v-model="filters.title"
                      label="Title"
                      variant="outlined"
                      density="compact"
                      clearable
                    />
                  </v-col>

                  <v-col cols="12" sm="6" md="3">
                    <v-select
                      v-model="filters.departmentId"
                      :items="[]"
                      label="Department"
                      variant="outlined"
                      density="compact"
                      clearable
                    />
                  </v-col>

                  <v-col cols="12" sm="6" md="3">
                    <v-text-field
                      v-model="filters.createdOnFrom"
                      label="Created From"
                      type="date"
                      variant="outlined"
                      density="compact"
                      clearable
                    />
                  </v-col>

                  <v-col cols="12" sm="6" md="3">
                    <v-text-field
                      v-model="filters.createdOnTo"
                      label="Created To"
                      type="date"
                      variant="outlined"
                      density="compact"
                      clearable
                    />
                  </v-col>

                  <v-col cols="12" class="d-flex gap-2">
                    <v-btn color="primary" type="submit"> Search </v-btn>
                    <v-btn color="secondary" variant="outlined" @click="handleReset"> Reset </v-btn>
                  </v-col>
                </v-row>
              </v-form>
            </v-card-text>
          </v-card>
        </v-expand-transition>

        <!-- Data Table -->
        <v-data-table
          :headers="headers"
          :items="data"
          :loading="loading"
          :items-per-page="pagination.pageSize"
          :page="pagination.pageIndex + 1"
          :items-length="totalRecords"
          @update:page="handlePageChange"
          @update:items-per-page="handleItemsPerPageChange"
        >
          <!-- Actions Column -->
          <template #[`item.actions`]="{ item }">
            <v-btn icon size="small" variant="text" @click="goToEditGoal(item.id)">
              <v-icon>mdi-pencil</v-icon>
            </v-btn>
            <v-btn
              icon
              size="small"
              variant="text"
              color="error"
              @click="openDeleteDialog(item.id)"
            >
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </template>

          <!-- Created On Column -->
          <template #[`item.createdOn`]="{ item }">
            {{ formatDate(item.createdOn) }}
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="deleteDialog" max-width="500">
      <v-card>
        <v-card-title class="text-h5">Delete Goal</v-card-title>
        <v-card-text>
          Are you sure you want to proceed? The selected item will be permanently deleted.
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="secondary" variant="text" @click="closeDeleteDialog"> Cancel </v-btn>
          <v-btn color="error" variant="text" :loading="deleting" @click="confirmDelete">
            Delete
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import kpiService from '@/services/kpi/kpi.service';
import type { GoalList, KPIGoalRequestFilter } from '@/types/kpi.types';
import { DEFAULT_KPI_GOAL_FILTERS } from '@/constants/kpi.constants';
import { useSnackbar } from '@/composables/useSnackbar';

const router = useRouter();
const { showSuccess, showError } = useSnackbar();

const loading = ref(false);
const deleting = ref(false);
const data = ref<GoalList[]>([]);
const totalRecords = ref(0);

const pagination = ref({
  pageIndex: 0,
  pageSize: 10,
});

const filters = ref<KPIGoalRequestFilter>({ ...DEFAULT_KPI_GOAL_FILTERS });
const showFilters = ref(false);
const hasActiveFilters = ref(false);

const deleteDialog = ref(false);
const goalToDeleteId = ref<string | null>(null);

const breadcrumbs = [
  { title: 'KPI', disabled: false },
  { title: 'Goals', disabled: true },
];

const headers = [
  { title: 'Title', key: 'title', sortable: true },
  { title: 'Description', key: 'description', sortable: false },
  { title: 'Department', key: 'department', sortable: true },
  { title: 'Created On', key: 'createdOn', sortable: true },
  { title: 'Created By', key: 'createdBy', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false, align: 'center' },
];

const fetchGoalList = async () => {
  try {
    loading.value = true;

    const response = await kpiService.getGoalList({
      sortColumnName: '',
      sortDirection: '',
      startIndex: pagination.value.pageIndex,
      pageSize: pagination.value.pageSize,
      filters: filters.value,
    });

    data.value = response.result.goalList;
    totalRecords.value = response.result.totalRecords;
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to fetch goals';
    showError(message);
  } finally {
    loading.value = false;
  }
};

const toggleFilters = () => {
  showFilters.value = !showFilters.value;
};

const handleSearch = () => {
  pagination.value.pageIndex = 0;
  checkActiveFilters();
  fetchGoalList();
};

const handleReset = () => {
  filters.value = { ...DEFAULT_KPI_GOAL_FILTERS };
  pagination.value.pageIndex = 0;
  hasActiveFilters.value = false;
  fetchGoalList();
};

const checkActiveFilters = () => {
  hasActiveFilters.value = Object.values(filters.value).some((val) => val !== null && val !== '');
};

const handlePageChange = (page: number) => {
  pagination.value.pageIndex = page - 1;
  fetchGoalList();
};

const handleItemsPerPageChange = (itemsPerPage: number) => {
  pagination.value.pageSize = itemsPerPage;
  pagination.value.pageIndex = 0;
  fetchGoalList();
};

const goToAddGoal = () => {
  router.push('/KPI/Goals/Add-Goal');
};

const goToEditGoal = (id: string) => {
  router.push(`/KPI/Goals/Edit-Goal/${id}`);
};

const openDeleteDialog = (id: string) => {
  goalToDeleteId.value = id;
  deleteDialog.value = true;
};

const closeDeleteDialog = () => {
  deleteDialog.value = false;
  goalToDeleteId.value = null;
};

const confirmDelete = async () => {
  if (!goalToDeleteId.value) return;

  try {
    deleting.value = true;
    await kpiService.deleteGoal(Number(goalToDeleteId.value));
    showSuccess('Goal deleted successfully');
    closeDeleteDialog();
    fetchGoalList();
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to delete goal';
    showError(message);
  } finally {
    deleting.value = false;
  }
};

const formatDate = (date: Date | string) => {
  const d = new Date(date);
  return d.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
};

onMounted(() => {
  fetchGoalList();
});

watch(
  () => pagination.value,
  () => {
    fetchGoalList();
  },
  { deep: true }
);
</script>

<style scoped>
.gap-2 {
  gap: 8px;
}
</style>

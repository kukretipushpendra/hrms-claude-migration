<template>
  <div>
    <v-breadcrumbs :items="breadcrumbs" />
    <v-card>
      <v-card-title class="bg-primary text-white d-flex justify-space-between align-center">
        <h3>My Grievances</h3>
        <v-btn
          color="white"
          variant="outlined"
          prepend-icon="mdi-plus"
          :to="'/Grievance/My-Grievance/add'"
        >
          Add Grievance
        </v-btn>
      </v-card-title>
      <v-card-text class="pa-4">
        <!-- Filters -->
        <v-expansion-panels v-model="showFilters" variant="accordion">
          <v-expansion-panel>
            <v-expansion-panel-title>
              <v-icon class="mr-2">mdi-filter-variant</v-icon>
              Filters
              <v-chip v-if="hasActiveFilters" size="small" color="primary" class="ml-2">
                Active
              </v-chip>
            </v-expansion-panel-title>
            <v-expansion-panel-text>
              <GrievanceFilterForm
                ref="filterFormRef"
                v-model="filters"
                @search="handleSearch"
                @reset="handleFilterReset"
              />
            </v-expansion-panel-text>
          </v-expansion-panel>
        </v-expansion-panels>

        <!-- Data Table -->
        <v-data-table-server
          v-model:items-per-page="pagination.pageSize"
          v-model:page="pagination.pageNumber"
          v-model:sort-by="sortBy"
          :headers="headers"
          :items="grievances"
          :items-length="totalRecords"
          :loading="loading"
          class="mt-4"
          @update:options="loadGrievances"
        >
          <template #item.ticketNo="{ item }">
            <router-link :to="`/Grievance/tickets/${item.id}`" class="text-primary">
              {{ item.ticketNo }}
            </router-link>
          </template>
          <template #item.status="{ item }">
            <GrievanceStatusChip :status="item.status" :level="item.level" />
          </template>
          <template #item.createdDate="{ item }">
            {{ formatDate(item.createdDate) }}
          </template>
        </v-data-table-server>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue';
import { useAuthStore } from '@/stores/auth.store';
import GrievanceFilterForm from '@/components/grievance/GrievanceFilterForm.vue';
import GrievanceStatusChip from '@/components/grievance/GrievanceStatusChip.vue';
import { getEmployeeGrievancesById } from '@/services/grievance/grievance.service';
import type { EmployeeGrievance, EmployeeGrievanceFilter } from '@/types/grievance.types';

const authStore = useAuthStore();

const breadcrumbs = [
  { title: 'Grievance', disabled: false, href: '/Grievance' },
  { title: 'My Grievances', disabled: true },
];

const headers = [
  { title: 'Ticket No', key: 'ticketNo', sortable: true },
  { title: 'Grievance Type', key: 'grievanceTypeName', sortable: true },
  { title: 'Title', key: 'title', sortable: true },
  { title: 'Status', key: 'status', sortable: false },
  { title: 'Level', key: 'level', sortable: true },
  { title: 'Created Date', key: 'createdDate', sortable: true },
];

const grievances = ref<EmployeeGrievance[]>([]);
const totalRecords = ref(0);
const loading = ref(false);
const showFilters = ref<number | undefined>(undefined);
const filterFormRef = ref<any>(null);

const pagination = reactive({
  pageNumber: 1,
  pageSize: 10,
});

const sortBy = ref<any[]>([{ key: 'createdDate', order: 'desc' }]);

const filters = ref<EmployeeGrievanceFilter>({
  grievanceTypeId: null,
  status: null,
});

const hasActiveFilters = computed(() => {
  return filters.value.grievanceTypeId !== null || filters.value.status !== null;
});

const loadGrievances = async () => {
  if (!authStore.user?.id) {
    return;
  }

  loading.value = true;
  try {
    const sortColumn = sortBy.value.length > 0 ? sortBy.value[0].key : 'createdDate';
    const sortDirection = sortBy.value.length > 0 ? sortBy.value[0].order : 'desc';

    const result = await getEmployeeGrievancesById(authStore.user.id, {
      pageNumber: pagination.pageNumber,
      pageSize: pagination.pageSize,
      sortColumn,
      sortDirection: sortDirection as 'asc' | 'desc',
      filter: filters.value,
    });

    grievances.value = result.items;
    totalRecords.value = result.totalCount;
  } catch (error) {
    console.error('Failed to load grievances:', error);
  } finally {
    loading.value = false;
  }
};

const handleSearch = (searchFilters: EmployeeGrievanceFilter) => {
  filters.value = searchFilters;
  pagination.pageNumber = 1;
  loadGrievances();
};

const handleFilterReset = () => {
  filters.value = {
    grievanceTypeId: null,
    status: null,
  };
  pagination.pageNumber = 1;
  loadGrievances();
};

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr);
  return date.toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};

onMounted(() => {
  loadGrievances();
});
</script>

<style scoped>
.text-primary {
  color: rgb(var(--v-theme-primary));
  text-decoration: none;
}

.text-primary:hover {
  text-decoration: underline;
}
</style>

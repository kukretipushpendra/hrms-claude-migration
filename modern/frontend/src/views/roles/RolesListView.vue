<script setup lang="ts">
import { ref, watch, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { getRoles } from '@/services/roles';
import type { RoleType } from '@/services/roles';
import { useAuthStore } from '@/stores/auth.store';

const router = useRouter();
const authStore = useAuthStore();

// State
const data = ref<RoleType[]>([]);
const searchQuery = ref('');
const sortBy = ref<{ key: string; order: 'asc' | 'desc' }[]>([
  { key: 'roleName', order: 'asc' },
]);
const page = ref(1);
const itemsPerPage = ref(10);
const totalRecords = ref(0);
const loading = ref(false);
const error = ref<string | null>(null);

// Debounce timer
let debounceTimer: ReturnType<typeof setTimeout> | null = null;

// Permissions
const hasEditPermission = authStore.hasPermission('ROLE.EDIT');
const hasCreatePermission = authStore.hasPermission('ROLE.CREATE');

// Headers for data table
const headers = [
  { title: 'S.No', key: 'sno', sortable: false, width: '50px' },
  { title: 'Role', key: 'roleName', sortable: true },
  { title: 'Users', key: 'userCount', sortable: false },
];

// Add actions column if has edit permission
if (hasEditPermission) {
  headers.push({ title: 'Actions', key: 'actions', sortable: false, width: '150px' });
}

// Fetch roles
async function fetchRoles() {
  loading.value = true;
  error.value = null;

  try {
    const sortColumnName = sortBy.value[0]?.key || 'roleName';
    const sortDirection = sortBy.value[0]?.order || 'asc';
    const startIndex = page.value;

    const response = await getRoles({
      sortColumnName,
      sortDirection,
      startIndex,
      pageSize: itemsPerPage.value,
      filters: {
        roleName: searchQuery.value,
      },
    });

    data.value = response.result?.roleResponseList || [];
    totalRecords.value = response.result?.totalRecords || 0;
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'Failed to fetch roles';
    console.error('Fetch roles error:', e);
  } finally {
    loading.value = false;
  }
}

// Navigate to employee list filtered by role
function viewEmployees(roleId: number) {
  router.push({
    path: '/employees/employee-list',
    state: { roleId, fromRolesPage: true },
  });
}

// Navigate to edit role
function editRole(roleId: number) {
  router.push(`/roles/edit/${roleId}`);
}

// Navigate to add role
function addRole() {
  router.push('/roles/add');
}

// Watch for search query changes (debounced)
watch(searchQuery, () => {
  if (debounceTimer) {
    clearTimeout(debounceTimer);
  }
  debounceTimer = setTimeout(() => {
    page.value = 1; // Reset to first page on search
    fetchRoles();
  }, 500);
});

// Watch for sort changes
watch(sortBy, () => {
  fetchRoles();
});

// Watch for pagination changes
watch([page, itemsPerPage], () => {
  fetchRoles();
});

onMounted(() => {
  fetchRoles();
});
</script>

<template>
  <div class="roles-page">
    <!-- Breadcrumbs placeholder (can be implemented later) -->
    <!-- <v-breadcrumbs :items="breadcrumbs" /> -->

    <v-card elevation="3" class="mb-4">
      <!-- Header -->
      <v-card-title class="d-flex align-center justify-space-between pa-4">
        <h2 class="text-h5">Roles</h2>
        <div class="d-flex gap-2">
          <v-text-field
            v-model="searchQuery"
            variant="outlined"
            density="compact"
            placeholder="Search"
            hide-details
            clearable
            style="max-width: 300px"
          >
            <template #append-inner>
              <v-icon size="small">mdi-magnify</v-icon>
            </template>
          </v-text-field>

          <v-btn
            v-if="hasCreatePermission"
            color="primary"
            size="small"
            prepend-icon="mdi-plus"
            @click="addRole"
          >
            Add Role
          </v-btn>
        </div>
      </v-card-title>

      <!-- Loading State -->
      <v-card-text v-if="loading">
        <div class="text-center py-8">
          <v-progress-circular indeterminate color="primary" size="48" />
          <p class="mt-4 text-grey-600">Loading roles...</p>
        </div>
      </v-card-text>

      <!-- Error State -->
      <v-card-text v-else-if="error">
        <v-alert type="error" variant="tonal">
          {{ error }}
          <template #append>
            <v-btn variant="text" size="small" @click="fetchRoles"> Retry </v-btn>
          </template>
        </v-alert>
      </v-card-text>

      <!-- Data Table -->
      <v-card-text v-else class="pa-0">
        <v-data-table
          :headers="headers"
          :items="data"
          :loading="loading"
          :items-per-page="itemsPerPage"
          :sort-by="sortBy"
          hide-default-footer
          @update:sort-by="sortBy = $event"
        >
          <!-- S.No Column -->
          <template #item.sno="{ index }">
            {{ (page - 1) * itemsPerPage + index + 1 }}
          </template>

          <!-- Role Name Column -->
          <template #item.roleName="{ item }">
            <span class="text-truncate" style="max-width: 400px; display: block">
              {{ item.roleName }}
            </span>
          </template>

          <!-- Users Count Column -->
          <template #item.userCount="{ item }">
            <v-tooltip text="View Employees">
              <template #activator="{ props }">
                <v-btn
                  v-bind="props"
                  color="primary"
                  size="small"
                  variant="tonal"
                  icon
                  @click="viewEmployees(item.roleId)"
                >
                  {{ item.userCount }}
                </v-btn>
              </template>
            </v-tooltip>
          </template>

          <!-- Actions Column -->
          <template v-if="hasEditPermission" #item.actions="{ item }">
            <div class="d-flex gap-2">
              <v-tooltip text="Edit Role">
                <template #activator="{ props }">
                  <v-btn
                    v-bind="props"
                    color="primary"
                    size="small"
                    variant="text"
                    icon="mdi-pencil"
                    @click="editRole(item.roleId)"
                  />
                </template>
              </v-tooltip>
            </div>
          </template>

          <!-- No data state -->
          <template #no-data>
            <div class="text-center py-8">
              <v-icon size="64" color="grey-lighten-1">mdi-account-group-outline</v-icon>
              <p class="mt-4 text-grey-600">No roles found</p>
            </div>
          </template>
        </v-data-table>

        <!-- Pagination -->
        <v-divider />
        <div class="d-flex align-center justify-space-between pa-4">
          <div class="d-flex align-center gap-2">
            <span class="text-caption">Rows per page:</span>
            <v-select
              v-model="itemsPerPage"
              :items="[5, 10, 25, 50, 100]"
              variant="outlined"
              density="compact"
              hide-details
              style="max-width: 80px"
            />
          </div>

          <v-pagination
            v-model="page"
            :length="Math.ceil(totalRecords / itemsPerPage)"
            :total-visible="7"
            size="small"
          />

          <div class="text-caption">
            Showing {{ (page - 1) * itemsPerPage + 1 }} to
            {{ Math.min(page * itemsPerPage, totalRecords) }} of {{ totalRecords }} entries
          </div>
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<style scoped lang="scss">
.roles-page {
  padding: 16px;
}

.gap-2 {
  gap: 8px;
}
</style>

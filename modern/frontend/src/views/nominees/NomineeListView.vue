<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import { nomineeService } from '@/services/nominee/nominee.service';
import type { NomineeItem, NomineeSearchFilter } from '@/types/nominee.types';
import { toast } from 'vue3-toastify';
import NomineeFilterForm from './components/NomineeFilterForm.vue';
import NomineeDialog from './components/NomineeDialog.vue';
import ConfirmDialog from '@/components/ui/ConfirmDialog.vue';

const authStore = useAuthStore();
const route = useRoute();

// Query params - allow viewing other employee's nominees
const employeeId = computed(() => {
  const id = route.query.employeeId as string;
  return id ? Number(id) : Number(authStore.user?.id);
});

// State
const nominees = ref<NomineeItem[]>([]);
const loading = ref(false);
const totalRecords = ref(0);
const totalPercentage = ref(0);

// Pagination & Sorting
const page = ref(1);
const pageSize = ref(10);
const sortColumnName = ref('nomineeName');
const sortDirection = ref<'asc' | 'desc'>('asc');

// Filters
const nomineeName = ref('');
const relationshipId = ref<number | string>(0);
const others = ref('');

// Dialog state
const showDialog = ref(false);
const selectedNomineeId = ref<number>(0);
const selectedNomineePercentage = ref(0);

// Delete confirmation
const showDeleteDialog = ref(false);
const nomineeToDeleteId = ref<number | null>(null);

// Permissions
const hasReadPermission = computed(() => authStore.hasPermission('Read.Employees'));
const hasCreatePermission = computed(() => authStore.hasPermission('CreateNomineeDetails'));
const hasEditPermission = computed(() => authStore.hasPermission('EditNomineeDetails'));
const hasDeletePermission = computed(() => authStore.hasPermission('DeleteNomineeDetails'));
const hasViewPermission = computed(() => authStore.hasPermission('ReadNomineeDetails'));

// Computed - check if user can view this page
const canViewPage = computed(() => {
  // If viewing own nominees, always allow
  if (employeeId.value === Number(authStore.user?.id)) {
    return true;
  }
  // If viewing another employee's nominees, need Read.Employees permission
  return hasReadPermission.value;
});

// Fetch nominees
async function fetchNominees() {
  if (!authStore.user?.id) return;

  loading.value = true;
  try {
    const response = await nomineeService.getNomineeList({
      sortColumnName: sortColumnName.value,
      sortDirection: sortDirection.value,
      startIndex: page.value,
      pageSize: pageSize.value,
      filters: {
        nomineeName: nomineeName.value || undefined,
        relationshipId: Number(relationshipId.value) || undefined,
        employeeId: employeeId.value,
        others: others.value || undefined,
      },
    });

    nominees.value = response.result.nomineeList || [];
    totalRecords.value = response.result.totalRecords || 0;
    totalPercentage.value = response.result.totalPercentage || 0;
  } catch (error) {
    console.error('Failed to fetch nominees:', error);
    toast.error('Failed to fetch nominees');
  } finally {
    loading.value = false;
  }
}

// Handle search
function handleSearch(filters: NomineeSearchFilter) {
  nomineeName.value = filters.nomineeName || '';
  relationshipId.value = filters.relationshipId || 0;
  others.value = filters.others || '';
  page.value = 1; // Reset to first page
}

// Handle reset
function handleReset() {
  nomineeName.value = '';
  relationshipId.value = 0;
  others.value = '';
  page.value = 1;
}

// Handle add nominee
function handleAddClick() {
  selectedNomineeId.value = 0;
  selectedNomineePercentage.value = 0;
  showDialog.value = true;
}

// Handle edit nominee
function handleEditClick(nominee: NomineeItem) {
  if (!nominee.id) {
    toast.error('Nominee ID not found');
    return;
  }
  selectedNomineeId.value = nominee.id;
  selectedNomineePercentage.value = nominee.percentage;
  showDialog.value = true;
}

// Handle delete nominee
function handleDeleteClick(id: number) {
  nomineeToDeleteId.value = id;
  showDeleteDialog.value = true;
}

async function confirmDelete() {
  if (!nomineeToDeleteId.value) return;

  try {
    await nomineeService.deleteNominee(nomineeToDeleteId.value);
    toast.success('Nominee deleted successfully');
    showDeleteDialog.value = false;
    nomineeToDeleteId.value = null;
    fetchNominees();
  } catch (error) {
    console.error('Failed to delete nominee:', error);
    toast.error('Failed to delete nominee');
  }
}

// Handle dialog close
function handleDialogClose() {
  showDialog.value = false;
  selectedNomineeId.value = 0;
  selectedNomineePercentage.value = 0;
  fetchNominees();
}

// Handle sort
function handleSort(column: string) {
  if (sortColumnName.value === column) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortColumnName.value = column;
    sortDirection.value = 'asc';
  }
}

// Handle page change
function handlePageChange(newPage: number) {
  page.value = newPage;
}

function handlePageSizeChange(newSize: number) {
  pageSize.value = newSize;
  page.value = 1;
}

// Format date
function formatDate(dateStr: string): string {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
}

// Display relationship
function displayRelationship(nominee: NomineeItem): string {
  return nominee.relationshipName === 'Others' ? nominee.others : nominee.relationshipName;
}

// Watchers
watch(
  [page, pageSize, sortColumnName, sortDirection, nomineeName, relationshipId, others, employeeId],
  () => {
    fetchNominees();
  }
);

// Initial load
onMounted(() => {
  if (authStore.user?.id) {
    fetchNominees();
  }
});
</script>

<template>
  <div v-if="!canViewPage" class="not-found">
    <h2>Page Not Found</h2>
    <p>You don't have permission to view this page.</p>
  </div>

  <div v-else class="nominee-page">
    <!-- Page Header -->
    <div class="page-header">
      <h3 class="page-title">Nominee Details</h3>
    </div>

    <!-- Filter Form -->
    <NomineeFilterForm
      @search="handleSearch"
      @reset="handleReset"
      :show-add-button="hasCreatePermission"
      :add-disabled="totalPercentage >= 100"
      :add-tooltip="
        totalPercentage >= 100 ? 'Total percentage cannot exceed 100%' : 'Add a new nominee'
      "
      @add="handleAddClick"
    />

    <!-- Loading State -->
    <div v-if="loading" class="loading-container">
      <div class="spinner"></div>
    </div>

    <!-- Data Table -->
    <div v-else class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th style="width: 50px">S.No</th>
            <th style="width: 250px" @click="handleSort('nomineeName')" class="sortable">
              Name
              <span v-if="sortColumnName === 'nomineeName'">
                {{ sortDirection === 'asc' ? '↑' : '↓' }}
              </span>
            </th>
            <th style="width: 200px">Relationship</th>
            <th style="width: 130px">DOB</th>
            <th style="width: 130px">Age</th>
            <th style="width: 100px">Care/of</th>
            <th style="width: 130px">Percentage</th>
            <th style="width: 50px">Attachment</th>
            <th v-if="hasEditPermission || hasDeletePermission" style="width: 100px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="nominees.length === 0">
            <td :colspan="hasEditPermission || hasDeletePermission ? 9 : 8" class="no-data">
              No nominees found
            </td>
          </tr>
          <tr v-for="(nominee, index) in nominees" :key="nominee.id">
            <td>{{ (page - 1) * pageSize + index + 1 }}</td>
            <td>
              <span :title="nominee.nomineeName">
                {{
                  nominee.nomineeName.length > 20
                    ? nominee.nomineeName.substring(0, 20) + '...'
                    : nominee.nomineeName
                }}
              </span>
            </td>
            <td>{{ displayRelationship(nominee) }}</td>
            <td>{{ formatDate(nominee.dob) }}</td>
            <td>{{ nominee.age }}</td>
            <td>{{ nominee.careOf }}</td>
            <td>{{ nominee.percentage }}%</td>
            <td>
              <button
                v-if="nominee.fileName"
                :disabled="!hasViewPermission"
                class="icon-button"
                :title="hasViewPermission ? 'View Attachment' : 'No permission to view attachment'"
              >
                <span v-if="hasViewPermission">👁️</span>
                <span v-else>🚫</span>
              </button>
            </td>
            <td v-if="hasEditPermission || hasDeletePermission" class="actions">
              <button
                v-if="hasEditPermission"
                @click="handleEditClick(nominee)"
                class="icon-button edit"
                title="Edit Nominee"
              >
                ✏️
              </button>
              <button
                v-if="hasDeletePermission"
                @click="handleDeleteClick(nominee.id)"
                class="icon-button delete"
                title="Delete Nominee"
              >
                🗑️
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Pagination -->
      <div v-if="totalRecords > 0" class="pagination">
        <div class="pagination-info">
          Showing {{ (page - 1) * pageSize + 1 }} to
          {{ Math.min(page * pageSize, totalRecords) }} of {{ totalRecords }} entries
        </div>
        <div class="pagination-controls">
          <button @click="handlePageChange(page - 1)" :disabled="page === 1">Previous</button>
          <span>Page {{ page }} of {{ Math.ceil(totalRecords / pageSize) }}</span>
          <button
            @click="handlePageChange(page + 1)"
            :disabled="page >= Math.ceil(totalRecords / pageSize)"
          >
            Next
          </button>
        </div>
        <div class="page-size">
          <label>Page Size:</label>
          <select
            :value="pageSize"
            @change="handlePageSizeChange(Number(($event.target as HTMLSelectElement).value))"
          >
            <option :value="10">10</option>
            <option :value="25">25</option>
            <option :value="50">50</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Add/Edit Nominee Dialog -->
    <NomineeDialog
      v-if="showDialog"
      :open="showDialog"
      :nominee-id="selectedNomineeId"
      :total-percentage="totalPercentage"
      :nominee-percentage="selectedNomineePercentage"
      :employee-id="employeeId"
      @close="handleDialogClose"
    />

    <!-- Delete Confirmation Dialog -->
    <ConfirmDialog
      v-if="showDeleteDialog"
      :open="showDeleteDialog"
      title="Delete Nominee"
      message="Are you sure you want to proceed? The selected nominee will be permanently deleted."
      @confirm="confirmDelete"
      @cancel="showDeleteDialog = false"
    />
  </div>
</template>

<style scoped>
.nominee-page {
  padding: 20px;
}

.page-header {
  margin-bottom: 20px;
}

.page-title {
  font-size: 24px;
  color: #1e75bb;
  margin: 0;
}

.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: calc(100vh - 200px);
}

.spinner {
  border: 4px solid #f3f3f3;
  border-top: 4px solid #1e75bb;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.table-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th,
.data-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.data-table th {
  background-color: #f5f5f5;
  font-weight: 600;
  color: #333;
}

.data-table th.sortable {
  cursor: pointer;
  user-select: none;
}

.data-table th.sortable:hover {
  background-color: #e0e0e0;
}

.data-table tbody tr:hover {
  background-color: #f9f9f9;
}

.no-data {
  text-align: center;
  color: #666;
  padding: 40px !important;
}

.actions {
  display: flex;
  gap: 10px;
}

.icon-button {
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px 8px;
  font-size: 16px;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.icon-button:hover:not(:disabled) {
  background-color: #f0f0f0;
}

.icon-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.icon-button.edit:hover {
  color: #1e75bb;
}

.icon-button.delete:hover {
  color: #d32f2f;
}

.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background-color: #f5f5f5;
  border-top: 1px solid #e0e0e0;
}

.pagination-info {
  color: #666;
}

.pagination-controls {
  display: flex;
  gap: 12px;
  align-items: center;
}

.pagination-controls button {
  padding: 6px 12px;
  border: 1px solid #ddd;
  background-color: white;
  cursor: pointer;
  border-radius: 4px;
}

.pagination-controls button:hover:not(:disabled) {
  background-color: #f0f0f0;
}

.pagination-controls button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-size {
  display: flex;
  gap: 8px;
  align-items: center;
}

.page-size select {
  padding: 4px 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.not-found {
  text-align: center;
  padding: 60px 20px;
}

.not-found h2 {
  color: #d32f2f;
  margin-bottom: 12px;
}
</style>

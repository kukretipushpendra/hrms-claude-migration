<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import {
  getAllEmployeeReport,
  exportEmployeeReport,
} from '@/services/attendance/attendance.service';
import type { EmployeeReportTableRow, EmployeeReportSearchFilter } from '@/types/attendance.types';

/**
 * Employee Report View
 * Matches legacy: /legacy/Frontend/HRMS-Frontend/source/src/pages/Attendance/EmployeeReport/index.tsx
 */

// State
const rows = ref<EmployeeReportTableRow[]>([]);
const totalRecords = ref(0);
const loading = ref(false);
const error = ref<string | null>(null);
const exportLoading = ref(false);

// Pagination
const pageIndex = ref(0);
const pageSize = ref(10);

// Filters
const filters = ref<EmployeeReportSearchFilter>({
  employeeCode: '',
  dateFrom: null,
  dateTo: null,
  branchId: null,
  departmentId: null,
});
const showFilters = ref(false);

// Date range for columns
const dateRange = ref<string[]>([]);

// Computed
const defaultStartDate = computed(() => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return date.toISOString().split('T')[0];
});

const defaultEndDate = computed(() => {
  const date = new Date();
  return date.toISOString().split('T')[0];
});

// Generate date range for columns
function generateDateRange(startDate: string, endDate: string): string[] {
  const dates: string[] = [];
  const start = new Date(startDate);
  const end = new Date(endDate);

  while (start <= end) {
    dates.push(start.toISOString().split('T')[0]);
    start.setDate(start.getDate() + 1);
  }

  return dates;
}

// Fetch employee report
async function fetchReport() {
  loading.value = true;
  error.value = null;

  try {
    const startDate = filters.value.dateFrom || defaultStartDate.value;
    const endDate = filters.value.dateTo || defaultEndDate.value;

    // Generate date range for table columns
    dateRange.value = generateDateRange(startDate, endDate);

    const response = await getAllEmployeeReport(
      pageIndex.value + 1, // .NET uses 1-based pagination
      pageSize.value,
      {
        ...filters.value,
        dateFrom: startDate,
        dateTo: endDate,
      }
    );

    if (response.result) {
      const data = response.result;
      totalRecords.value = data.totalRecords || 0;

      // Map employee reports to table rows
      const mappedRows = (data.employeeReports || []).map((emp) => {
        const timeEntries: Record<string, number | undefined> = {};

        // Initialize all dates with 0
        dateRange.value.forEach((date) => {
          timeEntries[date] = 0;
        });

        // Fill in worked hours from API response
        Object.entries(emp.workedHoursByDate || {}).forEach(([date, hhmm]) => {
          if (hhmm && hhmm.trim() !== '') {
            const [h, m] = hhmm.split(':').map(Number);
            timeEntries[date] = h + (m ? m / 60 : 0);
          }
        });

        return {
          employeeCode: emp.employeeCode,
          employeeName: emp.employeeName,
          totalHour: emp.totalHour,
          branch: emp.branch,
          department: emp.department,
          timeEntries,
        };
      });

      rows.value = mappedRows;
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to fetch report';
    console.error('Failed to fetch report:', err);
  } finally {
    loading.value = false;
  }
}

// Handle export
async function handleExport() {
  exportLoading.value = true;

  try {
    const startDate = filters.value.dateFrom || defaultStartDate.value;
    const endDate = filters.value.dateTo || defaultEndDate.value;

    const blob = await exportEmployeeReport(pageIndex.value + 1, pageSize.value, {
      ...filters.value,
      dateFrom: startDate,
      dateTo: endDate,
    });

    // Download file
    const fileName = 'EmployeeAttendanceReport.xlsx';
    const blobUrl = URL.createObjectURL(blob);
    const link = document.createElement('a');
    try {
      link.href = blobUrl;
      link.setAttribute('download', fileName);
      document.body.appendChild(link);
      link.click();
    } finally {
      document.body.removeChild(link);
      URL.revokeObjectURL(blobUrl);
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to export report';
    console.error('Failed to export report:', err);
  } finally {
    exportLoading.value = false;
  }
}

// Handle filter change
function handleFilterChange() {
  pageIndex.value = 0;
  fetchReport();
}

// Handle pagination change
function handlePaginationChange(newPageIndex: number, newPageSize: number) {
  pageIndex.value = newPageIndex;
  pageSize.value = newPageSize;
  fetchReport();
}

// Watch for changes
watch([pageIndex, pageSize], () => {
  fetchReport();
});

// Load data on mount
onMounted(() => {
  // Set default dates
  filters.value.dateFrom = defaultStartDate.value;
  filters.value.dateTo = defaultEndDate.value;
  fetchReport();
});
</script>

<template>
  <div class="report-page">
    <!-- Breadcrumbs -->
    <nav class="breadcrumbs">
      <span class="breadcrumb-item">Dashboard</span>
      <span class="breadcrumb-separator">/</span>
      <span class="breadcrumb-item">Attendance</span>
      <span class="breadcrumb-separator">/</span>
      <span class="breadcrumb-item active">Employee Report</span>
    </nav>

    <!-- Main Paper Container -->
    <div class="paper-container">
      <!-- Page Header -->
      <div class="page-header">
        <h2>Employee Report</h2>
      </div>

      <div class="report-content">
        <!-- Toolbar -->
        <div class="table-toolbar">
          <div class="toolbar-left">
            <button class="filter-toggle-button" @click="showFilters = !showFilters">
              {{ showFilters ? 'Hide' : 'Show' }} Filters
            </button>
          </div>
          <div class="toolbar-right">
            <button class="export-button" :disabled="exportLoading" @click="handleExport">
              {{ exportLoading ? 'Exporting...' : 'Export to Excel' }}
            </button>
          </div>
        </div>

        <!-- Filters -->
        <div v-if="showFilters" class="filters-section">
          <div class="filter-group">
            <label>Date From:</label>
            <input v-model="filters.dateFrom" type="date" class="filter-input" />
          </div>

          <div class="filter-group">
            <label>Date To:</label>
            <input v-model="filters.dateTo" type="date" class="filter-input" />
          </div>

          <div class="filter-group">
            <label>Employee Code:</label>
            <input
              v-model="filters.employeeCode"
              type="text"
              placeholder="Enter employee code"
              class="filter-input"
              @keyup.enter="handleFilterChange"
            />
          </div>

          <div class="filter-actions">
            <button class="search-button" @click="handleFilterChange">Search</button>
            <button
              class="reset-button"
              @click="
                filters = {
                  employeeCode: '',
                  dateFrom: defaultStartDate,
                  dateTo: defaultEndDate,
                  branchId: null,
                  departmentId: null,
                };
                handleFilterChange();
              "
            >
              Reset
            </button>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="loading-state">
          <div class="spinner"></div>
          <p>Loading report...</p>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="error-state">
          <p class="error-message">{{ error }}</p>
          <button class="retry-button" @click="fetchReport">Retry</button>
        </div>

        <!-- Table -->
        <div v-else class="table-container">
          <div class="table-wrapper">
            <table class="report-table">
              <thead>
                <tr>
                  <th class="sticky-col">#</th>
                  <th class="sticky-col">Employee Code</th>
                  <th class="sticky-col">Employee Name</th>
                  <th class="sticky-col">Total Hours</th>
                  <th class="sticky-col">Department</th>
                  <th v-for="date in dateRange" :key="date" class="date-col">
                    {{ date }}
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, index) in rows" :key="row.employeeCode">
                  <td class="sticky-col">{{ pageIndex * pageSize + index + 1 }}</td>
                  <td class="sticky-col">{{ row.employeeCode }}</td>
                  <td class="sticky-col">{{ row.employeeName }}</td>
                  <td class="sticky-col">{{ row.totalHour }}</td>
                  <td class="sticky-col">{{ row.department }}</td>
                  <td v-for="date in dateRange" :key="date" class="date-col">
                    {{ row.timeEntries[date]?.toFixed(2) || '0.00' }}
                  </td>
                </tr>
                <tr v-if="rows.length === 0">
                  <td :colspan="5 + dateRange.length" class="no-data">No employee records found</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="pagination">
            <span>Rows per page:</span>
            <select
              v-model="pageSize"
              class="page-size-select"
              @change="handlePaginationChange(pageIndex, pageSize)"
            >
              <option :value="10">10</option>
              <option :value="25">25</option>
              <option :value="50">50</option>
              <option :value="100">100</option>
            </select>

            <span class="pagination-info">
              {{ pageIndex * pageSize + 1 }}-{{
                Math.min((pageIndex + 1) * pageSize, totalRecords)
              }}
              of {{ totalRecords }}
            </span>

            <div class="pagination-controls">
              <button
                class="pagination-button"
                :disabled="pageIndex === 0"
                @click="handlePaginationChange(pageIndex - 1, pageSize)"
              >
                Previous
              </button>
              <button
                class="pagination-button"
                :disabled="(pageIndex + 1) * pageSize >= totalRecords"
                @click="handlePaginationChange(pageIndex + 1, pageSize)"
              >
                Next
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.report-page {
  padding: 20px;
}

.breadcrumbs {
  margin-bottom: 20px;
  font-size: 14px;
  color: #666;
}

.breadcrumb-item {
  color: #1e75bb;
}

.breadcrumb-item.active {
  color: #666;
}

.breadcrumb-separator {
  margin: 0 8px;
}

.paper-container {
  background: white;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.page-header {
  padding: 20px;
  border-bottom: 1px solid #e0e0e0;
}

.page-header h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 500;
  color: #333;
}

.report-content {
  padding: 20px;
}

.table-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.toolbar-left,
.toolbar-right {
  display: flex;
  gap: 12px;
}

.filter-toggle-button,
.export-button {
  padding: 8px 16px;
  background: #1e75bb;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.filter-toggle-button:hover,
.export-button:hover:not(:disabled) {
  background: #155a8a;
}

.export-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.filters-section {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  padding: 16px;
  background: #f5f5f5;
  border-radius: 4px;
  margin-bottom: 20px;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 200px;
}

.filter-group label {
  font-size: 12px;
  font-weight: 600;
  color: #666;
}

.filter-input {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
}

.filter-actions {
  display: flex;
  align-items: flex-end;
  gap: 8px;
}

.search-button {
  padding: 8px 16px;
  background: #1e75bb;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.search-button:hover {
  background: #155a8a;
}

.reset-button {
  padding: 8px 16px;
  background: white;
  color: #666;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.reset-button:hover {
  background: #f5f5f5;
}

.loading-state,
.error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #1e75bb;
  border-radius: 50%;
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

.error-message {
  color: #d32f2f;
  margin-bottom: 16px;
}

.retry-button {
  padding: 8px 16px;
  background: #1e75bb;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.retry-button:hover {
  background: #155a8a;
}

.table-container {
  margin-top: 20px;
}

.table-wrapper {
  overflow-x: auto;
  max-width: 100%;
}

.report-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.report-table th,
.report-table td {
  padding: 10px;
  text-align: left;
  border: 1px solid #e0e0e0;
}

.report-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
  position: sticky;
  top: 0;
  z-index: 10;
}

.sticky-col {
  position: sticky;
  background: white;
  z-index: 5;
}

.sticky-col:nth-child(1) {
  left: 0;
  min-width: 50px;
}
.sticky-col:nth-child(2) {
  left: 50px;
  min-width: 120px;
}
.sticky-col:nth-child(3) {
  left: 170px;
  min-width: 180px;
}
.sticky-col:nth-child(4) {
  left: 350px;
  min-width: 100px;
}
.sticky-col:nth-child(5) {
  left: 450px;
  min-width: 150px;
}

.report-table thead th.sticky-col {
  z-index: 15;
  background: #f5f5f5;
}

.date-col {
  min-width: 100px;
  text-align: center;
}

.report-table tbody tr:hover {
  background: #f9f9f9;
}

.no-data {
  text-align: center;
  padding: 40px;
  color: #999;
}

.pagination {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 16px;
  margin-top: 20px;
  font-size: 14px;
  color: #666;
}

.page-size-select {
  padding: 4px 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.pagination-controls {
  display: flex;
  gap: 8px;
}

.pagination-button {
  padding: 6px 12px;
  background: white;
  color: #1e75bb;
  border: 1px solid #1e75bb;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

.pagination-button:hover:not(:disabled) {
  background: #1e75bb;
  color: white;
}

.pagination-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>

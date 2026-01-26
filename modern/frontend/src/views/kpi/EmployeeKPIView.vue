<template>
  <div class="employee-kpi-view">
    <v-breadcrumbs :items="breadcrumbs" />

    <v-card>
      <v-card-title class="text-h4 pa-4">My KPI</v-card-title>

      <v-card-text>
        <!-- Last Review and Next Review Dates -->
        <v-row class="mb-6">
          <v-col cols="12" sm="6" md="3">
            <div class="text-subtitle-2 text-grey-darken-1">Last Review</div>
            <div class="text-body-1">
              {{ lastReviewDisplay }}
            </div>
          </v-col>
          <v-col cols="12" sm="6" md="3">
            <div class="text-subtitle-2 text-grey-darken-1">Next Review</div>
            <div class="text-body-1">
              {{ nextReviewDisplay }}
            </div>
          </v-col>
        </v-row>

        <!-- Loading State -->
        <v-progress-linear v-if="loading" indeterminate color="primary" />

        <!-- Error State -->
        <v-alert v-else-if="error" type="error" class="mb-4">
          {{ error }}
        </v-alert>

        <!-- KPI Table -->
        <v-data-table
          v-else
          :headers="headers"
          :items="goalRatingData"
          :items-per-page="-1"
          class="elevation-1"
        >
          <!-- Goal Title Column -->
          <template #[`item.goalTitle`]="{ item }">
            <div class="text-body-2">{{ item.goalTitle }}</div>
          </template>

          <!-- Quarterly Rating Columns -->
          <template
            v-for="quarter in ['Q1', 'Q2', 'Q3', 'Q4']"
            :key="quarter"
            #[`item.${quarter.toLowerCase()}_Rating`]="{ item }"
          >
            <div
              class="quarter-cell"
              @mouseenter="handleCellHover(item, quarter)"
              @mouseleave="hoveredCell = null"
              @click="handleQuarterCellClick(item, quarter)"
            >
              <div class="d-flex align-center justify-center">
                <span v-if="getQuarterRating(item, quarter) !== null">
                  {{ getQuarterRating(item, quarter) }}
                </span>
                <span v-else class="text-grey-lighten-1">-</span>

                <!-- Edit Icon on Hover -->
                <v-icon
                  v-if="
                    hoveredCell?.goalId === item.goalId &&
                    hoveredCell?.quarter === quarter &&
                    isQuarterAllowed(item.allowedQuarter, quarter) &&
                    !item.status
                  "
                  size="small"
                  class="ml-1"
                >
                  mdi-pencil
                </v-icon>
              </div>
            </div>
          </template>

          <!-- Manager Rating Column -->
          <template #[`item.managerRating`]="{ item }">
            <div
              class="manager-cell"
              @click="handleManagerCellClick(item)"
              :class="{ 'cursor-pointer': item.managerRating !== null }"
            >
              <span v-if="item.managerRating !== null">
                {{ item.managerRating }}
              </span>
              <span v-else class="text-grey-lighten-1">-</span>
            </div>
          </template>

          <!-- Target Column -->
          <template #[`item.targetExpected`]="{ item }">
            {{ item.targetExpected || '-' }}
          </template>
        </v-data-table>

        <!-- Submit Button -->
        <div v-if="planId && !data?.result[0]?.isReviewed" class="mt-4 text-center">
          <v-btn
            color="primary"
            :disabled="!canSubmit"
            :loading="submitting"
            @click="handleSubmitPlan"
          >
            Submit KPI Plan
          </v-btn>
        </div>
      </v-card-text>
    </v-card>

    <!-- Edit Dialog for Employee Self-Rating -->
    <KPIEditDialog
      v-if="selectedQuarterCell"
      :open="!!selectedQuarterCell"
      :action="cellAction || 'edit'"
      :data="selectedQuarterCell"
      @close="handleCloseEditDialog"
      @success="handleEditSuccess"
    />

    <!-- View Dialog for Manager Rating -->
    <ManagerKPIEditDialog
      v-if="selectedManagerCell"
      :open="!!selectedManagerCell"
      :editable="false"
      :data="selectedManagerCell"
      @close="handleCloseManagerDialog"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useAuthStore } from '@/stores/auth.store';
import kpiService from '@/services/kpi/kpi.service';
import type {
  GoalRating,
  GetEmployeeSelfRatingResponse,
  CellAction,
  QuarterType,
} from '@/types/kpi.types';
import {
  canEmployeeSubmitRatings,
  getQuarterRating,
  isQuarterAllowed,
  formatDisplayDate,
  calculateNextAppraisalDate,
} from '@/utils/kpi.utils';
import { useSnackbar } from '@/composables/useSnackbar';
import KPIEditDialog from '@/components/kpi/KPIEditDialog.vue';
import ManagerKPIEditDialog from '@/components/kpi/ManagerKPIEditDialog.vue';

const authStore = useAuthStore();
const { showSuccess, showError } = useSnackbar();

const loading = ref(false);
const error = ref<string | null>(null);
const data = ref<GetEmployeeSelfRatingResponse | null>(null);
const goalRatingData = ref<GoalRating[]>([]);
const planId = ref<number | null>(null);
const submitting = ref(false);

const hoveredCell = ref<{ goalId: number; quarter: string } | null>(null);
const cellAction = ref<CellAction | null>(null);

const selectedQuarterCell = ref<{
  quarter: QuarterType;
  goalId: number;
  goalTitle: string;
  rating: number | null;
  note: string | null;
  planId: number;
} | null>(null);

const selectedManagerCell = ref<{
  goalId: number;
  goalTitle: string;
  rating: number;
  note: string;
  planId: number;
} | null>(null);

const breadcrumbs = [
  { title: 'KPI', disabled: false },
  { title: 'My KPI', disabled: true },
];

const headers = [
  { title: 'Goal', key: 'goalTitle', sortable: false },
  { title: 'Q1', key: 'q1_Rating', sortable: false, align: 'center' },
  { title: 'Q2', key: 'q2_Rating', sortable: false, align: 'center' },
  { title: 'Q3', key: 'q3_Rating', sortable: false, align: 'center' },
  { title: 'Q4', key: 'q4_Rating', sortable: false, align: 'center' },
  { title: 'Manager Rating', key: 'managerRating', sortable: false, align: 'center' },
  { title: 'Target', key: 'targetExpected', sortable: false },
];

const lastReviewDisplay = computed(() => {
  const lastReview = data.value?.result[0]?.lastReviewDate;
  return formatDisplayDate(lastReview);
});

const nextReviewDisplay = computed(() => {
  if (!data.value?.result[0]) return 'N/A';

  const { joiningDate, lastReviewDate } = data.value.result[0];
  return calculateNextAppraisalDate(joiningDate, lastReviewDate);
});

const canSubmit = computed(() => {
  return canEmployeeSubmitRatings(goalRatingData.value);
});

const fetchEmployeeSelfRating = async () => {
  try {
    loading.value = true;
    error.value = null;

    const userId = authStore.user?.userId;
    if (!userId) {
      throw new Error('User ID not found');
    }

    const response = await kpiService.getEmployeeSelfRating({ employeeId: +userId });
    data.value = response;

    goalRatingData.value = response.result?.[0]?.ratings ?? [];
    planId.value = response.result?.[0]?.planId ?? null;
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to fetch KPI data';
    showError(error.value);
  } finally {
    loading.value = false;
  }
};

const handleCellHover = (item: GoalRating, quarter: string) => {
  if (isQuarterAllowed(item.allowedQuarter, quarter) && !item.status) {
    hoveredCell.value = { goalId: item.goalId, quarter };
  }
};

const handleQuarterCellClick = (item: GoalRating, quarter: string) => {
  if (!isQuarterAllowed(item.allowedQuarter, quarter)) return;
  if (item.status) return; // Already submitted

  const rating = getQuarterRating(item, quarter);
  const note = item[`${quarter.toLowerCase()}_Note` as keyof GoalRating] as string | null;

  cellAction.value = rating !== null ? 'edit' : 'add';
  selectedQuarterCell.value = {
    quarter: quarter as QuarterType,
    goalId: item.goalId,
    goalTitle: item.goalTitle,
    rating,
    note,
    planId: planId.value!,
  };
};

const handleManagerCellClick = (item: GoalRating) => {
  if (item.managerRating === null) return;

  selectedManagerCell.value = {
    goalId: item.goalId,
    goalTitle: item.goalTitle,
    rating: item.managerRating,
    note: item.managerNote || '',
    planId: planId.value!,
  };
};

const handleCloseEditDialog = () => {
  selectedQuarterCell.value = null;
  cellAction.value = null;
};

const handleCloseManagerDialog = () => {
  selectedManagerCell.value = null;
};

const handleEditSuccess = () => {
  fetchEmployeeSelfRating();
  handleCloseEditDialog();
};

const handleSubmitPlan = async () => {
  if (!planId.value) return;

  try {
    submitting.value = true;
    const response = await kpiService.submitKPIPlanByEmployee(planId.value);
    showSuccess(response.message);
    await fetchEmployeeSelfRating();
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to submit KPI plan';
    showError(message);
  } finally {
    submitting.value = false;
  }
};

onMounted(() => {
  fetchEmployeeSelfRating();
});
</script>

<style scoped>
.quarter-cell {
  cursor: pointer;
  padding: 8px;
  min-height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s;
}

.quarter-cell:hover {
  background-color: rgba(0, 0, 0, 0.04);
}

.manager-cell {
  padding: 8px;
  min-height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cursor-pointer {
  cursor: pointer;
}

.cursor-pointer:hover {
  background-color: rgba(0, 0, 0, 0.04);
}
</style>

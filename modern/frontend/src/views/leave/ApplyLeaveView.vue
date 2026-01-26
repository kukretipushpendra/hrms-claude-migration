<template>
  <div class="apply-leave-view">
    <!-- Leave Type Cards Grid -->
    <div class="leave-cards-section">
      <h3 class="section-title">Apply Leave</h3>

      <div v-if="loading" class="loading-container">
        <v-progress-circular indeterminate color="primary" />
      </div>

      <div v-else-if="error" class="error-message">
        {{ error }}
      </div>

      <div v-else-if="leaveBalances.length === 0" class="no-data">No Data Found</div>

      <div v-else class="leave-cards-grid">
        <div
          v-for="leave in leaveBalances"
          :key="leave.leaveId"
          class="leave-card"
          @click="navigateToApplyForm(leave.leaveId)"
        >
          <div class="leave-card-content">
            <div class="balance-circle">
              <span class="balance-value">{{ leave.closingBalance }}</span>
            </div>
            <div class="leave-type-title">{{ leave.title }}</div>
            <div class="balance-label">Closing Balance</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Leave History Section with Tabs -->
    <div class="leave-history-section">
      <h4 class="section-subtitle">Leave History</h4>

      <v-tabs v-model="activeTab" class="leave-tabs">
        <v-tab value="leave-requests">Leave Requests</v-tab>
        <v-tab value="comp-off-swaps">Comp-Off & Swaps</v-tab>
      </v-tabs>

      <v-window v-model="activeTab">
        <v-window-item value="leave-requests">
          <LeaveHistoryTable />
        </v-window-item>
        <v-window-item value="comp-off-swaps">
          <div class="placeholder-content">
            <p>Comp-Off & Swaps functionality coming soon</p>
          </div>
        </v-window-item>
      </v-window>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import { useLeaveBalance } from '@/composables/useLeaveBalance';
import LeaveHistoryTable from '@/components/leave/LeaveHistoryTable.vue';

const router = useRouter();
const authStore = useAuthStore();
const activeTab = ref('leave-requests');

// Fetch leave balances
const { leaveBalances, loading, error } = useLeaveBalance(Number(authStore.userData?.userId));

const navigateToApplyForm = (leaveId: number) => {
  router.push(`/leave/apply-leave/add/${leaveId}`);
};
</script>

<style scoped>
.apply-leave-view {
  padding: 20px;
}

.leave-cards-section {
  margin-bottom: 30px;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1e75bb;
  margin-bottom: 20px;
}

.section-subtitle {
  font-size: 1.25rem;
  font-weight: 600;
  color: #1e75bb;
  margin-bottom: 16px;
  padding-top: 30px;
}

.loading-container {
  display: flex;
  justify-content: center;
  padding: 40px;
}

.error-message,
.no-data {
  text-align: center;
  padding: 40px;
  color: #666;
}

.leave-cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

@media (min-width: 600px) {
  .leave-cards-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 960px) {
  .leave-cards-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (min-width: 1280px) {
  .leave-cards-grid {
    grid-template-columns: repeat(4, 1fr);
  }
}

@media (min-width: 1920px) {
  .leave-cards-grid {
    grid-template-columns: repeat(5, 1fr);
  }
}

.leave-card {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 20px;
  cursor: pointer;
  transition: box-shadow 0.3s ease;
  background: white;
}

.leave-card:hover {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.leave-card-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.balance-circle {
  width: 66px;
  height: 66px;
  border-radius: 50%;
  background-color: #27a8e0;
  border: 2px solid #1e87b8;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
}

.balance-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: white;
}

.leave-type-title {
  font-size: 1rem;
  color: #1e75bb;
  margin-bottom: 4px;
  font-weight: 500;
}

.balance-label {
  font-size: 0.75rem;
  color: #666;
}

.leave-history-section {
  margin-top: 40px;
}

.leave-tabs {
  border-bottom: 1px solid #e0e0e0;
  margin-bottom: 24px;
}

.placeholder-content {
  padding: 40px;
  text-align: center;
  color: #666;
}
</style>

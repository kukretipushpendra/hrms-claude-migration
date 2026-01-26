<template>
  <div class="leave-approval-view">
    <h2 class="page-title">Leave Approval</h2>

    <v-tabs v-model="activeTab" class="approval-tabs">
      <v-tab value="leave-requests">Leave Requests</v-tab>
      <v-tab value="comp-off-swaps">Comp-Off & Swaps</v-tab>
    </v-tabs>

    <v-window v-model="activeTab">
      <v-window-item value="leave-requests">
        <LeaveRequestsTable />
      </v-window-item>
      <v-window-item value="comp-off-swaps">
        <div class="placeholder-content">
          <p>Comp-Off & Swaps approval functionality coming soon</p>
        </div>
      </v-window-item>
    </v-window>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import LeaveRequestsTable from '@/components/leave/LeaveRequestsTable.vue';

const activeTab = ref('leave-requests');
</script>

<style scoped>
.leave-approval-view {
  padding: 20px;
}

.page-title {
  font-size: 1.75rem;
  font-weight: 600;
  color: #1e75bb;
  margin-bottom: 20px;
}

.approval-tabs {
  border-bottom: 1px solid #e0e0e0;
  margin-bottom: 24px;
}

.placeholder-content {
  padding: 40px;
  text-align: center;
  color: #666;
}
</style>

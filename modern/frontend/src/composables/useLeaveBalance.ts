/**
 * Composable for fetching employee leave balances
 */

import { ref, onMounted } from 'vue';
import { getLeaveBalances } from '@/services/leave/leave.service';
import type { LeaveBalanceItem } from '@/types/leave.types';

export function useLeaveBalance(employeeId: number) {
  const leaveBalances = ref<LeaveBalanceItem[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);

  const fetchLeaveBalances = async () => {
    loading.value = true;
    error.value = null;
    try {
      const response = await getLeaveBalances(employeeId);
      leaveBalances.value = response.result.data || [];
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Failed to fetch leave balances';
      console.error('Error fetching leave balances:', err);
    } finally {
      loading.value = false;
    }
  };

  onMounted(() => {
    if (employeeId) {
      fetchLeaveBalances();
    }
  });

  return {
    leaveBalances,
    loading,
    error,
    refetch: fetchLeaveBalances,
  };
}

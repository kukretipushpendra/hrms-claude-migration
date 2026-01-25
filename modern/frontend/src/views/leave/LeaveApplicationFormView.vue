<template>
  <div class="leave-application-form">
    <v-btn variant="text" @click="goBack" class="mb-4">
      <v-icon>mdi-arrow-left</v-icon>
      Back
    </v-btn>

    <h3 class="form-title">Apply for Leave: {{ leaveTypeLabel }}</h3>

    <!-- Leave Stats Section -->
    <div v-if="leaveStats" class="leave-stats-section">
      <div class="stats-grid">
        <div class="stat-item">
          <div class="stat-value">{{ leaveStats.openingBalance }}</div>
          <div class="stat-label">Opening Balance</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ leaveStats.creditedBalance }}</div>
          <div class="stat-label">Credited Balance</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ leaveStats.leavesTaken }}</div>
          <div class="stat-label">Leaves Taken</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">{{ leaveStats.closingBalance }}</div>
          <div class="stat-label">Closing Balance</div>
        </div>
      </div>
    </div>

    <!-- Application Form -->
    <v-form ref="formRef" v-model="formValid" @submit.prevent="handleSubmit">
      <v-row>
        <v-col cols="12" md="6">
          <v-text-field
            v-model="formData.fromDate"
            type="date"
            label="Start Date *"
            variant="outlined"
            :rules="[rules.required]"
            :min="minDate"
            :max="maxDate"
          />
        </v-col>
        <v-col cols="12" md="6">
          <v-select
            v-model="formData.startDateSlot"
            :items="daySlotOptions"
            label="Slot *"
            variant="outlined"
            :rules="[rules.required]"
          />
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12" md="6">
          <v-text-field
            v-model="formData.toDate"
            type="date"
            label="End Date *"
            variant="outlined"
            :rules="[rules.required]"
            :min="minDate"
            :max="maxDate"
          />
        </v-col>
        <v-col cols="12" md="6">
          <v-select
            v-model="formData.endDateSlot"
            :items="daySlotOptions"
            label="Slot *"
            variant="outlined"
            :rules="[rules.required]"
            :disabled="isSameDay"
          />
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12">
          <v-textarea
            v-model="formData.reason"
            label="Reason *"
            variant="outlined"
            :rules="[rules.required, rules.maxLength(600)]"
            rows="4"
            counter="600"
          />
        </v-col>
      </v-row>

      <div v-if="totalLeaveDays > 0" class="leave-days-info">
        Total Leaves Applied for: <strong>{{ totalLeaveDays }}</strong>
        {{ totalLeaveDays === 1 || totalLeaveDays === 0.5 ? 'day' : 'days' }}
      </div>

      <div class="form-actions">
        <v-btn type="submit" color="primary" :loading="submitting" :disabled="!formValid">
          Submit
        </v-btn>
        <v-btn variant="text" @click="resetForm" class="ml-2">Reset</v-btn>
      </div>
    </v-form>

    <!-- Loading Overlay -->
    <v-overlay v-model="loading" class="align-center justify-center">
      <v-progress-circular indeterminate size="64" />
    </v-overlay>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import { applyLeave, getEmployeeLeaveBalanceByType } from '@/services/leave/leave.service';
import type { LeaveStats, EmployeeLeaveApplyRequest } from '@/types/leave.types';
import { DaySlot, DAY_SLOT_LABELS } from '@/types/leave.types';

const router = useRouter();
const route = useRoute();
const authStore = useAuthStore();

// Form state
const formRef = ref();
const formValid = ref(false);
const submitting = ref(false);
const loading = ref(false);
const leaveTypeLabel = ref('');
const leaveStats = ref<LeaveStats | null>(null);

const formData = ref({
  fromDate: '',
  toDate: '',
  startDateSlot: DaySlot.FullDay,
  endDateSlot: DaySlot.FullDay,
  reason: '',
});

// Computed
const leaveTypeId = computed(() => {
  return Number(route.params.id);
});

const isSameDay = computed(() => {
  return formData.value.fromDate === formData.value.toDate;
});

const totalLeaveDays = computed(() => {
  if (!formData.value.fromDate || !formData.value.toDate) return 0;

  const start = new Date(formData.value.fromDate);
  const end = new Date(formData.value.toDate);

  if (start > end) return 0;

  const diffTime = Math.abs(end.getTime() - start.getTime());
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;

  // Adjust for half-day selections
  let adjustment = 0;
  if (formData.value.startDateSlot !== DaySlot.FullDay) adjustment -= 0.5;
  if (formData.value.endDateSlot !== DaySlot.FullDay && !isSameDay.value) adjustment -= 0.5;

  return Math.max(0, diffDays + adjustment);
});

const minDate = computed(() => {
  const date = new Date();
  date.setFullYear(date.getFullYear() - 1);
  date.setMonth(0, 1);
  return date.toISOString().split('T')[0];
});

const maxDate = computed(() => {
  const date = new Date();
  date.setFullYear(date.getFullYear() + 1);
  date.setMonth(11, 31);
  return date.toISOString().split('T')[0];
});

const daySlotOptions = Object.entries(DAY_SLOT_LABELS).map(([value, title]) => ({
  value: Number(value),
  title,
}));

// Validation rules
const rules = {
  required: (v: string) => !!v || 'This field is required',
  maxLength: (max: number) => (v: string) =>
    !v || v.length <= max || `Maximum ${max} characters allowed`,
};

// Methods
const fetchLeaveBalance = async () => {
  loading.value = true;
  try {
    const response = await getEmployeeLeaveBalanceByType(
      Number(authStore.userData?.userId),
      leaveTypeId.value
    );

    if (response.result) {
      const balance = response.result;
      leaveTypeLabel.value = balance.leaveTypeName || 'Leave';
      leaveStats.value = {
        openingBalance: balance.openingBalance || 0,
        creditedBalance: balance.creditedBalance || 0,
        leavesTaken: balance.leavesTaken || 0,
        closingBalance: balance.closingBalance || 0,
      };
    }
  } catch (err) {
    console.error('Error fetching leave balance:', err);
  } finally {
    loading.value = false;
  }
};

const handleSubmit = async () => {
  if (!formValid.value) return;

  submitting.value = true;
  try {
    const payload: EmployeeLeaveApplyRequest = {
      EmployeeId: Number(authStore.userData?.userId),
      LeaveTypeId: leaveTypeId.value,
      FromDate: formData.value.fromDate,
      ToDate: formData.value.toDate,
      Reason: formData.value.reason,
      IsHalfDay:
        formData.value.startDateSlot !== DaySlot.FullDay ||
        formData.value.endDateSlot !== DaySlot.FullDay,
    };

    const response = await applyLeave(payload);

    if (response.data.isSuccess) {
      alert('Leave applied successfully');
      router.push('/leave/apply-leave');
    } else {
      alert(response.data.message || 'Failed to apply leave');
    }
  } catch (err) {
    console.error('Error applying leave:', err);
    alert('Failed to apply leave. Please try again.');
  } finally {
    submitting.value = false;
  }
};

const resetForm = () => {
  formData.value = {
    fromDate: '',
    toDate: '',
    startDateSlot: DaySlot.FullDay,
    endDateSlot: DaySlot.FullDay,
    reason: '',
  };
  formRef.value?.resetValidation();
};

const goBack = () => {
  router.back();
};

// Initialize
onMounted(() => {
  fetchLeaveBalance();
});
</script>

<style scoped>
.leave-application-form {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.form-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1e75bb;
  margin-bottom: 24px;
}

.leave-stats-section {
  background: #f5f5f5;
  padding: 20px;
  margin-bottom: 30px;
  border-radius: 8px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1e75bb;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 0.875rem;
  color: #666;
  text-transform: uppercase;
}

.leave-days-info {
  margin: 20px 0;
  font-size: 1rem;
  color: #333;
}

.form-actions {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: 24px;
}
</style>

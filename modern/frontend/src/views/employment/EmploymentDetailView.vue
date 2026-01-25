<script setup lang="ts">
import { ref } from 'vue';
import { useRoute } from 'vue-router';
import { useAuthStore } from '@/stores/auth.store';
import CurrentEmploymentDetails from './components/CurrentEmploymentDetails.vue';
import NotFoundView from '@/views/error/NotFoundView.vue';

const route = useRoute();
const authStore = useAuthStore();

const employeeId = ref(route.query.employeeId as string | undefined);

// Check permission - if viewing another employee's details, need Read.Employees permission
const hasPermission =
  !employeeId.value ||
  employeeId.value === authStore.user?.userId.toString() ||
  authStore.hasPermission('Read.Employees');

type EmploymentPanelKey = 'currentEmployment' | 'previousEmployment';

const expandedPanels = ref<Record<EmploymentPanelKey, boolean>>({
  currentEmployment: false,
  previousEmployment: false,
});

const handlePanelToggle = (panel: EmploymentPanelKey) => (isExpanded: boolean) => {
  expandedPanels.value[panel] = isExpanded;
};
</script>

<template>
  <NotFoundView v-if="!hasPermission" />
  <div v-else>
    <CurrentEmploymentDetails
      :expanded="expandedPanels.currentEmployment"
      :on-accordion-toggle="handlePanelToggle"
    />
    <!-- Previous Employment Details will be added later if needed -->
  </div>
</template>

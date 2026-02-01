<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';
import EmployeeForm from '@/components/employees/EmployeeForm.vue';

const route = useRoute();

const isEditMode = computed(() => route.name === 'employee-edit');
const employeeId = computed(() => {
  const id = route.params.id;
  return id ? Number(id) : undefined;
});
</script>

<template>
  <EmployeeForm :mode="isEditMode ? 'edit' : 'create'" :employee-id="employeeId" />
</template>

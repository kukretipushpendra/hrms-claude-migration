<template>
  <v-container fluid>
    <v-breadcrumbs
      :items="breadcrumbs"
      divider=">"
      class="px-0"
    ></v-breadcrumbs>

    <v-card elevation="3">
      <v-card-title class="d-flex align-center pa-4 border-b">
        <v-btn
          icon
          variant="text"
          size="small"
          @click="router.back()"
          class="mr-2"
        >
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <h2 class="text-h5">{{ isEditMode ? 'Edit Employee' : 'Add Employee' }}</h2>
      </v-card-title>

      <v-card-text class="pa-5">
        <v-alert type="info" variant="tonal" class="mb-4">
          Employee create/edit form will be implemented in the next phase. This includes:
          <ul class="mt-2">
            <li>Personal information fields (Name, DOB, Gender, etc.)</li>
            <li>Contact information (Email, Phone, Address, etc.)</li>
            <li>Employment details (Department, Designation, Manager, etc.)</li>
            <li>Financial details (PAN, Bank Account, PF, ESI, etc.)</li>
            <li>Form validation using VeeValidate + Zod</li>
            <li>Profile picture upload</li>
          </ul>
        </v-alert>

        <div class="d-flex justify-end gap-3">
          <v-btn @click="router.back()" variant="outlined">Cancel</v-btn>
          <v-btn color="primary" disabled>{{ isEditMode ? 'Update' : 'Create' }} Employee</v-btn>
        </div>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';

const router = useRouter();
const route = useRoute();

const isEditMode = computed(() => route.name === 'employee-edit');

const breadcrumbs = computed(() => [
  { title: 'Dashboard', to: '/dashboard' },
  { title: 'Employees', to: '/employees' },
  { title: isEditMode.value ? 'Edit Employee' : 'Add Employee', to: '', disabled: true },
]);
</script>

<style scoped>
.border-b {
  border-bottom: 1px solid rgba(0, 0, 0, 0.12);
}
</style>

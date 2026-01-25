<script setup lang="ts">
import { ref } from 'vue';
import CurrentEmploymentForm from './components/CurrentEmploymentForm.vue';

const breadcrumbs = [
  { title: 'Dashboard', to: '/dashboard' },
  { title: 'Employment Details', to: '/employment-details' },
  { title: 'Edit Employment Details', to: '', disabled: true },
];

// TODO: Add LeaveTable component when implementing leave management feature
const enableLeave = ref(false); // Feature flag
</script>

<template>
  <v-container fluid>
    <v-breadcrumbs
      :items="breadcrumbs"
      divider=">"
      class="px-0"
    ></v-breadcrumbs>

    <v-card elevation="3">
      <v-card-title class="pa-4">
        <h3>Edit Employment Details</h3>
      </v-card-title>

      <v-divider></v-divider>

      <v-card-text class="pa-4">
        <CurrentEmploymentForm :is-editable="true" />
      </v-card-text>

      <v-divider v-if="enableLeave"></v-divider>

      <!-- Leave Table will be added when leave management is implemented -->
      <!-- <v-card-text v-if="enableLeave" class="pa-4">
        <LeaveTable />
      </v-card-text> -->
    </v-card>
  </v-container>
</template>

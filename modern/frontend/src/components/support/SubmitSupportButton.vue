<script setup lang="ts">
import { ref } from 'vue';
import SubmitSupportDialog from './SubmitSupportDialog.vue';

const dialogOpen = ref(false);

function openDialog() {
  dialogOpen.value = true;
}

function closeDialog() {
  dialogOpen.value = false;
}
</script>

<template>
  <div>
    <v-btn icon variant="text" color="grey-600" @click="openDialog">
      <v-icon>mdi-face-agent</v-icon>
      <v-tooltip activator="parent" location="bottom">Send Support Query</v-tooltip>
    </v-btn>

    <SubmitSupportDialog v-if="dialogOpen" :open="dialogOpen" @close="closeDialog" />
  </div>
</template>

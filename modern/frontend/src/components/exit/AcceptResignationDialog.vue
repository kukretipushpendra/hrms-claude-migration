<script setup lang="ts">
interface Props {
  modelValue: boolean;
  loading?: boolean;
}

defineProps<Props>();
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'confirm'): void;
}>();

const handleClose = () => {
  emit('update:modelValue', false);
};

const handleConfirm = () => {
  emit('confirm');
};
</script>

<template>
  <v-dialog :model-value="modelValue" max-width="500" @update:model-value="handleClose">
    <v-card>
      <v-card-title class="text-h6 bg-primary text-white"> Accept Resignation </v-card-title>
      <v-card-text class="pa-6">
        <p class="text-body-1">Are you sure you want to accept this resignation?</p>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn color="secondary" variant="text" :disabled="loading" @click="handleClose">
          Cancel
        </v-btn>
        <v-btn color="success" variant="flat" :loading="loading" @click="handleConfirm">
          Accept
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

<script setup lang="ts">
interface Props {
  modelValue: boolean;
  title: string;
  reason: string;
}

defineProps<Props>();
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
}>();

const handleClose = () => {
  emit('update:modelValue', false);
};
</script>

<template>
  <v-dialog :model-value="modelValue" max-width="600" @update:model-value="handleClose">
    <v-card>
      <v-card-title class="text-h6 bg-primary text-white">
        {{ title }}
      </v-card-title>
      <v-card-text class="pa-6">
        <p class="text-body-1">{{ reason }}</p>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn color="primary" variant="flat" @click="handleClose">Close</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

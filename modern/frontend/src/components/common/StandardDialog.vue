<script setup lang="ts">
/**
 * Standard Dialog Component
 * Standardized dialog component matching legacy React patterns
 * Features:
 * - Consistent max-width (960px default)
 * - Close button positioned absolutely
 * - Header with bottom border
 * - Title color matching theme
 */

interface Props {
  modelValue: boolean;
  title: string;
  maxWidth?: string | number;
  persistent?: boolean;
}

withDefaults(defineProps<Props>(), {
  maxWidth: '960px',
  persistent: false,
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'close'): void;
}>();

const closeDialog = () => {
  emit('update:modelValue', false);
  emit('close');
};
</script>

<template>
  <v-dialog
    :model-value="modelValue"
    :max-width="maxWidth"
    :persistent="persistent"
    @update:model-value="emit('update:modelValue', $event)"
  >
    <v-card class="standard-dialog">
      <!-- Close Button -->
      <v-btn icon size="small" variant="text" class="dialog-close-btn" @click="closeDialog">
        <v-icon>mdi-close</v-icon>
      </v-btn>

      <!-- Header -->
      <v-card-title class="dialog-header">
        {{ title }}
      </v-card-title>

      <!-- Content -->
      <v-card-text class="dialog-content">
        <slot />
      </v-card-text>

      <!-- Actions (optional) -->
      <v-card-actions v-if="$slots.actions" class="dialog-actions">
        <slot name="actions" />
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped lang="scss">
.standard-dialog {
  position: relative;
}

.dialog-close-btn {
  position: absolute;
  right: 8px;
  top: 8px;
  z-index: 1;
}

.dialog-header {
  border-bottom: 1px solid #e0e0e0;
  color: #1e75bb;
  font-size: 1.25rem;
  font-weight: 600;
  padding: 16px 24px;
}

.dialog-content {
  padding: 24px;
}

.dialog-actions {
  padding: 16px 24px;
  border-top: 1px solid #e0e0e0;
}
</style>

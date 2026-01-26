<script setup lang="ts">
import { computed } from 'vue';
import type { EmailTemplateTypeOption } from '@/types/email.types';

interface Props {
  modelValue: number | null | undefined;
  options: EmailTemplateTypeOption[];
  label?: string;
  disabled?: boolean;
  error?: string;
}

const props = withDefaults(defineProps<Props>(), {
  label: 'Template Type',
  disabled: false,
  error: '',
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: number | null | undefined): void;
}>();

const selectedValue = computed({
  get: () => props.modelValue ?? null,
  set: (value) => emit('update:modelValue', value),
});
</script>

<template>
  <v-select
    v-model="selectedValue"
    :items="options"
    :label="label"
    :disabled="disabled"
    :error-messages="error"
    item-title="name"
    item-value="id"
    variant="outlined"
    density="comfortable"
    clearable
  />
</template>

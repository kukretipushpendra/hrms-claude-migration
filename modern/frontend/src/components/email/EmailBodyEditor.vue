<script setup lang="ts">
import { ref, computed } from 'vue';
import { EMAIL_TEMPLATE_PLACEHOLDERS } from '@/types/email.types';

interface Props {
  modelValue: string;
  label?: string;
  error?: string;
}

const props = withDefaults(defineProps<Props>(), {
  label: 'Mail Body',
  error: '',
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void;
}>();

const content = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
});

const showPlaceholderMenu = ref(false);

// Insert placeholder at cursor position (simplified - appends to end)
const insertPlaceholder = (placeholder: string) => {
  const current = content.value || '';
  content.value = current + placeholder;
  showPlaceholderMenu.value = false;
};
</script>

<template>
  <div class="email-body-editor">
    <v-label class="mb-2">{{ label }}</v-label>

    <div class="d-flex justify-end mb-2">
      <v-menu v-model="showPlaceholderMenu" :close-on-content-click="false">
        <template #activator="{ props: menuProps }">
          <v-btn v-bind="menuProps" variant="outlined" size="small" prepend-icon="mdi-code-braces">
            Insert Placeholder
          </v-btn>
        </template>

        <v-card max-width="300" max-height="400" class="overflow-y-auto">
          <v-list density="compact">
            <v-list-item
              v-for="placeholder in EMAIL_TEMPLATE_PLACEHOLDERS"
              :key="placeholder"
              :title="placeholder"
              @click="insertPlaceholder(placeholder)"
            />
          </v-list>
        </v-card>
      </v-menu>
    </div>

    <v-textarea
      v-model="content"
      :error-messages="error"
      variant="outlined"
      rows="12"
      placeholder="Enter HTML content here. Use placeholders like {FirstName}, {LastName}, etc."
      class="monospace-textarea"
    />

    <v-card v-if="content" variant="outlined" class="mt-2 pa-3">
      <v-label class="mb-2">Preview</v-label>
      <!-- eslint-disable-next-line vue/no-v-html -->
      <div class="email-preview" v-html="content" />
    </v-card>
  </div>
</template>

<style scoped>
.email-body-editor {
  width: 100%;
}

.monospace-textarea :deep(textarea) {
  font-family: 'Courier New', Courier, monospace;
  font-size: 0.9rem;
}

.email-preview {
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  padding: 12px;
  background-color: #fafafa;
  min-height: 100px;
  font-family: Arial, sans-serif;
}

.email-preview :deep(p) {
  margin: 0 0 8px 0;
}

.email-preview :deep(p:last-child) {
  margin-bottom: 0;
}
</style>

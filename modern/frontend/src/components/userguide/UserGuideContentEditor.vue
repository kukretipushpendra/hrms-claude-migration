<script setup lang="ts">
import { ref, watch } from 'vue';

interface Props {
  modelValue: string;
  label?: string;
  error?: string;
}

const props = withDefaults(defineProps<Props>(), {
  label: 'Content',
  error: '',
});

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void;
}>();

const showPreview = ref(false);
const localValue = ref(props.modelValue);

watch(
  () => props.modelValue,
  (newVal) => {
    localValue.value = newVal;
  }
);

const handleInput = () => {
  emit('update:modelValue', localValue.value);
};
</script>

<template>
  <div class="user-guide-content-editor">
    <div class="d-flex justify-space-between align-center mb-2">
      <label class="text-subtitle-2">{{ label }}</label>
      <v-btn-toggle v-model="showPreview" mandatory density="compact">
        <v-btn :value="false" size="small">Edit</v-btn>
        <v-btn :value="true" size="small">Preview</v-btn>
      </v-btn-toggle>
    </div>

    <!-- Edit Mode -->
    <div v-if="!showPreview">
      <v-textarea
        v-model="localValue"
        placeholder="Enter guide content (HTML supported)"
        rows="15"
        variant="outlined"
        :error-messages="error"
        @input="handleInput"
      />
      <div class="text-caption text-grey mt-1">
        Supports HTML formatting: &lt;p&gt;, &lt;strong&gt;, &lt;em&gt;, &lt;ul&gt;, &lt;ol&gt;,
        &lt;li&gt;, &lt;a&gt;, etc.
      </div>
    </div>

    <!-- Preview Mode -->
    <div v-else>
      <v-card variant="outlined" class="pa-4" min-height="400">
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div v-if="localValue" class="content-preview" v-html="localValue"></div>
        <div v-else class="text-grey text-center py-8">No content to preview</div>
      </v-card>
    </div>
  </div>
</template>

<style scoped>
.content-preview {
  line-height: 1.6;
  word-wrap: break-word;
}

.content-preview :deep(p) {
  margin-bottom: 1em;
}

.content-preview :deep(ul),
.content-preview :deep(ol) {
  margin-left: 1.5em;
  margin-bottom: 1em;
}

.content-preview :deep(strong) {
  font-weight: 600;
}

.content-preview :deep(a) {
  color: #1976d2;
  text-decoration: underline;
}
</style>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useField } from 'vee-validate';
import { documentService } from '@/services/document/document.service';
import { DOCUMENT_CATEGORIES } from '@/types/document.types';
import type { GovtDocumentType } from '@/types/document.types';

interface Props {
  name?: string;
  required?: boolean;
  disabled?: boolean;
  existingDocTypes?: number[];
  currentDocType?: number | null;
}

const props = withDefaults(defineProps<Props>(), {
  name: 'documentTypeId',
  required: true,
  disabled: false,
  existingDocTypes: () => [],
  currentDocType: null,
});

const emit = defineEmits<{
  (e: 'update:selectedType', type: GovtDocumentType | null): void;
}>();

// Form field
const { value, errorMessage } = useField<number | null>(() => props.name, undefined, {
  initialValue: null,
});

// State
const documentTypes = ref<GovtDocumentType[]>([]);
const loading = ref(true);
const error = ref<string | null>(null);

// Fetch document types
const fetchDocumentTypes = async () => {
  try {
    loading.value = true;
    error.value = null;
    const types = await documentService.getGovtDocumentTypes(DOCUMENT_CATEGORIES.PERSONAL_DETAILS);
    documentTypes.value = types;
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load document types';
    documentTypes.value = [];
  } finally {
    loading.value = false;
  }
};

// Filter available options (exclude existing types)
const availableOptions = ref<GovtDocumentType[]>([]);

const updateAvailableOptions = () => {
  availableOptions.value = documentTypes.value.filter((type) => {
    // Include if not in existing list, or if it's the current document type being edited
    return !props.existingDocTypes.includes(type.id) || type.id === props.currentDocType;
  });
};

// Watch for changes
watch(
  () => [documentTypes.value, props.existingDocTypes, props.currentDocType],
  () => {
    updateAvailableOptions();
  },
  { deep: true }
);

// Watch value changes to emit selected type
watch(value, (newValue) => {
  if (newValue) {
    const selectedType = documentTypes.value.find((t) => t.id === newValue) || null;
    emit('update:selectedType', selectedType);
  } else {
    emit('update:selectedType', null);
  }
});

onMounted(() => {
  fetchDocumentTypes();
});
</script>

<template>
  <div>
    <v-select
      v-model="value"
      :items="availableOptions"
      item-title="name"
      item-value="id"
      label="Document Type"
      :required="required"
      :disabled="disabled || loading"
      :loading="loading"
      :error-messages="errorMessage"
      variant="outlined"
      density="comfortable"
    />
    <div v-if="error" class="text-error text-caption mt-1">
      {{ error }}
    </div>
  </div>
</template>

<style scoped>
.text-error {
  color: rgb(var(--v-theme-error));
}
</style>

<template>
  <v-dialog v-model="dialog" max-width="500px" persistent>
    <v-card>
      <v-card-title>Import Assets from Excel</v-card-title>
      <v-card-text>
        <v-file-input
          v-model="selectedFile"
          label="Select Excel File"
          accept=".xlsx,.xls"
          prepend-icon="mdi-file-excel"
          show-size
          clearable
        />
        <v-alert v-if="errorMessage" type="error" class="mt-3">
          {{ errorMessage }}
        </v-alert>
        <v-alert v-if="successMessage" type="success" class="mt-3">
          {{ successMessage }}
        </v-alert>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn variant="text" @click="handleCancel">Cancel</v-btn>
        <v-btn color="primary" :loading="uploading" :disabled="!selectedFile" @click="handleImport">
          Import
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { importExcel } from '@/services/assets/asset.service';

// Props
const props = defineProps<{
  modelValue: boolean;
}>();

// Emits
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'importSuccess'): void;
}>();

// Local state
const selectedFile = ref<File[]>([]);
const uploading = ref(false);
const errorMessage = ref('');
const successMessage = ref('');

// Two-way binding
const dialog = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
});

// Handle import
const handleImport = async () => {
  if (!selectedFile.value || selectedFile.value.length === 0 || !selectedFile.value[0]) {
    errorMessage.value = 'Please select a file';
    return;
  }

  uploading.value = true;
  errorMessage.value = '';
  successMessage.value = '';

  try {
    const response = await importExcel(selectedFile.value[0], true);

    if (response.statusCode === 200) {
      successMessage.value = response.message || 'Import successful';
      setTimeout(() => {
        emit('importSuccess');
        handleCancel();
      }, 1500);
    } else {
      errorMessage.value = response.message || 'Import failed';
    }
  } catch (error: unknown) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'An error occurred during import';
  } finally {
    uploading.value = false;
  }
};

// Handle cancel
const handleCancel = () => {
  selectedFile.value = [];
  errorMessage.value = '';
  successMessage.value = '';
  dialog.value = false;
};
</script>

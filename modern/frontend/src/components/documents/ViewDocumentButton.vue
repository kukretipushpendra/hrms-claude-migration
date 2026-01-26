<script setup lang="ts">
import { ref } from 'vue';
import { documentService } from '@/services/document/document.service';

interface Props {
  fileName: string;
  hasPermission: boolean;
}

const props = defineProps<Props>();

// State
const loading = ref(false);
const previewDialog = ref(false);
const fileContent = ref<string | null>(null);
const fileType = ref<string>('');

// Get file extension
const getFileExtension = (filename: string): string => {
  const parts = filename.split('.');
  return parts.length > 1 ? parts[parts.length - 1].toLowerCase() : '';
};

// Check if file is supported
const isSupportedFile = (filename: string): boolean => {
  const ext = getFileExtension(filename);
  return ['pdf', 'jpg', 'jpeg', 'png'].includes(ext);
};

// View document
const handleViewDocument = async () => {
  if (!props.fileName) {
    return;
  }

  if (!isSupportedFile(props.fileName)) {
    alert('Invalid file type. Only PDF and image files are supported.');
    return;
  }

  try {
    loading.value = true;
    const base64Content = await documentService.downloadUserDocument(props.fileName);

    if (base64Content) {
      fileContent.value = base64Content;
      fileType.value = getFileExtension(props.fileName);
      previewDialog.value = true;
    } else {
      alert('File content not available');
    }
  } catch (error) {
    console.error('Error loading document:', error);
    alert('Failed to load document. Please try again.');
  } finally {
    loading.value = false;
  }
};

// Get blob URL from base64
const getBlobUrl = (base64: string, type: string): string => {
  const mimeTypes: Record<string, string> = {
    pdf: 'application/pdf',
    jpg: 'image/jpeg',
    jpeg: 'image/jpeg',
    png: 'image/png',
  };

  const mimeType = mimeTypes[type] || 'application/octet-stream';
  const byteCharacters = atob(base64);
  const byteNumbers = new Array(byteCharacters.length);

  for (let i = 0; i < byteCharacters.length; i++) {
    byteNumbers[i] = byteCharacters.charCodeAt(i);
  }

  const byteArray = new Uint8Array(byteNumbers);
  const blob = new Blob([byteArray], { type: mimeType });
  return URL.createObjectURL(blob);
};

// Close dialog
const closeDialog = () => {
  previewDialog.value = false;
  // Clean up blob URL if needed
  if (fileContent.value && fileType.value) {
    const url = getBlobUrl(fileContent.value, fileType.value);
    URL.revokeObjectURL(url);
  }
  fileContent.value = null;
  fileType.value = '';
};
</script>

<template>
  <div>
    <v-tooltip
      :text="hasPermission ? 'View Attachment' : 'No Permission To View Attachment'"
      location="top"
    >
      <template #activator="{ props: tooltipProps }">
        <v-btn
          v-bind="tooltipProps"
          :disabled="!hasPermission || !fileName"
          :loading="loading"
          icon
          size="small"
          variant="text"
          @click="handleViewDocument"
        >
          <v-icon>{{ hasPermission ? 'mdi-eye' : 'mdi-eye-off' }}</v-icon>
        </v-btn>
      </template>
    </v-tooltip>

    <!-- Preview Dialog -->
    <v-dialog v-model="previewDialog" max-width="900px" @click:outside="closeDialog">
      <v-card>
        <v-card-title class="d-flex justify-space-between align-center">
          <span>Document Preview</span>
          <v-btn icon variant="text" @click="closeDialog">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text class="pa-0">
          <div v-if="fileContent" class="preview-container">
            <!-- PDF Preview -->
            <iframe
              v-if="fileType === 'pdf'"
              :src="getBlobUrl(fileContent, fileType)"
              width="100%"
              height="600px"
              style="border: none"
            />
            <!-- Image Preview -->
            <img
              v-else
              :src="getBlobUrl(fileContent, fileType)"
              alt="Document"
              class="preview-image"
            />
          </div>
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<style scoped>
.preview-container {
  min-height: 400px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.preview-image {
  max-width: 100%;
  max-height: 600px;
  object-fit: contain;
}
</style>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import {
  VContainer,
  VCard,
  VCardTitle,
  VCardText,
  VRow,
  VCol,
  VChip,
  VBtn,
  VProgressCircular,
} from 'vuetify/components';
import { getDeveloperLogById } from '@/services/developer/developer.service';
import type { DeveloperLog } from '@/types/developer.types';
import { LogLevel } from '@/types/developer.types';
import { format } from 'date-fns';

const route = useRoute();
const router = useRouter();

// State
const log = ref<DeveloperLog | null>(null);
const loading = ref(true);
const error = ref<string | null>(null);

// Fetch log details
const fetchLogDetails = async () => {
  const logId = Number(route.params.id);

  if (isNaN(logId)) {
    error.value = 'Invalid log ID';
    loading.value = false;
    return;
  }

  loading.value = true;
  error.value = null;

  try {
    log.value = await getDeveloperLogById(logId);
  } catch (err) {
    const errorObj = err as { response?: { data?: { message?: string } } };
    error.value = errorObj.response?.data?.message || 'Failed to fetch log details';
  } finally {
    loading.value = false;
  }
};

// Format date
const formatDate = (dateString: string | null): string => {
  if (!dateString) return 'N/A';
  try {
    return format(new Date(dateString), 'yyyy MMM dd HH:mm:ss');
  } catch {
    return dateString;
  }
};

// Log level color
const getLogLevelColor = (level: string): string => {
  if (level === LogLevel.Error) return 'error';
  if (level === LogLevel.Warning) return 'warning';
  return 'default';
};

// Go back
const goBack = () => {
  router.push({ name: 'developer-logs' });
};

onMounted(() => {
  fetchLogDetails();
});
</script>

<template>
  <VContainer fluid>
    <VCard>
      <VCardTitle class="d-flex justify-space-between align-center">
        <span>Log Details</span>
        <VBtn variant="outlined" @click="goBack">Back to Logs</VBtn>
      </VCardTitle>

      <VCardText>
        <div v-if="loading" class="text-center py-8">
          <VProgressCircular indeterminate color="primary" size="64" />
        </div>

        <div v-else-if="error" class="text-center py-8 text-error">
          {{ error }}
        </div>

        <VRow v-else-if="log" dense>
          <VCol cols="12" md="6">
            <div class="detail-row">
              <strong>ID:</strong>
              <span>{{ log.id }}</span>
            </div>
          </VCol>

          <VCol cols="12" md="6">
            <div class="detail-row">
              <strong>Log Level:</strong>
              <VChip :color="getLogLevelColor(log.logLevel)" size="small">
                {{ log.logLevel }}
              </VChip>
            </div>
          </VCol>

          <VCol cols="12" md="6">
            <div class="detail-row">
              <strong>Timestamp:</strong>
              <span>{{ formatDate(log.timestamp) }}</span>
            </div>
          </VCol>

          <VCol cols="12" md="6">
            <div class="detail-row">
              <strong>Request ID:</strong>
              <code class="request-id">{{ log.requestId || 'N/A' }}</code>
            </div>
          </VCol>

          <VCol cols="12" md="6">
            <div class="detail-row">
              <strong>Log Event:</strong>
              <span>{{ log.logEvent || 'N/A' }}</span>
            </div>
          </VCol>

          <VCol cols="12">
            <div class="detail-row">
              <strong>Message:</strong>
              <p class="message-text">{{ log.message || 'N/A' }}</p>
            </div>
          </VCol>

          <VCol cols="12">
            <div class="detail-row">
              <strong>Exception:</strong>
              <pre v-if="log.exception" class="exception-text">{{ log.exception }}</pre>
              <span v-else>No exception</span>
            </div>
          </VCol>
        </VRow>
      </VCardText>
    </VCard>
  </VContainer>
</template>

<style scoped>
.detail-row {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  padding: 0.75rem;
  border-bottom: 1px solid #e0e0e0;
}

.detail-row strong {
  font-weight: 600;
  color: #555;
  font-size: 0.875rem;
}

.request-id {
  font-family: 'Courier New', monospace;
  font-size: 0.875rem;
  background-color: #f5f5f5;
  padding: 4px 8px;
  border-radius: 4px;
  display: inline-block;
}

.message-text {
  margin: 0;
  padding: 8px;
  background-color: #f9f9f9;
  border-radius: 4px;
  font-size: 0.875rem;
}

.exception-text {
  font-family: 'Courier New', monospace;
  font-size: 0.75rem;
  background-color: #fff3e0;
  padding: 12px;
  border-radius: 4px;
  overflow-x: auto;
  white-space: pre-wrap;
  word-break: break-word;
  max-height: 400px;
  overflow-y: auto;
  border: 1px solid #ffe0b2;
}
</style>

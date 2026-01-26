<template>
  <v-card :class="['message-card', origin]" flat :color="cardColor">
    <v-card-text>
      <div class="d-flex align-start mb-3">
        <v-avatar :color="avatarColor" size="40" class="mr-3">
          <span class="text-h6">{{ actorInitials }}</span>
        </v-avatar>
        <div class="flex-grow-1">
          <div class="d-flex justify-space-between align-center">
            <div>
              <div class="text-subtitle-1 font-weight-medium">{{ actor.name }}</div>
              <div v-if="actor.email" class="text-caption text-medium-emphasis">
                {{ actor.email }}
              </div>
            </div>
            <div class="text-caption text-medium-emphasis">
              {{ formatTimestamp(timestamp) }}
            </div>
          </div>
        </div>
      </div>

      <div v-if="status" class="mb-2">
        <GrievanceStatusChip :status="status" size="small" />
      </div>

      <div class="message-body" v-html="bodyHtml"></div>

      <v-divider v-if="attachment" class="my-3" />

      <div v-if="attachment" class="attachment-section">
        <v-chip
          prepend-icon="mdi-paperclip"
          variant="outlined"
          :href="attachment.url"
          target="_blank"
          @click.prevent="downloadAttachment(attachment)"
        >
          {{ attachment.name }}
        </v-chip>
      </div>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import GrievanceStatusChip from './GrievanceStatusChip.vue';
import type { GrievanceStatusType } from '@/types/grievance.types';

interface Actor {
  name: string;
  email?: string;
  avatarUrl?: string;
}

interface Attachment {
  name: string;
  url: string;
}

interface Props {
  actor: Actor;
  timestamp: string;
  bodyHtml: string;
  attachment?: Attachment;
  status?: GrievanceStatusType;
  origin?: 'requester' | 'owner';
  toneBy?: 'status' | 'default';
}

const props = withDefaults(defineProps<Props>(), {
  origin: 'owner',
  toneBy: 'default',
});

const actorInitials = computed(() => {
  const names = props.actor.name.split(' ');
  if (names.length >= 2) {
    return names[0][0] + names[1][0];
  }
  return names[0]?.substring(0, 2) || 'U';
});

const avatarColor = computed(() => {
  return props.origin === 'requester' ? 'primary' : 'secondary';
});

const cardColor = computed(() => {
  if (props.toneBy === 'status' && props.status) {
    // System messages or status-based coloring
    return 'grey-lighten-4';
  }
  return props.origin === 'requester' ? 'blue-lighten-5' : 'grey-lighten-5';
});

const formatTimestamp = (timestamp: string) => {
  const date = new Date(timestamp);
  return date.toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};

const downloadAttachment = (attachment: Attachment) => {
  window.open(attachment.url, '_blank');
};
</script>

<style scoped>
.message-card {
  margin-bottom: 16px;
  border: 1px solid rgba(0, 0, 0, 0.12);
}

.message-card.requester {
  border-left: 4px solid rgb(var(--v-theme-primary));
}

.message-card.owner {
  border-left: 4px solid rgb(var(--v-theme-secondary));
}

.message-body {
  margin-top: 12px;
}

.message-body :deep(p) {
  margin-bottom: 8px;
}

.attachment-section {
  display: flex;
  align-items: center;
}
</style>

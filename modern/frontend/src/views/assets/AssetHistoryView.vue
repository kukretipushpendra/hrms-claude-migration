<template>
  <div class="asset-history-view">
    <div class="pa-5">
      <h3 class="text-h5 mb-4">History</h3>

      <v-data-table
        :headers="headers"
        :items="historyItems"
        :loading="loading"
        :items-per-page="10"
        class="elevation-1"
      >
        <template #item.sNo="{ index }">
          {{ index + 1 }}
        </template>

        <template #item.employeeName="{ item }">
          {{ item.employeeName?.trim() || 'NIL' }}
        </template>

        <template #item.assetStatus="{ item }">
          {{ getStatusLabel(item.assetStatus) }}
        </template>

        <template #item.assetCondition="{ item }">
          {{ getConditionLabel(item.assetCondition) }}
        </template>

        <template #item.modifiedBy="{ item }">
          {{ item.modifiedBy || 'N/A' }}
        </template>

        <template #item.modifiedOn="{ item }">
          {{ formatDate(item.modifiedOn) }}
        </template>

        <template #item.issueDate="{ item }">
          {{ item.issueDate ? formatDate(item.issueDate) : 'NIL' }}
        </template>

        <template #item.returnDate="{ item }">
          {{ item.returnDate ? formatDate(item.returnDate) : 'NIL' }}
        </template>

        <template #item.note="{ item }">
          <v-tooltip v-if="item.note" location="top">
            <template #activator="{ props: tooltipProps }">
              <span
                v-bind="tooltipProps"
                class="text-truncate d-inline-block"
                style="max-width: 200px"
              >
                {{ item.note }}
              </span>
            </template>
            {{ item.note }}
          </v-tooltip>
          <span v-else>N/A</span>
        </template>

        <template #loading>
          <v-skeleton-loader type="table-row@5" />
        </template>

        <template #no-data>
          <div class="text-center py-5">
            <v-icon size="64" color="grey">mdi-history</v-icon>
            <p class="text-grey mt-2">No history records found</p>
          </div>
        </template>
      </v-data-table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import { toast } from 'vue3-toastify';
import type { ITAssetHistory } from '@/types/asset.types';
import { getAssetHistoryById } from '@/services/assets/asset.service';
import {
  ASSET_STATUS_OPTIONS,
  ASSET_CONDITION_OPTIONS,
  AssetStatus,
  AssetCondition,
} from '@/types/asset.types';

const route = useRoute();

const historyItems = ref<ITAssetHistory[]>([]);
const loading = ref(false);

const assetId = computed(() => Number(route.params.assetId));

const headers = [
  { title: 'S No.', key: 'sNo', sortable: false, width: 80 },
  { title: 'Employee Name', key: 'employeeName', sortable: true },
  { title: 'Asset Status', key: 'assetStatus', sortable: true },
  { title: 'Asset Condition', key: 'assetCondition', sortable: true },
  { title: 'Updated by', key: 'modifiedBy', sortable: true },
  { title: 'Updated On', key: 'modifiedOn', sortable: true },
  { title: 'Issue Date', key: 'issueDate', sortable: true },
  { title: 'Return Date', key: 'returnDate', sortable: true },
  { title: 'Comment', key: 'note', sortable: false, width: 200 },
];

onMounted(() => {
  fetchHistory();
});

async function fetchHistory() {
  try {
    loading.value = true;
    const response = await getAssetHistoryById(assetId.value);

    if (response.statusCode === 200 && response.result) {
      historyItems.value = response.result;
    } else {
      toast.error('Failed to load asset history');
    }
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Failed to load asset history';
    toast.error(message);
  } finally {
    loading.value = false;
  }
}

function getStatusLabel(status: AssetStatus): string {
  const option = ASSET_STATUS_OPTIONS.find((opt) => opt.value === status);
  return option?.label || 'Unknown';
}

function getConditionLabel(condition: AssetCondition): string {
  const option = ASSET_CONDITION_OPTIONS.find((opt) => opt.value === condition);
  return option?.label || 'Unknown';
}

function formatDate(dateString: string | null): string {
  if (!dateString) return 'N/A';
  try {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  } catch {
    return 'Invalid Date';
  }
}
</script>

<style scoped>
.asset-history-view {
  background-color: #fff;
}
</style>

<template>
  <div>
    <ITAssetForm
      mode="edit"
      :asset-data="assetData"
      :is-editable="isEditable"
      @success="handleSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import type { AssetData } from '@/types/asset.types';
import ITAssetForm from '@/components/assets/ITAssetForm.vue';

interface Props {
  assetData: AssetData | null;
  loading: boolean;
  isEditable: boolean;
}

defineProps<Props>();

const emit = defineEmits<{
  (e: 'refresh'): void;
}>();

function handleSuccess() {
  emit('refresh');
}
</script>

<script setup lang="ts">
interface Props {
  open: boolean;
  title: string;
  message: string;
}

defineProps<Props>();

const emit = defineEmits<{
  (e: 'confirm'): void;
  (e: 'cancel'): void;
}>();

function handleConfirm() {
  emit('confirm');
}

function handleCancel() {
  emit('cancel');
}
</script>

<template>
  <div v-if="open" class="dialog-overlay" @click.self="handleCancel">
    <div class="dialog-container">
      <div class="dialog-header">
        <h4>{{ title }}</h4>
      </div>

      <div class="dialog-content">
        <p>{{ message }}</p>
      </div>

      <div class="dialog-actions">
        <button type="button" class="btn-confirm" @click="handleConfirm">Confirm</button>
        <button type="button" class="btn-cancel" @click="handleCancel">Cancel</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.dialog-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 400px;
  width: 90%;
}

.dialog-header {
  padding: 20px;
  border-bottom: 1px solid #e0e0e0;
}

.dialog-header h4 {
  margin: 0;
  color: #d32f2f;
  font-size: 18px;
}

.dialog-content {
  padding: 24px 20px;
}

.dialog-content p {
  margin: 0;
  color: #666;
  line-height: 1.5;
}

.dialog-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
  padding: 20px;
  border-top: 1px solid #e0e0e0;
}

.btn-confirm,
.btn-cancel {
  padding: 8px 20px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-confirm {
  background-color: #d32f2f;
  color: white;
}

.btn-confirm:hover {
  background-color: #b71c1c;
}

.btn-cancel {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-cancel:hover {
  background-color: #e0e0e0;
}
</style>

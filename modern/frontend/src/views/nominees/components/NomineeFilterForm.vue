<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue';
import { nomineeService } from '@/services/nominee/nominee.service';
import type { NomineeRelationship, NomineeSearchFilter } from '@/types/nominee.types';
import { toast } from 'vue3-toastify';

// Props
interface Props {
  showAddButton?: boolean;
  addDisabled?: boolean;
  addTooltip?: string;
}

withDefaults(defineProps<Props>(), {
  showAddButton: false,
  addDisabled: false,
  addTooltip: 'Add a new nominee',
});

// Emits
const emit = defineEmits<{
  (e: 'search', filters: NomineeSearchFilter): void;
  (e: 'reset'): void;
  (e: 'add'): void;
}>();

// Constants
const OTHER_RELATIONSHIP_ID = 13; // Same as legacy

// State
const nomineeName = ref('');
const relationshipId = ref<string>('');
const others = ref('');
const relationshipOptions = ref<NomineeRelationship[]>([]);
const loadingRelationships = ref(false);

// Computed
const showOtherRelationship = computed(() => {
  return Number(relationshipId.value) === OTHER_RELATIONSHIP_ID;
});

// Fetch relationships
async function fetchRelationships() {
  loadingRelationships.value = true;
  try {
    const response = await nomineeService.getRelationshipList();
    relationshipOptions.value = response.result || [];
  } catch (error) {
    console.error('Failed to fetch relationships:', error);
    toast.error('Failed to load relationship options');
  } finally {
    loadingRelationships.value = false;
  }
}

// Handle search
function handleSearch() {
  emit('search', {
    nomineeName: nomineeName.value || undefined,
    relationshipId: relationshipId.value || undefined,
    others: others.value || undefined,
  });
}

// Handle reset
function handleReset() {
  nomineeName.value = '';
  relationshipId.value = '';
  others.value = '';
  emit('reset');
}

// Handle add
function handleAdd() {
  emit('add');
}

// Watch relationship change to clear others field
watch(relationshipId, (newVal) => {
  if (Number(newVal) !== OTHER_RELATIONSHIP_ID) {
    others.value = '';
  }
});

// Initial load
onMounted(() => {
  fetchRelationships();
});
</script>

<template>
  <div class="filter-form">
    <form @submit.prevent="handleSearch" autocomplete="off">
      <div class="form-row">
        <!-- Nominee Name -->
        <div class="form-field">
          <label for="nomineeName">Nominee Name</label>
          <input
            id="nomineeName"
            v-model="nomineeName"
            type="text"
            placeholder="Enter nominee name"
            maxlength="35"
          />
        </div>

        <!-- Relationship -->
        <div class="form-field">
          <label for="relationshipId">Relationship</label>
          <select id="relationshipId" v-model="relationshipId">
            <option value="">Select Relationship</option>
            <option v-for="relation in relationshipOptions" :key="relation.id" :value="relation.id">
              {{ relation.name }}
            </option>
          </select>
        </div>

        <!-- Specify Relationship (shown only when "Others" is selected) -->
        <div v-if="showOtherRelationship" class="form-field">
          <label for="others">Specify Relationship <span class="required">*</span></label>
          <input
            id="others"
            v-model="others"
            type="text"
            placeholder="Enter relationship"
            maxlength="35"
            required
          />
        </div>

        <!-- Action Buttons -->
        <div class="form-actions">
          <button type="submit" class="btn-search" title="Search">🔍 Search</button>
          <button type="button" @click="handleReset" class="btn-reset" title="Reset">
            🔄 Reset
          </button>
          <button
            v-if="showAddButton"
            type="button"
            @click="handleAdd"
            class="btn-add"
            :disabled="addDisabled"
            :title="addTooltip"
          >
            ➕ Add
          </button>
        </div>
      </div>
    </form>
  </div>
</template>

<style scoped>
.filter-form {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.form-row {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  align-items: flex-end;
}

.form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
  min-width: 200px;
}

.form-field label {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.required {
  color: #d32f2f;
}

.form-field input,
.form-field select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  transition: border-color 0.2s;
}

.form-field input:focus,
.form-field select:focus {
  outline: none;
  border-color: #1e75bb;
}

.form-actions {
  display: flex;
  gap: 12px;
}

.btn-search,
.btn-reset,
.btn-add {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
}

.btn-search {
  background-color: #1e75bb;
  color: white;
}

.btn-search:hover {
  background-color: #165a93;
}

.btn-reset {
  background-color: #f5f5f5;
  color: #333;
  border: 1px solid #ddd;
}

.btn-reset:hover {
  background-color: #e0e0e0;
}

.btn-add {
  background-color: #4caf50;
  color: white;
}

.btn-add:hover:not(:disabled) {
  background-color: #45a049;
}

.btn-add:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Responsive */
@media (max-width: 768px) {
  .form-row {
    flex-direction: column;
  }

  .form-field {
    width: 100%;
  }

  .form-actions {
    width: 100%;
    justify-content: flex-start;
  }
}
</style>

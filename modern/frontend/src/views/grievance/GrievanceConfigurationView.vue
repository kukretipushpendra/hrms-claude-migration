<template>
  <div>
    <v-breadcrumbs :items="breadcrumbs" />
    <v-card>
      <v-card-title class="bg-primary text-white d-flex justify-space-between align-center">
        <h3>Grievance Configuration</h3>
        <v-btn
          color="white"
          variant="outlined"
          prepend-icon="mdi-plus"
          :to="'/Grievance/configuration/add'"
        >
          Add Type
        </v-btn>
      </v-card-title>
      <v-card-text class="pa-4">
        <v-data-table :headers="headers" :items="grievanceTypes" :loading="loading" item-value="id">
          <template #item.isActive="{ item }">
            <v-chip :color="item.isActive ? 'success' : 'error'" size="small">
              {{ item.isActive ? 'Active' : 'Inactive' }}
            </v-chip>
          </template>
          <template #item.isAutoEscalation="{ item }">
            <v-icon :color="item.isAutoEscalation ? 'success' : 'default'">
              {{ item.isAutoEscalation ? 'mdi-check-circle' : 'mdi-close-circle' }}
            </v-icon>
          </template>
          <template #item.actions="{ item }">
            <v-btn
              icon="mdi-pencil"
              size="small"
              variant="text"
              :to="`/Grievance/configuration/edit/${item.id}`"
            />
            <v-btn
              icon="mdi-delete"
              size="small"
              variant="text"
              color="error"
              @click="confirmDelete(item)"
            />
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="showDeleteDialog" max-width="500">
      <v-card>
        <v-card-title>Confirm Delete</v-card-title>
        <v-card-text>
          Are you sure you want to delete the grievance type "{{ typeToDelete?.grievanceName }}"?
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="secondary" variant="text" @click="showDeleteDialog = false"> Cancel </v-btn>
          <v-btn color="error" variant="flat" :loading="deleting" @click="handleDelete">
            Delete
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-snackbar v-model="showSuccess" color="success" timeout="3000">
      {{ successMessage }}
    </v-snackbar>

    <v-snackbar v-model="showError" color="error" timeout="5000">
      {{ errorMessage }}
    </v-snackbar>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { getAllGrievancesList, deleteGrievanceType } from '@/services/grievance/grievance.service';
import type { GrievanceType } from '@/types/grievance.types';

const breadcrumbs = [
  { title: 'Grievance', disabled: false, href: '/Grievance' },
  { title: 'Configuration', disabled: true },
];

const headers = [
  { title: 'Grievance Name', key: 'grievanceName', sortable: true },
  { title: 'Description', key: 'description', sortable: false },
  { title: 'L1 TAT (Hours)', key: 'l1TatHours', sortable: true },
  { title: 'L2 TAT (Hours)', key: 'l2TatHours', sortable: true },
  { title: 'L3 TAT (Days)', key: 'l3TatDays', sortable: true },
  { title: 'Auto Escalation', key: 'isAutoEscalation', sortable: false },
  { title: 'Status', key: 'isActive', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false },
];

const grievanceTypes = ref<GrievanceType[]>([]);
const loading = ref(false);
const showDeleteDialog = ref(false);
const typeToDelete = ref<GrievanceType | null>(null);
const deleting = ref(false);
const showSuccess = ref(false);
const showError = ref(false);
const successMessage = ref('');
const errorMessage = ref('');

const loadTypes = async () => {
  loading.value = true;
  try {
    grievanceTypes.value = await getAllGrievancesList();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'Failed to load grievance types';
    showError.value = true;
  } finally {
    loading.value = false;
  }
};

const confirmDelete = (item: GrievanceType) => {
  typeToDelete.value = item;
  showDeleteDialog.value = true;
};

const handleDelete = async () => {
  if (!typeToDelete.value) {
    return;
  }

  deleting.value = true;
  try {
    await deleteGrievanceType(typeToDelete.value.id);
    successMessage.value = 'Grievance type deleted successfully';
    showSuccess.value = true;
    showDeleteDialog.value = false;
    await loadTypes();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    errorMessage.value = err.response?.data?.message || 'Failed to delete grievance type';
    showError.value = true;
  } finally {
    deleting.value = false;
  }
};

onMounted(() => {
  loadTypes();
});
</script>

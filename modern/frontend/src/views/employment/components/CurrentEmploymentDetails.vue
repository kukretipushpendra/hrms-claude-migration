<script setup lang="ts">
import { ref } from 'vue';
import { useAuthStore } from '@/stores/auth.store';
import CurrentEmploymentForm from './CurrentEmploymentForm.vue';

interface Props {
  expanded: boolean;
  onAccordionToggle: (panel: string) => (isExpanded: boolean) => void;
}

const props = defineProps<Props>();

const authStore = useAuthStore();
const isEditable = ref(false);

const handleEdit = () => {
  isEditable.value = !isEditable.value;
};

const makeEditable = false; // Controlled by feature flag or permission

const handleAccordionChange = (isExpanded: boolean) => {
  props.onAccordionToggle('currentEmployment')(isExpanded);
};
</script>

<template>
  <v-expansion-panels v-model:model-value="expanded" @update:model-value="handleAccordionChange">
    <v-expansion-panel value="currentEmployment" elevation="1">
      <v-expansion-panel-title class="bg-grey-lighten-4">
        <v-row no-gutters align="center">
          <v-col>
            <span>Current Employment Details</span>
          </v-col>
          <v-col
            v-if="makeEditable && expanded && authStore.hasPermission('Edit.EmploymentDetails')"
            cols="auto"
          >
            <v-tooltip :text="isEditable ? 'Cancel' : 'Edit current employment'">
              <template #activator="{ props: tooltipProps }">
                <v-btn
                  v-bind="tooltipProps"
                  :icon="isEditable ? 'mdi-close' : 'mdi-pencil'"
                  :color="isEditable ? 'error' : 'primary'"
                  variant="text"
                  size="small"
                  @click.stop="handleEdit"
                  :aria-label="isEditable ? 'cancel' : 'edit current employment'"
                />
              </template>
            </v-tooltip>
          </v-col>
        </v-row>
      </v-expansion-panel-title>

      <v-expansion-panel-text class="border-t pa-4">
        <CurrentEmploymentForm :is-editable="isEditable" />
      </v-expansion-panel-text>
    </v-expansion-panel>
  </v-expansion-panels>
</template>

<style scoped>
.border-t {
  border-top: 1px solid rgba(0, 0, 0, 0.125);
}
</style>

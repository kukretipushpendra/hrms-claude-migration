<template>
  <v-dialog :model-value="open" max-width="600" persistent>
    <v-card>
      <v-card-title class="d-flex align-center pa-4">
        <span class="text-h5 flex-grow-1">
          {{ editable ? 'Edit Manager Rating' : 'View Manager Rating' }}
        </span>
        <v-btn icon variant="text" @click="handleClose">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>

      <v-divider />

      <v-card-text class="pa-4">
        <v-form ref="formRef" @submit.prevent="handleSubmit">
          <v-row>
            <!-- Goal Title (Read-only) -->
            <v-col cols="12">
              <v-text-field
                :model-value="data.goalTitle"
                label="Goal"
                variant="outlined"
                readonly
                density="compact"
              />
            </v-col>

            <!-- Manager Rating -->
            <v-col cols="6">
              <v-text-field
                v-if="editable"
                v-model="formData.rating"
                label="Manager Rating *"
                variant="outlined"
                type="number"
                density="compact"
                :rules="ratingRules"
              />
              <v-text-field
                v-else
                :model-value="formData.rating"
                label="Manager Rating"
                variant="outlined"
                readonly
                density="compact"
              />
            </v-col>

            <!-- Manager Notes -->
            <v-col cols="12">
              <v-textarea
                v-if="editable"
                v-model="formData.note"
                label="Manager Note"
                variant="outlined"
                rows="4"
                :maxlength="600"
                counter
              />
              <div v-else>
                <div class="text-subtitle-2 font-weight-bold mb-2">Manager Note</div>
                <div class="text-body-2" style="white-space: pre-wrap">
                  {{ formData.note || 'No notes' }}
                </div>
              </div>
            </v-col>
          </v-row>

          <!-- Action Buttons -->
          <v-row v-if="editable" class="mt-2">
            <v-col cols="12" class="d-flex justify-center gap-2">
              <v-btn color="primary" type="submit" :loading="loading" :disabled="!isFormValid">
                Save
              </v-btn>
              <v-btn color="secondary" variant="outlined" @click="handleReset"> Reset </v-btn>
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue';
import kpiService from '@/services/kpi/kpi.service';
import { MIN_RATING, MAX_RATING } from '@/constants/kpi.constants';
import { useSnackbar } from '@/composables/useSnackbar';

interface Props {
  open: boolean;
  editable: boolean;
  data: {
    goalId: number;
    goalTitle: string;
    rating: number;
    note: string;
    planId: number;
  };
}

const props = defineProps<Props>();

const emit = defineEmits<{
  (e: 'close'): void;
  (e: 'success'): void;
}>();

const { showSuccess, showError } = useSnackbar();

const formRef = ref();
const loading = ref(false);

const formData = ref({
  rating: String(props.data.rating),
  note: props.data.note || '',
});

const ratingRules = [
  (v: string) => !!v || 'Rating is required',
  (v: string) => {
    const num = parseFloat(v);
    if (isNaN(num)) return 'Must be a valid number';
    if (num < MIN_RATING || num > MAX_RATING) {
      return `Rating must be between ${MIN_RATING} and ${MAX_RATING}`;
    }
    if (!/^\d+(\.\d{1,2})?$/.test(v)) {
      return 'Only up to two decimal places allowed';
    }
    return true;
  },
];

const isFormValid = computed(() => {
  if (!props.editable) return false;

  const rating = formData.value.rating;
  if (!rating) return false;

  const num = parseFloat(rating);
  if (isNaN(num)) return false;
  if (num < MIN_RATING || num > MAX_RATING) return false;
  if (!/^\d+(\.\d{1,2})?$/.test(rating)) return false;

  return true;
});

const handleReset = () => {
  formData.value = {
    rating: String(props.data.rating),
    note: props.data.note || '',
  };
};

const handleClose = () => {
  emit('close');
};

const handleSubmit = async () => {
  if (!isFormValid.value) return;

  try {
    loading.value = true;

    const payload = {
      planId: props.data.planId,
      goalId: props.data.goalId,
      managerRating: parseFloat(formData.value.rating),
      managerNote: formData.value.note || null,
    };

    const response = await kpiService.updateEmployeeRatingByManager(payload);
    showSuccess(response.message);
    emit('success');
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to update manager rating';
    showError(message);
  } finally {
    loading.value = false;
  }
};

// Reset form data when dialog opens
watch(
  () => props.open,
  (newVal) => {
    if (newVal) {
      handleReset();
    }
  }
);
</script>

<style scoped>
.gap-2 {
  gap: 8px;
}
</style>

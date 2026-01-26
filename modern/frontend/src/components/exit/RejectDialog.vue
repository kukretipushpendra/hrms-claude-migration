<script setup lang="ts">
import { watch } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';

interface Props {
  modelValue: boolean;
  type: 'resignation' | 'earlyrelease';
  loading?: boolean;
}

const props = defineProps<Props>();
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'submit', reason: string): void;
}>();

// Validation schema
const schema = toTypedSchema(
  z.object({
    reason: z.string().min(1, 'Rejection reason is required'),
  })
);

const { defineField, handleSubmit, errors, resetForm } = useForm({
  validationSchema: schema,
  initialValues: {
    reason: '',
  },
});

const [reason, reasonAttrs] = defineField('reason');

const dialogTitle = props.type === 'resignation' ? 'Reject Resignation' : 'Reject Early Release';

const handleClose = () => {
  emit('update:modelValue', false);
  resetForm();
};

const onSubmit = handleSubmit((values) => {
  emit('submit', values.reason);
});

// Watch for dialog open/close
watch(
  () => props.modelValue,
  (newVal) => {
    if (!newVal) {
      resetForm();
    }
  }
);
</script>

<template>
  <v-dialog :model-value="modelValue" max-width="600" @update:model-value="handleClose">
    <v-card>
      <v-card-title class="text-h6 bg-primary text-white">
        {{ dialogTitle }}
      </v-card-title>
      <v-card-text class="pa-6">
        <form @submit.prevent="onSubmit">
          <v-textarea
            v-model="reason"
            v-bind="reasonAttrs"
            label="Rejection Reason"
            variant="outlined"
            rows="4"
            :error-messages="errors.reason"
            required
          />
        </form>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn color="secondary" variant="text" :disabled="loading" @click="handleClose">
          Cancel
        </v-btn>
        <v-btn color="error" variant="flat" :loading="loading" @click="onSubmit"> Reject </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

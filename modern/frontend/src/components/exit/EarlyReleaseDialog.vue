<script setup lang="ts">
import { watch } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import dayjs from 'dayjs';
import { formatDateForApi } from '@/utils/exit-helpers';

interface Props {
  modelValue: boolean;
  lastWorkingDay: string;
}

const props = defineProps<Props>();
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'submit', earlyReleaseDate: string): void;
}>();

// Validation schema
const schema = toTypedSchema(
  z.object({
    earlyReleaseDate: z.string().refine(
      (val) => {
        if (!val) return false;
        const selectedDate = dayjs(val);
        const today = dayjs().startOf('day');
        const lwd = dayjs(props.lastWorkingDay).startOf('day');
        return (
          (selectedDate.isAfter(today) || selectedDate.isSame(today, 'day')) &&
          (selectedDate.isBefore(lwd) || selectedDate.isSame(lwd, 'day'))
        );
      },
      {
        message: 'Early release date must be between today and last working day',
      }
    ),
  })
);

const { defineField, handleSubmit, errors, resetForm } = useForm({
  validationSchema: schema,
  initialValues: {
    earlyReleaseDate: '',
  },
});

const [earlyReleaseDate, earlyReleaseDateAttrs] = defineField('earlyReleaseDate');

// Handle dialog close
const handleClose = () => {
  emit('update:modelValue', false);
  resetForm();
};

// Handle submit
const onSubmit = handleSubmit((values) => {
  emit('submit', formatDateForApi(values.earlyReleaseDate));
  handleClose();
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
  <v-dialog :model-value="modelValue" max-width="500" @update:model-value="handleClose">
    <v-card>
      <v-card-title class="text-h6 bg-primary text-white"> Request Early Release </v-card-title>
      <v-card-text class="pa-6">
        <form @submit.prevent="onSubmit">
          <v-text-field
            v-model="earlyReleaseDate"
            v-bind="earlyReleaseDateAttrs"
            label="Early Release Date"
            type="date"
            variant="outlined"
            :error-messages="errors.earlyReleaseDate"
            :hint="`Must be between today and ${dayjs(lastWorkingDay).format('MMM DD, YYYY')}`"
            persistent-hint
          />
        </form>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn color="secondary" variant="text" @click="handleClose">Cancel</v-btn>
        <v-btn color="primary" variant="flat" @click="onSubmit">Submit</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

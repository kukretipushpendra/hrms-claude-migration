<script setup lang="ts">
import { watch } from 'vue';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import dayjs from 'dayjs';
import { formatDateForApi } from '@/utils/exit-helpers';

interface Props {
  modelValue: boolean;
  currentLwd: string;
  loading?: boolean;
}

const props = defineProps<Props>();
const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void;
  (e: 'submit', newLwd: string): void;
}>();

// Validation schema
const schema = toTypedSchema(
  z.object({
    lastWorkingDay: z.string().refine(
      (val) => {
        if (!val) return false;
        const selectedDate = dayjs(val);
        const today = dayjs().startOf('day');
        return selectedDate.isAfter(today);
      },
      {
        message: 'Last working day must be after today',
      }
    ),
  })
);

const { defineField, handleSubmit, errors, resetForm, setValues } = useForm({
  validationSchema: schema,
  initialValues: {
    lastWorkingDay: '',
  },
});

const [lastWorkingDay, lastWorkingDayAttrs] = defineField('lastWorkingDay');

const handleClose = () => {
  emit('update:modelValue', false);
  resetForm();
};

const onSubmit = handleSubmit((values) => {
  emit('submit', formatDateForApi(values.lastWorkingDay));
});

// Watch for dialog open/close and set current LWD
watch(
  () => props.modelValue,
  (newVal) => {
    if (newVal && props.currentLwd) {
      setValues({
        lastWorkingDay: props.currentLwd,
      });
    } else if (!newVal) {
      resetForm();
    }
  }
);
</script>

<template>
  <v-dialog :model-value="modelValue" max-width="500" @update:model-value="handleClose">
    <v-card>
      <v-card-title class="text-h6 bg-primary text-white"> Update Last Working Day </v-card-title>
      <v-card-text class="pa-6">
        <form @submit.prevent="onSubmit">
          <v-text-field
            v-model="lastWorkingDay"
            v-bind="lastWorkingDayAttrs"
            label="New Last Working Day"
            type="date"
            variant="outlined"
            :error-messages="errors.lastWorkingDay"
            hint="Must be after today"
            persistent-hint
          />
        </form>
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn color="secondary" variant="text" :disabled="loading" @click="handleClose">
          Cancel
        </v-btn>
        <v-btn color="primary" variant="flat" :loading="loading" @click="onSubmit"> Update </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<style scoped>
/* Add any component-specific styles here */
</style>

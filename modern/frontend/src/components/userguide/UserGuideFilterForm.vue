<script setup lang="ts">
import { ref } from 'vue';
import type { UserGuideFilter, UserGuideStatusValue, MenuOption } from '@/types/userguide.types';
import { UserGuideStatus, USER_GUIDE_STATUS_LABEL } from '@/types/userguide.types';

interface Props {
  menuOptions: MenuOption[];
}

defineProps<Props>();

const emit = defineEmits<{
  (e: 'search', filters: UserGuideFilter): void;
  (e: 'reset'): void;
}>();

const titleFilter = ref('');
const menuNameFilter = ref('');
const statusFilter = ref<UserGuideStatusValue | null>(null);

const statusOptions = [
  { value: UserGuideStatus.Published, label: USER_GUIDE_STATUS_LABEL[UserGuideStatus.Published] },
  { value: UserGuideStatus.Draft, label: USER_GUIDE_STATUS_LABEL[UserGuideStatus.Draft] },
];

const handleSearch = () => {
  emit('search', {
    title: titleFilter.value,
    menuName: menuNameFilter.value,
    status: statusFilter.value,
  });
};

const handleReset = () => {
  titleFilter.value = '';
  menuNameFilter.value = '';
  statusFilter.value = null;
  emit('reset');
};

// Expose reset for parent
defineExpose({
  handleReset,
});
</script>

<template>
  <v-card outlined>
    <v-card-text>
      <v-row>
        <v-col cols="12" md="3">
          <v-text-field
            v-model="titleFilter"
            label="Title"
            placeholder="Search by title"
            density="compact"
            clearable
            hide-details
          />
        </v-col>

        <v-col cols="12" md="3">
          <v-autocomplete
            v-model="menuNameFilter"
            :items="menuOptions"
            item-title="name"
            item-value="name"
            label="Menu Name"
            placeholder="Select menu"
            density="compact"
            clearable
            hide-details
          />
        </v-col>

        <v-col cols="12" md="3">
          <v-select
            v-model="statusFilter"
            :items="statusOptions"
            item-title="label"
            item-value="value"
            label="Status"
            placeholder="Select status"
            density="compact"
            clearable
            hide-details
          />
        </v-col>

        <v-col cols="12" md="3" class="d-flex gap-2 align-center">
          <v-btn color="primary" variant="flat" @click="handleSearch"> Search </v-btn>
          <v-btn color="grey" variant="outlined" @click="handleReset"> Reset </v-btn>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import { useField } from 'vee-validate';
import { getRoleList, type RoleType } from '@/services/employment';
import { useSnackbar } from '@/composables/useSnackbar';

interface Props {
  isEditable: boolean;
  required?: boolean;
  name?: string;
}

const props = withDefaults(defineProps<Props>(), {
  required: false,
  name: 'roleId',
});

const { showError } = useSnackbar();
const { value, errorMessage, setValue } = useField<string>(props.name);

const roleList = ref<RoleType[]>([]);
const loading = ref(false);

const fetchRoles = async () => {
  loading.value = true;
  try {
    const response = await getRoleList();
    roleList.value = response.result;
  } catch (error) {
    const axiosError = error as { response?: { data?: { message?: string } } };
    showError(axiosError.response?.data?.message || 'Failed to fetch roles');
  } finally {
    loading.value = false;
  }
};

const selectedId = ref<number | null>(null);
const selectedRole = ref<RoleType | null>(null);

// Watch value changes and sync with selectedId
watch(
  value,
  (newValue) => {
    if (newValue) {
      selectedId.value = Number(newValue);
      selectedRole.value = roleList.value.find((r) => r.id === Number(newValue)) || null;
    } else {
      selectedId.value = null;
      selectedRole.value = null;
    }
  },
  { immediate: true }
);

const handleChange = (id: number | null) => {
  setValue(id ? id.toString() : '');
};

onMounted(() => {
  fetchRoles();
});
</script>

<template>
  <v-select
    v-if="isEditable"
    v-model="selectedId"
    :items="roleList"
    :label="required ? 'Role*' : 'Role'"
    :loading="loading"
    :error-messages="errorMessage"
    item-title="name"
    item-value="id"
    variant="outlined"
    density="compact"
    @update:model-value="handleChange"
  />
  <v-text-field
    v-else
    :model-value="selectedRole?.name || ''"
    :label="required ? 'Role*' : 'Role'"
    readonly
    variant="outlined"
    density="compact"
  />
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { getRolePermissionById, getRolePermission, updatePermission } from '@/services/roles';
import type { Module, Permission, UpdatePermissionArgs } from '@/services/roles/types';
import { useAuthStore } from '@/stores/auth.store';

// Router & Route
const router = useRouter();
const route = useRoute();
const authStore = useAuthStore();

// Props from route
const roleId = computed(() => route.params.id as string);
const isAdd = computed(() => route.name === 'role-add');

// Permissions
const hasEditPermission = authStore.hasPermission('ROLE.EDIT');
const hasReadPermission = authStore.hasPermission('ROLE.READ');

// State
const roleName = ref('');
const modules = ref<Module[]>([]);
const loading = ref(false);
const saving = ref(false);
const error = ref<string | null>(null);
const snackbar = ref(false);
const snackbarMessage = ref('');
const snackbarColor = ref('success');
const originalData = ref<string>('');

// Validation
const roleNameRules = [
  (v: string) => !!v || 'Role name is required',
  (v: string) =>
    /^(?=.*[a-zA-Z].*[a-zA-Z])[a-zA-Z\s]+$/.test(v) ||
    'Role name must contain at least 2 alphabetic characters',
  (v: string) => (v && v.length <= 50) || 'Role name must be 50 characters or less',
];

// Load permissions
async function fetchPermissions() {
  loading.value = true;
  error.value = null;

  try {
    if (isAdd.value) {
      const response = await getRolePermission();
      modules.value = response.result || [];
      roleName.value = '';
    } else {
      const response = await getRolePermissionById(roleId.value);
      roleName.value = response.result?.roleName || '';
      modules.value = response.result?.modules || [];
    }

    // Store original state for comparison
    originalData.value = JSON.stringify({
      roleName: roleName.value,
      modules: modules.value,
    });
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'Enable to fetch permission for this role.';
    console.error('Fetch permissions error:', e);
  } finally {
    loading.value = false;
  }
}

// Toggle all permissions for a module
function toggleAllPermissions(moduleIndex: number) {
  const module = modules.value[moduleIndex];
  const allSelected = module.permissions.every((p) => p.isActive);
  module.permissions.forEach((p) => {
    p.isActive = !allSelected;
  });
}

// Check if all permissions are selected for a module
function areAllSelected(moduleIndex: number): boolean {
  return modules.value[moduleIndex].permissions.every((p) => p.isActive);
}

// Submit form
async function handleSubmit() {
  // Validate role name
  const isRoleNameValid = roleNameRules.every((rule) => {
    const result = rule(roleName.value);
    return result === true;
  });

  if (!isRoleNameValid) {
    showSnackbar('Please fix validation errors', 'error');
    return;
  }

  // Get active permissions
  const activePermissions = modules.value.reduce<number[]>((result, module) => {
    const activePerms = module.permissions.filter((p) => p.isActive).map((p) => p.permissionId);
    return [...result, ...activePerms];
  }, []);

  if (activePermissions.length === 0) {
    showSnackbar('Please select at least one permission.', 'error');
    return;
  }

  // Parse original data
  const original = JSON.parse(originalData.value);
  const originalPermissions = original.modules.reduce<number[]>(
    (result: number[], module: Module) => {
      const activePerms = module.permissions
        .filter((p: Permission) => p.isActive)
        .map((p: Permission) => p.permissionId);
      return [...result, ...activePerms];
    },
    []
  );

  // Check what changed
  const isRoleNameUpdate = roleName.value !== original.roleName;
  const isRolePermissionUpdate =
    JSON.stringify(originalPermissions.sort()) !== JSON.stringify(activePermissions.sort());

  if (!isRoleNameUpdate && !isRolePermissionUpdate) {
    showSnackbar("No modifications detected. There's nothing to save.", 'info');
    return;
  }

  // Prepare update request
  const updateArgs: UpdatePermissionArgs = {
    roleId: isAdd.value ? 0 : parseInt(roleId.value),
    isRoleNameUpdate,
    isRolePermissionUpdate,
    ...(isRoleNameUpdate ? { roleName: roleName.value } : {}),
    ...(isRolePermissionUpdate ? { permissionList: activePermissions } : {}),
  };

  // Submit
  saving.value = true;
  try {
    await updatePermission(updateArgs);
    showSnackbar('Update successful! Your changes have been saved.', 'success');

    // Reload data to get fresh state
    await fetchPermissions();

    // If user updated their own role permissions, update the store
    if (authStore.user?.roleId === roleId.value && isRolePermissionUpdate) {
      // Reload user data to refresh permissions
      await authStore.loadUser();
    }
  } catch (e) {
    const errorMsg = e instanceof Error ? e.message : 'Something went wrong!';
    showSnackbar(errorMsg, 'error');
    console.error('Update error:', e);
  } finally {
    saving.value = false;
  }
}

// Show snackbar notification
function showSnackbar(message: string, color: 'success' | 'error' | 'info' = 'success') {
  snackbarMessage.value = message;
  snackbarColor.value = color;
  snackbar.value = true;
}

// Go back to roles list
function goBack() {
  router.push('/roles');
}

// Load data on mount
onMounted(() => {
  if (!hasReadPermission) {
    router.push('/404');
    return;
  }
  fetchPermissions();
});
</script>

<template>
  <div class="role-permissions-page">
    <!-- Loading State -->
    <div v-if="loading" class="loading-container">
      <v-progress-circular indeterminate color="primary" size="64" />
      <p class="mt-4 text-grey-600">Loading permissions...</p>
    </div>

    <!-- Error State -->
    <v-alert v-else-if="error" type="error" variant="tonal" class="ma-4">
      {{ error }}
      <template #append>
        <v-btn variant="text" size="small" @click="fetchPermissions"> Retry </v-btn>
      </template>
    </v-alert>

    <!-- Main Content -->
    <v-card v-else class="mb-4">
      <!-- Header -->
      <v-card-title class="d-flex align-center pa-4 border-b">
        <v-btn icon variant="text" size="small" class="mr-2" @click="goBack">
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <h3 class="text-h5">{{ isAdd ? 'Create Role' : 'Edit Role' }}</h3>
      </v-card-title>

      <!-- Form -->
      <v-card-text class="pa-5">
        <v-form @submit.prevent="handleSubmit">
          <!-- Role Name & Save Button Row -->
          <v-row class="mb-4">
            <v-col cols="12" sm="6">
              <v-text-field
                v-model="roleName"
                label="Role Name"
                variant="outlined"
                density="comfortable"
                :rules="roleNameRules"
                :disabled="!isAdd"
                required
                hide-details="auto"
              />
            </v-col>
            <v-col cols="12" sm="6" class="d-flex align-center justify-end">
              <v-btn
                v-if="hasEditPermission"
                color="primary"
                size="large"
                type="submit"
                :loading="saving"
                :disabled="saving"
              >
                Save Changes
              </v-btn>
            </v-col>
          </v-row>

          <!-- Module Permission Cards -->
          <div class="modules-container">
            <div
              v-for="(module, moduleIndex) in modules"
              :key="module.moduleId"
              class="module-card mb-4"
            >
              <!-- Module Header -->
              <div class="module-header">
                <h6 class="module-title">{{ module.moduleName }}</h6>
                <v-checkbox
                  :model-value="areAllSelected(moduleIndex)"
                  label="Select All"
                  density="compact"
                  hide-details
                  @update:model-value="toggleAllPermissions(moduleIndex)"
                />
              </div>

              <!-- Permissions Grid -->
              <v-row class="permissions-grid pa-4">
                <v-col
                  v-for="(permission, permIndex) in module.permissions"
                  :key="permission.permissionId"
                  cols="12"
                  sm="6"
                  md="4"
                  lg="3"
                >
                  <v-checkbox
                    v-model="module.permissions[permIndex].isActive"
                    :label="permission.permissionName"
                    density="compact"
                    hide-details
                  />
                </v-col>
              </v-row>
            </div>
          </div>
        </v-form>
      </v-card-text>
    </v-card>

    <!-- Snackbar for notifications -->
    <v-snackbar v-model="snackbar" :color="snackbarColor" :timeout="3000" location="top">
      {{ snackbarMessage }}
      <template #actions>
        <v-btn variant="text" @click="snackbar = false"> Close </v-btn>
      </template>
    </v-snackbar>

    <!-- Global Loader Overlay -->
    <v-overlay v-model="saving" class="align-center justify-center" persistent>
      <v-progress-circular indeterminate size="64" color="primary" />
    </v-overlay>
  </div>
</template>

<style scoped lang="scss">
.role-permissions-page {
  padding: 16px;
}

.loading-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 160px);
}

.border-b {
  border-bottom: 1px solid rgba(0, 0, 0, 0.12);
}

.modules-container {
  margin-top: 16px;
}

.module-card {
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  overflow: hidden;
}

.module-header {
  background-color: #e6f4ff;
  border-left: 2px solid #1e75bb;
  color: #1e75bb;
  padding: 10px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.module-title {
  font-weight: 600;
  font-size: 1.1rem;
  margin: 0;
}

.permissions-grid {
  margin: 0 10px;
}
</style>

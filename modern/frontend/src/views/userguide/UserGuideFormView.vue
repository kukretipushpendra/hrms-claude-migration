<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { toast } from 'vue3-toastify';
import { useForm } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import UserGuideContentEditor from '@/components/userguide/UserGuideContentEditor.vue';
import type { MenuOption } from '@/types/userguide.types';
import { UserGuideStatus, USER_GUIDE_STATUS_LABEL } from '@/types/userguide.types';
import {
  getAllMenu,
  getUserGuideById,
  addUserGuide,
  updateUserGuide,
} from '@/services/userguide/userguide.service';

const router = useRouter();
const route = useRoute();

const menuOptions = ref<MenuOption[]>([]);
const loading = ref(false);
const submitting = ref(false);

const isEditMode = computed(() => !!route.params.id);
const pageTitle = computed(() => (isEditMode.value ? 'Edit User Guide' : 'Add User Guide'));

// Status options
const statusOptions = [
  {
    value: UserGuideStatus.Published,
    label: USER_GUIDE_STATUS_LABEL[UserGuideStatus.Published],
  },
  { value: UserGuideStatus.Draft, label: USER_GUIDE_STATUS_LABEL[UserGuideStatus.Draft] },
];

// Validation schema
const schema = toTypedSchema(
  z.object({
    title: z.string().min(1, 'Title is required').max(200, 'Title must not exceed 200 characters'),
    menuId: z.number({ required_error: 'Menu is required' }).min(1, 'Menu is required'),
    status: z.number({ required_error: 'Status is required' }),
    content: z.string().min(1, 'Content is required'),
  })
);

const { handleSubmit, errors, defineField, setValues } = useForm({
  validationSchema: schema,
  initialValues: {
    title: '',
    menuId: 0,
    status: UserGuideStatus.Draft,
    content: '',
  },
});

const [title] = defineField('title');
const [menuId] = defineField('menuId');
const [status] = defineField('status');
const [content] = defineField('content');

// Fetch menu options
const fetchMenuOptions = async () => {
  try {
    menuOptions.value = await getAllMenu();
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch menu options');
  }
};

// Fetch guide data for edit mode
const fetchGuideData = async () => {
  if (!isEditMode.value) return;

  loading.value = true;
  try {
    const guideId = Number(route.params.id);
    const guide = await getUserGuideById(guideId);

    if (guide) {
      setValues({
        title: guide.title,
        menuId: guide.menuId,
        status: guide.status,
        content: guide.content,
      });
    } else {
      toast.error('User guide not found');
      router.push('/settings/user-guides');
    }
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to fetch user guide');
    router.push('/settings/user-guides');
  } finally {
    loading.value = false;
  }
};

// Submit form
const onSubmit = handleSubmit(async (values) => {
  submitting.value = true;
  try {
    if (isEditMode.value) {
      // Update existing guide
      await updateUserGuide({
        id: Number(route.params.id),
        title: values.title,
        content: values.content,
        status: values.status,
        menuId: values.menuId,
      });
      toast.success('User Guide Updated Successfully');
    } else {
      // Create new guide
      await addUserGuide({
        title: values.title,
        content: values.content,
        status: values.status,
        menuId: values.menuId,
      });
      toast.success('User Guide Created Successfully');
    }
    router.push('/settings/user-guides');
  } catch (error) {
    const err = error as { response?: { data?: { message?: string } } };
    toast.error(err.response?.data?.message || 'Failed to save user guide');
  } finally {
    submitting.value = false;
  }
});

// Handle cancel
const handleCancel = () => {
  router.push('/settings/user-guides');
};

onMounted(() => {
  fetchMenuOptions();
  fetchGuideData();
});
</script>

<template>
  <div class="user-guide-form">
    <!-- Page Header -->
    <v-card class="mb-4" elevation="2">
      <v-card-title class="d-flex justify-space-between align-center">
        <div class="d-flex align-center gap-2">
          <v-btn icon="mdi-arrow-left" variant="text" @click="handleCancel" />
          <h2>{{ pageTitle }}</h2>
        </div>
      </v-card-title>
    </v-card>

    <!-- Form Card -->
    <v-card elevation="2">
      <v-card-text>
        <v-form v-if="!loading" @submit.prevent="onSubmit">
          <v-row>
            <!-- Title Field -->
            <v-col cols="12" md="8">
              <v-text-field
                v-model="title"
                label="Title *"
                placeholder="Enter guide title"
                :error-messages="errors.title"
                variant="outlined"
                counter="200"
                maxlength="200"
              />
            </v-col>

            <!-- Menu Field -->
            <v-col cols="12" md="4">
              <v-select
                v-model="menuId"
                :items="menuOptions"
                item-title="name"
                item-value="id"
                label="Menu *"
                placeholder="Select menu"
                :error-messages="errors.menuId"
                variant="outlined"
                :disabled="isEditMode"
              />
              <div v-if="isEditMode" class="text-caption text-grey mt-1">
                Menu cannot be changed in edit mode
              </div>
            </v-col>

            <!-- Status Field -->
            <v-col cols="12" md="4">
              <v-select
                v-model="status"
                :items="statusOptions"
                item-title="label"
                item-value="value"
                label="Status *"
                placeholder="Select status"
                :error-messages="errors.status"
                variant="outlined"
              />
            </v-col>

            <!-- Content Editor -->
            <v-col cols="12">
              <UserGuideContentEditor v-model="content" label="Content *" :error="errors.content" />
            </v-col>

            <!-- Action Buttons -->
            <v-col cols="12">
              <div class="d-flex gap-2 justify-end">
                <v-btn color="grey" variant="outlined" @click="handleCancel" :disabled="submitting">
                  Cancel
                </v-btn>
                <v-btn
                  color="primary"
                  variant="flat"
                  type="submit"
                  :loading="submitting"
                  :disabled="submitting"
                >
                  {{ isEditMode ? 'Update Guide' : 'Create Guide' }}
                </v-btn>
              </div>
            </v-col>
          </v-row>
        </v-form>

        <!-- Loading State -->
        <div v-if="loading" class="text-center py-8">
          <v-progress-circular indeterminate color="primary" />
          <p class="text-body-2 text-grey mt-4">Loading user guide...</p>
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

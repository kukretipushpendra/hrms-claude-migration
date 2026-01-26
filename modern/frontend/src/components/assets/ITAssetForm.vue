<template>
  <v-form @submit.prevent="onSubmit">
    <v-container fluid class="px-8 py-8">
      <!-- Device Name, Device Code, Serial Number -->
      <v-row>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="deviceName"
            label="Device Name"
            variant="outlined"
            :error-messages="errors.deviceName"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="deviceCode"
            label="Device Code"
            variant="outlined"
            :error-messages="errors.deviceCode"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="serialNumber"
            label="Serial Number"
            variant="outlined"
            :error-messages="errors.serialNumber"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
      </v-row>

      <!-- Invoice Number, Manufacturer, Model -->
      <v-row>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="invoiceNumber"
            label="Invoice Number"
            variant="outlined"
            :error-messages="errors.invoiceNumber"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="manufacturer"
            label="Manufacturer"
            variant="outlined"
            :error-messages="errors.manufacturer"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="model"
            label="Model"
            variant="outlined"
            :error-messages="errors.model"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
      </v-row>

      <!-- Asset Type, Specifications, Comments -->
      <v-row>
        <v-col cols="12" md="4">
          <v-select
            v-model="assetType"
            label="Asset Type"
            :items="ASSET_TYPE_OPTIONS"
            item-title="label"
            item-value="value"
            variant="outlined"
            :error-messages="errors.assetType"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="specification"
            label="Specifications"
            variant="outlined"
            :error-messages="errors.specification"
            :readonly="!isEditable"
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="comments"
            label="Comments"
            variant="outlined"
            :error-messages="errors.comments"
            :readonly="!isEditable"
            density="comfortable"
          />
        </v-col>
      </v-row>

      <!-- Branch, Purchase Date, Warranty Expires -->
      <v-row>
        <v-col cols="12" md="4">
          <v-select
            v-model="branch"
            label="Branch"
            :items="BRANCH_LOCATION_OPTIONS"
            item-title="label"
            item-value="value"
            variant="outlined"
            :error-messages="errors.branch"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="purchaseDate"
            label="Purchase Date"
            type="date"
            variant="outlined"
            :error-messages="errors.purchaseDate"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-text-field
            v-model="warrantyExpires"
            label="Warranty Expires"
            type="date"
            variant="outlined"
            :error-messages="errors.warrantyExpires"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
      </v-row>

      <!-- Asset Status, Asset Condition, Employee -->
      <v-row>
        <v-col cols="12" md="4">
          <v-select
            v-model="assetStatus"
            label="Asset Status"
            :items="statusOptions"
            item-title="label"
            item-value="value"
            variant="outlined"
            :error-messages="errors.assetStatus"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <v-select
            v-model="assetCondition"
            label="Asset Condition"
            :items="ASSET_CONDITION_OPTIONS"
            item-title="label"
            item-value="value"
            variant="outlined"
            :error-messages="errors.assetCondition"
            :readonly="!isEditable"
            required
            density="comfortable"
          />
        </v-col>
        <v-col cols="12" md="4">
          <AssetUserAutocomplete
            v-if="isEditable"
            v-model="employeeId"
            :disabled="isEmployeeFieldDisabled"
            :error="errors.employeeId"
          />
          <div v-else class="pa-2">
            <div class="text-caption text-grey-darken-1">Employee Name</div>
            <div class="text-body-1 mt-1">
              {{
                assetData?.custodian?.fullName
                  ? `${assetData.custodian.fullName} (${assetData.custodian.email})`
                  : 'Unallocated'
              }}
            </div>
          </div>
          <v-alert
            v-if="
              isEditable &&
              isEmployeeFieldDisabled &&
              (assetStatus === AssetStatus.Retired || assetStatus === AssetStatus.InInventory)
            "
            type="error"
            density="compact"
            class="mt-2"
          >
            This will deallocate the asset.
          </v-alert>
        </v-col>
      </v-row>

      <!-- Note Field (conditional) -->
      <v-row v-if="showNote">
        <v-col cols="12">
          <v-textarea
            v-model="note"
            label="Please enter reason for status or condition change...."
            variant="outlined"
            :error-messages="errors.note"
            :readonly="!isEditable"
            rows="3"
            counter="600"
            maxlength="600"
          />
        </v-col>
      </v-row>

      <!-- Product Invoice File -->
      <v-row>
        <v-col cols="12" md="6">
          <div class="mb-2">
            <span class="text-subtitle-1">Product Invoice</span>
            <span v-if="mode === 'add'" class="text-error">*</span>
          </div>
          <div v-if="isEditable">
            <v-file-input
              v-model="productFile"
              variant="outlined"
              density="comfortable"
              :error-messages="errors.productFileOriginalName"
              accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
              prepend-icon=""
              prepend-inner-icon="mdi-paperclip"
            />
          </div>
          <div v-else class="d-flex align-center ga-2">
            <span v-if="assetData?.productFileOriginalName" class="text-body-1">
              {{ assetData.productFileOriginalName }}
            </span>
            <span v-else class="text-grey">No file uploaded</span>
            <v-btn
              v-if="assetData?.productFileName"
              icon="mdi-eye"
              size="small"
              variant="text"
              color="primary"
              @click="viewDocument(assetData.productFileName)"
            />
          </div>
        </v-col>
      </v-row>

      <!-- Signature Document File -->
      <v-row>
        <v-col cols="12" md="6">
          <div class="mb-2">
            <span class="text-subtitle-1">Acknowledgment/Signature Document</span>
          </div>
          <div v-if="isEditable">
            <v-file-input
              v-model="signatureFile"
              variant="outlined"
              density="comfortable"
              :error-messages="errors.signatureFileOriginalName"
              accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
              prepend-icon=""
              prepend-inner-icon="mdi-paperclip"
            />
          </div>
          <div v-else class="d-flex align-center ga-2">
            <span v-if="assetData?.signatureFileOriginalName" class="text-body-1">
              {{ assetData.signatureFileOriginalName }}
            </span>
            <span v-else class="text-grey">No file uploaded</span>
            <v-btn
              v-if="assetData?.signatureFileName"
              icon="mdi-eye"
              size="small"
              variant="text"
              color="primary"
              @click="viewDocument(assetData.signatureFileName)"
            />
          </div>
        </v-col>
      </v-row>

      <!-- Action Buttons -->
      <v-row v-if="isEditable">
        <v-col cols="12" class="d-flex justify-center ga-4">
          <v-btn type="submit" color="primary" size="large" :loading="loading">Submit</v-btn>
          <v-btn type="button" color="grey" size="large" @click="handleReset">Reset</v-btn>
        </v-col>
      </v-row>
    </v-container>

    <!-- Loading Overlay -->
    <v-overlay v-model="loading" class="align-center justify-center" persistent>
      <v-progress-circular indeterminate size="64" color="primary" />
    </v-overlay>
  </v-form>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue';
import { useForm, useField } from 'vee-validate';
import { toTypedSchema } from '@vee-validate/zod';
import { z } from 'zod';
import { useSnackbar } from '@/composables/useSnackbar';
import {
  ASSET_TYPE_OPTIONS,
  ASSET_STATUS_OPTIONS,
  ASSET_CONDITION_OPTIONS,
  BRANCH_LOCATION_OPTIONS,
  AssetStatus,
  AssetCondition,
  type AssetType,
  type BranchLocation,
  type AssetData,
  type UpsertITAssetPayload,
} from '@/types/asset.types';
import { upsertITAsset } from '@/services/assets/asset.service';
import AssetUserAutocomplete from './AssetUserAutocomplete.vue';

interface Props {
  mode: 'add' | 'edit' | 'read';
  assetData?: AssetData | null;
  isEditable: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  assetData: null,
});

const emit = defineEmits<{
  (e: 'success'): void;
  (e: 'cancel'): void;
}>();

const loading = ref(false);
const originalAssetStatus = ref<AssetStatus | null>(null);
const originalAssetCondition = ref<AssetCondition | null>(null);
const { showSuccess, showError } = useSnackbar();

// Validation Schema
const createValidationSchema = (isDisabled: boolean) => {
  return toTypedSchema(
    z
      .object({
        deviceName: z.string().min(1, 'Device Name is required'),
        deviceCode: z.string().min(1, 'Device Code is required'),
        serialNumber: z.string().min(1, 'Serial Number is required'),
        invoiceNumber: z.string().min(1, 'Invoice Number is required'),
        manufacturer: z.string().min(1, 'Manufacturer is required'),
        model: z.string().min(1, 'Model is required'),
        assetType: z.union(
          [
            z.literal(1),
            z.literal(2),
            z.literal(3),
            z.literal(4),
            z.literal(5),
            z.literal(6),
            z.literal(7),
            z.literal(8),
            z.literal(9),
            z.literal(10),
            z.literal(11),
            z.literal(12),
            z.literal(13),
            z.literal(14),
          ],
          { required_error: 'Asset Type is required' }
        ),
        assetStatus: z.union([z.literal(1), z.literal(2), z.literal(3)], {
          required_error: 'Asset Status is required',
        }),
        assetCondition: z.union([z.literal(1), z.literal(2), z.literal(3)], {
          required_error: 'Asset Condition is required',
        }),
        branch: z.union([z.literal(1), z.literal(2), z.literal(3)], {
          required_error: 'Branch is required',
        }),
        purchaseDate: z.string().min(1, 'Purchase Date is required'),
        warrantyExpires: z.string().min(1, 'Warranty Expires Date is required'),
        specification: z.string().nullable().optional(),
        comments: z.string().nullable().optional(),
        note: z.string().nullable().optional(),
        employeeId: z.number().nullable().optional(),
        productFileOriginalName: props.mode === 'add' ? z.any() : z.any().nullable().optional(),
        signatureFileOriginalName: z.any().nullable().optional(),
      })
      .refine(
        (data) => {
          if (!data.warrantyExpires || !data.purchaseDate) return true;
          return new Date(data.warrantyExpires) >= new Date(data.purchaseDate);
        },
        {
          message: 'Warranty Expires Date cannot be before Purchase Date',
          path: ['warrantyExpires'],
        }
      )
      .refine(
        (data) => {
          if (isDisabled) return true;
          if (data.assetStatus === AssetStatus.Retired && data.employeeId) {
            return false;
          }
          return true;
        },
        {
          message: 'Cannot allocate a retired asset',
          path: ['assetStatus'],
        }
      )
      .refine(
        (data) => {
          if (isDisabled) return true;
          if (!data.employeeId) return true;
          if (
            data.assetStatus === AssetStatus.InInventory &&
            data.assetCondition === AssetCondition.Missing
          ) {
            return false;
          }
          return true;
        },
        {
          message:
            'Asset cannot be allocated because it is currently marked as missing in inventory.',
          path: ['assetCondition'],
        }
      )
      .refine(
        (data) => {
          if (isDisabled) return true;
          if (!data.employeeId) return true;
          if (
            data.assetStatus === AssetStatus.InInventory &&
            data.assetCondition === AssetCondition.Damage
          ) {
            return false;
          }
          return true;
        },
        {
          message:
            'Asset cannot be allocated because it is currently marked as damaged in inventory.',
          path: ['assetCondition'],
        }
      )
  );
};

const isEmployeeFieldDisabled = computed(() => originalAssetStatus.value === AssetStatus.Allocated);

const { handleSubmit, errors, resetForm } = useForm({
  validationSchema: createValidationSchema(isEmployeeFieldDisabled.value),
});

// Form fields
const { value: deviceName } = useField<string>('deviceName');
const { value: deviceCode } = useField<string>('deviceCode');
const { value: serialNumber } = useField<string>('serialNumber');
const { value: invoiceNumber } = useField<string>('invoiceNumber');
const { value: manufacturer } = useField<string>('manufacturer');
const { value: model } = useField<string>('model');
const { value: assetType } = useField<AssetType>('assetType');
const { value: assetStatus } = useField<AssetStatus>('assetStatus');
const { value: assetCondition } = useField<AssetCondition>('assetCondition');
const { value: branch } = useField<BranchLocation>('branch');
const { value: purchaseDate } = useField<string>('purchaseDate');
const { value: warrantyExpires } = useField<string>('warrantyExpires');
const { value: specification } = useField<string | null>('specification');
const { value: comments } = useField<string | null>('comments');
const { value: note } = useField<string | null>('note');
const { value: employeeId } = useField<number | null>('employeeId');

const productFile = ref<File[] | null>(null);
const signatureFile = ref<File[] | null>(null);

// Status options (filter out "Allocated" for new assets)
const statusOptions = computed(() => {
  if (props.mode === 'add') {
    return ASSET_STATUS_OPTIONS.filter((opt) => opt.value !== AssetStatus.Allocated);
  }
  if (props.assetData?.assetStatus === AssetStatus.Allocated) {
    return ASSET_STATUS_OPTIONS;
  }
  return ASSET_STATUS_OPTIONS.filter((opt) => opt.value !== AssetStatus.Allocated);
});

// Show note field when status or condition changes
const showNote = computed(() => {
  if (props.mode === 'add') return false;
  return (
    assetStatus.value !== originalAssetStatus.value ||
    assetCondition.value !== originalAssetCondition.value
  );
});

// Load asset data in edit mode
onMounted(() => {
  if (props.mode === 'edit' && props.assetData) {
    loadAssetData();
  }
});

watch(
  () => props.assetData,
  () => {
    if (props.mode === 'edit' && props.assetData) {
      loadAssetData();
    }
  }
);

watch(
  () => props.isEditable,
  () => {
    resetForm();
    if (props.mode === 'edit' && props.assetData) {
      loadAssetData();
    }
  }
);

function loadAssetData() {
  if (!props.assetData) return;

  deviceName.value = props.assetData.deviceName ?? '';
  deviceCode.value = props.assetData.deviceCode ?? '';
  serialNumber.value = props.assetData.serialNumber ?? '';
  invoiceNumber.value = props.assetData.invoiceNumber ?? '';
  manufacturer.value = props.assetData.manufacturer ?? '';
  model.value = props.assetData.model ?? '';
  assetType.value = props.assetData.assetType;
  assetStatus.value = props.assetData.assetStatus;
  assetCondition.value = props.assetData.assetCondition;
  branch.value = props.assetData.branch;
  purchaseDate.value = props.assetData.purchaseDate ?? '';
  warrantyExpires.value = props.assetData.warrantyExpires ?? '';
  specification.value = props.assetData.specification ?? '';
  comments.value = props.assetData.comments ?? '';
  employeeId.value = props.assetData.custodian?.employeeId ?? null;
  note.value = null;

  originalAssetStatus.value = props.assetData.assetStatus;
  originalAssetCondition.value = props.assetData.assetCondition;
}

const onSubmit = handleSubmit(async (values) => {
  try {
    loading.value = true;

    // Determine isAllocated value
    let isAllocatedValue: boolean | null = null;
    if (
      (originalAssetStatus.value === AssetStatus.InInventory ||
        originalAssetStatus.value === AssetStatus.Retired) &&
      values.employeeId
    ) {
      isAllocatedValue = true;
    } else if (
      originalAssetStatus.value === AssetStatus.Allocated &&
      (values.assetStatus === AssetStatus.Retired || values.assetStatus === AssetStatus.InInventory)
    ) {
      isAllocatedValue = false;
    }

    const payload: UpsertITAssetPayload = {
      ...(props.mode === 'edit' && props.assetData?.id ? { id: props.assetData.id } : {}),
      deviceName: values.deviceName,
      deviceCode: values.deviceCode,
      serialNumber: values.serialNumber,
      invoiceNumber: values.invoiceNumber,
      manufacturer: values.manufacturer,
      model: values.model,
      assetType: values.assetType,
      assetStatus: values.assetStatus,
      assetCondition: values.assetCondition,
      branch: values.branch,
      purchaseDate: values.purchaseDate,
      warrantyExpires: values.warrantyExpires,
      specification: values.specification ?? '',
      comments: values.comments ?? '',
      employeeId: values.employeeId ?? null,
      isAllocated: isAllocatedValue,
      note: values.note ?? '',
      productFileOriginalName: productFile.value?.[0] ?? null,
      signatureFileOriginalName: signatureFile.value?.[0] ?? null,
    };

    const response = await upsertITAsset(payload);

    if (response.statusCode === 200) {
      showSuccess(response.message);
      if (props.mode === 'add') {
        handleReset();
      }
      emit('success');
    } else {
      showError(response.message || 'Failed to save asset');
    }
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Failed to save asset';
    showError(message);
  } finally {
    loading.value = false;
  }
});

function handleReset() {
  resetForm();
  productFile.value = null;
  signatureFile.value = null;
  if (props.mode === 'edit' && props.assetData) {
    loadAssetData();
  }
}

function viewDocument(filename: string) {
  // Container type 1 = Asset documents
  const url = `${import.meta.env.VITE_API_URL}/DownloadFile/GetFileByFileName?fileName=${filename}&containerType=1`;
  window.open(url, '_blank');
}
</script>

<style scoped>
/* Additional styling if needed */
</style>

/**
 * Asset Management Service
 * API calls to .NET backend for asset-related operations
 */

import httpClient from '@/services/api/http-client';
import type {
  SearchRequestDto,
  ITAssetSearchFilter,
  ApiResponse,
  ITAssetListResponse,
  UpsertITAssetPayload,
  AssetData,
  ITAssetHistory,
  EmployeeAsset,
  CrudResult,
} from '@/types/asset.types';

const BASE_ROUTE = '/AssetManagement';

/**
 * Get paginated list of IT assets with filters
 * POST /GetAssetList
 */
export async function getAssetList(
  searchRequest: SearchRequestDto<ITAssetSearchFilter>
): Promise<ApiResponse<ITAssetListResponse>> {
  const response = await httpClient.post(`${BASE_ROUTE}/GetAssetList`, searchRequest);
  return response.data;
}

/**
 * Create or update an IT asset (multipart/form-data)
 * POST /UpsertITAsset
 */
export async function upsertITAsset(
  payload: UpsertITAssetPayload
): Promise<ApiResponse<CrudResult>> {
  const formData = new FormData();

  // Add all fields to FormData
  formData.append('id', String(payload.id || 0));
  formData.append('deviceName', payload.deviceName);
  formData.append('deviceCode', payload.deviceCode);
  formData.append('serialNumber', payload.serialNumber);
  formData.append('invoiceNumber', payload.invoiceNumber);
  formData.append('manufacturer', payload.manufacturer);
  formData.append('model', payload.model);
  formData.append('assetType', String(payload.assetType));
  formData.append('assetStatus', String(payload.assetStatus));
  formData.append('assetCondition', String(payload.assetCondition));
  formData.append('branch', String(payload.branch));
  formData.append('purchaseDate', payload.purchaseDate);
  formData.append('warrantyExpires', payload.warrantyExpires);
  formData.append('specification', payload.specification || '');
  formData.append('comments', payload.comments || '');

  // Optional fields
  if (payload.employeeId !== undefined && payload.employeeId !== null) {
    formData.append('employeeId', String(payload.employeeId));
  }
  if (payload.isAllocated !== undefined && payload.isAllocated !== null) {
    formData.append('isAllocated', String(payload.isAllocated));
  }
  if (payload.note) {
    formData.append('note', payload.note);
  }

  // File uploads
  if (payload.productFileOriginalName instanceof File) {
    formData.append('productFileOriginalName', payload.productFileOriginalName);
  }
  if (payload.signatureFileOriginalName instanceof File) {
    formData.append('signatureFileOriginalName', payload.signatureFileOriginalName);
  }

  const response = await httpClient.post(`${BASE_ROUTE}/UpsertITAsset`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
  return response.data;
}

/**
 * Get asset details by ID
 * GET /GetAssetById/{id}
 */
export async function getAssetById(assetId: number): Promise<ApiResponse<AssetData>> {
  const response = await httpClient.get(`${BASE_ROUTE}/GetAssetById/${assetId}`);
  return response.data;
}

/**
 * Get asset history by ID
 * GET /GetAssetHistoryById/{id}
 */
export async function getAssetHistoryById(assetId: number): Promise<ApiResponse<ITAssetHistory[]>> {
  const response = await httpClient.get(`${BASE_ROUTE}/GetAssetHistoryById/${assetId}`);
  return response.data;
}

/**
 * Get assets allocated to an employee
 * GET /GetEmployeeAsset/{employeeId}
 */
export async function getEmployeeAsset(employeeId: number): Promise<ApiResponse<EmployeeAsset[]>> {
  const response = await httpClient.get(`${BASE_ROUTE}/GetEmployeeAsset/${employeeId}`);
  return response.data;
}

/**
 * Import assets from Excel file
 * POST /ImportExcel
 */
export async function importExcel(
  file: File,
  importConfirmed: boolean = true
): Promise<ApiResponse<CrudResult>> {
  const formData = new FormData();
  formData.append('excelfile', file);
  formData.append('importConfirmed', String(importConfirmed));

  const response = await httpClient.post(`${BASE_ROUTE}/ImportExcel`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
  return response.data;
}

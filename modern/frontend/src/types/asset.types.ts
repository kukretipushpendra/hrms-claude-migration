/**
 * Asset Management TypeScript Types
 * Generated from API contracts in /migration/api-contracts/assets/asset-management.api.md
 */

// Type unions for enums (using as const pattern for type safety)
export const AssetType = {
  Laptop: 1,
  Desktop: 2,
  Monitor: 3,
  Keyboard: 4,
  Mouse: 5,
  Printer: 6,
  Scanner: 7,
  UPS: 8,
  ExternalHardDrive: 9,
  Headset: 10,
  Webcam: 11,
  Projector: 12,
  SoftwareLicense: 13,
  NetworkCable: 14,
} as const;

export type AssetType = (typeof AssetType)[keyof typeof AssetType];

export const AssetStatus = {
  InInventory: 1,
  Allocated: 2,
  Retired: 3,
} as const;

export type AssetStatus = (typeof AssetStatus)[keyof typeof AssetStatus];

export const AssetCondition = {
  Ok: 1,
  Damage: 2,
  Missing: 3,
} as const;

export type AssetCondition = (typeof AssetCondition)[keyof typeof AssetCondition];

export const BranchLocation = {
  Hyderabad: 1,
  Jaipur: 2,
  Pune: 3,
} as const;

export type BranchLocation = (typeof BranchLocation)[keyof typeof BranchLocation];

// Enum Options for Dropdowns
export const ASSET_TYPE_OPTIONS = [
  { value: AssetType.Laptop, label: 'Laptop' },
  { value: AssetType.Desktop, label: 'Desktop' },
  { value: AssetType.Monitor, label: 'Monitor' },
  { value: AssetType.Keyboard, label: 'Keyboard' },
  { value: AssetType.Mouse, label: 'Mouse' },
  { value: AssetType.Printer, label: 'Printer' },
  { value: AssetType.Scanner, label: 'Scanner' },
  { value: AssetType.UPS, label: 'UPS' },
  { value: AssetType.ExternalHardDrive, label: 'External Hard Drive' },
  { value: AssetType.Headset, label: 'Headset' },
  { value: AssetType.Webcam, label: 'Webcam' },
  { value: AssetType.Projector, label: 'Projector' },
  { value: AssetType.SoftwareLicense, label: 'Software License' },
  { value: AssetType.NetworkCable, label: 'Network Cable' },
];

export const ASSET_STATUS_OPTIONS = [
  { value: AssetStatus.InInventory, label: 'In Inventory' },
  { value: AssetStatus.Allocated, label: 'Allocated' },
  { value: AssetStatus.Retired, label: 'Retired' },
];

export const ASSET_CONDITION_OPTIONS = [
  { value: AssetCondition.Ok, label: 'Ok' },
  { value: AssetCondition.Damage, label: 'Damage' },
  { value: AssetCondition.Missing, label: 'Missing' },
];

export const BRANCH_LOCATION_OPTIONS = [
  { value: BranchLocation.Hyderabad, label: 'Hyderabad' },
  { value: BranchLocation.Jaipur, label: 'Jaipur' },
  { value: BranchLocation.Pune, label: 'Pune' },
];

// API Response Types
export interface ITAsset {
  id: number;
  deviceName: string;
  deviceCode: string;
  serialNumber: string;
  manufacturer: string;
  model: string;
  assetType: AssetType;
  assetStatus: AssetStatus;
  branch: BranchLocation;
  purchaseDate: string;
  warrantyExpires: string;
  comments: string;
  custodian: string;
  allocatedBy: string;
  custodianFullName: string;
  modifiedOn: string;
}

export interface Custodian {
  employeeId: number | null;
  email: string;
  firstName: string;
  middleName: string;
  lastName: string;
  fullName: string;
}

export interface AssetData {
  id: number;
  deviceName: string;
  deviceCode: string;
  serialNumber: string;
  invoiceNumber: string;
  manufacturer: string;
  model: string;
  assetType: AssetType;
  assetStatus: AssetStatus;
  assetCondition: AssetCondition;
  branch: BranchLocation;
  purchaseDate: string | null;
  warrantyExpires: string | null;
  comments: string;
  modifiedOn: string;
  specification: string;
  custodian: Custodian | null;
  employeeId: number | null;
  note: string | null;
  productFileOriginalName: string | null;
  productFileName: string | null;
  signatureFileOriginalName: string | null;
  signatureFileName: string | null;
}

export interface ITAssetHistory {
  id: number;
  custodian: string;
  employeeName: string;
  assetStatus: AssetStatus;
  assetCondition: AssetCondition;
  modifiedOn: string | null;
  modifiedBy: string | null;
  issueDate: string | null;
  returnDate: string | null;
  note: string | null;
}

export interface EmployeeAsset {
  assetId: number;
  serialNumber: string;
  deviceCode: string;
  deviceName: string;
  manufacturer: string;
  model: string;
  assetType: AssetType;
  branch: BranchLocation | null;
  assignedBy: string;
  assignedOn: string;
  returnDate: string | null;
  assetStatus: AssetStatus;
  assetCondition: AssetCondition;
}

// Request Types
export interface ITAssetSearchFilter {
  deviceName?: string | null;
  deviceCode?: string | null;
  manufacturer?: string | null;
  model?: string | null;
  assetStatus?: AssetStatus | null;
  assetType?: AssetType | null;
  branch?: BranchLocation | null;
  employeeCodes?: string;
}

export interface UpsertITAssetPayload {
  id?: number;
  deviceName: string;
  deviceCode: string;
  serialNumber: string;
  invoiceNumber: string;
  manufacturer: string;
  model: string;
  assetType: AssetType;
  assetStatus: AssetStatus;
  assetCondition: AssetCondition;
  branch: BranchLocation;
  purchaseDate: string;
  warrantyExpires: string;
  specification: string;
  comments: string;
  employeeId?: number | null;
  isAllocated?: boolean | null;
  note?: string;
  productFileOriginalName?: File | null;
  signatureFileOriginalName?: File | null;
}

// Search Request Wrapper (matches .NET backend structure)
export interface SearchRequestDto<T> {
  sortColumnName: string;
  sortDirection: string;
  startIndex: number;
  pageSize: number;
  filters: T;
}

// API Response Wrappers
export interface ApiResponse<T> {
  statusCode: number;
  message: string;
  result: T | null;
}

export interface ITAssetListResponse {
  iTAssetList: ITAsset[];
  totalRecords: number;
}

export interface ITAssetHistoryResponse {
  result: ITAssetHistory[];
}

export interface EmployeeAssetResponse {
  result: EmployeeAsset[];
}

export interface CrudResult {
  isSuccess?: boolean;
  message?: string;
}

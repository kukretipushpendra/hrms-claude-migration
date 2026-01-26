// Permission value format: "{Action}.{ModuleName}"
// These constants map to the permission strings returned by the .NET backend
export const PERMISSIONS = {
  ROLE: {
    READ: 'Read.Role',
    VIEW: 'View.Role',
    CREATE: 'Create.Role',
    EDIT: 'Edit.Role',
    DELETE: 'Delete.Role',
  },
  PERSONAL_DETAILS: {
    READ: 'Read.PersonalDetails',
    VIEW: 'View.PersonalDetails',
    CREATE: 'Create.PersonalDetails',
    EDIT: 'Edit.PersonalDetails',
    DELETE: 'Delete.PersonalDetails',
  },
  EMPLOYMENT_DETAILS: {
    READ: 'Read.EmploymentDetails',
    VIEW: 'View.EmploymentDetails',
    CREATE: 'Create.EmploymentDetails',
    EDIT: 'Edit.EmploymentDetails',
    DELETE: 'Delete.EmploymentDetails',
  },
  COMPANY_POLICY: {
    READ: 'Read.CompanyPolicy',
    VIEW: 'View.CompanyPolicy',
    CREATE: 'Create.CompanyPolicy',
    EDIT: 'Edit.CompanyPolicy',
    DELETE: 'Delete.CompanyPolicy',
  },
  EVENTS: {
    READ: 'Read.Events',
    VIEW: 'View.Events',
    CREATE: 'Create.Events',
    EDIT: 'Edit.Events',
    DELETE: 'Delete.Events',
  },
  ATTENDANCE: {
    READ: 'Read.Attendance',
    VIEW: 'View.Attendance',
    CREATE: 'Create.Attendance',
    EDIT: 'Edit.Attendance',
    DELETE: 'Delete.Attendance',
  },
  LEAVE: {
    READ: 'Read.Leave',
    VIEW: 'View.Leave',
    CREATE: 'Create.Leave',
    EDIT: 'Edit.Leave',
    DELETE: 'Delete.Leave',
  },
  IT_ASSETS: {
    READ: 'Read.ITAssets',
    VIEW: 'View.ITAssets',
    CREATE: 'Create.ITAssets',
    EDIT: 'Edit.ITAssets',
    DELETE: 'Delete.ITAssets',
  },
  EXIT: {
    READ: 'Read.Exit',
    VIEW: 'View.Exit',
    CREATE: 'Create.Exit',
    EDIT: 'Edit.Exit',
    DELETE: 'Delete.Exit',
  },
  KPI: {
    READ: 'Read.KPI',
    VIEW: 'View.KPI',
    CREATE: 'Create.KPI',
    EDIT: 'Edit.KPI',
    DELETE: 'Delete.KPI',
  },
  GRIEVANCE: {
    READ: 'Read.Grievance',
    VIEW: 'View.Grievance',
    CREATE: 'Create.Grievance',
    EDIT: 'Edit.Grievance',
    DELETE: 'Delete.Grievance',
  },
  SUPPORT: {
    READ: 'Read.Support',
    VIEW: 'View.Support',
    CREATE: 'Create.Support',
    EDIT: 'Edit.Support',
    DELETE: 'Delete.Support',
  },
  EMAIL_TEMPLATE: {
    READ: 'Read.EmailTemplate',
    VIEW: 'View.EmailTemplate',
    CREATE: 'Create.EmailTemplate',
    EDIT: 'Edit.EmailTemplate',
    DELETE: 'Delete.EmailTemplate',
  },
  DEVELOPER: {
    READ: 'Read.Developer',
    VIEW: 'View.Developer',
    CREATE: 'Create.Developer',
    EDIT: 'Edit.Developer',
    DELETE: 'Delete.Developer',
  },
  USER_GUIDE: {
    READ: 'Read.UserGuide',
    VIEW: 'View.UserGuide',
    CREATE: 'Create.UserGuide',
    EDIT: 'Edit.UserGuide',
    DELETE: 'Delete.UserGuide',
  },
  DOCUMENT: {
    READ: 'Read.Document',
    VIEW: 'View.Document',
    CREATE: 'Create.Document',
    EDIT: 'Edit.Document',
    DELETE: 'Delete.Document',
  },
} as const;

export type PermissionModule = keyof typeof PERMISSIONS;
export type PermissionAction = 'READ' | 'VIEW' | 'CREATE' | 'EDIT' | 'DELETE';

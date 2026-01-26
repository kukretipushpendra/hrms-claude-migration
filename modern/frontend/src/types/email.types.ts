// Email Notification / Template Management Types

// Enums (using const object pattern)
export const EmailTemplateType = {
  Birthday: 1,
  Anniversary: 2,
  Welcome: 3,
  GrievanceResolved: 4,
  ResignationApproved: 5,
  LeaveApplied: 6,
  LeaveApproval: 7,
  LeaveRejection: 8,
  ResignationApplied: 9,
  ResignationRejected: 10,
  EarlyReleaseRequested: 11,
  EarlyReleaseApproved: 12,
  EarlyReleaseRejected: 13,
  AccountClearanceGranted: 14,
  ITClearanceGranted: 15,
  GrievanceSubmitted: 16,
  NewRoleAdded: 17,
  UpdatedPolicy: 18,
  NewPolicyAdded: 19,
  KPIComplete: 20,
  FeedbackSubmitted: 21,
  FeedbackStatusChanged: 22,
} as const;

export type EmailTemplateTypeValue = (typeof EmailTemplateType)[keyof typeof EmailTemplateType];

export const EmailTemplateStatus = {
  Inactive: 0,
  Active: 1,
} as const;

export type EmailTemplateStatusValue =
  (typeof EmailTemplateStatus)[keyof typeof EmailTemplateStatus];

// Template Type Labels
export const EMAIL_TEMPLATE_TYPE_LABEL: Record<EmailTemplateTypeValue, string> = {
  [EmailTemplateType.Birthday]: 'Birthday',
  [EmailTemplateType.Anniversary]: 'Anniversary',
  [EmailTemplateType.Welcome]: 'Welcome',
  [EmailTemplateType.GrievanceResolved]: 'Grievance Resolved',
  [EmailTemplateType.ResignationApproved]: 'Resignation Approved',
  [EmailTemplateType.LeaveApplied]: 'Leave Applied',
  [EmailTemplateType.LeaveApproval]: 'Leave Approval',
  [EmailTemplateType.LeaveRejection]: 'Leave Rejection',
  [EmailTemplateType.ResignationApplied]: 'Resignation Applied',
  [EmailTemplateType.ResignationRejected]: 'Resignation Rejected',
  [EmailTemplateType.EarlyReleaseRequested]: 'Early Release Requested',
  [EmailTemplateType.EarlyReleaseApproved]: 'Early Release Approved',
  [EmailTemplateType.EarlyReleaseRejected]: 'Early Release Rejected',
  [EmailTemplateType.AccountClearanceGranted]: 'Account Clearance Granted',
  [EmailTemplateType.ITClearanceGranted]: 'IT Clearance Granted',
  [EmailTemplateType.GrievanceSubmitted]: 'Grievance Submitted',
  [EmailTemplateType.NewRoleAdded]: 'New Role Added',
  [EmailTemplateType.UpdatedPolicy]: 'Updated Policy',
  [EmailTemplateType.NewPolicyAdded]: 'New Policy Added',
  [EmailTemplateType.KPIComplete]: 'KPI Complete',
  [EmailTemplateType.FeedbackSubmitted]: 'Feedback Submitted',
  [EmailTemplateType.FeedbackStatusChanged]: 'Feedback Status Changed',
};

// Status Labels
export const EMAIL_TEMPLATE_STATUS_LABEL: Record<EmailTemplateStatusValue, string> = {
  [EmailTemplateStatus.Inactive]: 'Inactive',
  [EmailTemplateStatus.Active]: 'Active',
};

// Core Interfaces
export interface EmailTemplate {
  id: number;
  templateName: string;
  subject: string;
  content: string; // HTML body
  type: EmailTemplateTypeValue;
  status: EmailTemplateStatusValue | null; // null = default template
  senderName: string;
  senderEmail: string;
  ccEmails: string; // semicolon-delimited
  bccEmails: string; // semicolon-delimited
  toEmail: string; // semicolon-delimited
  createdOn: string;
  modifiedOn?: string | null;
}

export interface EmailTemplateTypeOption {
  id: EmailTemplateTypeValue;
  name: string;
}

// Request DTOs
export interface EmailTemplateSearchFilter {
  templateName?: string;
  senderName?: string;
  senderEmail?: string;
  templateType?: EmailTemplateTypeValue | null;
  status?: EmailTemplateStatusValue | null;
}

export interface EmailTemplatePaginationRequest {
  searchValue?: string;
  pageNumber: number;
  pageSize: number;
  sortColumn?: string;
  sortDirection?: 'asc' | 'desc';
  filter: EmailTemplateSearchFilter;
}

export interface AddEmailTemplateRequest {
  templateName: string;
  subject: string;
  content: string;
  type: EmailTemplateTypeValue;
  senderName: string;
  senderEmail: string;
  ccEmails?: string;
  bccEmails?: string;
  toEmail?: string;
  isDefault?: boolean;
}

export interface UpdateEmailTemplateRequest {
  id: number;
  templateName: string;
  subject: string;
  content: string;
  type: EmailTemplateTypeValue;
  senderName: string;
  senderEmail: string;
  ccEmails?: string;
  bccEmails?: string;
  toEmail?: string;
}

export interface ToggleStatusRequest {
  id: number;
  status: EmailTemplateStatusValue;
}

// Response DTOs
export interface EmailTemplateListResponse {
  totalRecords: number;
  templates: EmailTemplate[];
}

// Available placeholders for email templates
export const EMAIL_TEMPLATE_PLACEHOLDERS = [
  '{FirstName}',
  '{LastName}',
  '{EmployeeName}',
  '{SenderName}',
  '{SenderEmail}',
  '{StartDate}',
  '{EndDate}',
  '{TotalLeaveDays}',
  '{LeaveType}',
  '{CreatedOn}',
  '{Reason}',
  '{RejectReason}',
  '{TicketNo}',
  '{Department}',
  '{ReportingManagerName}',
  '{ResignationDate}',
  '{LastWorkingDate}',
  '{RoleName}',
  '{DocumentName}',
  '{Branch}',
  '{ReviewDate}',
];

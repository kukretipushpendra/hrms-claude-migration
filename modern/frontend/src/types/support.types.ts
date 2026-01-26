// Feedback Type (Bug/Suggestion)
export const FeedbackType = {
  Bug: 1,
  Suggestion: 2,
} as const;

export type FeedbackTypeValue = (typeof FeedbackType)[keyof typeof FeedbackType];

// Ticket Status
export const FeedbackStatus = {
  Open: 0,
  InProgress: 1,
  UnableToReproduce: 2,
  NotFixing: 3,
  NotApplicable: 4,
  Closed: 5,
} as const;

export type FeedbackStatusType = (typeof FeedbackStatus)[keyof typeof FeedbackStatus];

// Labels for UI display
export const FEEDBACK_TYPE_LABEL: Record<FeedbackTypeValue, string> = {
  [FeedbackType.Bug]: 'Bug',
  [FeedbackType.Suggestion]: 'Suggestion',
};

export const FEEDBACK_STATUS_LABEL: Record<FeedbackStatusType, string> = {
  [FeedbackStatus.Open]: 'Open',
  [FeedbackStatus.InProgress]: 'In Progress',
  [FeedbackStatus.UnableToReproduce]: 'Unable to Reproduce',
  [FeedbackStatus.NotFixing]: 'Not Fixing',
  [FeedbackStatus.NotApplicable]: 'Not Applicable',
  [FeedbackStatus.Closed]: 'Closed',
};

// Options for dropdowns
export const FEEDBACK_TYPE_OPTIONS = [
  { label: 'Bug', value: FeedbackType.Bug },
  { label: 'Suggestion', value: FeedbackType.Suggestion },
];

export const FEEDBACK_STATUS_OPTIONS = [
  { label: 'Open', value: FeedbackStatus.Open },
  { label: 'In Progress', value: FeedbackStatus.InProgress },
  { label: 'Unable to Reproduce', value: FeedbackStatus.UnableToReproduce },
  { label: 'Not Fixing', value: FeedbackStatus.NotFixing },
  { label: 'Not Applicable', value: FeedbackStatus.NotApplicable },
  { label: 'Closed', value: FeedbackStatus.Closed },
];

// Interfaces
export interface Feedback {
  id: number;
  employeeId: number;
  employeeName?: string;
  employeeEmail?: string;
  ticketStatus: FeedbackStatusType;
  feedbackType: FeedbackTypeValue;
  subject: string;
  description: string;
  adminComment?: string;
  attachmentPath?: string;
  fileOriginalName?: string;
  createdOn: string;
  modifiedOn?: string;
}

export interface EmployeeFeedback {
  id: number;
  ticketStatus: FeedbackStatusType;
  feedbackType: FeedbackTypeValue;
  subject: string;
  description: string;
  adminComment?: string;
  createdOn: string;
  modifiedOn?: string;
}

// Request DTOs
export interface AddFeedbackRequest {
  employeeId: number;
  feedbackType: FeedbackTypeValue;
  subject: string;
  description: string;
  attachment?: File | null;
}

export interface FeedbackSearchFilter {
  ticketStatus?: FeedbackStatusType | null;
  feedbackType?: FeedbackTypeValue | null;
  searchQuery?: string;
  createdOnFrom?: string | null;
  createdOnTo?: string | null;
  employeeCodes?: string[];
}

export interface EmployeeFeedbackFilter {
  ticketStatus?: FeedbackStatusType | null;
  feedbackType?: FeedbackTypeValue | null;
}

export interface ModifyStatusRequest {
  id: number;
  ticketStatus: FeedbackStatusType;
  adminComment: string;
}

// Response DTOs
export interface AddFeedbackResponse {
  id: number;
  ticketId?: string;
}

export interface FeedbackListResponse {
  totalRecords: number;
  feedbackList: Feedback[];
}

export interface EmployeeFeedbackListResponse {
  totalRecords: number;
  feedbackList: EmployeeFeedback[];
}

// Date range types
export type DateRangeType = 'previous15Days' | 'previous30Days' | 'previous90Days' | 'custom';

export interface DateRangeOption {
  id: DateRangeType;
  label: string;
}

export const DATE_RANGE_OPTIONS: DateRangeOption[] = [
  { id: 'previous15Days', label: 'Previous 15 Days' },
  { id: 'previous30Days', label: 'Previous 30 Days' },
  { id: 'previous90Days', label: 'Previous 90 Days' },
  { id: 'custom', label: 'Custom' },
];

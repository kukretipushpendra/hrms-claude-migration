// Types matching legacy .NET backend responses

export interface ApiResponse<T> {
  statusCode: number;
  message: string;
  modelErrors?: string[];
  result: T;
}

// Employee Count (Analytics)
export interface GetEmployeeCountParams {
  from?: string;
  to?: string;
  days?: number;
}

export interface EmployeeCount {
  activeEmployeeCount: number;
  newEmployeeCount: number;
  exitOrgEmployeeCount: number;
}

// Birthday
export interface EmployeeBirthday {
  id: number;
  firstName: string;
  middleName: string;
  lastName: string;
  profileImagePath: string;
  dob: string;
}

// Work Anniversary
export interface WorkAnniversary {
  id: number;
  firstName: string;
  middleName: string;
  lastName: string;
  joiningDate: string;
  profilePicPath: string;
}

// Holidays
export interface Holiday {
  date: string;
  day: string;
  location: string;
  title: string;
}

export interface HolidayResult {
  india: Holiday[];
  usa: Holiday[];
}

// Upcoming Events
export interface UpcomingEvent {
  id: number;
  eventName: string;
  bannerFileName: string;
  startDate: string;
  status: string;
  venue: string;
}

// Company Policy Document
export interface CompanyPolicyDocument {
  id: number;
  name: string;
  updatedOn: string;
}

export interface GetPublishedCompanyPoliciesParams {
  from?: string;
  to?: string;
  days?: number;
}

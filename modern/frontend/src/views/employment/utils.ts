export function formatDuration(years: number, months: number): string {
  if (years < 0 || months < 0) {
    return 'Invalid input';
  }

  if (years === 0 && months === 0) {
    return '0 months';
  }

  const yearStr = years === 1 ? `${years} year` : `${years} years`;
  const monthStr = months === 1 ? `${months} month` : `${months} months`;

  if (years === 0) {
    return monthStr;
  } else if (months === 0) {
    return yearStr;
  } else {
    return `${yearStr} ${monthStr}`;
  }
}

export const jobTypes = [
  { id: 1, label: 'Probation' },
  { id: 2, label: 'Confirmed' },
  { id: 3, label: 'Training' },
];

export const backgroundVerificationStatuses = [
  { id: 1, label: 'Pending' },
  { id: 2, label: 'Successful' },
  { id: 3, label: 'Unsuccessful' },
];

export const CRIMINAL_VERIFICATION_STATUS = {
  PENDING: '1',
  COMPLETED: '2',
} as const;

export const criminalVerificationStatuses = [
  { id: CRIMINAL_VERIFICATION_STATUS.PENDING, label: 'Pending' },
  { id: CRIMINAL_VERIFICATION_STATUS.COMPLETED, label: 'Completed' },
];

export const EMPLOYMENT_STATUS = {
  FULL_TIME: 1,
  PART_TIME: 2,
  PROBATION: 3,
  INTERNSHIP: 4,
} as const;

export const EMPLOYMENT_STATUS_OPTIONS = [
  { id: '1', label: 'Full Time' },
  { id: '2', label: 'Part Time' },
  { id: '3', label: 'Probation' },
  { id: '4', label: 'Internship' },
];

export function convertApiValueToStr(apiValue: number | null): string {
  return apiValue === 0 || apiValue === null ? '' : String(apiValue);
}

export function convertFormStrToApiValue(formValue: string): number | null {
  return formValue === '' ? null : Number(formValue);
}

// Branch Location Constants (matching legacy)
export const BRANCH_LOCATION = {
  NOIDA: 1,
  JAIPUR: 2,
  US: 3,
  REMOTE: 4,
  HYDERABAD: 5,
  PUNE: 6,
} as const;

export const BRANCH_LOCATION_LABEL: Record<number, string> = {
  [BRANCH_LOCATION.NOIDA]: 'Noida',
  [BRANCH_LOCATION.JAIPUR]: 'Jaipur',
  [BRANCH_LOCATION.US]: 'US',
  [BRANCH_LOCATION.REMOTE]: 'Remote',
  [BRANCH_LOCATION.HYDERABAD]: 'Hyderabad',
  [BRANCH_LOCATION.PUNE]: 'Pune',
};

export const BRANCH_LOCATION_OPTIONS = Object.entries(BRANCH_LOCATION_LABEL).map(
  ([key, value]) => ({ id: Number(key), label: value })
);

// Employee Status Constants (matching legacy)
export const EMPLOYEE_STATUS = {
  ACTIVE: 1,
  INACTIVE: 2,
  EXITED: 3,
  FNF_PENDING: 4,
  ON_NOTICE: 5,
  EX_EMPLOYEE: 6,
} as const;

export const EMPLOYEE_STATUS_LABEL: Record<number, string> = {
  [EMPLOYEE_STATUS.ACTIVE]: 'Active',
  [EMPLOYEE_STATUS.INACTIVE]: 'Inactive',
  [EMPLOYEE_STATUS.EXITED]: 'Exited',
  [EMPLOYEE_STATUS.FNF_PENDING]: 'F&F Pending',
  [EMPLOYEE_STATUS.ON_NOTICE]: 'On Notice',
  [EMPLOYEE_STATUS.EX_EMPLOYEE]: 'Ex Employee',
};

export const EMPLOYEE_STATUS_OPTIONS = Object.entries(EMPLOYEE_STATUS_LABEL).map(
  ([key, value]) => ({ id: Number(key), label: value })
);

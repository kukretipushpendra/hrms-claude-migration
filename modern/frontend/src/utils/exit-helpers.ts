// Exit Management Helper Functions
// Utilities for calculating last working day, formatting dates, etc.

import dayjs, { type Dayjs } from 'dayjs';
import { JobTypes, type JobType, NOTICE_PERIOD_CONFIG } from '@/types/exit.types';

/**
 * Calculate last working day based on resignation date and job type
 * @param resignationDate - Date of resignation
 * @param jobType - Employee's job type (probation, confirmed, training)
 * @returns Last working day
 */
export function calculateLastWorkingDay(resignationDate: Dayjs, jobType: JobType): Dayjs {
  const config = NOTICE_PERIOD_CONFIG[jobType];
  return resignationDate.add(config.amount, config.unit);
}

/**
 * Check if value is a valid job type
 * @param value - Value to check
 * @returns True if valid job type
 */
export function isValidJobType(value: unknown): value is JobType {
  return typeof value === 'number' && Object.values(JobTypes).includes(value as JobType);
}

/**
 * Get notice period text for display
 * @param jobType - Employee's job type
 * @returns Notice period text (e.g., "3 months", "15 days")
 */
export function getNoticePeriod(jobType: JobType): string {
  if (!isValidJobType(jobType)) {
    return '';
  }

  const { amount, unit } = NOTICE_PERIOD_CONFIG[jobType];
  return `${amount} ${unit}`;
}

/**
 * Format date for API (YYYY-MM-DD)
 * @param date - Date to format
 * @returns Formatted date string
 */
export function formatDateForApi(date: Dayjs | Date | string): string {
  return dayjs(date).format('YYYY-MM-DD');
}

/**
 * Format date for display (e.g., Jan 26, 2026)
 * @param date - Date to format
 * @returns Formatted date string
 */
export function formatDateForDisplay(date: Dayjs | Date | string): string {
  return dayjs(date).format('MMM DD, YYYY');
}

/**
 * Check if resignation can be revoked
 * @param status - Resignation status
 * @param lastWorkingDay - Last working day
 * @returns True if can revoke
 */
export function canRevokeResignation(status: number, lastWorkingDay: string): boolean {
  const today = dayjs();
  const lwd = dayjs(lastWorkingDay);

  // Can revoke if status is pending (1) or accepted (3) and LWD >= today
  const isValidStatus = status === 1 || status === 3;
  const isBeforeLWD = lwd.isSameOrAfter(today, 'day');

  return isValidStatus && isBeforeLWD;
}

/**
 * Check if early release can be requested
 * @param status - Resignation status
 * @param earlyReleaseStatus - Early release status
 * @returns True if can request early release
 */
export function canRequestEarlyRelease(status: number, earlyReleaseStatus: number | null): boolean {
  // Can request if resignation is accepted (3) and no early release requested yet
  return status === 3 && (earlyReleaseStatus === null || earlyReleaseStatus === 0);
}

/**
 * Check if clearances can be edited
 * @param status - Resignation status
 * @returns True if can edit clearances
 */
export function canEditClearances(status: number): boolean {
  // Cannot edit if completed (5), cancelled (4), or revoked (2)
  return status !== 2 && status !== 4 && status !== 5;
}

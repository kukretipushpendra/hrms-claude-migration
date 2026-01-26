// Grievance utility functions

import {
  GrievanceStatus,
  GrievanceLevel,
  GRIEVANCE_STATUS_LABEL,
  GRIEVANCE_LEVEL_LABEL,
} from '@/types/grievance.types';
import type { GrievanceStatusType, GrievanceLevelType } from '@/types/grievance.types';

export interface StatusMeta {
  label: string;
  color: 'info' | 'success' | 'warning' | 'error' | 'default';
  icon: string;
}

/**
 * Get status display metadata (label, color, icon)
 */
export function getGrievanceStatusMeta(
  status: GrievanceStatusType,
  level?: GrievanceLevelType
): StatusMeta {
  const baseLabel = GRIEVANCE_STATUS_LABEL[status];

  switch (status) {
    case GrievanceStatus.Open:
      return { label: baseLabel, color: 'info', icon: 'mdi-adjust' };

    case GrievanceStatus.InProgress:
      return { label: baseLabel, color: 'info', icon: 'mdi-autorenew' };

    case GrievanceStatus.Resolved:
      return { label: baseLabel, color: 'success', icon: 'mdi-check-circle' };

    case GrievanceStatus.Closed:
      return { label: baseLabel, color: 'default', icon: 'mdi-check-circle-outline' };

    case GrievanceStatus.Escalated: {
      const levelLabel = level ? GRIEVANCE_LEVEL_LABEL[level] : undefined;
      const color = level === GrievanceLevel.L3 ? 'error' : 'warning';

      return {
        label: levelLabel ? `${baseLabel} to ${levelLabel}` : baseLabel,
        color,
        icon: 'mdi-trending-up',
      };
    }

    default:
      return { label: 'Unknown', color: 'default', icon: 'mdi-help-circle-outline' };
  }
}

/**
 * Get level label
 */
export function getGrievanceLevelLabel(level: GrievanceLevelType): string {
  return GRIEVANCE_LEVEL_LABEL[level] || 'Unknown';
}

/**
 * Get status label
 */
export function getGrievanceStatusLabel(status: GrievanceStatusType): string {
  return GRIEVANCE_STATUS_LABEL[status] || 'Unknown';
}

/**
 * Parse CSV string to array
 */
export function parseCsv(csv: string | undefined | null): string[] {
  if (!csv || !csv.trim()) {
    return [];
  }
  return csv
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
}

/**
 * Check if grievance can be edited (for remarks)
 */
export function canAddRemarks(status: GrievanceStatusType): boolean {
  return status !== GrievanceStatus.Resolved && status !== GrievanceStatus.Closed;
}

/**
 * Format file size
 */
export function formatFileSize(bytes: number): string {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}

/**
 * Validate file upload
 */
export function validateFile(file: File | null, maxSizeMB = 5): { valid: boolean; error?: string } {
  if (!file) {
    return { valid: true };
  }

  const maxBytes = maxSizeMB * 1024 * 1024;

  if (file.size > maxBytes) {
    return {
      valid: false,
      error: `File size must be less than ${maxSizeMB}MB`,
    };
  }

  return { valid: true };
}

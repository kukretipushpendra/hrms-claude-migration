/**
 * Feature Flags Constants - Matches Legacy React Constants
 * From: /utils/constants.ts (FEATURE_FLAGS, FEATURE_FLAG_TO_MENU_ID)
 */

// Feature flag keys
export const FEATURE_FLAGS = {
  enableExitEmployee: 'enableExitEmployee',
  enableAttendance: 'enableAttendance',
  enableLeave: 'enableLeave',
  enableITAsset: 'enableITAsset',
  enableKPI: 'enableKPI',
  enableGrievance: 'enableGrievance',
  enableChatbot: 'enableChatbot',
} as const;

// Feature flag URL (public folder)
export const FEATURE_FLAGS_URL = '/feature-flags.json';

// Feature flag storage key
export const FEATURE_FLAG_STORAGE_KEY = 'feature-flags';

/**
 * Maps feature flags to navigation menu IDs
 * Used to hide/show menu items based on feature flags
 */
export const FEATURE_FLAG_TO_MENU_ID: Record<string, string[]> = {
  [FEATURE_FLAGS.enableExitEmployee]: ['employee-exit'],
  [FEATURE_FLAGS.enableAttendance]: ['attendance'],
  [FEATURE_FLAGS.enableLeave]: ['leave'],
  [FEATURE_FLAGS.enableITAsset]: ['it-assets'],
  [FEATURE_FLAGS.enableKPI]: ['kpi'],
  [FEATURE_FLAGS.enableGrievance]: ['grievance'],
};

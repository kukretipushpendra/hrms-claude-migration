/**
 * Feature Flag Composable - Matches Legacy React Hook
 * From: /hooks/useFeatureFlag.tsx
 *
 * Use this composable to check if a feature flag is enabled in components.
 *
 * @example
 * const isLeaveEnabled = useFeatureFlag('enableLeave');
 * <div v-if="isLeaveEnabled">...</div>
 */

import { computed } from 'vue';
import { storeToRefs } from 'pinia';
import { useFeatureFlagStore } from '@/stores/featureFlag.store';

export function useFeatureFlag(flagKey: string) {
  const store = useFeatureFlagStore();
  const { flags } = storeToRefs(store);

  // Return a computed that reactively checks the flag value
  return computed(() => flags.value[flagKey] ?? false);
}

/**
 * Get feature flag value outside of Vue components (e.g., in utility functions)
 * From: /utils/feature-flags.ts
 *
 * @example
 * if (getFeatureFlag('enableAttendance')) {
 *   // Do something
 * }
 */
export function getFeatureFlag(key: string, defaultValue = false): boolean {
  const store = useFeatureFlagStore();
  const flags = store.flags;

  return typeof flags[key] !== 'boolean' ? defaultValue : flags[key];
}

/**
 * Feature Flags Plugin - Matches Legacy React FeatureFlagProvider
 * From: /contexts/FeatureFlagProvider.tsx
 *
 * Initializes feature flags by:
 * 1. Fetching remote flags from /feature-flags.json
 * 2. Merging with local state based on version
 * 3. Setting up window.featureFlags proxy for runtime override
 */

import axios from 'axios';
import { useFeatureFlagStore } from '@/stores/featureFlag.store';
import type { FeatureFlagsConfig, FeatureFlagMap } from '@/stores/featureFlag.store';
import { FEATURE_FLAGS_URL } from '@/constants/featureFlags';

/**
 * Initialize feature flags
 * Called from main.ts before mounting the app
 */
export async function initFeatureFlags(): Promise<void> {
  const store = useFeatureFlagStore();

  try {
    // Fetch remote feature flags
    const response = await axios.get<FeatureFlagsConfig>(FEATURE_FLAGS_URL);
    const remote = response.data;

    // Merge with local state (version-controlled)
    store.mergeRemoteFlags(remote);

    // Setup window proxy for runtime flag override
    setupFeatureFlagsProxy();

    console.log('[FeatureFlags] Initialized with version:', store.version);
  } catch (error) {
    console.error('[FeatureFlags] Failed to fetch feature flags:', error);
    // Continue without remote flags (use local cache if available)
  }
}

/**
 * Check if a flag key is valid
 */
function isExistingFeatureFlag(key: string, flags: FeatureFlagMap): boolean {
  return Object.keys(flags).includes(key);
}

/**
 * Setup window.featureFlags proxy for runtime override
 * Allows developers to toggle flags via browser console:
 *
 * window.featureFlags.enableLeave = true;
 * window.featureFlags.enableAttendance = false;
 */
function setupFeatureFlagsProxy(): void {
  const store = useFeatureFlagStore();

  const handler: ProxyHandler<FeatureFlagMap> = {
    set(_target: FeatureFlagMap, prop: string, value: boolean): boolean {
      if (!isExistingFeatureFlag(prop, store.flags)) {
        console.error(`[FeatureFlags] Feature flag "${prop}" is not a known flag`);
        return false;
      }

      store.setFlag(prop, value);
      console.log(`[FeatureFlags] "${prop}" set to`, value);
      return true;
    },

    get(_target: FeatureFlagMap, prop: string): boolean {
      return store.flags[prop] ?? false;
    },
  };

  // Create proxy and attach to window
  (window as Window & { featureFlags?: FeatureFlagMap }).featureFlags = new Proxy<FeatureFlagMap>(
    {},
    handler
  );
}

/**
 * Cleanup feature flags proxy on logout
 */
export function cleanupFeatureFlags(): void {
  delete (window as Window & { featureFlags?: FeatureFlagMap }).featureFlags;
}

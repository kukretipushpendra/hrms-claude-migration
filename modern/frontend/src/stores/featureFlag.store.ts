/**
 * Feature Flags Store - Matches Legacy React Zustand Store
 * From: /store/featureFlagStore.ts
 *
 * Manages feature flags with version-controlled persistence to localStorage.
 * Flags are fetched from /feature-flags.json and merged based on version.
 */

import { defineStore } from 'pinia';

export interface FeatureFlagMap {
  [flagKey: string]: boolean;
}

export interface FeatureFlagsConfig {
  flags: FeatureFlagMap;
  version: string;
}

interface FeatureFlagState {
  flags: FeatureFlagMap;
  version: string;
}

const FEATURE_FLAG_STORAGE_KEY = 'feature-flags';

export const useFeatureFlagStore = defineStore('featureFlags', {
  state: (): FeatureFlagState => ({
    flags: {},
    version: '',
  }),

  getters: {
    /**
     * Get a specific feature flag value
     * Returns false if flag doesn't exist
     */
    getFlag:
      (state) =>
      (key: string): boolean => {
        return state.flags[key] ?? false;
      },

    /**
     * Check if all flags are loaded
     */
    isLoaded: (state): boolean => {
      return Object.keys(state.flags).length > 0;
    },
  },

  actions: {
    /**
     * Set a single feature flag value
     * Used by window.featureFlags proxy for runtime override
     */
    setFlag(key: string, value: boolean) {
      this.flags = { ...this.flags, [key]: value };
    },

    /**
     * Merge remote flags with local state
     * Only updates if version has changed or no local version exists
     *
     * This matches the legacy behavior exactly:
     * - If no local version, use remote
     * - If versions differ, use remote
     * - If versions match, keep local (preserves runtime overrides)
     */
    mergeRemoteFlags(remote: FeatureFlagsConfig) {
      if (!this.version || this.version !== remote.version) {
        this.flags = remote.flags;
        this.version = remote.version;
      }
    },

    /**
     * Reset all flags to empty state
     * Used during logout
     */
    reset() {
      this.flags = {};
      this.version = '';
    },
  },

  persist: {
    key: FEATURE_FLAG_STORAGE_KEY,
    storage: localStorage,
  },
});

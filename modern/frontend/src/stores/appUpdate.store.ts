/**
 * App Update Store - Matches Legacy React Zustand Store
 * From: /store/useAppUpdateStore.ts
 *
 * Manages app version updates when backend returns 422 with new build version.
 * Shows update dialog prompting user to refresh.
 */

import { defineStore } from 'pinia';

interface AppUpdateState {
  newVersionAvailable: string | null;
  showUpdateDialog: boolean;
}

export const useAppUpdateStore = defineStore('appUpdate', {
  state: (): AppUpdateState => ({
    newVersionAvailable: null,
    showUpdateDialog: false,
  }),

  actions: {
    /**
     * Set new version and show update dialog
     * Called by http-client when 422 response received
     */
    setNewVersion(version: string) {
      this.newVersionAvailable = version;
      this.showUpdateDialog = true;
    },

    /**
     * Clear update state and hide dialog
     * Called when user dismisses or after refresh
     */
    clearUpdate() {
      this.newVersionAvailable = null;
      this.showUpdateDialog = false;
    },
  },
});

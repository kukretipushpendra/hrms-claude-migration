import { createApp } from 'vue';
import { createPinia } from 'pinia';
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate';
import App from './App.vue';
import router from './router';

// Vuetify with legacy theme
import vuetify from './plugins/vuetify';

// Global styles matching legacy
import './styles/global.scss';

// Feature flags initialization
import { initFeatureFlags } from './plugins/featureFlags';

// Create Pinia store with persistence plugin
const pinia = createPinia();
pinia.use(piniaPluginPersistedstate);

// Initialize app
async function initApp() {
  const app = createApp(App);

  app.use(pinia);
  app.use(router);
  app.use(vuetify);

  // Load feature flags BEFORE mounting app (like legacy FeatureFlagProvider)
  await initFeatureFlags();

  app.mount('#app');
}

// Start app
initApp();

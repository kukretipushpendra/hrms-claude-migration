import { createApp } from 'vue';
import { createPinia } from 'pinia';
import App from './App.vue';
import router from './router';

// Vuetify with legacy theme
import vuetify from './plugins/vuetify';

// Global styles matching legacy
import './styles/global.scss';

// Create Pinia store
const pinia = createPinia();

// Create and mount app
const app = createApp(App);

app.use(pinia);
app.use(router);
app.use(vuetify);

app.mount('#app');

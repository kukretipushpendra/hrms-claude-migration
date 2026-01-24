import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import { fileURLToPath, URL } from 'node:url';

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        // Use modern @use syntax to make variables available in all SCSS files
        additionalData: `@use "@/styles/variables" as *;`,
      },
    },
  },
  server: {
    port: 5173,
    proxy: {
      // Proxy API requests to .NET backend during development
      '/api': {
        target: 'http://localhost:5281',
        changeOrigin: true,
        secure: false,
      },
    },
  },
});

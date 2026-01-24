/// <reference types="vite/client" />

// Module declarations for non-TypeScript modules
declare module 'vuetify/styles' {
  // CSS module
}

declare module 'vuetify/components' {
  import type { ComponentPublicInstance } from 'vue';
  const components: Record<string, ComponentPublicInstance>;
  export = components;
}

declare module 'vuetify/directives' {
  import type { Directive } from 'vue';
  const directives: Record<string, Directive>;
  export = directives;
}

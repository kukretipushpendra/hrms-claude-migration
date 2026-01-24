/**
 * Vuetify Configuration
 * Matches legacy React MUI theme exactly
 */
import 'vuetify/styles';
import { createVuetify, type ThemeDefinition } from 'vuetify';
import * as components from 'vuetify/components';
import * as directives from 'vuetify/directives';
import '@mdi/font/css/materialdesignicons.css';

// Legacy brand colors
const brandColors = {
  primaryBlue: '#1e75bb',
  darkColor: '#283a50',
  secondaryDark: '#273A50',
};

// Grey scale (matches Ant Design)
const greyScale = {
  grey0: '#ffffff',
  grey50: '#fafafa',
  grey100: '#f5f5f5',
  grey200: '#f0f0f0',
  grey300: '#d9d9d9',
  grey400: '#bfbfbf',
  grey500: '#8c8c8c',
  grey600: '#595959',
  grey700: '#262626',
  grey800: '#141414',
  grey900: '#000000',
};

// Status colors
const statusColors = {
  wipPending: '#FF9800',
  upcoming: '#2196F3',
  completed: '#4CAF50',
};

// Light theme matching legacy
const lightTheme: ThemeDefinition = {
  dark: false,
  colors: {
    // Brand colors
    primary: brandColors.primaryBlue,
    secondary: greyScale.grey600,

    // Status colors
    error: '#ff4d4f',
    warning: '#faad14',
    info: '#13c2c2',
    success: '#52c41a',

    // Background colors
    background: '#fafafb',
    surface: greyScale.grey0,

    // Text colors
    'on-background': greyScale.grey700,
    'on-surface': greyScale.grey700,
    'on-primary': greyScale.grey0,
    'on-secondary': greyScale.grey0,

    // Custom colors (accessible via RGB vars)
    'brand-dark': brandColors.darkColor,
    'brand-secondary': brandColors.secondaryDark,
    'grey-50': greyScale.grey50,
    'grey-100': greyScale.grey100,
    'grey-200': greyScale.grey200,
    'grey-300': greyScale.grey300,
    'grey-400': greyScale.grey400,
    'grey-500': greyScale.grey500,
  },
  variables: {
    // Border radius
    'border-radius-root': '4px',

    // Shadows
    'shadow-key-umbra-opacity': 0.08,
    'shadow-key-penumbra-opacity': 0.05,
    'shadow-key-ambient-opacity': 0.04,
  },
};

export default createVuetify({
  components,
  directives,
  theme: {
    defaultTheme: 'light',
    themes: {
      light: lightTheme,
    },
  },
  defaults: {
    VBtn: {
      style: 'text-transform: capitalize;', // Match legacy button styling
    },
    VCard: {
      elevation: 0,
      border: true,
    },
    VTextField: {
      variant: 'outlined',
      density: 'comfortable',
    },
    VSelect: {
      variant: 'outlined',
      density: 'comfortable',
    },
    VAutocomplete: {
      variant: 'outlined',
      density: 'comfortable',
    },
  },
});

// Export colors for use in components
export { brandColors, greyScale, statusColors };

import { ref } from 'vue';

export interface SnackbarOptions {
  message: string;
  color?: string;
  timeout?: number;
}

const snackbar = ref({
  visible: false,
  message: '',
  color: 'success',
  timeout: 3000,
});

export function useSnackbar() {
  const show = (options: SnackbarOptions) => {
    snackbar.value.message = options.message;
    snackbar.value.color = options.color || 'success';
    snackbar.value.timeout = options.timeout || 3000;
    snackbar.value.visible = true;
  };

  const showSuccess = (message: string) => {
    show({ message, color: 'success' });
  };

  const showError = (message: string) => {
    show({ message, color: 'error', timeout: 5000 });
  };

  const showInfo = (message: string) => {
    show({ message, color: 'info' });
  };

  const showWarning = (message: string) => {
    show({ message, color: 'warning' });
  };

  const hide = () => {
    snackbar.value.visible = false;
  };

  return {
    snackbar,
    show,
    showSuccess,
    showError,
    showInfo,
    showWarning,
    hide,
  };
}

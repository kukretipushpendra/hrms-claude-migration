```typescript
import { Component } from 'react';
import type { ErrorInfo, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
  errorInfo: ErrorInfo | null;
}

/**
 * ErrorBoundary component matching legacy ASP.NET error handling behavior.
 * Legacy used server-side error pages (/Error) with request ID tracking.
 * React requires client-side error boundaries to catch rendering errors.
 */
export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      hasError: false,
      error: null,
      errorInfo: null,
    };
  }

  static getDerivedStateFromError(error: Error): Partial<State> {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo): void {
    this.setState({ errorInfo });
    // Log error to console (in production, send to error tracking service)
    console.error('ErrorBoundary caught an error:', error, errorInfo);
  }

  handleRetry = (): void => {
    this.setState({ hasError: false, error: null, errorInfo: null });
  };

  render(): ReactNode {
    if (this.state.hasError) {
      // Custom fallback provided
      if (this.props.fallback) {
        return this.props.fallback;
      }

      // Default error UI matching legacy Error.cshtml style
      return (
        <div className="container mt-5">
          <h1 className="text-danger">Error.</h1>
          <h2 className="text-danger">An error occurred while processing your request.</h2>

          {import.meta.env.DEV && this.state.error && (
            <>
              <h3 className="mt-4">Development Mode</h3>
              <p>
                <strong>Error:</strong> {this.state.error.message}
              </p>
              {this.state.errorInfo && (
                <details className="mt-3">
                  <summary>Component Stack</summary>
                  <pre className="bg-light p-3 mt-2" style={{ whiteSpace: 'pre-wrap' }}>
                    {this.state.errorInfo.componentStack}
                  </pre>
                </details>
              )}
              <p className="mt-3 text-muted">
                <strong>The Development environment shouldn't be enabled for deployed applications.</strong>
                {' '}It can result in displaying sensitive information from exceptions to end users.
              </p>
            </>
          )}

          <div className="mt-4">
            <button
              className="btn btn-primary me-2"
              onClick={this.handleRetry}
            >
              Try Again
            </button>
            <button
              className="btn btn-secondary"
              onClick={() => window.location.href = '/login'}
            >
              Go to Login
            </button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

```
/**
 * Integration Test Suite for Frontend Auth
 * Tests the complete authentication flow from Vue.js frontend to .NET backend
 */

const API_BASE_URL = 'http://localhost:5281/api';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

// Test credentials
const TEST_CREDENTIALS = {
  admin: {
    email: 'test.admin@programmers.io',
    password: 'SPHappy@2025Day!',
    expectedRole: 'SuperAdmin',
    expectedName: 'Aaryan Pancholi'
  },
  hr: {
    email: 'test.hr@programmers.io',
    password: 'hrShiny@Star100x',
    expectedRole: 'HR',
    expectedName: 'Shubham Mandavkar'
  },
  dev: {
    email: 'test.dev@programmers.io',
    password: 'dev$Sky21@Pio',
    expectedRole: 'HR',
    expectedName: 'Prajwal Gaikwad'
  }
};

let testResults = {
  total: 0,
  passed: 0,
  failed: 0,
  tests: []
};

function log(message, type = 'info') {
  const timestamp = new Date().toISOString();
  const prefix = {
    info: '[INFO]',
    success: '[PASS]',
    error: '[FAIL]',
    warn: '[WARN]'
  }[type];
  console.log(`${timestamp} ${prefix} ${message}`);
}

function addTestResult(testName, passed, details) {
  testResults.total++;
  if (passed) {
    testResults.passed++;
    log(`${testName}`, 'success');
  } else {
    testResults.failed++;
    log(`${testName} - ${details}`, 'error');
  }
  testResults.tests.push({ testName, passed, details, timestamp: new Date().toISOString() });
}

async function testLoginAPI(credentials) {
  const testName = `Login API - ${credentials.email}`;

  try {
    const response = await fetch(`${API_BASE_URL}/Auth/Login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-API_KEY': API_KEY
      },
      body: JSON.stringify({
        Email: credentials.email,
        Password: credentials.password
      })
    });

    const data = await response.json();

    if (response.status === 200 && data.statusCode === 200) {
      const result = data.result;

      // Validate response structure
      if (!result.authToken || !result.refreshToken) {
        addTestResult(testName, false, 'Missing tokens in response');
        return null;
      }

      if (result.roleName !== credentials.expectedRole) {
        addTestResult(testName, false, `Role mismatch: expected ${credentials.expectedRole}, got ${result.roleName}`);
        return null;
      }

      if (!result.firstName || !result.lastName) {
        addTestResult(testName, false, 'Missing user name in response');
        return null;
      }

      addTestResult(testName, true, `Logged in as ${result.firstName} ${result.lastName} (${result.roleName})`);
      return result;
    } else {
      addTestResult(testName, false, `Status ${response.status}: ${data.message}`);
      return null;
    }
  } catch (error) {
    addTestResult(testName, false, error.message);
    return null;
  }
}

async function testWrongPassword() {
  const testName = 'Login with wrong password';

  try {
    const response = await fetch(`${API_BASE_URL}/Auth/Login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-API_KEY': API_KEY
      },
      body: JSON.stringify({
        Email: TEST_CREDENTIALS.admin.email,
        Password: 'WrongPassword123!'
      })
    });

    const data = await response.json();

    // Should get error response
    if (response.status === 400 || data.statusCode === 400) {
      addTestResult(testName, true, 'Correctly rejected wrong password');
    } else {
      addTestResult(testName, false, 'Should have rejected wrong password');
    }
  } catch (error) {
    addTestResult(testName, false, error.message);
  }
}

async function testNonExistentUser() {
  const testName = 'Login with non-existent email';

  try {
    const response = await fetch(`${API_BASE_URL}/Auth/Login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-API_KEY': API_KEY
      },
      body: JSON.stringify({
        Email: 'nonexistent@programmers.io',
        Password: 'SomePassword123!'
      })
    });

    const data = await response.json();

    // Should get error response
    if (response.status === 400 || data.statusCode === 400) {
      addTestResult(testName, true, 'Correctly rejected non-existent user');
    } else {
      addTestResult(testName, false, 'Should have rejected non-existent user');
    }
  } catch (error) {
    addTestResult(testName, false, error.message);
  }
}

async function testRefreshToken(refreshToken) {
  const testName = 'Refresh token endpoint';

  try {
    const response = await fetch(`${API_BASE_URL}/Auth/RefreshToken`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        RefreshToken: refreshToken
      })
    });

    const data = await response.json();

    if (response.status === 200 && data.statusCode === 200) {
      const result = data.result;

      if (!result.authToken || !result.refreshToken) {
        addTestResult(testName, false, 'Missing tokens in refresh response');
        return null;
      }

      addTestResult(testName, true, 'Token refreshed successfully');
      return result;
    } else {
      addTestResult(testName, false, `Status ${response.status}: ${data.message}`);
      return null;
    }
  } catch (error) {
    addTestResult(testName, false, error.message);
    return null;
  }
}

async function testProtectedEndpoint(token) {
  const testName = 'Protected endpoint with valid token';

  try {
    const response = await fetch(`${API_BASE_URL}/UserProfile/GetPersonalDetail`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });

    if (response.status === 200) {
      addTestResult(testName, true, 'Access granted to protected endpoint');
    } else {
      addTestResult(testName, false, `Expected 200, got ${response.status}`);
    }
  } catch (error) {
    addTestResult(testName, false, error.message);
  }
}

async function testProtectedEndpointWithoutToken() {
  const testName = 'Protected endpoint without token';

  try {
    const response = await fetch(`${API_BASE_URL}/UserProfile/GetPersonalDetail`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    });

    // Should get 401 unauthorized
    if (response.status === 401) {
      addTestResult(testName, true, 'Correctly rejected request without token');
    } else {
      addTestResult(testName, false, `Expected 401, got ${response.status}`);
    }
  } catch (error) {
    addTestResult(testName, false, error.message);
  }
}

async function testMissingAPIKey() {
  const testName = 'Login without X-API_KEY header';

  try {
    const response = await fetch(`${API_BASE_URL}/Auth/Login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
        // Missing X-API_KEY header
      },
      body: JSON.stringify({
        Email: TEST_CREDENTIALS.admin.email,
        Password: TEST_CREDENTIALS.admin.password
      })
    });

    // Should get 403 Forbidden
    if (response.status === 403) {
      addTestResult(testName, true, 'Correctly rejected request without API key');
    } else {
      addTestResult(testName, false, `Expected 403, got ${response.status}`);
    }
  } catch (error) {
    addTestResult(testName, false, error.message);
  }
}

async function runIntegrationTests() {
  log('='.repeat(80), 'info');
  log('INTEGRATION TEST SUITE - Frontend Authentication', 'info');
  log('='.repeat(80), 'info');
  log('', 'info');
  log(`Backend URL: ${API_BASE_URL}`, 'info');
  log(`Frontend URL: http://localhost:5174`, 'info');
  log('', 'info');

  // Test 1: Backend connectivity
  log('Test 1: Validating backend connectivity...', 'info');
  await testMissingAPIKey();
  log('', 'info');

  // Test 2: Valid login scenarios
  log('Test 2: Valid login scenarios...', 'info');
  let adminUser = await testLoginAPI(TEST_CREDENTIALS.admin);
  let hrUser = await testLoginAPI(TEST_CREDENTIALS.hr);
  let devUser = await testLoginAPI(TEST_CREDENTIALS.dev);
  log('', 'info');

  // Test 3: Invalid login scenarios
  log('Test 3: Invalid login scenarios...', 'info');
  await testWrongPassword();
  await testNonExistentUser();
  log('', 'info');

  // Test 4: Token refresh
  if (adminUser && adminUser.refreshToken) {
    log('Test 4: Token refresh...', 'info');
    await testRefreshToken(adminUser.refreshToken);
    log('', 'info');
  }

  // Test 5: Protected endpoint access
  if (adminUser && adminUser.authToken) {
    log('Test 5: Protected endpoint access...', 'info');
    await testProtectedEndpoint(adminUser.authToken);
    await testProtectedEndpointWithoutToken();
    log('', 'info');
  }

  // Print summary
  log('='.repeat(80), 'info');
  log('TEST SUMMARY', 'info');
  log('='.repeat(80), 'info');
  log(`Total Tests: ${testResults.total}`, 'info');
  log(`Passed: ${testResults.passed}`, 'success');
  log(`Failed: ${testResults.failed}`, testResults.failed > 0 ? 'error' : 'info');
  log(`Success Rate: ${((testResults.passed / testResults.total) * 100).toFixed(1)}%`, 'info');
  log('', 'info');

  // Print failed tests details
  if (testResults.failed > 0) {
    log('FAILED TESTS:', 'error');
    testResults.tests
      .filter(t => !t.passed)
      .forEach(t => {
        log(`- ${t.testName}: ${t.details}`, 'error');
      });
    log('', 'info');
  }

  // Overall verdict
  const verdict = testResults.failed === 0 ? 'PASSED' : 'FAILED';
  const verdictType = testResults.failed === 0 ? 'success' : 'error';
  log('='.repeat(80), 'info');
  log(`INTEGRATION QA VERDICT: ${verdict}`, verdictType);
  log('='.repeat(80), 'info');

  return testResults;
}

// Run tests
runIntegrationTests()
  .then(() => {
    process.exit(testResults.failed > 0 ? 1 : 0);
  })
  .catch(error => {
    log(`Fatal error: ${error.message}`, 'error');
    process.exit(1);
  });

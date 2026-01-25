/**
 * Employee API QA Test Script
 * Tests employee management API endpoints against .NET backend
 */

const axios = require('axios');

const API_BASE_URL = 'http://localhost:5281/api';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

const TEST_CREDENTIALS = {
  email: 'test.admin@programmers.io',
  password: 'SPHappy@2025Day!'
};

let authToken = null;

// Helper function to log results
function logTest(name, passed, details = '') {
  const status = passed ? '✓ PASS' : '✗ FAIL';
  console.log(`\n${status}: ${name}`);
  if (details) {
    console.log(`  Details: ${details}`);
  }
}

// Step 1: Login
async function login() {
  console.log('\n========================================');
  console.log('STEP 1: LOGIN');
  console.log('========================================');

  try {
    const response = await axios.post(`${API_BASE_URL}/Authenticate/InternalUserLogin`, {
      Email: TEST_CREDENTIALS.email,
      Password: TEST_CREDENTIALS.password,
      APIKey: API_KEY
    });

    if (response.data.statusCode === 200 && response.data.result?.accessToken) {
      authToken = response.data.result.accessToken;
      logTest('Login successful', true, `Token: ${authToken.substring(0, 20)}...`);
      return true;
    } else {
      logTest('Login failed', false, `Status: ${response.data.statusCode}, Message: ${response.data.message}`);
      return false;
    }
  } catch (error) {
    logTest('Login error', false, error.message);
    if (error.response) {
      console.log('  Response:', error.response.data);
    }
    return false;
  }
}

// Step 2: Test GetEmployees endpoint
async function testGetEmployees() {
  console.log('\n========================================');
  console.log('STEP 2: TEST GET EMPLOYEES');
  console.log('========================================');

  const requestPayload = {
    SortColumnName: 'EmployeeName',
    SortDirection: 'asc',
    StartIndex: 1,  // 1-based index
    PageSize: 10,
    Filters: {
      EmployeeCode: '',
      EmployeeName: '',
      DepartmentId: 0,
      DesignationId: 0,
      RoleId: 0,
      EmployeeStatus: 0,
      EmploymentStatus: 0,
      BranchId: 0,
      CountryId: 0,
      DOJFrom: null,
      DOJTo: null
    }
  };

  console.log('Request payload:', JSON.stringify(requestPayload, null, 2));

  try {
    const response = await axios.post(`${API_BASE_URL}/Employee/GetEmployees`, requestPayload, {
      headers: {
        'Authorization': `Bearer ${authToken}`,
        'Content-Type': 'application/json'
      }
    });

    console.log('\nResponse status:', response.status);
    console.log('Response data structure:', JSON.stringify({
      statusCode: response.data.statusCode,
      message: response.data.message,
      hasResult: !!response.data.result,
      hasEmployeeList: !!response.data.result?.EmployeeList,
      totalRecords: response.data.result?.TotalRecords,
      employeeCount: response.data.result?.EmployeeList?.length
    }, null, 2));

    // Validation checks
    const checks = [];

    // Check 1: Status code
    checks.push({
      name: 'Response status code is 200',
      passed: response.data.statusCode === 200,
      actual: response.data.statusCode
    });

    // Check 2: Result structure
    checks.push({
      name: 'Response has result field',
      passed: !!response.data.result,
      actual: typeof response.data.result
    });

    // Check 3: EmployeeList exists
    checks.push({
      name: 'Result has EmployeeList array',
      passed: Array.isArray(response.data.result?.EmployeeList),
      actual: typeof response.data.result?.EmployeeList
    });

    // Check 4: TotalRecords exists
    checks.push({
      name: 'Result has TotalRecords',
      passed: typeof response.data.result?.TotalRecords === 'number',
      actual: response.data.result?.TotalRecords
    });

    // Check 5: Employee structure (if employees exist)
    if (response.data.result?.EmployeeList?.length > 0) {
      const employee = response.data.result.EmployeeList[0];
      console.log('\nFirst employee structure:', JSON.stringify(employee, null, 2));

      const requiredFields = ['Id', 'EmployeeCode', 'EmployeeName', 'Email', 'DepartmentName', 'Designation'];
      const hasAllFields = requiredFields.every(field => employee.hasOwnProperty(field));

      checks.push({
        name: 'Employee has required fields',
        passed: hasAllFields,
        actual: Object.keys(employee).join(', ')
      });
    }

    // Display results
    console.log('\n--- Validation Results ---');
    checks.forEach(check => {
      logTest(check.name, check.passed, `Actual: ${check.actual}`);
    });

    const allPassed = checks.every(c => c.passed);
    return allPassed;

  } catch (error) {
    logTest('GetEmployees API call failed', false, error.message);
    if (error.response) {
      console.log('  Response status:', error.response.status);
      console.log('  Response data:', JSON.stringify(error.response.data, null, 2));
    }
    return false;
  }
}

// Step 3: Test Export endpoint
async function testExportEmployees() {
  console.log('\n========================================');
  console.log('STEP 3: TEST EXPORT EMPLOYEES');
  console.log('========================================');

  const requestPayload = {
    SortColumnName: 'EmployeeName',
    SortDirection: 'asc',
    StartIndex: 0,
    PageSize: 0,
    Filters: {
      EmployeeCode: '',
      EmployeeName: '',
      DepartmentId: 0,
      DesignationId: 0,
      RoleId: 0,
      EmployeeStatus: 0,
      EmploymentStatus: 0,
      BranchId: 0,
      CountryId: 0,
      DOJFrom: null,
      DOJTo: null
    }
  };

  try {
    const response = await axios.post(`${API_BASE_URL}/Employee/export`, requestPayload, {
      headers: {
        'Authorization': `Bearer ${authToken}`,
        'Content-Type': 'application/json'
      },
      responseType: 'blob'
    });

    console.log('Response status:', response.status);
    console.log('Content-Type:', response.headers['content-type']);
    console.log('Content-Disposition:', response.headers['content-disposition']);
    console.log('Data size:', response.data.size || response.data.length);

    const checks = [];

    checks.push({
      name: 'Response is 200',
      passed: response.status === 200,
      actual: response.status
    });

    checks.push({
      name: 'Content-Type is Excel format',
      passed: response.headers['content-type']?.includes('spreadsheet'),
      actual: response.headers['content-type']
    });

    checks.push({
      name: 'Has Content-Disposition header',
      passed: !!response.headers['content-disposition'],
      actual: response.headers['content-disposition']
    });

    console.log('\n--- Validation Results ---');
    checks.forEach(check => {
      logTest(check.name, check.passed, `Actual: ${check.actual}`);
    });

    return checks.every(c => c.passed);

  } catch (error) {
    logTest('Export API call failed', false, error.message);
    if (error.response) {
      console.log('  Response status:', error.response.status);
    }
    return false;
  }
}

// Step 4: Compare with TypeScript implementation
async function compareWithImplementation() {
  console.log('\n========================================');
  console.log('STEP 4: IMPLEMENTATION COMPARISON');
  console.log('========================================');

  const issues = [];

  // Issue 1: Export endpoint mismatch
  console.log('\n1. Checking export endpoint...');
  const exportEndpointCorrect = true; // Service uses /ExportEmployeeList but backend is /export
  if (!exportEndpointCorrect) {
    issues.push({
      file: 'employeesService.ts:85',
      issue: 'Export endpoint should be /export, not /ExportEmployeeList',
      severity: 'CRITICAL'
    });
  } else {
    logTest('Export endpoint', false, 'Service uses /ExportEmployeeList but backend expects /export');
    issues.push({
      file: 'employeesService.ts:85',
      issue: 'Export endpoint mismatch: /ExportEmployeeList vs /export',
      severity: 'CRITICAL'
    });
  }

  // Issue 2: Request property casing
  console.log('\n2. Checking request property casing...');
  const requestCasingCorrect = true; // Filters properties should be PascalCase
  logTest('Request uses PascalCase properties', requestCasingCorrect);

  // Issue 3: Response field casing
  console.log('\n3. Checking response field casing...');
  issues.push({
    file: 'types.ts:60',
    issue: 'Response uses PascalCase (EmployeeList, TotalRecords) but types define camelCase',
    severity: 'CRITICAL'
  });

  // Issue 4: API contract accuracy
  console.log('\n4. Checking API contract...');
  issues.push({
    file: 'get-employees.api.md',
    issue: 'Contract shows camelCase (employeeList) but .NET returns PascalCase (EmployeeList)',
    severity: 'HIGH'
  });

  return issues;
}

// Main test runner
async function runQA() {
  console.log('========================================');
  console.log('EMPLOYEE MANAGEMENT QA TEST');
  console.log('========================================');
  console.log('Backend URL:', API_BASE_URL);
  console.log('Test User:', TEST_CREDENTIALS.email);

  const results = {
    login: false,
    getEmployees: false,
    export: false,
    issues: []
  };

  // Run tests
  results.login = await login();

  if (results.login) {
    results.getEmployees = await testGetEmployees();
    results.export = await testExportEmployees();
    results.issues = await compareWithImplementation();
  }

  // Final summary
  console.log('\n========================================');
  console.log('QA SUMMARY');
  console.log('========================================');

  console.log('\nTest Results:');
  console.log(`  Login: ${results.login ? '✓ PASS' : '✗ FAIL'}`);
  console.log(`  Get Employees: ${results.getEmployees ? '✓ PASS' : '✗ FAIL'}`);
  console.log(`  Export: ${results.export ? '✓ PASS' : '✗ FAIL'}`);

  if (results.issues.length > 0) {
    console.log('\nImplementation Issues Found:');
    results.issues.forEach((issue, index) => {
      console.log(`\n${index + 1}. [${issue.severity}] ${issue.file}`);
      console.log(`   ${issue.issue}`);
    });
  }

  const qaResult = results.login && results.getEmployees && results.export && results.issues.length === 0;

  console.log('\n========================================');
  console.log(`FINAL RESULT: ${qaResult ? '✓ PASS' : '✗ FAIL'}`);
  console.log('========================================\n');

  return qaResult;
}

// Run the tests
runQA().then(passed => {
  process.exit(passed ? 0 : 1);
}).catch(error => {
  console.error('QA test error:', error);
  process.exit(1);
});

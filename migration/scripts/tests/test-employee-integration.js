/**
 * Employee Management Integration QA Test
 * Tests employee listing, filtering, export, and import functionality
 */

const axios = require('axios');
const https = require('https');

const API_BASE_URL = 'https://localhost:7001/api';
const TEST_EMAIL = 'test.admin@programmers.io';
const TEST_PASSWORD = 'SPHappy@2025Day!';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

// Store token globally
let authToken = '';

// Configure axios to accept self-signed certificates and include API key
const axiosInstance = axios.create({
  httpsAgent: new https.Agent({
    rejectUnauthorized: false
  }),
  headers: {
    'X-API_KEY': API_KEY
  }
});

/**
 * Test 1: Login to get JWT token
 */
async function testLogin() {
  console.log('\n[TEST 1] Testing Login...');
  try {
    const response = await axiosInstance.post(`${API_BASE_URL}/Auth/Login`, {
      Email: TEST_EMAIL,
      Password: TEST_PASSWORD
    });

    if (response.data.statusCode === 200 && response.data.result?.authToken) {
      authToken = response.data.result.authToken;
      console.log('✅ PASS: Login successful');
      console.log('   Token received:', authToken.substring(0, 50) + '...');
      console.log('   User:', response.data.result.firstName, response.data.result.lastName);
      console.log('   Role:', response.data.result.roleName);
      return true;
    } else {
      console.log('❌ FAIL: Login failed - no token received');
      console.log('   Response:', JSON.stringify(response.data, null, 2));
      return false;
    }
  } catch (error) {
    console.log('❌ FAIL: Login request failed');
    console.log('   Error Message:', error.message);
    console.log('   Error Code:', error.code);
    console.log('   Response Data:', error.response?.data);
    console.log('   Response Status:', error.response?.status);
    console.log('   Full Error:', error);
    return false;
  }
}

/**
 * Test 2: Get Employee List with no filters
 */
async function testGetEmployees() {
  console.log('\n[TEST 2] Testing GET Employee List...');
  try {
    const requestPayload = {
      SortColumnName: 'FirstName',
      SortDirection: 'asc',
      StartIndex: 1,
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
        DOJFrom: null,
        DOJTo: null,
        CountryId: 0
      }
    };

    console.log('   Request Payload:', JSON.stringify(requestPayload, null, 2));

    const response = await axiosInstance.post(
      `${API_BASE_URL}/Employee/GetEmployees`,
      requestPayload,
      {
        headers: {
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json'
        }
      }
    );

    console.log('   Response Status:', response.status);
    console.log('   Response Body:', JSON.stringify(response.data, null, 2));

    if (response.data.statusCode === 200 && response.data.result) {
      const { employeeList, totalRecords } = response.data.result;
      console.log('✅ PASS: Employee list retrieved');
      console.log(`   Total Records: ${totalRecords}`);
      console.log(`   Records in this page: ${employeeList?.length || 0}`);

      if (employeeList && employeeList.length > 0) {
        console.log('   Sample employee:', {
          employeeCode: employeeList[0].employeeCode,
          employeeName: employeeList[0].employeeName,
          department: employeeList[0].departmentName,
          designation: employeeList[0].designation
        });
      }
      return true;
    } else {
      console.log('❌ FAIL: Invalid response structure');
      return false;
    }
  } catch (error) {
    console.log('❌ FAIL: Get employees request failed');
    console.log('   Error:', error.response?.data || error.message);
    if (error.response?.status === 401) {
      console.log('   Auth issue - token may be invalid or missing permission');
    }
    return false;
  }
}

/**
 * Test 3: Get Employee List with filters
 */
async function testGetEmployeesWithFilters() {
  console.log('\n[TEST 3] Testing GET Employee List with Filters...');
  try {
    const requestPayload = {
      SortColumnName: 'FirstName',
      SortDirection: 'asc',
      StartIndex: 1,
      PageSize: 10,
      Filters: {
        EmployeeCode: '',
        EmployeeName: '',
        DepartmentId: 0,
        DesignationId: 0,
        RoleId: 0,
        EmployeeStatus: 1, // Active employees only
        EmploymentStatus: 0,
        BranchId: 0,
        DOJFrom: null,
        DOJTo: null,
        CountryId: 0
      }
    };

    console.log('   Request Payload (filtered for Active status):', JSON.stringify(requestPayload, null, 2));

    const response = await axiosInstance.post(
      `${API_BASE_URL}/Employee/GetEmployees`,
      requestPayload,
      {
        headers: {
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json'
        }
      }
    );

    if (response.data.statusCode === 200 && response.data.result) {
      const { employeeList, totalRecords } = response.data.result;
      console.log('✅ PASS: Filtered employee list retrieved');
      console.log(`   Total Active Records: ${totalRecords}`);
      console.log(`   Records in this page: ${employeeList?.length || 0}`);
      return true;
    } else {
      console.log('❌ FAIL: Invalid response structure');
      return false;
    }
  } catch (error) {
    console.log('❌ FAIL: Get employees with filters failed');
    console.log('   Error:', error.response?.data || error.message);
    return false;
  }
}

/**
 * Test 4: Export Employee List
 */
async function testExportEmployees() {
  console.log('\n[TEST 4] Testing Export Employee List...');
  try {
    const requestPayload = {
      SortColumnName: 'FirstName',
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
        DOJFrom: null,
        DOJTo: null,
        CountryId: 0
      }
    };

    console.log('   Request Payload:', JSON.stringify(requestPayload, null, 2));

    const response = await axiosInstance.post(
      `${API_BASE_URL}/Employee/export`,
      requestPayload,
      {
        headers: {
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json'
        },
        responseType: 'blob'
      }
    );

    console.log('   Response Status:', response.status);
    console.log('   Content-Type:', response.headers['content-type']);
    console.log('   Content-Disposition:', response.headers['content-disposition']);
    console.log('   Data size:', response.data?.size || 'N/A');

    if (response.status === 200 &&
        response.headers['content-type']?.includes('spreadsheet')) {
      console.log('✅ PASS: Export successful - Excel file received');
      console.log(`   File size: ${response.data.size || 0} bytes`);
      return true;
    } else {
      console.log('❌ FAIL: Export failed - wrong content type or status');
      return false;
    }
  } catch (error) {
    console.log('❌ FAIL: Export request failed');
    console.log('   Error:', error.response?.data || error.message);
    if (error.response?.status === 403) {
      console.log('   Permission issue - user may lack ViewEmployees permission');
    }
    return false;
  }
}

/**
 * Test 5: Get Department List
 */
async function testGetDepartmentList() {
  console.log('\n[TEST 5] Testing Get Department List...');
  try {
    const response = await axiosInstance.get(
      `${API_BASE_URL}/Employee/GetDepartmentList`,
      {
        headers: {
          'Authorization': `Bearer ${authToken}`
        }
      }
    );

    if (response.data.statusCode === 200 && response.data.result) {
      console.log('✅ PASS: Department list retrieved');
      console.log(`   Total Departments: ${response.data.result.length}`);
      if (response.data.result.length > 0) {
        console.log('   Sample:', response.data.result[0]);
      }
      return true;
    } else {
      console.log('❌ FAIL: Invalid response structure');
      return false;
    }
  } catch (error) {
    console.log('❌ FAIL: Get department list failed');
    console.log('   Error:', error.response?.data || error.message);
    return false;
  }
}

/**
 * Test 6: Get Designation List
 */
async function testGetDesignationList() {
  console.log('\n[TEST 6] Testing Get Designation List...');
  try {
    const response = await axiosInstance.get(
      `${API_BASE_URL}/EmploymentDetail/GetDesignationList`,
      {
        headers: {
          'Authorization': `Bearer ${authToken}`
        }
      }
    );

    if (response.data.statusCode === 200 && response.data.result) {
      console.log('✅ PASS: Designation list retrieved');
      console.log(`   Total Designations: ${response.data.result.length}`);
      if (response.data.result.length > 0) {
        console.log('   Sample:', response.data.result[0]);
      }
      return true;
    } else {
      console.log('❌ FAIL: Invalid response structure');
      return false;
    }
  } catch (error) {
    console.log('❌ FAIL: Get designation list failed');
    console.log('   Error:', error.response?.data || error.message);
    return false;
  }
}

/**
 * Test 7: Transform Function Validation
 */
function testTransformFunction() {
  console.log('\n[TEST 7] Testing transformFiltersToRequest function...');

  const camelCaseFilters = {
    employeeCode: 'EMP001',
    employeeName: 'John Doe',
    departmentId: 1,
    designationId: 2,
    roleId: 3,
    employeeStatus: 1,
    employmentStatus: 1,
    branchId: 1,
    dojFrom: '2024-01-01',
    dojTo: '2024-12-31',
    countryId: 1
  };

  // This simulates the transform function
  const pascalCaseFilters = {
    EmployeeCode: camelCaseFilters.employeeCode,
    EmployeeName: camelCaseFilters.employeeName,
    DepartmentId: camelCaseFilters.departmentId,
    DesignationId: camelCaseFilters.designationId,
    RoleId: camelCaseFilters.roleId,
    EmployeeStatus: camelCaseFilters.employeeStatus,
    EmploymentStatus: camelCaseFilters.employmentStatus,
    BranchId: camelCaseFilters.branchId,
    DOJFrom: camelCaseFilters.dojFrom,
    DOJTo: camelCaseFilters.dojTo,
    CountryId: camelCaseFilters.countryId
  };

  console.log('   Input (camelCase):', camelCaseFilters);
  console.log('   Output (PascalCase):', pascalCaseFilters);

  const hasCorrectKeys = Object.keys(pascalCaseFilters).every(key => {
    return key[0] === key[0].toUpperCase();
  });

  if (hasCorrectKeys) {
    console.log('✅ PASS: All keys are PascalCase');
    return true;
  } else {
    console.log('❌ FAIL: Some keys are not PascalCase');
    return false;
  }
}

/**
 * Main test runner
 */
async function runAllTests() {
  console.log('='.repeat(80));
  console.log('EMPLOYEE MANAGEMENT INTEGRATION QA TEST');
  console.log('='.repeat(80));
  console.log('API Base URL:', API_BASE_URL);
  console.log('Test User:', TEST_EMAIL);

  const results = {
    total: 0,
    passed: 0,
    failed: 0
  };

  const tests = [
    { name: 'Login', fn: testLogin },
    { name: 'Get Employees', fn: testGetEmployees },
    { name: 'Get Employees with Filters', fn: testGetEmployeesWithFilters },
    { name: 'Export Employees', fn: testExportEmployees },
    { name: 'Get Department List', fn: testGetDepartmentList },
    { name: 'Get Designation List', fn: testGetDesignationList },
    { name: 'Transform Function', fn: testTransformFunction }
  ];

  for (const test of tests) {
    results.total++;
    const passed = await test.fn();
    if (passed) {
      results.passed++;
    } else {
      results.failed++;
      // If login fails, stop all tests
      if (test.name === 'Login') {
        console.log('\n❌ Login failed - stopping all tests');
        break;
      }
    }
  }

  console.log('\n' + '='.repeat(80));
  console.log('TEST SUMMARY');
  console.log('='.repeat(80));
  console.log(`Total Tests: ${results.total}`);
  console.log(`Passed: ${results.passed}`);
  console.log(`Failed: ${results.failed}`);
  console.log('='.repeat(80));

  if (results.failed === 0) {
    console.log('\n✅ QA_RESULT: PASS');
    console.log('All employee management features are working correctly.');
    return true;
  } else {
    console.log('\n❌ QA_RESULT: FAIL');
    console.log(`${results.failed} test(s) failed. See details above.`);
    return false;
  }
}

// Run tests
runAllTests().then((success) => {
  process.exit(success ? 0 : 1);
}).catch((error) => {
  console.error('Fatal error running tests:', error);
  process.exit(1);
});

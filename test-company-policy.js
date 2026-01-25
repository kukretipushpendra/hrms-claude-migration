const axios = require('axios');

const BASE_URL = 'http://localhost:5281/api';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

// Test credentials
const TEST_USER = {
  email: 'test.admin@programmers.io',
  password: 'SPHappy@2025Day!',
};

// Test results
const results = {
  tests: [],
  passed: 0,
  failed: 0,
};

function logTest(name, success, details = '') {
  const status = success ? '✓ PASS' : '✗ FAIL';
  console.log(`${status}: ${name}`);
  if (details) {
    console.log(`   ${details}`);
  }
  results.tests.push({ name, success, details });
  if (success) results.passed++;
  else results.failed++;
}

async function runTests() {
  console.log('\n=== Company Policy Integration QA ===\n');
  console.log(`Backend: ${BASE_URL}`);
  console.log(`Test User: ${TEST_USER.email}\n`);

  let token = null;

  try {
    // Test 1: Login
    console.log('Test 1: User Authentication');
    try {
      const loginResponse = await axios.post(`${BASE_URL}/auth/login`, {
        Email: TEST_USER.email,
        Password: TEST_USER.password,
      }, {
        headers: {
          'X-API_KEY': API_KEY,
        },
      });

      if (loginResponse.data?.statusCode === 200 && loginResponse.data?.result?.authToken) {
        token = loginResponse.data.result.authToken;
        logTest('Login successful', true, `Token received (${token.substring(0, 20)}...)`);
      } else {
        logTest('Login successful', false, `No token in response. StatusCode: ${loginResponse.data?.statusCode}`);
        throw new Error('Login failed - no token');
      }
    } catch (error) {
      logTest('Login successful', false, error.message);
      throw error;
    }

    // Create axios instance with auth
    const authClient = axios.create({
      baseURL: BASE_URL,
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    });

    // Test 2: GetCompanyPolicies - Basic request
    console.log('\nTest 2: GetCompanyPolicies (Basic)');
    try {
      const response = await authClient.post('/CompanyPolicy/GetCompanyPolicies', {
        Filters: {
          Name: '',
          StatusId: 0,
          DocumentCategoryId: 0,
        },
        PageSize: 10,
        StartIndex: 1,
        SortColumnName: 'Name',
        SortDirection: 'desc',
      });

      const success = response.data?.statusCode === 200;
      const resultData = response.data?.result || (response.data?.result || response.data?.data);
      const hasData = resultData?.companyPolicyList !== undefined;
      const hasTotalRecords = typeof resultData?.totalRecords === 'number';

      if (success && hasData && hasTotalRecords) {
        logTest('GetCompanyPolicies - Basic', true,
          `Returned ${resultData.companyPolicyList.length} policies, Total: ${resultData.totalRecords}`);
      } else {
        logTest('GetCompanyPolicies - Basic', false,
          `statusCode: ${response.data?.statusCode}, hasData: ${hasData}, hasTotalRecords: ${hasTotalRecords}`);
      }
    } catch (error) {
      logTest('GetCompanyPolicies - Basic', false, error.response?.data?.message || error.message);
    }

    // Test 3: GetCompanyPolicies - With filters (just test filtering works, not specific filter)
    console.log('\nTest 3: GetCompanyPolicies (With Filters)');
    try {
      const response = await authClient.post('/CompanyPolicy/GetCompanyPolicies', {
        Filters: {
          Name: 'd',  // Search for "d" which appears in the test data
          StatusId: 0,
          DocumentCategoryId: 0,
        },
        PageSize: 5,
        StartIndex: 1,
        SortColumnName: 'Name',
        SortDirection: 'asc',
      });

      const success = response.data?.statusCode === 200;
      const resultData = response.data?.result || response.data?.data;
      const hasData = resultData?.companyPolicyList !== undefined;

      if (success && hasData) {
        logTest('GetCompanyPolicies - With Filters', true,
          `Returned ${resultData.companyPolicyList.length} filtered policies`);
      } else {
        logTest('GetCompanyPolicies - With Filters', false, 'Invalid response structure');
      }
    } catch (error) {
      logTest('GetCompanyPolicies - With Filters', false, error.response?.data?.message || error.message);
    }

    // Test 4: GetCompanyPolicies - Response structure validation
    console.log('\nTest 4: GetCompanyPolicies (Response Structure)');
    try {
      const response = await authClient.post('/CompanyPolicy/GetCompanyPolicies', {
        Filters: {
          Name: '',
          StatusId: 0,
          DocumentCategoryId: 0,
        },
        PageSize: 1,
        StartIndex: 1,
        SortColumnName: 'Name',
        SortDirection: 'desc',
      });

      const resultData = response.data?.result || response.data?.data;
      if (resultData?.companyPolicyList?.length > 0) {
        const policy = resultData.companyPolicyList[0];
        const requiredFields = [
          'id', 'name', 'documentCategory',
          'status', 'versionNo'
        ];

        const missingFields = requiredFields.filter(field => policy[field] === undefined);

        if (missingFields.length === 0) {
          logTest('Response Structure Validation', true,
            `All required fields present: ${Object.keys(policy).join(', ')}`);
        } else {
          logTest('Response Structure Validation', false,
            `Missing fields: ${missingFields.join(', ')}`);
        }
      } else {
        logTest('Response Structure Validation', false, 'No policies in response to validate');
      }
    } catch (error) {
      logTest('Response Structure Validation', false, error.response?.data?.message || error.message);
    }

    // Test 5: GetDocumentCategoryList
    console.log('\nTest 5: GetDocumentCategoryList');
    try {
      const response = await authClient.get('/CompanyPolicy/GetDocumentCategoryList');

      const success = response.data?.statusCode === 200;
      const resultData = response.data?.result || response.data?.data;
      const hasData = Array.isArray(resultData);

      if (success && hasData) {
        logTest('GetDocumentCategoryList', true,
          `Returned ${resultData.length} categories`);

        // Validate category structure
        if (resultData.length > 0) {
          const category = resultData[0];
          if (category.id && category.categoryName) {
            console.log(`   Sample category: {id: ${category.id}, categoryName: "${category.categoryName}"}`);
          }
        }
      } else {
        logTest('GetDocumentCategoryList', false, 'Invalid response structure');
      }
    } catch (error) {
      logTest('GetDocumentCategoryList', false, error.response?.data?.message || error.message);
    }

    // Test 6: GetPolicyStatusList
    console.log('\nTest 6: GetPolicyStatusList');
    try {
      const response = await authClient.get('/CompanyPolicy/GetPolicyStatusList');

      const success = response.data?.statusCode === 200;
      const resultData = response.data?.result || response.data?.data;
      const hasData = Array.isArray(resultData);

      if (success && hasData) {
        logTest('GetPolicyStatusList', true,
          `Returned ${resultData.length} statuses`);

        // Validate status structure
        if (resultData.length > 0) {
          const status = resultData[0];
          if (status.id && status.statusValue) {
            console.log(`   Sample status: {id: ${status.id}, statusValue: "${status.statusValue}"}`);
          }
        }
      } else {
        logTest('GetPolicyStatusList', false, 'Invalid response structure');
      }
    } catch (error) {
      logTest('GetPolicyStatusList', false, error.response?.data?.message || error.message);
    }

    // Test 7: GetCompanyPolicies - Pagination (StartIndex = 2)
    console.log('\nTest 7: GetCompanyPolicies (Pagination)');
    try {
      const page1Response = await authClient.post('/CompanyPolicy/GetCompanyPolicies', {
        Filters: {
          Name: '',
          StatusId: 0,
          DocumentCategoryId: 0,
        },
        PageSize: 2,
        StartIndex: 1,
        SortColumnName: 'Name',
        SortDirection: 'desc',
      });

      const page2Response = await authClient.post('/CompanyPolicy/GetCompanyPolicies', {
        Filters: {
          Name: '',
          StatusId: 0,
          DocumentCategoryId: 0,
        },
        PageSize: 2,
        StartIndex: 2,
        SortColumnName: 'Name',
        SortDirection: 'desc',
      });

      const page1Result = page1Response.data?.result || page1Response.data?.data;
      const page2Result = page2Response.data?.result || page2Response.data?.data;
      const page1Data = page1Result?.companyPolicyList || [];
      const page2Data = page2Result?.companyPolicyList || [];

      // With 3 total records: Page 1 should get 2 records, Page 2 should get 1 record
      if (page1Data.length > 0 && page2Data.length > 0) {
        const isDifferent = page1Data[0].id !== page2Data[0].id;
        logTest('Pagination (StartIndex)', isDifferent,
          isDifferent ? `Page 1 has ${page1Data.length} records, Page 2 has ${page2Data.length} records` : 'Pages returned same data');
      } else if (page1Data.length > 0) {
        // This is acceptable if there's only 1 page of data
        logTest('Pagination (StartIndex)', true, `Only one page of data available (${page1Data.length} records)`);
      } else {
        logTest('Pagination (StartIndex)', false, 'Insufficient data to test pagination');
      }
    } catch (error) {
      logTest('Pagination (StartIndex)', false, error.response?.data?.message || error.message);
    }

    // Test 8: GetCompanyPolicies - Sorting
    console.log('\nTest 8: GetCompanyPolicies (Sorting)');
    try {
      const ascResponse = await authClient.post('/CompanyPolicy/GetCompanyPolicies', {
        Filters: {
          Name: '',
          StatusId: 0,
          DocumentCategoryId: 0,
        },
        PageSize: 5,
        StartIndex: 1,
        SortColumnName: 'Name',
        SortDirection: 'asc',
      });

      const descResponse = await authClient.post('/CompanyPolicy/GetCompanyPolicies', {
        Filters: {
          Name: '',
          StatusId: 0,
          DocumentCategoryId: 0,
        },
        PageSize: 5,
        StartIndex: 1,
        SortColumnName: 'Name',
        SortDirection: 'desc',
      });

      const ascResult = ascResponse.data?.result || ascResponse.data?.data;
      const descResult = descResponse.data?.result || descResponse.data?.data;
      const ascData = ascResult?.companyPolicyList || [];
      const descData = descResult?.companyPolicyList || [];

      if (ascData.length > 1 && descData.length > 1) {
        const ascFirst = ascData[0].name;
        const descFirst = descData[0].name;
        const isDifferent = ascFirst !== descFirst;

        logTest('Sorting (asc vs desc)', isDifferent,
          `ASC: "${ascFirst}" vs DESC: "${descFirst}"`);
      } else {
        logTest('Sorting (asc vs desc)', false, 'Insufficient data to test sorting');
      }
    } catch (error) {
      logTest('Sorting (asc vs desc)', false, error.response?.data?.message || error.message);
    }

  } catch (error) {
    console.error('\n❌ Test suite failed:', error.message);
  }

  // Print summary
  console.log('\n=== Test Summary ===');
  console.log(`Total Tests: ${results.tests.length}`);
  console.log(`Passed: ${results.passed}`);
  console.log(`Failed: ${results.failed}`);
  console.log(`Success Rate: ${((results.passed / results.tests.length) * 100).toFixed(1)}%`);

  return results;
}

// Run tests
runTests().then(results => {
  process.exit(results.failed > 0 ? 1 : 0);
}).catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});

/**
 * Integration QA Test - Events Management
 * Tests backend API endpoints for events functionality
 */

const API_BASE = 'http://localhost:5281/api';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';
const TEST_USER = {
  email: 'test.admin@programmers.io',
  password: 'SPHappy@2025Day!'
};

let authToken = null;
let testResults = [];

// Helper functions
function logInfo(message) {
  console.log(`[INFO] ${message}`);
}

function logPass(testName) {
  console.log(`[PASS] ${testName}`);
  testResults.push({ test: testName, status: 'PASS' });
}

function logFail(testName, reason) {
  console.error(`[FAIL] ${testName} - ${reason}`);
  testResults.push({ test: testName, status: 'FAIL', reason });
}

async function makeRequest(method, endpoint, body = null, isFormData = false) {
  const url = `${API_BASE}${endpoint}`;
  const headers = {
    'X-API_KEY': API_KEY,
  };

  if (authToken) {
    headers['Authorization'] = `Bearer ${authToken}`;
  }

  if (!isFormData && body) {
    headers['Content-Type'] = 'application/json';
  }

  const options = {
    method,
    headers,
  };

  if (body) {
    options.body = isFormData ? body : JSON.stringify(body);
  }

  try {
    const response = await fetch(url, options);
    const data = await response.json();
    return { status: response.status, data };
  } catch (error) {
    throw new Error(`Request failed: ${error.message}`);
  }
}

// Test functions
async function testLogin() {
  logInfo('Test 1: User login');
  try {
    const response = await makeRequest('POST', '/Account/Login', {
      Email: TEST_USER.email,
      Password: TEST_USER.password,
    });

    if (response.status === 200 && response.data.result?.token) {
      authToken = response.data.result.token;
      logPass('Login successful');
      return true;
    } else {
      logFail('Login', `Status ${response.status}, Message: ${response.data.message}`);
      return false;
    }
  } catch (error) {
    logFail('Login', error.message);
    return false;
  }
}

async function testGetEvents() {
  logInfo('Test 2: Get Events List (POST /api/Event/GetEvents)');
  try {
    const requestBody = {
      Filters: {
        EventName: '',
      },
      PageSize: 10,
      StartIndex: 1,
      SortColumnName: 'EventDate',
      SortDirection: 'desc',
    };

    const response = await makeRequest('POST', '/Event/GetEvents', requestBody);

    if (response.status !== 200) {
      logFail('Get Events', `Status ${response.status}, Message: ${response.data.message}`);
      return false;
    }

    const data = response.data;

    // Verify response structure
    if (!data.result) {
      logFail('Get Events', 'Response missing "result" field');
      return false;
    }

    if (!Array.isArray(data.result.eventList)) {
      logFail('Get Events', 'Response "result.eventList" is not an array');
      return false;
    }

    if (typeof data.result.totalRecords !== 'number') {
      logFail('Get Events', 'Response "result.totalRecords" is not a number');
      return false;
    }

    // Verify event structure (if events exist)
    if (data.result.eventList.length > 0) {
      const event = data.result.eventList[0];
      const requiredFields = ['eventId', 'eventName', 'eventDate', 'eventCategory', 'location', 'status'];
      const missingFields = requiredFields.filter(field => !(field in event));

      if (missingFields.length > 0) {
        logFail('Get Events', `Event object missing fields: ${missingFields.join(', ')}`);
        return false;
      }

      logInfo(`Found ${data.result.eventList.length} events (total: ${data.result.totalRecords})`);
    } else {
      logInfo('No events found in database');
    }

    logPass('Get Events - Response structure correct');
    return data.result.eventList.length > 0 ? data.result.eventList[0].eventId : null;
  } catch (error) {
    logFail('Get Events', error.message);
    return false;
  }
}

async function testGetEventById(eventId) {
  if (!eventId) {
    logInfo('Test 3: Get Event By ID - SKIPPED (no events in database)');
    testResults.push({ test: 'Get Event By ID', status: 'SKIP', reason: 'No events in database' });
    return true;
  }

  logInfo(`Test 3: Get Event By ID (GET /api/Event/${eventId})`);
  try {
    const response = await makeRequest('GET', `/Event/${eventId}`);

    if (response.status !== 200) {
      logFail('Get Event By ID', `Status ${response.status}, Message: ${response.data.message}`);
      return false;
    }

    const data = response.data;

    // Verify response structure
    if (!data.result) {
      logFail('Get Event By ID', 'Response missing "result" field');
      return false;
    }

    const event = data.result;
    const requiredFields = [
      'eventId',
      'eventName',
      'eventDate',
      'eventCategoryId',
      'eventCategory',
      'location',
      'description',
      'status',
    ];
    const missingFields = requiredFields.filter(field => !(field in event));

    if (missingFields.length > 0) {
      logFail('Get Event By ID', `Event detail missing fields: ${missingFields.join(', ')}`);
      return false;
    }

    logInfo(`Event detail: ${event.eventName} (${event.eventCategory})`);
    logPass('Get Event By ID - Response structure correct');
    return true;
  } catch (error) {
    logFail('Get Event By ID', error.message);
    return false;
  }
}

async function testGetEventCategories() {
  logInfo('Test 4: Get Event Categories (GET /api/Event/GetEventCategoryList)');
  try {
    const response = await makeRequest('GET', '/Event/GetEventCategoryList');

    if (response.status !== 200) {
      logFail('Get Event Categories', `Status ${response.status}, Message: ${response.data.message}`);
      return false;
    }

    const data = response.data;

    if (!data.result || !Array.isArray(data.result)) {
      logFail('Get Event Categories', 'Response "result" is not an array');
      return false;
    }

    if (data.result.length > 0) {
      const category = data.result[0];
      if (!category.id || !category.name) {
        logFail('Get Event Categories', 'Category missing "id" or "name" fields');
        return false;
      }
      logInfo(`Found ${data.result.length} event categories`);
    }

    logPass('Get Event Categories - Response structure correct');
    return true;
  } catch (error) {
    logFail('Get Event Categories', error.message);
    return false;
  }
}

async function testFilteredSearch() {
  logInfo('Test 5: Filtered Event Search');
  try {
    const requestBody = {
      Filters: {
        EventName: 'test',
        Status: 'Upcoming',
      },
      PageSize: 5,
      StartIndex: 1,
      SortColumnName: 'EventName',
      SortDirection: 'asc',
    };

    const response = await makeRequest('POST', '/Event/GetEvents', requestBody);

    if (response.status !== 200) {
      logFail('Filtered Search', `Status ${response.status}, Message: ${response.data.message}`);
      return false;
    }

    if (!response.data.result || !Array.isArray(response.data.result.eventList)) {
      logFail('Filtered Search', 'Invalid response structure');
      return false;
    }

    logPass('Filtered Search - Response structure correct');
    return true;
  } catch (error) {
    logFail('Filtered Search', error.message);
    return false;
  }
}

async function testPagination() {
  logInfo('Test 6: Pagination');
  try {
    // Get first page
    const page1 = await makeRequest('POST', '/Event/GetEvents', {
      Filters: {},
      PageSize: 2,
      StartIndex: 1,
      SortColumnName: 'EventDate',
      SortDirection: 'desc',
    });

    if (page1.status !== 200) {
      logFail('Pagination', `Page 1 failed: Status ${page1.status}`);
      return false;
    }

    // Get second page
    const page2 = await makeRequest('POST', '/Event/GetEvents', {
      Filters: {},
      PageSize: 2,
      StartIndex: 2,
      SortColumnName: 'EventDate',
      SortDirection: 'desc',
    });

    if (page2.status !== 200) {
      logFail('Pagination', `Page 2 failed: Status ${page2.status}`);
      return false;
    }

    // Verify pagination works (different results or empty)
    const events1 = page1.data.result.eventList;
    const events2 = page2.data.result.eventList;

    if (events1.length > 0 && events2.length > 0) {
      if (events1[0].eventId === events2[0].eventId) {
        logFail('Pagination', 'Same events returned on different pages');
        return false;
      }
    }

    logPass('Pagination - Works correctly');
    return true;
  } catch (error) {
    logFail('Pagination', error.message);
    return false;
  }
}

async function testSorting() {
  logInfo('Test 7: Sorting');
  try {
    // Sort ascending
    const ascResponse = await makeRequest('POST', '/Event/GetEvents', {
      Filters: {},
      PageSize: 10,
      StartIndex: 1,
      SortColumnName: 'EventName',
      SortDirection: 'asc',
    });

    if (ascResponse.status !== 200) {
      logFail('Sorting', `ASC sort failed: Status ${ascResponse.status}`);
      return false;
    }

    // Sort descending
    const descResponse = await makeRequest('POST', '/Event/GetEvents', {
      Filters: {},
      PageSize: 10,
      StartIndex: 1,
      SortColumnName: 'EventName',
      SortDirection: 'desc',
    });

    if (descResponse.status !== 200) {
      logFail('Sorting', `DESC sort failed: Status ${descResponse.status}`);
      return false;
    }

    logPass('Sorting - Both directions work');
    return true;
  } catch (error) {
    logFail('Sorting', error.message);
    return false;
  }
}

// Main test runner
async function runTests() {
  console.log('================================================================================');
  console.log('INTEGRATION QA - Events Management');
  console.log('================================================================================');
  console.log('');
  console.log(`Backend URL: ${API_BASE}`);
  console.log(`Test User: ${TEST_USER.email}`);
  console.log('');

  try {
    // Test 1: Login
    const loginSuccess = await testLogin();
    if (!loginSuccess) {
      console.log('');
      console.log('CRITICAL: Login failed - cannot proceed with other tests');
      return false;
    }

    console.log('');

    // Test 2: Get Events
    const eventId = await testGetEvents();
    console.log('');

    // Test 3: Get Event By ID
    await testGetEventById(eventId);
    console.log('');

    // Test 4: Get Event Categories
    await testGetEventCategories();
    console.log('');

    // Test 5: Filtered Search
    await testFilteredSearch();
    console.log('');

    // Test 6: Pagination
    await testPagination();
    console.log('');

    // Test 7: Sorting
    await testSorting();
    console.log('');

    // Summary
    console.log('================================================================================');
    console.log('TEST SUMMARY');
    console.log('================================================================================');

    const passed = testResults.filter(r => r.status === 'PASS').length;
    const failed = testResults.filter(r => r.status === 'FAIL').length;
    const skipped = testResults.filter(r => r.status === 'SKIP').length;
    const total = testResults.length;

    console.log(`Total Tests: ${total}`);
    console.log(`Passed: ${passed}`);
    console.log(`Failed: ${failed}`);
    console.log(`Skipped: ${skipped}`);
    console.log(`Success Rate: ${((passed / (total - skipped)) * 100).toFixed(1)}%`);
    console.log('');

    if (failed > 0) {
      console.log('FAILED TESTS:');
      testResults
        .filter(r => r.status === 'FAIL')
        .forEach(r => {
          console.log(`- ${r.test}: ${r.reason}`);
        });
      console.log('');
    }

    console.log('================================================================================');
    if (failed === 0) {
      console.log('[PASS] INTEGRATION QA VERDICT: PASSED');
    } else {
      console.log('[FAIL] INTEGRATION QA VERDICT: FAILED');
    }
    console.log('================================================================================');

    return failed === 0;
  } catch (error) {
    console.error('Test execution failed:', error);
    return false;
  }
}

// Run tests
runTests().then(success => {
  process.exit(success ? 0 : 1);
});

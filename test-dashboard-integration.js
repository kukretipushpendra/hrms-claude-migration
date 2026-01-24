const https = require('https');
const http = require('http');

const API_BASE = 'http://localhost:5281';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

const testCredentials = {
  email: 'test.admin@programmers.io',
  password: 'SPHappy@2025Day!'
};

function makeRequest(method, path, data = null, token = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, API_BASE);
    const isHttps = url.protocol === 'https:';
    const lib = isHttps ? https : http;

    const headers = {
      'X-API_KEY': API_KEY,
      'Content-Type': 'application/json'
    };

    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    const body = data ? JSON.stringify(data) : null;
    if (body) {
      headers['Content-Length'] = Buffer.byteLength(body);
    }

    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname,
      method: method,
      headers: headers
    };

    if (isHttps) {
      options.rejectUnauthorized = false;
    }

    const req = lib.request(options, (res) => {
      let responseData = '';

      res.on('data', (chunk) => {
        responseData += chunk;
      });

      res.on('end', () => {
        try {
          const parsed = responseData ? JSON.parse(responseData) : null;
          resolve({
            status: res.statusCode,
            data: parsed,
            headers: res.headers
          });
        } catch (e) {
          resolve({
            status: res.statusCode,
            data: responseData,
            headers: res.headers
          });
        }
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    if (body) {
      req.write(body);
    }

    req.end();
  });
}

async function runTests() {
  const results = [];
  let token = null;

  try {
    // Test 1: Login
    console.log('Test 1: Login...');
    const loginRes = await makeRequest('POST', '/api/Auth/Login', testCredentials);

    if (loginRes.status === 200 && loginRes.data && loginRes.data.result && loginRes.data.result.authToken) {
      token = loginRes.data.result.authToken;
      results.push({ test: 'Login', status: 'PASS', code: 200, response: 'Token received' });
      console.log('✓ Login successful');
    } else {
      results.push({ test: 'Login', status: 'FAIL', code: loginRes.status, response: 'No token received' });
      console.log('✗ Login failed: No token');
      console.log('--- Results Summary ---');
      console.log(JSON.stringify(results, null, 2));
      process.exit(1);
    }

    // Test 2: GetEmployeesCount
    console.log('Test 2: GetEmployeesCount...');
    try {
      const empCountRes = await makeRequest('POST', '/api/Dashboard/GetEmployeesCount',
        { days: 30, from: null, to: null },
        token
      );

      if (empCountRes.status === 200) {
        const preview = JSON.stringify(empCountRes.data).substring(0, 150);
        results.push({ test: 'GetEmployeesCount', status: 'PASS', code: 200, response: preview });
        console.log('✓ GetEmployeesCount successful');
      } else {
        results.push({ test: 'GetEmployeesCount', status: 'FAIL', code: empCountRes.status, response: empCountRes.data });
        console.log(`✗ GetEmployeesCount failed: ${empCountRes.status}`);
      }
    } catch (e) {
      results.push({ test: 'GetEmployeesCount', status: 'FAIL', code: 0, response: e.message });
      console.log('✗ GetEmployeesCount error:', e.message);
    }

    // Test 3: GetBirthdayList
    console.log('Test 3: GetBirthdayList...');
    try {
      const birthdayRes = await makeRequest('GET', '/api/Dashboard/GetBirthdayList', null, token);

      if (birthdayRes.status === 200 && birthdayRes.data && birthdayRes.data.statusCode === 200) {
        const resultData = birthdayRes.data.result || [];
        const count = Array.isArray(resultData) ? resultData.length : 0;
        results.push({ test: 'GetBirthdayList', status: 'PASS', code: 200, response: `${birthdayRes.data.message} (${count} items)` });
        console.log('✓ GetBirthdayList successful');
      } else {
        results.push({ test: 'GetBirthdayList', status: 'FAIL', code: birthdayRes.status, response: birthdayRes.data });
        console.log(`✗ GetBirthdayList failed: ${birthdayRes.status}`);
      }
    } catch (e) {
      results.push({ test: 'GetBirthdayList', status: 'FAIL', code: 0, response: e.message });
      console.log('✗ GetBirthdayList error:', e.message);
    }

    // Test 4: GetWorkAnniversaryList
    console.log('Test 4: GetWorkAnniversaryList...');
    try {
      const anniversaryRes = await makeRequest('GET', '/api/Dashboard/GetWorkAnniversaryList', null, token);

      if (anniversaryRes.status === 200 && anniversaryRes.data && anniversaryRes.data.statusCode === 200) {
        const resultData = anniversaryRes.data.result || [];
        const count = Array.isArray(resultData) ? resultData.length : 0;
        results.push({ test: 'GetWorkAnniversaryList', status: 'PASS', code: 200, response: `${anniversaryRes.data.message} (${count} items)` });
        console.log('✓ GetWorkAnniversaryList successful');
      } else {
        results.push({ test: 'GetWorkAnniversaryList', status: 'FAIL', code: anniversaryRes.status, response: anniversaryRes.data });
        console.log(`✗ GetWorkAnniversaryList failed: ${anniversaryRes.status}`);
      }
    } catch (e) {
      results.push({ test: 'GetWorkAnniversaryList', status: 'FAIL', code: 0, response: e.message });
      console.log('✗ GetWorkAnniversaryList error:', e.message);
    }

    // Test 5: GetUpcomingHolidayList
    console.log('Test 5: GetUpcomingHolidayList...');
    try {
      const holidayRes = await makeRequest('GET', '/api/Dashboard/GetUpcomingHolidayList', null, token);

      if (holidayRes.status === 200) {
        const preview = JSON.stringify(holidayRes.data).substring(0, 150);
        results.push({ test: 'GetUpcomingHolidayList', status: 'PASS', code: 200, response: preview });
        console.log('✓ GetUpcomingHolidayList successful');
      } else {
        results.push({ test: 'GetUpcomingHolidayList', status: 'FAIL', code: holidayRes.status, response: holidayRes.data });
        console.log(`✗ GetUpcomingHolidayList failed: ${holidayRes.status}`);
      }
    } catch (e) {
      results.push({ test: 'GetUpcomingHolidayList', status: 'FAIL', code: 0, response: e.message });
      console.log('✗ GetUpcomingHolidayList error:', e.message);
    }

    // Test 6: GetUpcomingEvents
    console.log('Test 6: GetUpcomingEvents...');
    try {
      const eventsRes = await makeRequest('GET', '/api/Dashboard/GetUpcomingEvents', null, token);

      if (eventsRes.status === 200 && eventsRes.data && eventsRes.data.statusCode === 200) {
        const resultData = eventsRes.data.result || [];
        const count = Array.isArray(resultData) ? resultData.length : 0;
        results.push({ test: 'GetUpcomingEvents', status: 'PASS', code: 200, response: `${eventsRes.data.message} (${count} items)` });
        console.log('✓ GetUpcomingEvents successful');
      } else {
        results.push({ test: 'GetUpcomingEvents', status: 'FAIL', code: eventsRes.status, response: eventsRes.data });
        console.log(`✗ GetUpcomingEvents failed: ${eventsRes.status}`);
      }
    } catch (e) {
      results.push({ test: 'GetUpcomingEvents', status: 'FAIL', code: 0, response: e.message });
      console.log('✗ GetUpcomingEvents error:', e.message);
    }

    // Test 7: GetPublishedCompanyPolicies
    console.log('Test 7: GetPublishedCompanyPolicies...');
    try {
      const policiesRes = await makeRequest('POST', '/api/Dashboard/GetPublishedCompanyPolicies',
        { days: 30, from: null, to: null },
        token
      );

      if (policiesRes.status === 200) {
        const preview = JSON.stringify(policiesRes.data).substring(0, 150);
        results.push({ test: 'GetPublishedCompanyPolicies', status: 'PASS', code: 200, response: preview });
        console.log('✓ GetPublishedCompanyPolicies successful');
      } else {
        results.push({ test: 'GetPublishedCompanyPolicies', status: 'FAIL', code: policiesRes.status, response: policiesRes.data });
        console.log(`✗ GetPublishedCompanyPolicies failed: ${policiesRes.status}`);
      }
    } catch (e) {
      results.push({ test: 'GetPublishedCompanyPolicies', status: 'FAIL', code: 0, response: e.message });
      console.log('✗ GetPublishedCompanyPolicies error:', e.message);
    }

    console.log('\n--- Results Summary ---');
    console.log(JSON.stringify(results, null, 2));

    // Check if all tests passed
    const allPassed = results.every(r => r.status === 'PASS');
    if (!allPassed) {
      process.exit(1);
    }

  } catch (error) {
    console.error('Fatal error:', error.message);
    process.exit(1);
  }
}

runTests();

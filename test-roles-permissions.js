const axios = require('axios');

const API_BASE_URL = 'http://localhost:5281/api';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

const TEST_USER = {
  email: 'test.admin@programmers.io',
  password: 'SPHappy@2025Day!'
};

const log = {
  info: (msg) => console.log(`[INFO] ${msg}`),
  pass: (msg) => console.log(`✓ [PASS] ${msg}`),
  fail: (msg) => console.log(`✗ [FAIL] ${msg}`),
  separator: () => console.log('='.repeat(80))
};

async function runTests() {
  log.separator();
  log.info('INTEGRATION QA - Roles & Permissions');
  log.separator();
  console.log();

  let token = null;
  let results = {
    total: 0,
    passed: 0,
    failed: 0,
    details: []
  };

  try {
    // Test 1: Login to get fresh JWT
    log.info('Test 1: Login to get fresh JWT with updated permissions...');
    results.total++;
    try {
      const loginResponse = await axios.post(`${API_BASE_URL}/Auth/Login`, TEST_USER, {
        headers: { 'X-API_KEY': API_KEY }
      });

      if (loginResponse.status === 200 && loginResponse.data.result) {
        token = loginResponse.data.result.authToken;

        if (token) {
          log.pass(`Login successful - Got fresh JWT token`);
          log.info(`User: ${loginResponse.data.result.firstName} ${loginResponse.data.result.lastName}`);
          log.info(`Role: ${loginResponse.data.result.roleName}`);

          // Check for Role permissions in JWT
          const roleModule = loginResponse.data.result.modulePermissions?.modules?.find(m => m.moduleName === 'Role');
          if (roleModule && roleModule.permissions.length > 0) {
            const rolePerms = roleModule.permissions.map(p => p.permissionValue).join(', ');
            log.pass(`JWT includes Role permissions: ${rolePerms}`);
          } else {
            log.info(`Note: No Role module permissions found in JWT`);
          }

          results.passed++;
          results.details.push({ test: 'Login', status: 'PASS', message: 'Got fresh JWT token with permissions' });
        } else {
          log.fail(`Login succeeded but no token in response`);
          results.failed++;
          results.details.push({ test: 'Login', status: 'FAIL', message: 'No token in response' });
          return results;
        }
      } else {
        log.fail(`Login failed - Status: ${loginResponse.status}`);
        results.failed++;
        results.details.push({ test: 'Login', status: 'FAIL', message: `Status: ${loginResponse.status}` });
        return results;
      }
    } catch (error) {
      log.fail(`Login failed: ${error.message}`);
      results.failed++;
      results.details.push({ test: 'Login', status: 'FAIL', message: error.message });
      return results;
    }

    console.log();

    // Test 2: POST /api/RolePermission/GetRoles
    log.info('Test 2: POST /api/RolePermission/GetRoles...');
    results.total++;
    try {
      const getRolesPayload = {
        Filters: { RoleName: "" },
        PageSize: 10,
        StartIndex: 1,  // 1-based indexing for first page
        SortColumnName: "Name",
        SortDirection: "asc"
      };

      const rolesResponse = await axios.post(`${API_BASE_URL}/RolePermission/GetRoles`, getRolesPayload, {
        headers: {
          'X-API_KEY': API_KEY,
          'Authorization': `Bearer ${token}`
        }
      });

      if (rolesResponse.status === 200) {
        const data = rolesResponse.data;
        log.pass(`GetRoles endpoint returned 200`);
        log.info(`Total Roles: ${data.totalRecords || data.length || 'N/A'}`);

        if (data.data && Array.isArray(data.data)) {
          const roleNames = data.data.slice(0, 5).map(r => r.name || r.roleName).join(', ');
          log.info(`Sample Roles: ${roleNames}`);

          // Check for expected roles
          const hasExpectedRoles = data.data.some(r =>
            (r.name || r.roleName || '').toLowerCase().includes('superadmin') ||
            (r.name || r.roleName || '').toLowerCase().includes('hr') ||
            (r.name || r.roleName || '').toLowerCase().includes('employee')
          );

          if (hasExpectedRoles) {
            log.pass(`Found expected roles (SuperAdmin, HR, or Employee)`);
          } else {
            log.info(`Note: Expected roles not found in sample`);
          }
        }

        results.passed++;
        results.details.push({ test: 'GetRoles', status: 'PASS', message: `Returned ${data.totalRecords || data.length} roles` });
      } else {
        log.fail(`GetRoles failed - Status: ${rolesResponse.status}`);
        results.failed++;
        results.details.push({ test: 'GetRoles', status: 'FAIL', message: `Status: ${rolesResponse.status}` });
      }
    } catch (error) {
      log.fail(`GetRoles failed: ${error.response?.status || error.message}`);
      if (error.response?.data) {
        log.info(`Error details: ${JSON.stringify(error.response.data)}`);
      } else {
        log.info(`Error message: ${error.message}`);
      }
      results.failed++;
      results.details.push({ test: 'GetRoles', status: 'FAIL', message: error.response?.data?.message || error.message });
    }

    console.log();

    // Test 3: GET /api/RolePermission/GetModulePermissionsByRole?roleId=1
    log.info('Test 3: GET /api/RolePermission/GetModulePermissionsByRole?roleId=1...');
    results.total++;
    try {
      const modulePermsResponse = await axios.get(`${API_BASE_URL}/RolePermission/GetModulePermissionsByRole`, {
        params: { roleId: 1 },
        headers: {
          'X-API_KEY': API_KEY,
          'Authorization': `Bearer ${token}`
        }
      });

      if (modulePermsResponse.status === 200) {
        const data = modulePermsResponse.data;
        log.pass(`GetModulePermissionsByRole endpoint returned 200`);

        if (Array.isArray(data)) {
          log.info(`Total Modules: ${data.length}`);
          const moduleNames = data.slice(0, 5).map(m => m.moduleName || m.name).filter(Boolean).join(', ');
          if (moduleNames) {
            log.info(`Sample Modules: ${moduleNames}`);
          }

          // Check if permissions are grouped by module
          const hasGroupedPermissions = data.some(m => m.permissions && Array.isArray(m.permissions));
          if (hasGroupedPermissions) {
            log.pass(`Permissions are grouped by module`);
          }
        } else if (data && typeof data === 'object') {
          log.info(`Response structure: ${Object.keys(data).join(', ')}`);
        }

        results.passed++;
        results.details.push({ test: 'GetModulePermissionsByRole', status: 'PASS', message: `Retrieved role permissions` });
      } else {
        log.fail(`GetModulePermissionsByRole failed - Status: ${modulePermsResponse.status}`);
        results.failed++;
        results.details.push({ test: 'GetModulePermissionsByRole', status: 'FAIL', message: `Status: ${modulePermsResponse.status}` });
      }
    } catch (error) {
      log.fail(`GetModulePermissionsByRole failed: ${error.response?.status || error.message}`);
      log.info(`Error details: ${error.response?.data || error.message}`);
      results.failed++;
      results.details.push({ test: 'GetModulePermissionsByRole', status: 'FAIL', message: error.response?.data || error.message });
    }

    console.log();

    // Test 4: GET /api/RolePermission/GetPermissionList
    log.info('Test 4: GET /api/RolePermission/GetPermissionList...');
    results.total++;
    try {
      const permListResponse = await axios.get(`${API_BASE_URL}/RolePermission/GetPermissionList`, {
        headers: {
          'X-API_KEY': API_KEY,
          'Authorization': `Bearer ${token}`
        }
      });

      if (permListResponse.status === 200) {
        const data = permListResponse.data;
        log.pass(`GetPermissionList endpoint returned 200`);

        if (Array.isArray(data)) {
          log.info(`Total Permissions: ${data.length}`);
          const permNames = data.slice(0, 5).map(p => p.name || p.permissionName).filter(Boolean).join(', ');
          if (permNames) {
            log.info(`Sample Permissions: ${permNames}`);
          }

          // Check for expected permissions (Read.Role, View.Role, Edit.Role)
          const hasRolePermissions = data.some(p =>
            (p.name || p.permissionName || '').includes('Role')
          );
          if (hasRolePermissions) {
            log.pass(`Found Role-related permissions`);
          }
        } else if (data && typeof data === 'object') {
          log.info(`Response structure: ${Object.keys(data).join(', ')}`);
        }

        results.passed++;
        results.details.push({ test: 'GetPermissionList', status: 'PASS', message: `Retrieved permission list` });
      } else {
        log.fail(`GetPermissionList failed - Status: ${permListResponse.status}`);
        results.failed++;
        results.details.push({ test: 'GetPermissionList', status: 'FAIL', message: `Status: ${permListResponse.status}` });
      }
    } catch (error) {
      log.fail(`GetPermissionList failed: ${error.response?.status || error.message}`);
      log.info(`Error details: ${error.response?.data || error.message}`);
      results.failed++;
      results.details.push({ test: 'GetPermissionList', status: 'FAIL', message: error.response?.data || error.message });
    }

  } catch (error) {
    log.fail(`Unexpected error: ${error.message}`);
  }

  console.log();
  log.separator();
  log.info('TEST SUMMARY');
  log.separator();
  log.info(`Total Tests: ${results.total}`);
  log.pass(`Passed: ${results.passed}`);
  log.fail(`Failed: ${results.failed}`);
  log.info(`Success Rate: ${((results.passed / results.total) * 100).toFixed(1)}%`);
  console.log();

  if (results.failed > 0) {
    log.fail('FAILED TESTS:');
    results.details.filter(d => d.status === 'FAIL').forEach(d => {
      log.fail(`- ${d.test}: ${d.message}`);
    });
    console.log();
  }

  log.separator();
  if (results.passed === results.total) {
    log.pass('QA VERDICT: PASSED');
  } else {
    log.fail('QA VERDICT: FAILED');
  }
  log.separator();

  return results;
}

runTests().then(results => {
  process.exit(results.passed === results.total ? 0 : 1);
}).catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});

const axios = require('axios');

const API_BASE = 'http://localhost:5281/api';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

async function testIntegration() {
  console.log('=== INTEGRATION QA: Roles & Permissions ===\n');

  // Step 1: Login
  console.log('1. Testing Login...');
  try {
    const loginRes = await axios.post(`${API_BASE}/Auth/Login`, {
      Email: 'test.admin@programmers.io',
      Password: 'SPHappy@2025Day!'
    }, {
      headers: {
        'X-API_KEY': API_KEY,
        'Content-Type': 'application/json'
      }
    });

    const token = loginRes.data.result?.authToken;
    if (!token) {
      console.log('FAIL: No token received');
      console.log('Response:', JSON.stringify(loginRes.data, null, 2));
      process.exit(1);
    }
    console.log('✓ Login successful, token received');
    console.log(`User: ${loginRes.data.result.firstName} ${loginRes.data.result.lastName} (${loginRes.data.result.roleName})\n`);

    const headers = {
      'Authorization': `Bearer ${token}`,
      'X-API_KEY': API_KEY,
      'Content-Type': 'application/json'
    };

    // Step 2: Test GetRoles
    console.log('2. Testing POST /api/RolePermission/GetRoles...');
    const rolesRes = await axios.post(`${API_BASE}/RolePermission/GetRoles`, {
      filters: { roleName: '' },
      pageSize: 10,
      startIndex: 0,
      sortColumnName: 'Name',
      sortDirection: 'asc'
    }, { headers });

    console.log('Status:', rolesRes.status);
    console.log('Response structure:', JSON.stringify({
      success: rolesRes.data.success,
      totalRecords: rolesRes.data.totalRecords,
      dataLength: rolesRes.data.data?.length,
      firstRole: rolesRes.data.data?.[0] ? {
        roleId: rolesRes.data.data[0].roleId,
        name: rolesRes.data.data[0].name,
        hasDescription: !!rolesRes.data.data[0].description
      } : null
    }, null, 2));

    if (rolesRes.status !== 200 || !rolesRes.data.success) {
      console.log('FAIL: GetRoles failed');
      console.log('Full response:', JSON.stringify(rolesRes.data, null, 2));
      process.exit(1);
    }
    console.log('✓ GetRoles passed\n');

    // Step 3: Test GetModulePermissionsByRole
    console.log('3. Testing GET /api/RolePermission/GetModulePermissionsByRole?roleId=1...');
    const permsByRoleRes = await axios.get(`${API_BASE}/RolePermission/GetModulePermissionsByRole?roleId=1`, { headers });

    console.log('Status:', permsByRoleRes.status);
    console.log('Response structure:', JSON.stringify({
      success: permsByRoleRes.data.success,
      dataLength: permsByRoleRes.data.data?.length,
      firstModule: permsByRoleRes.data.data?.[0] ? {
        moduleName: permsByRoleRes.data.data[0].moduleName,
        permissionsCount: permsByRoleRes.data.data[0].permissions?.length,
        firstPermission: permsByRoleRes.data.data[0].permissions?.[0]
      } : null
    }, null, 2));

    if (permsByRoleRes.status !== 200 || !permsByRoleRes.data.success) {
      console.log('FAIL: GetModulePermissionsByRole failed');
      console.log('Full response:', JSON.stringify(permsByRoleRes.data, null, 2));
      process.exit(1);
    }
    console.log('✓ GetModulePermissionsByRole passed\n');

    // Step 4: Test GetPermissionList
    console.log('4. Testing GET /api/RolePermission/GetPermissionList...');
    const permListRes = await axios.get(`${API_BASE}/RolePermission/GetPermissionList`, { headers });

    console.log('Status:', permListRes.status);
    console.log('Response structure:', JSON.stringify({
      success: permListRes.data.success,
      dataLength: permListRes.data.data?.length,
      firstPermission: permListRes.data.data?.[0] ? {
        id: permListRes.data.data[0].id,
        name: permListRes.data.data[0].name,
        module: permListRes.data.data[0].module
      } : null
    }, null, 2));

    if (permListRes.status !== 200 || !permListRes.data.success) {
      console.log('FAIL: GetPermissionList failed');
      console.log('Full response:', JSON.stringify(permListRes.data, null, 2));
      process.exit(1);
    }
    console.log('✓ GetPermissionList passed\n');

    console.log('=== ALL TESTS PASSED ===');
    console.log('\nSummary:');
    console.log('- Login: PASS');
    console.log('- GetRoles: PASS');
    console.log('- GetModulePermissionsByRole: PASS');
    console.log('- GetPermissionList: PASS');

  } catch (error) {
    console.log('\nERROR:', error.response?.status, error.response?.statusText);
    console.log('Response data:', JSON.stringify(error.response?.data, null, 2));
    console.log('Error message:', error.message);
    process.exit(1);
  }
}

testIntegration();

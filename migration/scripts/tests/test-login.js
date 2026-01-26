// Test script to verify login functionality
const axios = require('axios');

const API_URL = 'http://localhost:5281/api';
const API_KEY = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf';

async function testLogin() {
  console.log('Testing Internal Login...\n');

  // Test credentials from appsettings.Development.json
  const testUsers = [
    { email: 'test.hr@programmers.io', password: 'test123' },
    { email: 'test.dev@programmers.io', password: 'test123' },
    { email: 'test.admin@programmers.io', password: 'test123' },
    { email: 'test.admin@programmers.io', password: 'admin' },
    { email: 'test.admin@programmers.io', password: 'Admin@123' },
  ];

  for (const credentials of testUsers) {
    try {
      console.log(`Trying: ${credentials.email} / ${credentials.password}`);

      const response = await axios.post(
        `${API_URL}/Auth/Login`,
        credentials,
        {
          headers: {
            'Content-Type': 'application/json',
            'X-API_KEY': API_KEY,
          },
        }
      );

      console.log('✓ SUCCESS!');
      console.log('Response:', JSON.stringify(response.data, null, 2));
      console.log('\nToken:', response.data.result?.authToken?.substring(0, 50) + '...');
      break;
    } catch (error) {
      if (error.response) {
        console.log(`✗ Failed: ${error.response.data.message}`);
      } else {
        console.log(`✗ Error: ${error.message}`);
      }
    }
  }
}

testLogin().catch(console.error);

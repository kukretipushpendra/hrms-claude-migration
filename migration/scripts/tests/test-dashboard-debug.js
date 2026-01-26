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

    const req = http.request(options, (res) => {
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
            raw: responseData,
            headers: res.headers
          });
        } catch (e) {
          resolve({
            status: res.statusCode,
            data: responseData,
            raw: responseData,
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

async function debugLogin() {
  console.log('Testing login...');
  console.log('API Base:', API_BASE);
  console.log('Credentials:', testCredentials);

  try {
    const loginRes = await makeRequest('POST', '/api/Auth/Login', testCredentials);

    console.log('\nStatus:', loginRes.status);
    console.log('Headers:', loginRes.headers);
    console.log('\nRaw Response:');
    console.log(loginRes.raw);
    console.log('\nParsed Data:');
    console.log(JSON.stringify(loginRes.data, null, 2));

  } catch (error) {
    console.error('Error:', error.message);
  }
}

debugLogin();

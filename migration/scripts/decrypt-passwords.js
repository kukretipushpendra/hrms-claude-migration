// Decrypt HRMS test user passwords
// Uses the same AES key/IV as the .NET backend

const crypto = require('crypto');

const key = Buffer.from('abcd1234efgh5678ijkl9012mnop3456', 'utf8'); // 32 bytes
const iv = Buffer.from('d5e4f3c2b1a09876', 'utf8'); // 16 bytes

function decrypt(encryptedBase64) {
  const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
  const encryptedBytes = Buffer.from(encryptedBase64, 'base64');
  let decrypted = decipher.update(encryptedBytes);
  decrypted = Buffer.concat([decrypted, decipher.final()]);
  return decrypted.toString('utf8');
}

console.log('\nTEST USER CREDENTIALS');
console.log('=====================\n');

const users = [
  { email: 'test.admin@programmers.io', encrypted: 'LF1hNZh1127rGk7FaeiDFYZ3+LVXzNmizV/eB4hvgh4=' },
  { email: 'test.hr@programmers.io', encrypted: 'pZcBolsjutgx7O6HAjShLsBP4j8WimM6m/czxSlyLtk=' },
  { email: 'test.dev@programmers.io', encrypted: 'UEAZC1/kgsolftMj425JXg==' }
];

users.forEach(user => {
  try {
    const password = decrypt(user.encrypted);
    console.log(`${user.email} : ${password}`);
  } catch (err) {
    console.log(`${user.email} : ERROR - ${err.message}`);
  }
});

console.log('');

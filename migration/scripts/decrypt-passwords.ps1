# Decrypt HRMS test user passwords
# Uses the same AES key/IV as the .NET backend

$key = [System.Text.Encoding]::UTF8.GetBytes("abcd1234efgh5678ijkl9012mnop3456")
$iv = [System.Text.Encoding]::UTF8.GetBytes("d5e4f3c2b1a09876")

function Decrypt-Password {
    param([string]$encrypted)

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.IV = $iv

    $decryptor = $aes.CreateDecryptor()
    $encryptedBytes = [Convert]::FromBase64String($encrypted)

    $ms = New-Object System.IO.MemoryStream(,$encryptedBytes)
    $cs = New-Object System.Security.Cryptography.CryptoStream($ms, $decryptor, [System.Security.Cryptography.CryptoStreamMode]::Read)
    $sr = New-Object System.IO.StreamReader($cs)

    $plaintext = $sr.ReadToEnd()

    $sr.Close()
    $cs.Close()
    $ms.Close()

    return $plaintext
}

Write-Host ""
Write-Host "TEST USER CREDENTIALS" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host ""

$users = @(
    @{ Email = "test.admin@programmers.io"; Encrypted = "LF1hNZh1127rGk7FaeiDFYZ3+LVXzNmizV/eB4hvgh4=" },
    @{ Email = "test.hr@programmers.io"; Encrypted = "pZcBolsjutgx7O6HAjShLsBP4j8WimM6m/czxSlyLtk=" },
    @{ Email = "test.dev@programmers.io"; Encrypted = "UEAZC1/kgsolftMj425JXg==" }
)

foreach ($user in $users) {
    try {
        $password = Decrypt-Password $user.Encrypted
        Write-Host "$($user.Email)" -ForegroundColor Green -NoNewline
        Write-Host " : " -NoNewline
        Write-Host "$password" -ForegroundColor Yellow
    } catch {
        Write-Host "$($user.Email) : DECRYPT_ERROR - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""

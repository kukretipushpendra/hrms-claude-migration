# Verify HRMS login with decrypted credentials

$headers = @{
    'X-API_KEY' = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf'
    'Content-Type' = 'application/json'
}

$url = 'http://localhost:5281/api/Auth/Login'

$users = @(
    @{ Email = 'test.admin@programmers.io'; Password = 'SPHappy@2025Day!' },
    @{ Email = 'test.hr@programmers.io'; Password = 'hrShiny@Star100x' },
    @{ Email = 'test.dev@programmers.io'; Password = 'dev$Sky21@Pio' }
)

Write-Host ""
Write-Host "VERIFYING LOGIN CREDENTIALS" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

foreach ($user in $users) {
    $body = @{
        email = $user.Email
        password = $user.Password
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ErrorAction Stop
        Write-Host "[OK] $($user.Email)" -ForegroundColor Green
        Write-Host "    User ID: $($response.data.userId)"
        Write-Host "    Name: $($response.data.firstName) $($response.data.lastName)"
        Write-Host "    Role: $($response.data.roleName)"
        Write-Host ""
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "[FAIL] $($user.Email) - HTTP $statusCode" -ForegroundColor Red
        Write-Host ""
    }
}

Write-Host "Verification complete." -ForegroundColor Gray

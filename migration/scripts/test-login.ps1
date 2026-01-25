# Test HRMS login with various passwords

$headers = @{
    'X-API_KEY' = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf'
    'Content-Type' = 'application/json'
}

$passwords = @(
    'Password123',
    'Admin@123',
    'admin123',
    'test123',
    'Password@123',
    'Admin123!',
    'Test123!',
    'P@ssw0rd',
    'Welcome@123',
    'Hrms@123',
    'password',
    '123456',
    'admin',
    'test',
    'Programmers@123',
    'Pio@123'
)

$email = 'test.admin@programmers.io'
$url = 'http://localhost:5281/api/Auth/Login'

Write-Host "Testing login for: $email" -ForegroundColor Cyan
Write-Host "URL: $url" -ForegroundColor Gray
Write-Host ""

foreach ($pwd in $passwords) {
    $body = @{
        email = $email
        password = $pwd
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ErrorAction Stop
        Write-Host "SUCCESS: $pwd" -ForegroundColor Green
        Write-Host ($response | ConvertTo-Json -Depth 3)
        exit 0
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "Failed ($statusCode): $pwd" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "No password matched. Please get the correct password from your team." -ForegroundColor Yellow

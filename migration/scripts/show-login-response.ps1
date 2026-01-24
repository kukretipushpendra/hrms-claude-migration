# Show full login response

$headers = @{
    'X-API_KEY' = 'X3nvZJ7pQe5tKuL9Bd1aH8yWOm4Cx6Tf'
    'Content-Type' = 'application/json'
}

$body = @{
    email = 'test.admin@programmers.io'
    password = 'SPHappy@2025Day!'
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri 'http://localhost:5281/api/Auth/Login' -Method Post -Headers $headers -Body $body

Write-Host "FULL RESPONSE:" -ForegroundColor Cyan
$response | ConvertTo-Json -Depth 10

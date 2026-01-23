# Hook: Log user prompts to Prompts.md
# Triggered on: UserPromptSubmit

$PromptsFile = "Prompts.md"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Read prompt from stdin
$Prompt = [Console]::In.ReadToEnd()

# Skip empty or very short prompts
if ([string]::IsNullOrWhiteSpace($Prompt) -or $Prompt.Length -lt 10) {
    exit 0
}

# Get the next prompt number
$NextNum = 1
if (Test-Path $PromptsFile) {
    $Content = Get-Content $PromptsFile -Raw
    $Matches = [regex]::Matches($Content, '### Prompt (\d+)')
    if ($Matches.Count -gt 0) {
        $LastNum = [int]$Matches[$Matches.Count - 1].Groups[1].Value
        $NextNum = $LastNum + 1
    }
}

# Escape backticks for markdown
$EscapedPrompt = $Prompt -replace '`', '\`'

# Create the entry
$Entry = @"

### Prompt ${NextNum}: User Prompt
**Time:** $Timestamp

``````
$EscapedPrompt
``````

**Result:** [Pending - update after completion]

---
"@

# Append to Prompts.md
Add-Content -Path $PromptsFile -Value $Entry

exit 0

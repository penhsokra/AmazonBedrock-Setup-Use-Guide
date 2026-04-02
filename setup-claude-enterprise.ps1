<#
.SYNOPSIS
    Claude Code Enterprise Setup Script for 20 Teams.
    Powered by Senior Developer Infrastructure.
#>

$ErrorActionPreference = "Stop"
Clear-Host

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "   CLAUDE CODE ENTERPRISE SETUP - 20 TEAMS CONFIG   " -ForegroundColor Cyan
Write-Host "====================================================`n" -ForegroundColor Cyan

# ១. ឱ្យបុគ្គលិកជ្រើសរើសក្រុម (Team Selection)
Write-Host "Please select your Team Number (01 to 20):" -ForegroundColor Yellow
$teamId = Read-Host "Team ID"

if ($teamId -lt 1 -or $teamId -gt 20) {
    Write-Host "Invalid Team ID! Please enter between 01 and 20." -ForegroundColor Red
    exit
}

# ២. កំណត់ Configuration តាមក្រុម
$region = "ap-southeast-1"
$modelARN = "arn:aws:bedrock:ap-southeast-1:351381968895:application-inference-profile/team-$teamId"

try {
    Write-Host "`n[1/3] Configuring Environment Variables..." -ForegroundColor White
    [System.Environment]::SetEnvironmentVariable('CLAUDE_CODE_PROVIDER', 'bedrock', 'User')
    [System.Environment]::SetEnvironmentVariable('AWS_REGION', $region, 'User')
    [System.Environment]::SetEnvironmentVariable('CLAUDE_CODE_MODEL', $modelARN, 'User')

    Write-Host "[2/3] Updating Execution Policy..." -ForegroundColor White
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

    Write-Host "[3/3] Finalizing Setup..." -ForegroundColor White
    # បង្កើត Alias សម្រាប់ងាយស្រួលប្រើ (Optional)
    if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Type File -Force }
    
    Write-Host "`n✅ SETUP SUCCESSFUL!" -ForegroundColor Green
    Write-Host "----------------------------------------------------"
    Write-Host "Team: Team-$teamId"
    Write-Host "Model: Claude 3.5 Sonnet (via Bedrock)"
    Write-Host "----------------------------------------------------"
    Write-Host "`nACTION REQUIRED: Please RESTART your PowerShell/VS Code terminal." -ForegroundColor Cyan
}
catch {
    Write-Host "`n❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Pause
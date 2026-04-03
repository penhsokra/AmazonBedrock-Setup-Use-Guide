<#
.SYNOPSIS
    Claude Code Enterprise Setup Script (Final)
.DESCRIPTION
    Configures AWS SSO, sets persistent environment variables for the Backend Team, and verifies connectivity.
#>

$ErrorActionPreference = "Stop"
Clear-Host

# --- Configuration ---
$CONFIG = @{
    ProfileName = "bedrock"
    SSOUrl      = "https://d-90660621fe.awsapps.com/start"
    SSORegion   = "us-east-1"
    AccountID   = "351381968895"
    RoleName    = "BedrockTeamBackend"
    # Updated to the specific Backend Team Inference Profile found in your console
    ModelARN    = "arn:aws:bedrock:us-east-1:351381968895:application-inference-profile/aibid7fhapm8"
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   Claude Code Enterprise Setup        " -ForegroundColor Cyan
Write-Host "========================================="

try {
    # 1. AWS SSO Configuration
    Write-Host "`n[1/5] Configuring AWS SSO profile [$($CONFIG.ProfileName)]..." -ForegroundColor White
    $ConfigMap = @{
        "sso_start_url"  = $CONFIG.SSOUrl
        "sso_region"     = $CONFIG.SSORegion
        "sso_account_id" = $CONFIG.AccountID
        "sso_role_name"  = $CONFIG.RoleName
        "region"         = $CONFIG.SSORegion
        "output"         = "json"
    }

    foreach ($Key in $ConfigMap.Keys) {
        aws configure set $Key $($ConfigMap[$Key]) --profile $($CONFIG.ProfileName)
    }

    # 2. Environment Variables (Persistent + Current Session)
    Write-Host "[2/5] Setting User Environment Variables..." -ForegroundColor White
    $EnvVars = @{
        "AWS_PROFILE"                    = $CONFIG.ProfileName
        "AWS_REGION"                     = $CONFIG.SSORegion
        "CLAUDE_CODE_USE_BEDROCK"        = "1"
        "ANTHROPIC_DEFAULT_SONNET_MODEL" = $CONFIG.ModelARN
    }

    foreach ($Var in $EnvVars.Keys) {
        [System.Environment]::SetEnvironmentVariable($Var, $EnvVars[$Var], 'User')
        Set-Item -Path "Env:\$Var" -Value $EnvVars[$Var]
    }

    # 3. Policy Update
    Write-Host "[3/5] Updating Execution Policy..." -ForegroundColor White
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

    # 4. AWS Authentication
    Write-Host "[4/5] Logging in to AWS SSO..." -ForegroundColor White
    aws sso login --profile $($CONFIG.ProfileName)
    
    # 5. Verification
    Write-Host "[5/5] Verifying identity..." -ForegroundColor White
    try {
        $IdentityJson = aws sts get-caller-identity --profile $($CONFIG.ProfileName)
        $Identity = $IdentityJson | ConvertFrom-Json
        
        Write-Host "`n✅ SETUP SUCCESSFUL!" -ForegroundColor Green
        Write-Host "-----------------------------------------"
        Write-Host "User ID  : $($Identity.UserId)"
        Write-Host "Account  : $($Identity.Account)"
        Write-Host "Profile  : $($CONFIG.ProfileName)"
        Write-Host "Model ARN: $($CONFIG.ModelARN)"
        Write-Host "-----------------------------------------"
        Write-Host "`nNEXT STEPS:" -ForegroundColor Cyan
        Write-Host "1. Restart VS Code (to reload global Env Vars)"
        Write-Host "2. Run: claude"
    }
    catch {
        Write-Host "`n❌ LOGIN FAILED: You do not have access to the role '$($CONFIG.RoleName)' in account $($CONFIG.AccountID)." -ForegroundColor Red
        Write-Host "Check your AWS SSO portal to ensure the RoleName is correct." -ForegroundColor Yellow
        exit
    }
}
catch {
    Write-Host "`n❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Pause

# Author: Aaron R - Corgan
param(
    [Parameter(Mandatory = $false)]
    [String]$InformationPreference = "Continue",
    [Parameter(Mandatory = $false)]
    [String]$WarningPreference = "Continue",
    [Parameter(Mandatory = $false)]
    [String]$DebugPreference = "Continue",
    [Parameter(Mandatory = $false)]
    [String]$VerbosePreference = "Continue",
    [Parameter(Mandatory = $false)]
    [String]$ErrorActionPreference = "Inquire"
)

# Check if PowerShell session is running as admin
if ([bool]([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsSystem) {
    Write-Host "$($PSStyle.Foreground.Red)DO NOT RUN AS ADMIN! Exiting..."
    exit
}


Get-WinGetPackage | Where-Object {$_.IsUpdateAvailable} | ForEach-Object { Update-WinGetPackage -Id $_.ID }


Write-Host -NoNewLine 'Press any key to exit...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
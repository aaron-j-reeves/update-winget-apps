# Author: Aaron R
# Date: 9/2024
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
    [String]$ErrorActionPreference = "Continue"
)

# Check if PowerShell session is running as admin
if ([bool]([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsSystem) {
    Write-Host "$($PSStyle.Foreground.Red)DO NOT RUN AS ADMIN! Exiting..."
    exit
}

# Get the list of packages that need updating, excluding those with 'microsoft' in their names
$packagesToUpdate = Get-WinGetPackage | Where-Object { $_.IsUpdateAvailable -and $_.Name -notmatch "microsoft" }

# Print the entire results table
$packagesToUpdate | Format-Table

# Prompt the user to input partial names of any apps they want to exclude from updating
$exclusions = Read-Host "Enter comma-separated partial names of any apps you want to exclude from updating (leave blank to update all)"

if ($exclusions) {
    # Convert the input string into an array of exclusion terms
    $exclusionList = $exclusions -split ',' | ForEach-Object { $_.Trim() }

    # Filter out the packages that match any of the exclusion terms
    $packagesToUpdate = $packagesToUpdate | Where-Object {
        $exclude = $false
        foreach ($term in $exclusionList) {
            if ($_.Name -match $term) {
                $exclude = $true
                break
            }
        }
        -not $exclude
    }
}

# Now proceed with the updates
$packagesToUpdate | ForEach-Object { Update-WinGetPackage -Id $_.ID }

Write-Host -NoNewLine 'Press any key to exit...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
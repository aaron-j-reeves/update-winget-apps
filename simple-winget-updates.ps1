Get-WinGetPackage | Where-Object { $_.IsUpdateAvailable -and $_.Name -notmatch "microsoft" } | Update-WinGetPackage
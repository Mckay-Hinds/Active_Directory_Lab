Import-Module ActiveDirectory

$reportPath = "..\reports\Domain-Health-Report.txt"

if (-not (Test-Path "..\reports")) {
    New-Item -Path "..\reports" -ItemType Directory | Out-Null
}

"=== Domain Health Report ===" | Out-File $reportPath
"Generated: $(Get-Date)" | Out-File $reportPath -Append
"" | Out-File $reportPath -Append

"=== Domain Controllers ===" | Out-File $reportPath -Append
Get-ADDomainController -Filter * |
    Select-Object HostName, Site, IPv4Address |
    Out-File $reportPath -Append

"=== Users ===" | Out-File $reportPath -Append
Get-ADUser -Filter * |
    Select-Object Name, SamAccountName, Enabled |
    Out-File $reportPath -Append

"=== Groups ===" | Out-File $reportPath -Append
Get-ADGroup -Filter * |
    Select-Object Name, GroupScope, GroupCategory |
    Out-File $reportPath -Append

"=== Computers ===" | Out-File $reportPath -Append
Get-ADComputer -Filter * |
    Select-Object Name, Enabled |
    Out-File $reportPath -Append

"=== DCDIAG ===" | Out-File $reportPath -Append
dcdiag | Out-File $reportPath -Append

Write-Host "Domain health report created at $reportPath" -ForegroundColor Green
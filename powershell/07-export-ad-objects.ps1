Import-Module ActiveDirectory

if (-not (Test-Path "..\exports")) {
    New-Item -Path "..\exports" -ItemType Directory | Out-Null
}

Get-ADUser -Filter * -Properties Department |
    Select-Object Name, SamAccountName, Department, Enabled |
    Export-Csv "..\exports\Users.csv" -NoTypeInformation

Get-ADGroup -Filter * |
    Select-Object Name, GroupScope, GroupCategory |
    Export-Csv "..\exports\Groups.csv" -NoTypeInformation

Get-ADComputer -Filter * -Properties OperatingSystem |
    Select-Object Name, OperatingSystem, Enabled |
    Export-Csv "..\exports\Computers.csv" -NoTypeInformation

Write-Host "AD exports created in exports folder." -ForegroundColor Green
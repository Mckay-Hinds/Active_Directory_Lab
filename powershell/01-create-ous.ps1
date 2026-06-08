Import-Module ActiveDirectory

$config = Import-PowerShellDataFile -Path "..\config\lab-config.psd1"
$domainDN = $config.DomainDN

foreach ($ou in $config.OUs) {
    $existingOU = Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -ErrorAction SilentlyContinue

    if (-not $existingOU) {
        New-ADOrganizationalUnit `
            -Name $ou `
            -Path $domainDN `
            -ProtectedFromAccidentalDeletion $true

        Write-Host "Created OU: $ou" -ForegroundColor Green
    }
    else {
        Write-Host "OU already exists: $ou" -ForegroundColor Yellow
    }
}
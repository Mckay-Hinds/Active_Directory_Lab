Import-Module ActiveDirectory

$config = Import-PowerShellDataFile -Path "..\config\lab-config.psd1"
$domainDN = $config.DomainDN

foreach ($group in $config.Groups) {
    $groupName = $group.Name
    $ouPath = "OU=$($group.OU),$domainDN"

    $existingGroup = Get-ADGroup -Filter "Name -eq '$groupName'" -ErrorAction SilentlyContinue

    if (-not $existingGroup) {
        New-ADGroup `
            -Name $groupName `
            -SamAccountName $groupName `
            -GroupScope Global `
            -GroupCategory Security `
            -Path $ouPath

        Write-Host "Created group: $groupName" -ForegroundColor Green
    }
    else {
        Write-Host "Group already exists: $groupName" -ForegroundColor Yellow
    }
}
Import-Module GroupPolicy
Import-Module ActiveDirectory

$config = Import-PowerShellDataFile -Path "..\config\lab-config.psd1"
$domainDN = $config.DomainDN

function New-LabGPO {
    param (
        [string]$Name,
        [string]$TargetOU
    )

    $gpo = Get-GPO -Name $Name -ErrorAction SilentlyContinue

    if (-not $gpo) {
        $gpo = New-GPO -Name $Name
        Write-Host "Created GPO: $Name" -ForegroundColor Green
    }
    else {
        Write-Host "GPO already exists: $Name" -ForegroundColor Yellow
    }

    $target = "OU=$TargetOU,$domainDN"

    $existingLink = Get-GPInheritance -Target $target | Select-Object -ExpandProperty GpoLinks | Where-Object {
        $_.DisplayName -eq $Name
    }

    if (-not $existingLink) {
        New-GPLink -Name $Name -Target $target -LinkEnabled Yes
        Write-Host "Linked $Name to $TargetOU" -ForegroundColor Cyan
    }
}

New-LabGPO -Name "Disable Control Panel" -TargetOU "Homelab Users"
New-LabGPO -Name "Basic Security Settings" -TargetOU "Homelab Users"
New-LabGPO -Name "IT Admin Policy" -TargetOU "IT"

Set-GPRegistryValue `
    -Name "Disable Control Panel" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -ValueName "NoControlPanel" `
    -Type DWord `
    -Value 1

Set-GPRegistryValue `
    -Name "Basic Security Settings" `
    -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -ValueName "DisableTaskMgr" `
    -Type DWord `
    -Value 0

Write-Host "GPO configuration complete." -ForegroundColor Green
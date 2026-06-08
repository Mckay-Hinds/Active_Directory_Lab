Import-Module ActiveDirectory

$config = Import-PowerShellDataFile -Path "..\config\lab-config.psd1"
$reportPath = "..\reports\Lab-Validation.txt"

if (-not (Test-Path "..\reports")) {
    New-Item -Path "..\reports" -ItemType Directory | Out-Null
}

"=== Active Directory Lab Validation ===" | Out-File $reportPath
"Generated: $(Get-Date)" | Out-File $reportPath -Append
"" | Out-File $reportPath -Append

"=== OUs ===" | Out-File $reportPath -Append
foreach ($ou in $config.OUs) {
    $exists = Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -ErrorAction SilentlyContinue

    if ($exists) {
        "[PASS] OU exists: $ou" | Out-File $reportPath -Append
    }
    else {
        "[FAIL] Missing OU: $ou" | Out-File $reportPath -Append
    }
}

"" | Out-File $reportPath -Append
"=== Groups ===" | Out-File $reportPath -Append
foreach ($group in $config.Groups) {
    $exists = Get-ADGroup -Filter "Name -eq '$($group.Name)'" -ErrorAction SilentlyContinue

    if ($exists) {
        "[PASS] Group exists: $($group.Name)" | Out-File $reportPath -Append
    }
    else {
        "[FAIL] Missing group: $($group.Name)" | Out-File $reportPath -Append
    }
}

"" | Out-File $reportPath -Append
"=== Users ===" | Out-File $reportPath -Append
foreach ($user in $config.Users) {
    $exists = Get-ADUser -Filter "SamAccountName -eq '$($user.Username)'" -ErrorAction SilentlyContinue

    if ($exists) {
        "[PASS] User exists: $($user.Username)" | Out-File $reportPath -Append
    }
    else {
        "[FAIL] Missing user: $($user.Username)" | Out-File $reportPath -Append
    }
}

"" | Out-File $reportPath -Append
"=== Shares ===" | Out-File $reportPath -Append
foreach ($share in $config.Shares) {
    $exists = Get-SmbShare -Name $share.Name -ErrorAction SilentlyContinue

    if ($exists) {
        "[PASS] Share exists: \\$($config.ServerName)\$($share.Name)" | Out-File $reportPath -Append
    }
    else {
        "[FAIL] Missing share: $($share.Name)" | Out-File $reportPath -Append
    }
}

Write-Host "Validation report created at $reportPath" -ForegroundColor Green
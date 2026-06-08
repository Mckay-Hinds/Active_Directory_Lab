Import-Module ActiveDirectory

$config = Import-PowerShellDataFile -Path "..\config\lab-config.psd1"
$domainDN = $config.DomainDN
$domainName = $config.DomainName
$password = ConvertTo-SecureString $config.DefaultPassword -AsPlainText -Force

foreach ($user in $config.Users) {
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $username = $user.Username
    $fullName = "$firstName $lastName"
    $ouPath = "OU=$($user.OU),$domainDN"

    $existingUser = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

    if (-not $existingUser) {
        New-ADUser `
            -GivenName $firstName `
            -Surname $lastName `
            -Name $fullName `
            -DisplayName $fullName `
            -SamAccountName $username `
            -UserPrincipalName "$username@$domainName" `
            -Department $user.Department `
            -Path $ouPath `
            -AccountPassword $password `
            -Enabled $true `
            -ChangePasswordAtLogon $true

        Write-Host "Created user: $username" -ForegroundColor Green
    }
    else {
        Write-Host "User already exists: $username" -ForegroundColor Yellow
    }

    Add-ADGroupMember -Identity $user.Group -Members $username -ErrorAction SilentlyContinue
    Write-Host "Added $username to $($user.Group)" -ForegroundColor Cyan
}
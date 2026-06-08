Import-Module ActiveDirectory

$config = Import-PowerShellDataFile -Path "..\config\lab-config.psd1"

if (-not (Test-Path $config.ShareRoot)) {
    New-Item -Path $config.ShareRoot -ItemType Directory | Out-Null
}

foreach ($share in $config.Shares) {
    $shareName = $share.Name
    $sharePath = $share.Path
    $groupName = $share.Group

    if (-not (Test-Path $sharePath)) {
        New-Item -Path $sharePath -ItemType Directory | Out-Null
        Write-Host "Created folder: $sharePath" -ForegroundColor Green
    }

    $existingShare = Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue

    if (-not $existingShare) {
        New-SmbShare `
            -Name $shareName `
            -Path $sharePath `
            -FullAccess "Domain Admins" `
            -ChangeAccess $groupName

        Write-Host "Created share: \\$($config.ServerName)\$shareName" -ForegroundColor Green
    }
    else {
        Write-Host "Share already exists: $shareName" -ForegroundColor Yellow
    }

    $acl = Get-Acl $sharePath

    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $groupName,
        "Modify",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )

    $acl.SetAccessRule($rule)
    Set-Acl -Path $sharePath -AclObject $acl

    Write-Host "Set NTFS permissions for $groupName on $sharePath" -ForegroundColor Cyan
}
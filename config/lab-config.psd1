@{
    DomainName = "homelab.local"
    DomainDN   = "DC=homelab,DC=local"
    ServerName = "DC01"

    ShareRoot = "C:\LabShares"

    DefaultPassword = "P@ssw0rd123!"

    OUs = @(
        "Homelab Users",
        "Homelab Computers",
        "IT",
        "HR",
        "Finance",
        "Disabled Users"
    )

    Groups = @(
        @{ Name = "IT_Admins"; OU = "IT" },
        @{ Name = "HR_Users"; OU = "HR" },
        @{ Name = "Finance_Users"; OU = "Finance" },
        @{ Name = "Password_Reset_Team"; OU = "IT" }
    )

    Users = @(
        @{
            FirstName = "John"
            LastName = "Doe"
            Username = "jdoe"
            OU = "IT"
            Group = "IT_Admins"
            Department = "IT"
        },
        @{
            FirstName = "Amy"
            LastName = "Smith"
            Username = "asmith"
            OU = "HR"
            Group = "HR_Users"
            Department = "HR"
        },
        @{
            FirstName = "Ben"
            LastName = "Jones"
            Username = "bjones"
            OU = "Finance"
            Group = "Finance_Users"
            Department = "Finance"
        },
        @{
            FirstName = "IT"
            LastName = "Admin"
            Username = "it.admin"
            OU = "IT"
            Group = "IT_Admins"
            Department = "IT"
        }
    )

    Shares = @(
        @{
            Name = "IT"
            Path = "C:\LabShares\IT"
            Group = "IT_Admins"
        },
        @{
            Name = "HR"
            Path = "C:\LabShares\HR"
            Group = "HR_Users"
        },
        @{
            Name = "Finance"
            Path = "C:\LabShares\Finance"
            Group = "Finance_Users"
        }
    )
}
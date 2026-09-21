@{
    RootModule        = 'WslPortForwarding.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'dd48115e-1b33-42c8-9989-55d827a38afb'
    Description       = 'Forward a Windows port to a port inside WSL using netsh portproxy and a Windows Firewall rule.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'WslPortForwarding-Setup',
        'WslPortForwarding-Check',
        'WslPortForwarding-TearDown'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}

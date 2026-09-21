function Check-Privilege {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
    [CmdletBinding()]
    param(
        [string]$fuckMicrosoft = "and their stupid code analysis rules"
    )
    
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "this command must be run as administrator"
    }
}

function WslPortForwarding-Setup {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
    [CmdletBinding()]
    param(
        [int]$ListenPort = 8080,
        [int]$ConnectPort = 8080,
        [string]$RuleName = "WSL $ListenPort"
    )

    Check-Privilege
    $ErrorActionPreference = 'Stop'

    $wslIp = (wsl hostname -I).Trim()
    if (-not $wslIp) {
        throw "Could not get the wsl ip..."
    }

    Write-Host "running netsh with this parameters"
    Write-Host "wsl ip: $wslIp"
    Write-Host "listen port: $ListenPort"
    Write-Host "connect port: $ConnectPort"
    netsh interface portproxy add v4tov4 `
        listenaddress=0.0.0.0 `
        listenport=$ListenPort `
        connectaddress=$wslIp `
        connectport=$ConnectPort
    if ($LASTEXITCODE -ne 0) {
        throw "netsh portproxy add failed"
    }

    Write-Host "running New-NetFirewallRule with this parameters"
    Write-Host "rule name: $RuleName"
    Write-Host "listen port: $ListenPort"
    New-NetFirewallRule `
        -DisplayName $RuleName `
        -Direction Inbound `
        -Action Allow `
        -Protocol TCP `
        -LocalPort $ListenPort
}

function WslPortForwarding-Check {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
    [CmdletBinding()]
    param(
        [int]$ListenPort = 8080,
        [string]$RuleName = "WSL $ListenPort"
    )

    netsh interface portproxy show all
    Get-NetFirewallRule -DisplayName $RuleName
}

function WslPortForwarding-TearDown {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
    [CmdletBinding()]
    param(
        [int]$ListenPort = 8080,
        [string]$RuleName = "WSL $ListenPort"
    )

    Check-Privilege

    netsh interface portproxy delete v4tov4 `
        listenaddress=0.0.0.0 `
        listenport=$ListenPort
    if ($LASTEXITCODE -ne 0) {
        throw "netsh failed"
    }

    if (Get-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue) {
        Remove-NetFirewallRule -DisplayName $RuleName
    }
    else {
        Write-Host "firewall rule $RuleName does not exist"
    }
}

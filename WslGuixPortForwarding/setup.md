run in Admin terminal

get the wsl ip

```powershell
wsl hostname -I
```

forward
host:8080 -> wsl:8080

```powershell
netsh interface portproxy add v4tov4 `
  listenaddress=0.0.0.0 `
  listenport=8080 `
  connectaddress=<WSL_IP> `
  connectport=3000
```

firewall settings

```powershell
New-NetFirewallRule `
  -DisplayName "WSL 8080" `
  -Direction Inbound `
  -Action Allow `
  -Protocol TCP `
  -LocalPort 8080
```

check that settings are applied

```powershell
netsh interface portproxy show all
```

```powershell
Get-NetFirewallRule -DisplayName "WSL 8080"
```

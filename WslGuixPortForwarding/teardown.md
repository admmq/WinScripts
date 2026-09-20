to remove the setup

```powershell
netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=8080
```

```powershell
Remove-NetFirewallRule -DisplayName "WSL 8080"
```

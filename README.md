# Get-CUOneDriveStatus
A function that grabs the latest version of Rodneyviana's "[Get-ODStatus](https://github.com/rodneyviana/ODSyncService)" function and uses My "[PSRunAsCurrentUser](https://github.com/AlecMcCutcheon/PSRunAsCurrentUser)" function there's a compatibility layer of sorts. Which allows it to work as the (User, Admin or even System) account. Note: If you are running it as Administrator or System, keep in mind that a user must be logged into the machine in order for this to work.

Use the following One-liner to Temp Run in session: 

```
iex ((New-Object System.Net.WebClient).DownloadString("https://tinyurl.com/Get-CUOneDriveStatus"));
```

# Usage

```
PS C:\WINDOWS\system32> (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
True

PS C:\WINDOWS\system32> whoami
nt authority\system

PS C:\WINDOWS\system32> (Get-CUOneDriveStatus).StatusString
Up to date
Up to date
```
```
PS C:\Users\AlecMcCutcheon\Desktop> (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
False

PS C:\Users\AlecMcCutcheon\Desktop> whoami
azuread\alecmccutcheon

PS C:\Users\AlecMcCutcheon\Desktop> (Get-CUOneDriveStatus).StatusString
Up to date
Up to date
```

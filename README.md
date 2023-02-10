# Get-CUOneDriveStatus
A function that grabs the latest version of Rodneyviana's "[Get-ODStatus](https://github.com/rodneyviana/ODSyncService)" function and uses My "[PSRunAsCurrentUser](https://github.com/AlecMcCutcheon/PSRunAsCurrentUser)" function as a compatibility layer of sorts. Which allows it to work as the (User, Admin or even System) account. Note: If you are running it as Administrator or System, keep in mind that a user must be logged into the machine in order for this to work.

Use the following One-liner to Import the function into the current session: 

```
iex ((New-Object System.Net.WebClient).DownloadString("https://tinyurl.com/Get-CUOneDriveStatus"));
```

# Usage:

As System:
```
PS C:\WINDOWS\system32> iex ((New-Object System.Net.WebClient).DownloadString("https://tinyurl.com/Get-CUOneDriveStatus"));

PS C:\WINDOWS\system32> (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator);
True

PS C:\WINDOWS\system32> whoami;
nt authority\system

PS C:\WINDOWS\system32> (Get-CUOneDriveStatus).StatusString;
Up to date
Up to date
```
```
PS C:\WINDOWS\system32> iex ((New-Object System.Net.WebClient).DownloadString("https://tinyurl.com/Get-CUOneDriveStatus"));

PS C:\WINDOWS\system32> (Get-CUOneDriveStatus -Type Business).UserName
AzureAD\AlecMcCutcheon
```
As User:
```
PS C:\Users\AlecMcCutcheon\Desktop> iex ((New-Object System.Net.WebClient).DownloadString("https://tinyurl.com/Get-CUOneDriveStatus"));

PS C:\Users\AlecMcCutcheon\Desktop> (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator);
False

PS C:\Users\AlecMcCutcheon\Desktop> whoami
azuread\alecmccutcheon

PS C:\Users\AlecMcCutcheon\Desktop> (Get-CUOneDriveStatus).StatusString;
Up to date
Up to date
```

# Syntax:

"Get-CUOneDriveStatus" is basicly just a compatibility wrapper for "Get-ODStatus", so all of the same parameters for the original can be used as you would expect.

```
Get-CUOneDriveStatus [-Type <type-Name>] [-ByPath <path>] [CLSID <guid>]
             [-IncludeLog] [-Verbose]

Or
Get-CUOneDriveStatus -OnDemandOnly [-Type <type-Name>] [-IncludeLog] [-Verbose]
```
# Where:
```
-Type <type>       Only returns if Service Type matches <type>
                   Example: Get-CUOneDriveStatus -Type Personal

-ByPath <path>     Only checks a particular folder or file status
                   Example: Get-CUOneDriveStatus -Path "$env:OneDrive\docs"

-CLSD <guid>       Verify only a particular GUID (not used normally)
                   Example: Get-CUOneDriveStatus -CLSD A0396A93-DC06-4AEF-BEE9-95FFCCAEF20E

-IncludeLog        If present will save a log file on the temp folder

-Verbose           Show verbose information

-OnDemandOnly      Normally On Demand is only tested as a fallback, when
                   -OnDemandOnly is present it goes directly to 
                   On Demand status. This may resolve flicker issues
```
# Alias:
```
Get-CUODStatus
```

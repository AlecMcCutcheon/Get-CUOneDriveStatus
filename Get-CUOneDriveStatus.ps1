Function Get-CUOneDriveStatus {

  [cmdletbinding(DefaultParameterSetName="OnDemandOnly")]
  param(
    [Parameter(ParameterSetName='ByPathOrCLSID', Mandatory=$false)]
    [string]$ByPath,

    [Parameter(ParameterSetName='ByPathOrCLSID', Mandatory=$false)]
    [string]$CLSID,

    [Parameter(ParameterSetName='OnDemandOnly', Mandatory=$false)]
    [switch]$OnDemandOnly,

    [Parameter(ParameterSetName='OnDemandOnly', Mandatory=$false)]
    [Parameter(ParameterSetName='ByPathOrCLSID', Mandatory=$false)]
    [string]$Type,

    [Parameter(ParameterSetName='OnDemandOnly', Mandatory=$false)]
    [Parameter(ParameterSetName='ByPathOrCLSID', Mandatory=$false)]
    [switch]$IncludeLog
  )

  $Command = "Get-ODStatus";
  if ($ByPath) {$Command += " -ByPath $ByPath";};
  if ($CLSID) {$Command += " -CLSID $CLSID";};
  if ($OnDemandOnly) {$Command += " -OnDemandOnly";};
  if ($Type) {$Command += " -Type $Type";};
  if ($IncludeLog) {$Command += " -IncludeLog";};
  if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {$Command += " -Verbose";};

  if (((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    iex ((New-Object System.Net.WebClient).DownloadString("https://tinyurl.com/PSRunAsCurrentUser"));
    $OneDriveSync = [scriptblock]::Create('Import-Module ([System.Reflection.Assembly]::Load((Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/rodneyviana/ODSyncService/releases/latest/download/OneDriveLib.dll").content)) -ErrorAction SilentlyContinue > $null;' + " $Command|ConvertTo-Json;")
    $Result = (PSRunAsCurrentUser -ScriptBlock $OneDriveSync | ConvertFrom-Json).Value
  }else{
    Import-Module ([System.Reflection.Assembly]::Load((Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/rodneyviana/ODSyncService/releases/latest/download/OneDriveLib.dll").content)) -ErrorAction SilentlyContinue > $null;
    $Result = Invoke-Expression "$Command";
  };

return $Result

}

Set-Alias -Name Get-CUODStatus -Value Get-CUOneDriveStatus;
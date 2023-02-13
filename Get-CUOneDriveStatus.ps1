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
    [switch]$IncludeLog,

    [Parameter(ParameterSetName='OnDemandOnly', Mandatory=$false)]
    [Parameter(ParameterSetName='ByPathOrCLSID', Mandatory=$false)]
    [switch]$ForceFallback
  )

  $Command = "Get-ODStatus";
  if ($ByPath) {$Command += " -ByPath $ByPath";};
  if ($CLSID) {$Command += " -CLSID $CLSID";};
  if ($OnDemandOnly) {$Command += " -OnDemandOnly";};
  if ($Type) {$Command += " -Type $Type";};
  if ($IncludeLog) {$Command += " -IncludeLog";};
  if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {$Command += " -Verbose";};

  if (((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    iex ((New-Object System.Net.WebClient).DownloadString("https://rawcdn.githack.com/AlecMcCutcheon/PSRunAsCurrentUser/b419b135641597982a2a4fa38e27502cde172584/PSRunAsCurrentUser.ps1"));
    $OneDriveSync = [scriptblock]::Create('Import-Module ([System.Reflection.Assembly]::Load((Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/rodneyviana/ODSyncService/releases/latest/download/OneDriveLib.dll").content)) -ErrorAction SilentlyContinue > $null;' + " $Command|ConvertTo-Json;");
    $PSRunAsCurrentUser = 'PSRunAsCurrentUser -ScriptBlock $OneDriveSync';
    if ($ForceFallback) {$PSRunAsCurrentUser += " -ForceFallback";};
    $Result = (Invoke-Expression "$PSRunAsCurrentUser" | ConvertFrom-Json).Value
  }else{
    Import-Module ([System.Reflection.Assembly]::Load((Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/rodneyviana/ODSyncService/releases/latest/download/OneDriveLib.dll").content)) -ErrorAction SilentlyContinue > $null;
    $Result = Invoke-Expression "$Command";
  };

return $Result

}

Set-Alias -Name Get-CUODStatus -Value Get-CUOneDriveStatus;

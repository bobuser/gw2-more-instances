If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}
# Now running elevated so launch the script:

$username = 'ENTER NAME OF LOCAL WINDOWS USER ACOUNT HERE'
$password = 'ENTER PASSWORD OF LOCAL WINDOWS USER ACCOUNT HERE'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username, $securePassword

$gw2path = $PSScriptRoot
Set-Location $gw2path
$gw2exe = Join-Path $gw2path "Gw2-64.exe"
$han = "Handle.exe"
$hanexe = Join-Path $gw2path $han
& $hanexe -accepteula -a "AN-Mutex-Window-Guild Wars 2" | ? { $_ -match 'pid' } | %{ $p = ($_ -split '\s+')[2]; $c = ($_ -split '\s+')[5]; $c = $c -replace ':', ''; & $hanexe -p $p -c $c -y}
Start-Process  $gw2exe -Credential $Credential

#Read-Host "Pulse una tecla"
echo "++++++++++++++++++++Inicializando variables++++++++++++++++++++++++++++++++++++++++++"
$var=Get-ExecutionPolicy
$PartitionDiskWork="D:"
$DirProgramas="D:\Programas"
$wifi1="WIFI-WONKA"
$wifi2="WINTERFELL"
$pwWifi1="ilo21790987*+"
$pwWifi2="ioU1ZQHvt*U%"
$UserName="JBRAN"
$Email="jhonbrandom@gmail.com"
$DirDatos=$null
$DirTemp= $null
$DirRepositoriosGit="repositoriosGit"
#Read-Host "Pulse una tecla"

echo "++++++++++++++++++++Habilitando politicas para ejecucion de comandos en el servidor++++++++++++++++++++++++++++++++++++++++++"
if ( $var -eq "Restricted" )
{
    Set-ExecutionPolicy AllSigned
    Set-ExecutionPolicy Bypass -Scope Process -Force
    $var=Get-ExecutionPolicy
    echo $var
}


echo "++++++++++++++++++++Determinando Directorios++++++++++++++++++++++++++++++++++++++++++"


if((Test-Path $PartitionDiskWork)) {
	echo "Existe"
} else
{
    echo "$PartitionDiskWork No Existe"
    $PartitionDiskWork = (Read-Host "Digite la letra de la partición en la cual desea instalar los programas").ToUpper().Trim(' ')
    echo "$PartitionDiskWork  $DirProgramas"
}

$DirProgramas= $PartitionDiskWork + "\Programas"
$DirDatos=$PartitionDiskWork + "\Datos"
$DirTemp=$PartitionDiskWork + "\Temp"

if(-not (Test-Path $DirProgramas) ) {
	New-Item $DirProgramas -Type Directory -Force  
}

echo "++++++++++++++++++++Alistamiento para el procesamiento++++++++++++++++++++++++++++++++++++++++++"
if(-not (Test-Path $DirTemp)) {
	New-Item $DirTemp -Type Directory -Force  
}
cd $DirTemp

#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

echo "++++++++++++++++++++Instalar administrador de programas++++++++++++++++++++++++++++++++++++++++++"

$Program="chocolatey"
if(-not (Test-Path $DirProgramas\$Program) ) {
	New-Item $DirProgramas\$Program -Type Directory -Force  
}

#Read-Host "Check Point  $DirProgramas\$Program"

$chocolateyBin = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "Machine")# + "\bin"


if(-not (Test-Path $chocolateyBin)) {
    Write-Output "Environment variable 'ChocolateyInstall' was not found in the system variables. Attempting to find it in the user variables..."
    #Read-Host "Check Point  $chocolateyBin"
    
    $chocolateyBin = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "User")# + "\bin"
    if(-not (Test-Path $chocolateyBin)) {
        [Environment]::SetEnvironmentVariable("ChocolateyInstall", $chocolateyBin, "User")
        [Environment]::SetEnvironmentVariable("ChocolateyInstall", $chocolateyBin, 'Machine')
        iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) -Verbose
    }
    
}
#Read-Host "Check Point  $chocolateyBin"

<#
$cinst = "$chocolateyBin\cinst.exe"
$choco = "$chocolateyBin\choco.exe"

if (-not (Test-Path $cinst) -or -not (Test-Path $choco)) {
    #throw "Chocolatey was not found at $chocolateyBin."
    #Remove-Item C:\ProgramData\chocolatey -Recurse
    Set-Variable -Name "ChocolateyInstall" -Value ("$DirProgramas\$Program")
    New-Item $ChocolateyInstall -Type Directory -Force
    [Environment]::SetEnvironmentVariable("ChocolateyInstall", $ChocolateyInstall, "User")
    [Environment]::SetEnvironmentVariable("ChocolateyInstall", $ChocolateyInstall, 'Machine')
    $Env:ChocolateyInstall=$DirProgramas
    #[Environment]::SetEnvironmentVariable("ChocolateyInstall", '', "User")
    #[Environment]::SetEnvironmentVariable("ChocolateyInstall", '', 'Machine')
    $Env:ChocolateyInstall=''
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) -Verbose
    
}#>
choco --version

echo "Instalar programas"
#Read-Host "Instalar programas with choco"
F:\Arquitectura\repositoriosGit\setupWindows10\chocoInstalls.ps1 -ParamDirProgramas $DirProgramas -ParamDirTemp $DirTemp -ParamUserName $UserName -ParamEmail $Email


echo "++++++++++++++++++++Configurar acciones al cerrar la tapa++++++++++++++++++++++++++++++++++++++++++"
#Bateria
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
# Red electrica
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

echo "++++++++++++++++++++Configurar Red WIFI++++++++++++++++++++++++++++++++++++++++++"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name wifiprofilemanagement -Confirm:$false



$ErrorActionPreference= "SilentlyContinue"
#Get-WiFiProfile -ProfileName WIFI-WONKA
if ( Get-WiFiProfile -ProfileName WIFI-WONKA )
{
    echo "Perfil WIFI existente"
} else
{
    New-WiFiProfile -ProfileName $wifi1 -ConnectionMode auto -Authentication WPA2PSK -Password ($secureString1 = convertto-securestring $pwWifi1 -asplaintext -force) -Encryption AES


    $cur_strength=(netsh wlan show interfaces) -Match '^\s+Signal' -Replace '^\s+Signal\s+:\s+','' | Out-String
    if ( -not [string]::IsNullOrEmpty( $cur_strength.Trim(' ') ) )
    {
        If ($cur_strength.replace('%','') –le 30)
        {
            New-WiFiProfile -ProfileName $wifi2 -ConnectionMode manual -Authentication WPA2PSK -Password ($secureString2 = convertto-securestring $pwWifi2 -asplaintext -force) -Encryption AES
            Connect-WiFiProfile -ProfileName $wifi2
        }
    } else
    {
        $cur_strength=(netsh wlan show interfaces) -Match '^\s+Señal' -Replace '^\s+Señal\s+:\s+','' | Out-String
        if ( -not [string]::IsNullOrEmpty( $cur_strength.Trim(' ') ) )
        {
            If ($cur_strength.replace('%','') –le 30)
            {
                New-WiFiProfile -ProfileName $wifi2 -ConnectionMode manual -Authentication WPA2PSK -Password ($secureString2 = convertto-securestring $pwWifi2 -asplaintext -force) -Encryption AES
                Connect-WiFiProfile -ProfileName $wifi2
            }
        } else
        {
            echo "No se conecto a ninguna Red"
        }
    }
}

$ErrorActionPreference="Continue"





echo "++++++++++++++++++++Configurar Repositorios++++++++++++++++++++++++++++++++++++++++++"

#echo $DirDatos + "\$DirRepositoriosGit"


if(-not (Test-Path $DirDatos))
{
    New-Item $DirDatos -Type Directory -Force    
}

$fullPathDirRepositoriosGit= "$DirDatos" + "\$DirRepositoriosGit"
#Read-Host "Punto validacion +++++++++++++++ $fullPathDirRepositoriosGit"
#exit

if(-not (Test-Path $fullPathDirRepositoriosGit))
{
    New-Item $fullPathDirRepositoriosGit -Type Directory -Force    
}

cd $fullPathDirRepositoriosGit
Get-Location

echo $fullPathDirRepositoriosGit

git clone https://jhonbrandom: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@github.com/west-bank/awsarchitect.git
Read-Host "Punto validacion +++++++++++++++"
exit

git clone https://jbranbocc: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@github.com/bocc-principal/Arquitectura.git




<#
If ($cur_strength.replace('%','') –le 30)
{
Add-Type -AssemblyName System.Windows.Forms
$global:balmsg = New-Object System.Windows.Forms.NotifyIcon
$path = (Get-Process -id $pid).Path
$balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
$balmsg.BalloonTipText = “The Wi-Fi signal strength is less than $cur_strength Go back to the access point!”
$balmsg.BalloonTipTitle = "Attention $Env:USERNAME"
$balmsg.Visible = $true
$balmsg.ShowBalloonTip(10000)
}

#$cur_strength=(netsh wlan show interfaces) -Match '^\s+Señal' -Replace '^\s+señal\s+:\s+','' | Out-String

Get-PhysicalDisk
Get-Partition
Get-Volume
Get-WmiObject Win32_LogicalDisk

choco list --local-only --exact python --trace
#>

<#
#$secureString1 = convertto-securestring "ilo21790987*+" -asplaintext -force
#$secureString2 = convertto-securestring "ioU1ZQHvt*U%" -asplaintext -force
#echo $secureString1 $secureString2

#New-WiFiProfile -ProfileName $wifi1 -ConnectionMode auto -Authentication WPA2PSK -Password $secureString1 -Encryption AES
#New-WiFiProfile -ProfileName $wifi2 -ConnectionMode manual -Authentication WPA2PSK -Password $secureString2 -Encryption AES
#New-WiFiProfile -ProfileName "WINTERFELL" -ConnectionMode manual -Authentication WPA2PSK -Password ($secureString2 = convertto-securestring "ioU1ZQHvt*U%" -asplaintext -force) -Encryption AES
#New-WiFiProfile -ProfileName "WIFI-WONKA" -ConnectionMode auto -Authentication WPA2PSK -Password $secureString1 -Encryption AES
#Get-WiFiProfile -ProfileName "WIFI-WONKA"
#Get-WiFiProfile -ProfileName "WIFI-WONKA" -ClearKey | select Password
#Connect-WiFiProfile -ProfileName "WINTERFELL"
$var=Connect-WiFiProfile -ProfileName ("WIFI-WONKA")
#>



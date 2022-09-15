param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $ParamDirProgramas,

    [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $ParamDirTemp,

    [Parameter(Mandatory=$True, Position=2, ValueFromPipeline=$false)]
    [System.String]
    $ParamUserName,

    [Parameter(Mandatory=$True, Position=3, ValueFromPipeline=$false)]
    [System.String]
    $ParamEmail,

    [Parameter(Mandatory=$True, Position=4, ValueFromPipeline=$false)]
    [System.String]
    $ParamPartitionDiskWork,

    [Parameter(Mandatory=$True, Position=5, ValueFromPipeline=$false)]
    [System.String]
    $ParamNameDirProgramas,


    [Parameter(Mandatory=$false, Position=6, ValueFromPipeline=$false)]
    [System.String]
    $Param2
)

echo $ParamDirProgramas
#Read-Host "Pulse una tecla. Directorio programas"

$Programa="ChocolateyGUI"
choco search $Programa
choco install $Programa -y


$Programa="googlechrome"
Echo "Instalando $Programa"
choco install $Programa -y
if(-not (Test-Path $ParamDirProgramas\$Programa)) {
    New-Item $ParamDirProgramas\$Programa -Type Directory -Force
    choco install "$Programa" -y --params "'/AllUsers /NoAutoStart --install-arguments='/DIR=D:\Programas\""$Programa""''"
}


$Programa="microsoft-teams"
Echo "Installing $Programa"
choco install "$Programa.install" -y --params "'/AllUsers /NoAutoStart --install-arguments='/DIR=D:\Programas''"

#choco uninstall $Programa -y

$Programa="obs-studio"
Echo "Installing $Programa"
if(-not (Test-Path $ParamDirProgramas\$Programa)) {
    New-Item $ParamDirProgramas\$Programa -Type Directory -Force
    choco install "$Programa.install" -y --params "--install-arguments='/DIR=D:\Programas'"
}


#--install-directory=$DirProgramas


$Programa="firefox"
Echo "Installing $Programa"
#Read-Host "Pulse una tecla"
if(-not (Test-Path $ParamDirProgramas\$Programa)) {
    New-Item $ParamDirProgramas\$Programa -Type Directory -Force
}

if(-not (Test-Path $ParamDirProgramas\$Programa\firefox.exe)) {
    choco install "$Programa" --force -y --params "/InstallDir:$ParamDirProgramas\$Programa /NoDesktopShortcut" 
}

$Programa="office365business"
Echo "Installing $Programa"
choco install $Programa -y

$Programa="gh"
Echo "Installing $Programa"
choco install $Programa -y


$Programa="7zip"
Echo "Installing $Programa"
choco install "$Programa.portable" -y


$Programa="drawio"
Echo "Installing $Programa"
choco install "$Programa" -y

$Programa="git"
Echo "Installing $Programa"
if(-not (Test-Path $ParamDirProgramas\$Programa)) {
    New-Item $ParamDirProgramas\$Programa -Type Directory -Force
}

if(-not (Test-Path $ParamDirTemp\"$Programa.installparams")) {
    New-item -Path $ParamDirTemp -Name "$Programa.installparams" -ItemType "file" -Value "[Setup]
    Lang=default
    Dir=$ParamDirProgramas\$Programa
    Group=Git
    NoIcons=0
    SetupType=default
    Components=ext,ext\shellhere,ext\guihere,gitlfs,assoc,autoupdate
    Tasks=
    EditorOption=
    CustomEditorPath=
    PathOption=Cmd
    SSHOption=OpenSSH
    TortoiseOption=false
    CURLOption=WinSSL
    CRLFOption=LFOnly
    BashTerminalOption=ConHost
    PerformanceTweaksFSCache=Enabled
    UseCredentialManager=Enabled
    EnableSymlinks=Disabled
    EnableBuiltinInteractiveAdd=Disabled"   
}


Set-Variable -Name "GIT_EXEC_PATH" -Value ([Environment]::GetEnvironmentVariable("ChocolateyInstall", "Machine") -or [Environment]::GetEnvironmentVariable("ChocolateyInstall", "User"))
if( -not ($GIT_EXEC_PATH) )
{
    # get latest download url for git-for-windows 64-bit exe
    $git_url = "https://api.github.com/repos/git-for-windows/git/releases/latest"
    $asset = Invoke-RestMethod -Method Get -Uri $git_url | % assets | where name -like "*64-bit.exe"
    # download installer
    $installer = "$env:temp\$($asset.name)"
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installer
    # run installer
    $git_install_inf = (Get-Location).Path + "\$Programa.installparams"
    echo " full path archivo parametros instalacion Git" $git_install_inf
    #Read-Host "Fin instalación programas"
    $install_args = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$git_install_inf"""
    Start-Process -FilePath $installer -ArgumentList $install_args -Wait
    $GIT_EXEC_PATH="$ParamDirProgramas\$Programa\mingw64\libexec\git-core"
    Set-Variable -Name "GIT_EXEC_PATH" -Value ($GIT_EXEC_PATH)
    [Environment]::SetEnvironmentVariable("GIT_EXEC_PATH", $GIT_EXEC_PATH, "User")
    [Environment]::SetEnvironmentVariable("GIT_EXEC_PATH", $GIT_EXEC_PATH, 'Machine')
    git config --global user.name "$ParamUserName"
    git config --global user.email "$ParamEmail"
}


$Programa="homebank"
Echo "Installing $Programa"
if(-not (Test-Path $ParamDirProgramas\$Programa)) {
    New-Item $ParamDirProgramas\$Programa -Type Directory -Force
}
choco install "$Programa" -y --install-arguments='/DIR=""D:\Programas\$Programa""'


$Programa="vscode"
Echo "Installing $Programa"
if(-not (Test-Path $ParamDirProgramas\$Programa)) {
    New-Item $ParamDirProgramas\$Programa -Type Directory -Force
}
choco install $Programa -y --params "/NoDesktopIcon /DontAddToPath /NoQuicklaunchIcon" --ia="/DIR=D:\\Programas\\vscode"


$Programa="terraform"
Echo "Installing $Programa"
if(-not (Test-Path $ParamDirProgramas\$Programa)) {
    New-Item $ParamDirProgramas\$Programa -Type Directory -Force
}
choco install $Programa -y --params "/NoDesktopIcon /DontAddToPath /NoQuicklaunchIcon" --ia="/DIR=$ParamPartitionDiskWork\\$ParamNameDirProgramas\\$Programa"
echo "/DIR=$ParamPartitionDiskWork\\$ParamNameDirProgramas\\$Programa"

$Programa="adobereader"
Echo "Installing $Programa"
if(-not (Test-Path $ParamDirProgramas\$Programa)) {
    New-Item $ParamDirProgramas\$Programa -Type Directory -Force
}
choco install $Programa -y --params '"/UpdateMode:4"' --ia="/DIR=$ParamPartitionDiskWork\\$ParamNameDirProgramas\\$Programa"
echo "/DIR=$ParamPartitionDiskWork\\$ParamNameDirProgramas\\$Programa"




Read-Host "Pulse una tecla**********************************************"
#--params "--install-arguments='/DIR=D:\Programas\""$Programa""'"



#Read-Host "Pulse una tecla"
<#
choco install office365proplus --params '/ConfigPath:c:\myConfig.xml'
#>
#Read-Host "Fin instalación programas"
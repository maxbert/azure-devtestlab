﻿Param(
    # comma or semicolon separated list of chocolatey packages.
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory=$True)]
    [string] $packageList,

    [Parameter(Mandatory=$True)]
    [string] $username,

    [Parameter(Mandatory=$True)]
    [string] $password
)

$secPassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$($username)", $secPassword)

$command = $file = $PSScriptRoot + "\ChocolateyPackageInstaller.ps1"

Enable-PSRemoting –force

# Work around a bug in the Squirrel installer
Invoke-Command -Credential $credential -ComputerName $env:COMPUTERNAME -ScriptBlock {New-Item -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify"  -type directory -force -ErrorAction Continue}

Invoke-Command -FilePath $command -Credential $credential -ComputerName $env:COMPUTERNAME -ArgumentList $packageList
Disable-PSRemoting -Force
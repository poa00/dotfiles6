﻿if ($PSVersionTable.PSVersion -lt 6.0.0) {
    $IsWindows = $true
    $IsLinux = $false
    $IsMacOS = $false
    $IsCoreCLR = $false
}

if ($IsWindows) {
    Set-Location -Path $env:SystemDrive\
}

Clear-Host

$Error.Clear()

$poshGitModule = Get-Module posh-git -ListAvailable

if ($poshGitModule) {
    Import-Module -Name posh-git

    function prompt {

        if (-not(git rev-parse --is-inside-work-tree 2> $null)) {
            $prompt = "PS $($executionContext.SessionState.Path.CurrentLocation)$('>') "
        }
        else {
            $prompt = Write-Prompt 'PS ' -ForegroundColor ([ConsoleColor]::Green)
            $prompt += Write-Prompt "$($executionContext.SessionState.Path.CurrentLocation)" -ForegroundColor ([ConsoleColor]::Yellow)
            $prompt += Write-VcsStatus
            $prompt += "`n$ "
        }

        $prompt

    }

    $GitPromptSettings.BeforeStatus = '('
    $GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Cyan
    $GitPromptSettings.AfterStatus = ')'
    $GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Cyan
}

$PSDefaultParameterValues += @{
    'Out-Default:OutVariable' = 'LastResult'
    'Out-File:Encoding' = 'utf8'
    'Export-Csv:NoTypeInformation' = $true
    'ConvertTo-Csv:NoTypeInformation' = $true
    'Receive-Job:Keep' = $true
    'Install-Module:AllowClobber' = $true
    'Install-Module:Force' = $true
    'Install-Module:SkipPublisherCheck' = $true
    'Group-Object:NoElement' = $true
    'Find-Module:Repository' = 'PSGallery'
    'Install-Module:Repository' = 'PSGallery'
}

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineKeyHandler -Chord F2 -Function SwitchPredictionView
Set-PSReadLineKeyHandler -Chord Enter -Function ValidateAndAcceptLine
Set-PSReadLineKeyHandler -Chord Escape -Function BackwardKillInput
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+D2 -Function MenuComplete

$StartupVars = @()
$StartupVars = Get-Variable | Select-Object -ExpandProperty Name

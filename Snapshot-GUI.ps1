<#
.SYNOPSIS
A GUI for Snapshot-Management.ps1

.DESCRIPTION
Allows for quick selection of regular vmware maintenance tasks for OGELP

.EXAMPLE
./Snapshot-GUI.ps1

.NOTES
AUTHORS
Sawyer Peacock - OGELP SysAdmin

FIXES
Version 1.0
Initial Commit

Version 2.0
- Split GUI and functions
- Fixed some spelling mistakes

Version 2.0.1
- Fixed bad boolean check
#>
############### Functions ############### 
function PromptEnviroment() {
    $Title = "GMS Environment"
    $Info = "Please select the environment to manage snapshots"
    $options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Production", "&Lab", "&Quit")
    [int]$defaultchoice = 2
    $opt = $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)
    switch($opt)
    {
        0 { 
            $Script:ServerName = "ONTORVMM02.BLACKJACK.GCGAMING.COM"
            $Script:VMListFile = "..\GMS-Servers\OGELP\Production.txt"
            }
        1 { 
            $Script:ServerName = "ONBRMVMM01.blackjack.gcgaming.com"
            $Script:VMListFile = "..\GMS-Servers\OGELP\Lab.txt"
            }
        2 { 
            Write-Host "Good Bye!!!" -ForegroundColor Green 
            Return
        }
    }
}

function PromptAction() {
    # Select What To Do
    $Title = "Snapshot Action"
    $Info = "How would you like to process snapshots"
    $options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Create", "&Delete", "&Quit")
    [int]$defaultchoice = 2
    $Script:VMAction = $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)
}

############### Main Program ############### 

$ServerName = $null
$VMListFile = $null
$VMAction = $null

PromptEnviroment
PromptAction

if ($ServerName -and $VMListFile -and ($VMAction -ne $null)) {
    switch($VMAction)
    {
        0 {
            ./Snapshot-Management -ServerName $ServerName -VMListFile $VMListFile -Create
        }
        1 {
            ./Snapshot-Management -ServerName $ServerName -VMListFile $VMListFile -Delete
        }
    }    
}
else {
    Write-Warning -Message "Missing important values, so gettings a coffee while you figure it out"
}
<#
.SYNOPSIS
Automate the creation and removal of snapshots in a VMWare enviroment

.DESCRIPTION
This script will allow the user to loop through multiple VMs on a server and create or delete snapshots; primarily used during server maintenance routines

.EXAMPLE

.NOTES
AUTHORS
Sawyer Peacock - OGELP SysAdmin

FIXES
Version 1.0
Initial Commit
#>
Import-Module -Name "VMware.VimAutomation.Core"

############### Functions ############### 
function PromptEnviroment() {
    $Title = "GMS Enviroment"
    $Info = "Please select the enviroment to manage snapshots"
    $options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Production", "&Lab", "&Quit")
    [int]$defaultchoice = 2
    $opt = $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)
    switch($opt)
    {
        0 { 
        
            $Script:ServerName = "ONTORVMM02.BLACKJACK.GCGAMING.COM"
            $Script:VMListFile = "ServersProd.txt"
            }
        1 { 
            $Script:ServerName = "ONBRMVMM01.blackjack.gcgaming.com"
            $Script:VMListFile = "ServersLab.txt"
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

function SnapShotCreate(){
    foreach($vm in Get-VM $VMlist) {
        Write-Host "Creating Snapshot for $($vm.name)"
        New-Snapshot -VM $vm -Memory:$false -Quiesce:$true -Name "$($vm.Name)_BEFOREPATCH" -description "$($vmserver.User) Patching"
	    # Start-Sleep -s 5
    }
}

function SnapShotDelete() {
    foreach($vm in Get-VM $VMlist) {
        Write-Host "Deleting Snapshot for $($vm.name)"
        Get-Snapshot -VM $vm |
        Remove-Snapshot -RemoveChildren:$true -Confirm:$false
        
	    # Start-Sleep -s 5
    }
}

############### Main Program ############### 

$ServerName = $null
$VMListFile = $null
$VMAction = $null

PromptEnviroment
PromptAction

$VMlist = Get-Content -Path:$VMListFile
$vmserver = Connect-VIServer -Server $ServerName -Protocol https
switch($VMAction)
{
    0 {
        SnapShotCreate
    }
    1 {
        SnapShotDelete
    }
}
Disconnect-VIServer -Confirm:$false
<#
.SYNOPSIS
Automate the creation and removal of snapshots in a VMWare environment

.DESCRIPTION
This script will allow the user to loop through multiple VMs on a server and create or delete snapshots; primarily used during server maintenance routines

.PARAMETER ServerName
Specifies the ESXi host or vSphere server to connect to

.PARAMETER VMListFile
Specifies the txt file with the list of VM names (1 per line) that we would like to manage snapshots for

.PARAMETER Create
Tells the script that you want to create a snapshot for the VMs

.PARAMETER Delete
Tells the script that you want to DELETE the VM snapshots.
NOTE: ALL VM shapshots are deleted; not just the one created by the script

.EXAMPLE
./Snapshot-Management.ps1 -ServerName vmhost.example.com -VMListFile servernames.txt -Create

.EXAMPLE
./Snapshot-Management.ps1 -ServerName vmhost.example.com -VMListFile servernames.txt -Delete

.NOTES
AUTHORS
Sawyer Peacock - OGELP SysAdmin

FIXES
Version 1.0
Initial Commit

Version 2.0
Split GUI and functions
#>
param (
	[string]$ServerName = $null,
	[string]$VMListFile = $null,
    [switch]$Create = $false,
    [switch]$Delete = $false
)

Import-Module -Name "VMware.VimAutomation.Core"

############### Functions ############### 
function SnapShotCreate(){
    foreach($vm in Get-VM $VMlist) {
        Write-Host "Creating Snapshot for $($vm.name)"
        New-Snapshot -VM $vm -Memory:$false -Name "$($vm.Name)_BEFOREPATCH" -description "$($vmserver.User) Patching"
    }
}

function SnapShotDelete() {
    foreach($vm in Get-VM $VMlist) {
        Write-Host "Deleting Snapshot for $($vm.name)"
        Get-Snapshot -VM $vm |
        Remove-Snapshot -RemoveChildren:$true -Confirm:$false
    }
}

############### Main Program ############### 

$VMlist = Get-Content -Path:$VMListFile
$vmserver = Connect-VIServer -Server $ServerName -Protocol https

if ($Delete) { SnapShotDelete }
if ($Create) { SnapShotCreate }

Disconnect-VIServer -Confirm:$false
<#
.SYNOPSIS
Automate the creation and removal of snapshots in a VMWare environment

.DESCRIPTION
This script will allow the user to loop through multiple VMs on a server and create or delete snapshots; primarily used during server maintenance routines.
If both the delete and the create options are selected, it will delete all snapshots before creating new ones

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

Version 2.0.1
- Changed ServerName and VMListFile to be manditory
#>
param (
    [Parameter(Mandatory=$True)]
	[string]$ServerName = $null,
    [Parameter(Mandatory=$True)]
	[string]$VMListFile = $null,
    [switch]$Create = $false,
    [switch]$Delete = $false
)

Import-Module -Name "VMware.VimAutomation.Core"

############### Functions ############### 
function SnapShotCreate(){
    foreach($vm in Get-VM -Name @(GetServerList)) {
        Write-Host "Creating Snapshot for $($vm.name)"
        New-Snapshot -VM $vm -Memory:$false -Name "$(Get-Date -Format s) Patching" -description "$($vmserver.User) created a snapshot"
    }
}

function SnapShotDelete() {
    foreach($vm in Get-VM -Name @(GetServerList)) {
        Write-Host "Deleting Snapshot for $($vm.name)"
        Get-Snapshot -VM $vm |
        Remove-Snapshot -RemoveChildren:$true -Confirm:$false
    }
}

function GetServerList() {
    $serverlist = @()
    foreach($enty in Get-Content -Path:$VMListFile) {
        if ($enty.Trim() -eq "") {
            # Ignore the line cause it's blank
        }
        elseif ($enty.SubString(0,1) -eq "#") {
            # Ignore the line cause it's a comment
        }
        else {
            # Line isn't a comment or blank, must be a server
            $serverlist += $enty
        }
    }
    return $serverlist
}

############### Main Program ############### 

$vmserver = Connect-VIServer -Server $ServerName -Protocol https

# Delete before Create allows the user to use both parameters to ensure all existing snapshots are deleted before creating new ones
if ($Delete) { 
    Write-Host "[Deleting Snapshots]" -BackgroundColor Green -ForegroundColor Yellow
    SnapShotDelete 
    }
if ($Create) { 
    Write-Host "[Creating Snapshots]" -BackgroundColor Green -ForegroundColor Yellow
    SnapShotCreate 
    }

Disconnect-VIServer -Confirm:$false
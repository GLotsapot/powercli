$vmserver = Connect-VIServer -Server ONBRMVMM01.blackjack.gcgaming.com

#VM Server List
$vmlist = Get-Content ServersLab.txt

foreach($vm in Get-VM $VMlist) {
    New-Snapshot -VM $vm -Memory:$false -Name "$($vm.Name)_BEFOREPATCH" -description "$($vmserver.User) Patching"
	# Start-Sleep -s 5
}

Disconnect-VIServer -Confirm:$false
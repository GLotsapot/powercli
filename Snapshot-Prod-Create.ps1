$vmserver = Connect-VIServer -Server ONTORVMM02.BLACKJACK.GCGAMING.COM

#VM Server List
$vmlist = Get-Content ServersProd.txt

foreach($vm in Get-VM $VMlist) {
    Write-Host "Snapshotting $($vm.Name)"
    New-Snapshot -VM $vm -Memory:$false -Name "$($vm.Name)_BEFOREPATCH" -description "$($vmserver.User) Patching"
	# Start-Sleep -s 5
}

Disconnect-VIServer -Confirm:$false
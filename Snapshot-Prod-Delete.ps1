Connect-VIServer -Server ONTORVMM02.BLACKJACK.GCGAMING.COM

#VM Server List
$vmlist = Get-Content ServersProd.txt

foreach($VM in $VMlist) {
	Write-Host "Removing Snapshot on $($vm.Name)"
    Get-Snapshot -VM $vm |
    Remove-Snapshot -RemoveChildren:$true -Confirm:$false
	# Start-Sleep -s 5
}

Disconnect-VIServer -Confirm:$false
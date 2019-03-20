Connect-VIServer -Server ONBRMVMM01.blackjack.gcgaming.com

#VM Server List
$vmlist = Get-Content ServersLab.txt

foreach($VM in $VMlist) {
    Get-Snapshot -VM $vm |
    Remove-Snapshot -RemoveChildren:$true -Confirm:$false
	# Start-Sleep -s 5
}

Disconnect-VIServer -Confirm:$false
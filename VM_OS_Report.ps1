#**************************************************************************************************
#*                                                                                                *
#*          __       _                      _____           _       __     ____             __    *
#*   ____  / /__    (_)___  ____  ____     / ___/__________(_)___  / /_   / __ \____ ______/ /__  *
#*  /_  / / / _ \  / / __ \/ __ \/ __ \    \__ \/ ___/ ___/ / __ \/ __/  / /_/ / __ `/ ___/ //_/  *
#*   / /_/ /  __/ / / /_/ / /_/ / /_/ /   ___/ / /__/ /  / / /_/ / /_   / ____/ /_/ / /__/ ,<     *
#*  /___/_/\___/_/ /\____/\____/\____/   /____/\___/_/  /_/ .___/\__/  /_/    \__,_/\___/_/|_|    *
#*            /___/                                      /_/                                      *
#*                                                                                                *
#**************************************************************************************************
#
# Script Name   : VM_OS_Report.ps1
# Author        : zlejooo
# Created       : 2025-11-20
# Updated       : 2025-11-21
# Version       : 1.0.1
# Description   : Report OS from all Hyper-V VMs
# Requirements  :
#                 - PowerShell 5.1 or later
#                 - Hyper-V module installed
#                 - Administrative privileges on the Hyper-V host
# Notes         :
#                 - Tested on Windows Server 2022 with Hyper-V role
#                 - Output: List of VM names and their Guest OS
#                 - Only for localhost use
#**************************************************************************************************

$HyperVhost = hostname

$vms = Get-VM -ComputerName $HyperVhost | Select-Object Name
$OSReport = foreach ($vm in $vms) {
    $query = "Select * From Msvm_ComputerSystem Where ElementName='$($vm.name)'"
    $vmq = Get-CimInstance -namespace root\virtualization\v2 -query $query -computername $HyperVhost
    $vm_info = Get-CimAssociatedInstance -InputObject $vmq

    [pscustomobject]@{
        VmName  = $vm.name
        GuestOS = ($vm_info | Where-Object GuestOperatingSystem).GuestOperatingSystem
    }
}

$OSReport
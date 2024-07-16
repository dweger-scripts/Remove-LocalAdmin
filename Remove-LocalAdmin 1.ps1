#*********************************************************************
#========================
#Remove-LocalAdmin.ps1
#========================
# This script looks for local administrators on a device and then removes their admin privileges.
# 	It will exclude known/good local admins and only remove the anomalies.
# 	The users removed will be logged to this machine running this script and to the file server.
#-------------------------------------------------
# Usage/Switches
#	If no switch is given, this script will identify all local admins and write them to the log.
#		Example: C:\System\LocalAdmin.ps1
#		Destructive. Removes all bad admins.
#		Example: C:\System\LocalAdmin.ps1
#	-WhatIf
#		Non-Destructive. Test mode. Logs what would happen if the script runs.
#		Example: C:\System\LocalAdmin.ps1 -WhatIf
#-------------------------------------------------
#========================
#Modified: 05.10.2024
#========================
#*********************************************************************
	#-------------------------------------------------
	# Optional Parameters/switches. This has to be the first line in the script.
	#-------------------------------------------------
param (
	[switch]$WhatIf,
	[switch]$Remove,
	[switch]$Count
)
	
	
	#-------------------------------------------------
	# Variables
	#-------------------------------------------------
	# Known good local admins. Excluded from removal.
	$excludedUsers = @('CONTOSO\DOMAIN ADMINS', 'CONTOSO\LocalAdmins', "${ENV:ComputerName}\Administrator", "${ENV:ComputerName}\itsupport")
    #----Logging specific variables
	# Path/name of the log file located on a remote device (typically file server network shared folder).
		$RemoteLogFile = "\\fileserver\logs\RemoveLocalAdmin_log.csv"
	# Where the local log file should be stored.
		$LogFilePath = "C:\temp"
    # $RunTimestamp is the date/time the script was run.
		$RunTimestamp = get-date -Format "MM.dd.yyyy-HH_mm_ss"
	# $LogFileName is the name of the log file.
		$LogFileName = "RemoveLocalAdmin_Log-" + $RunTimestamp + ".csv"
	# $Logfile describes the name of the log file located in the same folder as the script itself.
		$Logfile = Join-Path $LogFilePath $LogFileName
	#-------------------------------------------------


	#-------------------------------------------------
	# This function allows us to write to the log file located at $Logfile.
	#-------------------------------------------------
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,
		
		[Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$AdminUserName,

		[Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Status
    )
 
    [pscustomobject]@{
        Time = (Get-Date -Format "MM/dd/yyyy HH:mm:ss")
        ComputerName = $ComputerName
		AdminUserName = $AdminUserName
		Status = $Status
    } | Export-Csv -Path $Logfile -Append -NoTypeInformation
 }

function Remove-BadAdmins {
	#Write all local Admins to Log.
	Write-Log -ComputerName $ENV:ComputerName -AdminUserName $AllLocalAdmins -Status "Identified"
	#This will remove the bad admin user, check that it successfully removed, then write to the log about it.
	Remove-LocalGroupMember -Group "Administrators" -Member $user
	if ((get-localgroupmember administrators).Name -notcontains $user){Write-Log -ComputerName $ENV:ComputerName -AdminUserName $user -Status "Removed"}
	#Copy the local log to the server's log file.
	if (Test-Path $RemoteLogFile){Get-Content $Logfile |Select-Object -Skip 1|Out-File $RemoteLogFile -Append -Encoding utf8} 
		else {Get-Content $Logfile | Out-File $RemoteLogFile -Encoding utf8}
}
function WhatIf-RemoveBadAdmins {
	#Write all local Admins to Log.
	Write-Log -ComputerName $ENV:ComputerName -AdminUserName $AllLocalAdmins -Status "Identified"
	#Writes to the script log to simulate the remove action.
	Write-Log -ComputerName $ENV:ComputerName -AdminUserName $user -Status "WhatIf-Removed"
	#Copy the local log to the server's log file.
	if (Test-Path $RemoteLogFile){Get-Content $Logfile |Select-Object -Skip 1|Out-File $RemoteLogFile -Append -Encoding utf8} 
		else {Get-Content $Logfile | Out-File $RemoteLogFile -Encoding utf8}
}

#Get all local admins.
$LocalAdmins = (get-localgroupmember administrators).Name
$AllLocalAdmins = $LocalAdmins -join ' '


#Initialize array for bad admins.
$badAdmins = @()

#This will look for admins NOT on our excluded list.
foreach ($user in $LocalAdmins){if ($excludedUsers -notcontains $user){$badAdmins += $user}}

#This will remove all the bad admins.
foreach ($user in $badAdmins){
	if ($WhatIf){ WhatIf-RemoveBadAdmins }
	if ($Remove){ Remove-BadAdmins }
}

$badAdminsCount = $badAdmins.count
$AdminsCount = $AllLocalAdmins.count
if ($WhatIf){Write-Host "WhatIf-Removed $badAdminsCount admins: $badAdmins"}
if ($Remove){Write-Host "Removed $badAdminsCount admins: $badAdmins"}
if ($Count){Write-Host "zCounted $badAdminsCount bad admins. $badAdmins"}
if (!$WhatIf -and !$Remove -and !$Count) {Write-Host "Identified admins: $AllLocalAdmins"}

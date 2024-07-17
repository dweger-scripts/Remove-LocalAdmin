# Remove-LocalAdmin
Removes local admins on a device

## Usage
` .\Remove-LocalAdmin.ps1 `
*script will identify all local admins and write them to the log*

### -WhatIf
` .\Remove-LocalAdmin.ps1 -WhatIf `
*Test mode, logs what would happen if the script runs.*

### -Remove
` .\Remove-LocalAdmin.ps1 -Remove `
*Destructive, removes all bad admins.*

## Deploy from RMM
Most RMMs are a pain, but they usually let you run a Powershell command pretty easily. Here are some one-liners that might help.
Great for RMMs that only let you bring back the last returned output.

### Download the script
`$downloadURI = 'https://raw.githubusercontent.com/dweger-scripts/Remove-LocalAdmin/main/Remove-LocalAdmin.ps1'; $script = 'C:\temp\Remove-LocalAdmin.ps1'; Invoke-WebRequest -URI $downloadURI -Outfile $script `

*This will download the script to the C:\temp folder*

### Run WhatIf
`C:\temp\Remove-LocalAdmin.ps1 -WhatIf; $Logs = get-item C:\temp\RemoveLocalAdminLog* ; Get-content $Logs[-1] -Tail 1`

*This will run the script in WhatIf mode*

### Run Remove
`C:\temp\Remove-LocalAdmin.ps1 -Remove; $Logs = get-item C:\temp\RemoveLocalAdminLog* ; Get-content $Logs[-1] -Tail 1`

*This will run the script in Remove mode*

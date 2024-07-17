# Remove-LocalAdmin
Removes local admins on a device

## Usage
### -WhatIf
` .\Remove-LocalADMIN 1.ps1 -WhatIf `
*Test mode, logs what would happen if the script runs.*

### -Remove
` .\Remove-LocalADMIN 1.ps1 -Remove `
*Place Holder*

### -Count
` .\Remove-LocalADMIN 1.ps1 -Count `
*Place Holder*

## Deploy from RMM
Most RMMs are a pain, but they usually let you run a Powershell command pretty easily. Here are some one-liners that might help.
Great for RMMs that only let you bring back the last returned output.

### Download the script
`$downloadURI = 'https://raw.githubusercontent.com/dweger-scripts/Remove-LocalAdmin/main/Remove-LocalAdmin%201.ps1'; $script = 'C:\temp\Remove-LocalAdmin 1.ps1'; Invoke-WebRequest -URI $downloadURI -Outfile $script `

*This will download the script to the C:\temp folder*

### Run WhatIf
`C:\temp\Remove-LocalAdmin 1.ps1 -WhatIf; $Logs = get-item C:\temp\RemoveLocalAdminLog* ; Get-content $Logs[-1] -Tail 1`

*This will run the script in WhatIf PlaceHolder*

### Run Remove
`C:\temp\Remove-LocalAdmin 1.ps1 -Remove; $Logs = get-item C:\temp\RemoveLocalAdminLog* ; Get-content $Logs[-1] -Tail 1`

*This will run the script in Remove PlaceHolder*

### Run Count
`C:\temp\Remove-LocalAdmin 1.ps1 -Count; $Logs = get-item C:\temp\RemoveLocalAdminLog* ; Get-content $Logs[-1] -Tail 1`

*This will run the script in Count PlaceHolder*

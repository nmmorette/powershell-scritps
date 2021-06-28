###winserverbackupreport.ps1
###---------------------------------------------------------------
### Objective: Scan for win server backup and send log by email
###---------------------------------------------------------------
### Author: Natan Morette
###---------------------------------------------------------------

$status = Get-ChildItem -path "C:\Windows\Logs\WindowsServerBackup\"  | Sort-Object LastAccessTime -Descending | Select-Object -First 1
$statusfinal = Get-Content "C:\Windows\Logs\WindowsServerBackup\$status"
$backup = wbadmin get versions | Out-String
$servername = $env:computername | Select-Object
$data = get-date
$space = Get-WmiObject -Class Win32_logicaldisk -Filter "DriveType = '3'" | 
Select-Object -Property DeviceID, DriveType, VolumeName, 
@{L='FreeSpaceGB';E={"{0:N2}" -f ($_.FreeSpace /1GB)}},
@{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}} | Out-String


# Envia Report 
$EmailTo = "EMAIL TO RECEIVE ALERT"
$EmailFrom = "SMTP RELAY"
$Subject = "Report Backup Windows Server " + " " + $data
$Body = @"
Servidor $servername 

$statusfinal

#################################

$backup

#################################


$space




"@

#Criar arquivo criptografado de senha
#Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File -FilePath "D:\key.dat" 
 

$SMTPServer = “smtp.office365.com” 
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$password = Get-Content D:\key.dat | ConvertTo-SecureString
$credential = New-Object System.Management.Automation.PSCredential "nul",$password
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $credential.GetNetworkCredential().Password); 
$SMTPClient.Send($SMTPMessage)

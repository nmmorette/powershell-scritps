###---------------------------------------------------------------
### Objective: Backup SQL  
###---------------------------------------------------------------
### Author: Natan Morette
###---------------------------------------------------------------


# 1 
#Run the comand below for creat key.dat file for your email password
#Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File -FilePath "E:\SQL\ZKAccess\BACKUP\LOGS\key.dat"

# -- BACKUP DATABASE --
 

#Variáveis
$localdobackup = "INSERT YOU BACKUP FOLDER"
$data = get-date
$database = "INSERT YOU DATABASE NAME" 
$arquivodelog ="INSERT YOU LOG FILE"
$servername = $env:computername | Select-Object



#Executa o backup da base de dados do SLQ
#lê os arquivos na pasta
#salva txt com conteúdo para envio 
& {$backup = sqlcmd -S .\"INSERT DBUSER" -E -Q "EXEC dbo.sp_BackupDatabases @backupLocation='$localdobackup',@databaseName='$database', @backupType='F'" | Out-File -append -filePath $arquivodelog -NoClobber}
& {$arquivos= Get-ChildItem -Path $localdobackup -Force | Out-File -append -filePath $arquivodelog -NoClobber}

#Lê o conteúdo do arquivo para envio 
$conteudo= Get-Content $arquivodelog | Out-String

# Envia Report 

$EmailTo = "youemail@.com"
$EmailFrom = "email@email.com"
$Subject = "Report Backup SQL $database" + " " + $data
$Body = @"
Servidor $servername -  Base de dados = $database 


$conteudo


$arte
"@

 

$SMTPServer = “SMTP SERVER” 
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
#$SMTPMessage.IsBodyHtml = $true
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
#$password = Get-Content "YOUR CYPHER KEY FILE"\key.dat | ConvertTo-SecureString
#$credential = New-Object System.Management.Automation.PSCredential "nul",$password
$SMTPClient.EnableSsl = $false
#$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, $credential.GetNetworkCredential().Password); 
$SMTPClient.Send($SMTPMessage)


#Deleta arquivos mais antigos que 9 dias da pasta do backup
$limit = (Get-Date).AddDays(-9)
$path = "$localdobackup"
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

#Deleta arquivo montado 

del $arquivodelog

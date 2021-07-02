###parsing.ps1
###---------------------------------------------------------------
### Objective: Simple network top ports scan
###---------------------------------------------------------------
### Author: Natan Morette
###---------------------------------------------------------------

# Edit $topports with the ports you want to scan

param($ip)
# if(!$ip -or !$porta){ 
if(!$ip){    
    echo "Portsacan"
    echo ".\portscan.ps1 192.168.0.1"
        }else {
        $topports = 21,22,53,443,80,8080,4443,313,13,37,30000,3000,1337
     try {   foreach ($porta in $topports){
if (Test-NetConnection $ip -Port $porta -WarningAction SilentlyContinue -Informationlevel Quiet) { 
echo "Porta $porta Aberta"
}} else {
    echo "Porta $porta Fechada"
    }} catch {}
    }
    

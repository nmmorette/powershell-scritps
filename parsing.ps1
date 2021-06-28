###parsing.ps1
###---------------------------------------------------------------
### Objective: Parsing html for information gathering 
###---------------------------------------------------------------
### Author: Natan Morette
###---------------------------------------------------------------


$url = read-host " Digite o  Site"

$web = Invoke-WebRequest -Uri "$url" -Method Options
echo ""
echo ""
echo "O Servidor roda: "
$web.headers.server
echo ""
echo " O servidor aceita os metodos:"
$web.headers.Allow
echo ""
echo ""
echo "Links Encontrados:"
$web2 = $web = Invoke-WebRequest -Uri "$url"
$web2.links.href | Select-String http://

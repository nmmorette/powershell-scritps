###parsing.ps1
###---------------------------------------------------------------
### Objective: Ping Sweep on network
###---------------------------------------------------------------
### Author: Natan Morette
###---------------------------------------------------------------

param($p1)
if (!$p1) {
    echo "Ping Sweep"
    echo "Exemplo de uso: .\script.ps1 192.168.0"
    
    } else {
    foreach ($ip in 1..254){
  try { $resp = ping -n 1 "$p1.$ip" | Select-String "bytes=32"
   $resp.Line.split(' ')[2] -replace ":" , ""
    } catch {}
    }
    }

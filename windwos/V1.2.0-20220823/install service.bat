cd ./
set curPath=%~dp0
set exePath=%~dp0\CarEyeMediaServer.exe
set xmlPath=%~dp0\Configure.xml
echo service path£º%curPath%
sc create CarEyeMediaServer binPath= "\"%exePath%\" \"%xmlPath%\" -s" start= auto
sc failure CarEyeMediaServer reset= 0 actions= restart/0
sc config CarEyeMediaServer type= interact type= own
net start CarEyeMediaServer
pause
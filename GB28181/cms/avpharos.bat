@echo off

:loop
avpharos.exe
timeout /T 3 /NOBREAK > NUL
goto loop
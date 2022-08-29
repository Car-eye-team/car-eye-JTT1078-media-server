@echo off

:loop
avlines.exe
timeout /T 3 /NOBREAK > NUL
goto loop
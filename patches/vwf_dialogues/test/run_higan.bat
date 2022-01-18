@echo off

.\..\..\..\tools\higan_v101-windows\higan.exe .\vwf_dialogues.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Running "vwf_dialogues.smc" in Higan failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Running "vwf_dialogues.smc" in Higan.
	echo.
)
@echo off

.\..\..\..\tools\bsnes_v115-windows\bsnes.exe .\vwf_dialogues.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Running "vwf_dialogues.smc" in BSNES failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Running "vwf_dialogues.smc" in BSNES.
	echo.
)
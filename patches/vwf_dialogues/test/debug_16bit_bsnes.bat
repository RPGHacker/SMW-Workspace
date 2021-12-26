@echo off

.\..\..\..\tools\bsnes-plus-v05.87-master\bsnes-accuracy.exe .\patched_16bit.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Running "patched_16bit.smc" in BSNES Debugger failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Running "patched_16bit.smc" in BSNES Debugger.
	echo.
)
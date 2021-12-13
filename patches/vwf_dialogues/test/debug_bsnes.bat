@echo off

.\..\..\..\tools\bsnes-plus-v05.87-master\bsnes-accuracy.exe .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Running "patched.smc" in BSNES Debugger failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Running "patched.smc" in BSNES Debugger.
	echo.
)
@echo off

.\..\..\..\tools\bsnes-plus-073.2-x64\bsnes-accuracy.exe .\patched.smc

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
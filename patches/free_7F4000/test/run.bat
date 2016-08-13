@echo off

.\..\..\..\tools\higan_v101-windows\higan.exe .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Running "patched.smc" in Higan failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Running "patched.smc" in Higan.
	echo.
)
@echo off

.\..\..\..\tools\zsnesw151-FuSoYa-8MB_R2\zsnesw.exe .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Running "patched.smc" in ZSNES failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Running "patched.smc" in ZSNES.
	echo.
)
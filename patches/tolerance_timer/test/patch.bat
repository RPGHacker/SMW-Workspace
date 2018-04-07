@echo off

copy /B/Y .\..\..\..\baserom\lm1mb.smc .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Copying "lm1mb.smc" to "patched.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Copied "lm1mb.smc" to "patched.smc".
	echo.
)

.\..\..\..\tools\asar\asar.exe .\..\tolerance_timer.asm .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "tolerance_timer.asm" to "patched.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Patched "tolerance_timer.asm" to "patched.smc".
	echo.
)
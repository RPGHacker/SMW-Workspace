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
)

.\..\..\..\tools\asar137\asar.exe .\..\free_7F4000.asm .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "free_7F4000.asm" to "patched.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Patched "free_7F4000.asm" to "patched.smc".
	echo.
)
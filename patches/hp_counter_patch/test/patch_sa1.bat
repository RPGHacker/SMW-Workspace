@echo off

copy /B/Y .\..\..\..\baserom\lm1mb_sa1.smc .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Copying "lm1mb_sa1.smc" to "patched.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Copied "lm1mb_sa1.smc" to "patched.smc".
	echo.
)

.\..\..\..\tools\asar\asar.exe .\..\hp_counter_patch.asm .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "hp_counter_patch.asm" to "patched.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Patched "hp_counter_patch.asm" to "patched.smc".
	echo.
)
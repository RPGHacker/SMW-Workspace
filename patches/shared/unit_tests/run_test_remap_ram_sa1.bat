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
	echo.
)

.\..\..\..\tools\asar\asar.exe .\test_remap_ram.asm .\patched.smc

echo.
echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "test_remap_ram.asm" to "patched.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Patched "test_remap_ram.asm" to "patched.smc".
	echo.
)

pause
@echo off

copy /B/Y .\..\..\..\baserom\lm2mb_sa1.smc .\patched_sa1.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Copying "lm2mb_sa1.smc" to "patched_sa1.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Copied "lm2mb_sa1.smc" to "patched_sa1.smc".
	echo.
)

.\..\..\..\tools\asar\asar.exe -I".\..\messages\tests" .\..\vwf_dialogues.asm .\patched_sa1.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "vwf_dialogues.asm" to "patched_sa1.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Patched "vwf_dialogues.asm" to "patched_sa1.smc".
	echo.
)
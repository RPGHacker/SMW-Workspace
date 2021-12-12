@echo off

copy /B/Y .\..\..\..\baserom\lm2mb_sa1.smc .\patched_sa1.smc > NUL

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

.\..\..\..\tools\asar\asar.exe --symbols=wla --symbols-path=".\patched_sa1.cpu.sym" -I".\..\messages\tests" .\..\vwf_dialogues.asm .\patched_sa1.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "vwf_dialogues.asm" to "patched_sa1.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	COPY /Y ".\patched_sa1.cpu.sym" ".\patched_sa1.sa1.sym" > NUL

	echo Patched "vwf_dialogues.asm" to "patched_sa1.smc".
	echo.
)
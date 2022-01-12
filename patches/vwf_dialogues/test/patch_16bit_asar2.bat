@echo off

copy /B/Y .\..\..\..\baserom\lm2mb.smc .\patched_16bit.smc > NUL

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Copying "lm2mb.smc" to "patched_16bit.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Copied "lm2mb.smc" to "patched_16bit.smc".
	echo.
)

.\..\..\..\tools\asar\asar2.exe --symbols=wla --symbols-path=".\patched_16bit.cpu.sym" -D"bitmode=BitMode.16Bit" -I".\..\builds\tests" -I".\..\.." .\..\vwf_dialogues.asm .\patched_16bit.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "vwf_dialogues.asm" to "patched_16bit.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Patched "vwf_dialogues.asm" to "patched_16bit.smc".
	echo.
)
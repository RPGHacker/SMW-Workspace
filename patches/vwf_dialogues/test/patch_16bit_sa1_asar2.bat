@echo off

copy /B/Y .\..\..\..\baserom\lm2mb_sa1.smc .\patched_16bit_sa1.smc > NUL

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Copying "lm2mb_sa1.smc" to "patched_16bit_sa1.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Copied "lm2mb_sa1.smc" to "patched_16bit_sa1.smc".
	echo.
)

.\..\..\..\tools\asar\asar2.exe --symbols=wla --symbols-path=".\patched_16bit_sa1.cpu.sym" -D"bitmode=BitMode.16Bit" -I".\..\builds\tests" -I".\..\.." .\..\vwf_dialogues.asm .\patched_16bit_sa1.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "vwf_dialogues.asm" to "patched_16bit_sa1.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Patched "vwf_dialogues.asm" to "patched_16bit_sa1.smc".
	echo.
)
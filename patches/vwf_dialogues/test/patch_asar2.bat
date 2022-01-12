@echo off

copy /B/Y .\..\..\..\baserom\lm1mb.smc .\patched.smc > NUL

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

.\..\..\..\tools\asar\asar2.exe --symbols=wla --symbols-path=".\patched.cpu.sym" -I".\..\builds\tests" -I".\..\.." .\..\vwf_dialogues.asm .\patched.smc

echo.

IF %ERRORLEVEL% NEQ 0 (
	echo Patching "vwf_dialogues.asm" to "patched.smc" failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo Patched "vwf_dialogues.asm" to "patched.smc".
	echo.
)
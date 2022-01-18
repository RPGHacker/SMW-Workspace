@echo off

set /a NUM_ERRORS=0

call :Applay_Patch 8-bit, 1.9, normal
call :Applay_Patch 8-bit, 1.9, sa-1
call :Applay_Patch 8-bit, 2.0, normal
call :Applay_Patch 8-bit, 2.0, sa-1
call :Applay_Patch 16-bit, 1.9, normal
call :Applay_Patch 16-bit, 1.9, sa-1
call :Applay_Patch 16-bit, 2.0, normal
call :Applay_Patch 16-bit, 2.0, sa-1

EXIT /B %ERRORLEVEL%


:Applay_Patch

python.exe .\apply_patch.py --bit_mode %~1 --asar_ver %~2 --rom_type %~3

IF %ERRORLEVEL% NEQ 0 (
	echo Creating ROM failed.
	echo.
	pause
	exit %ERRORLEVEL%
) ELSE (
	echo ROM created successfully!
	echo.
)

EXIT /B %ERRORLEVEL%
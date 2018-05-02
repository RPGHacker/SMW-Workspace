@echo off

set patchname=tolerance_timer

IF EXIST "./%patchname%.zip" (
    del "./%patchname%.zip"
)

cd ..

"C:\Program Files\7-Zip\7z.exe" a ./%patchname%/%patchname%.zip %patchname%/README.md ../LICENSE %patchname%/ttconfig.cfg %patchname%/tolerance_timer.asm

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%/%patchname%.zip %patchname%/README.md %patchname%/readme.txt LICENSE %patchname%/license.txt

"C:\Program Files\7-Zip\7z.exe" a ./%patchname%/%patchname%.zip shared/README.md ../LICENSE shared/includes shared/shared.asm

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%/%patchname%.zip shared/README.md shared/readme.txt LICENSE shared/license.txt
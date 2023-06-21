@echo off

set patchname=tolerance_timer

IF EXIST "./%patchname%.zip" (
    del "./%patchname%.zip"
)

"C:\Program Files\7-Zip\7z.exe" a %patchname%.zip README.md ../../LICENSE ttconfig.cfg tolerance_timer.asm

"C:\Program Files\7-Zip\7z.exe" rn %patchname%.zip README.md readme.txt LICENSE license.txt

"C:\Program Files\7-Zip\7z.exe" a %patchname%.zip ../shared ../../LICENSE

"C:\Program Files\7-Zip\7z.exe" rn %patchname%.zip shared shared_temp

"C:\Program Files\7-Zip\7z.exe" rn %patchname%.zip shared_temp/README.md shared/readme.txt LICENSE shared/license.txt shared_temp/shared.asm shared/shared.asm shared_temp/includes shared/includes

"C:\Program Files\7-Zip\7z.exe" d %patchname%.zip shared_temp
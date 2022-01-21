@echo off

set patchname=vwf_dialogues

set vwf_dir="%~dp0"

cd %vwf_dir%

IF EXIST "./%patchname%.zip" (
    del "./%patchname%.zip"
)

"C:\Program Files\7-Zip\7z.exe" a ./%patchname%.zip README.md ../../LICENSE %patchname%.asm vwfroutines.asm data vwfmacros.asm code

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%.zip README.md readme.txt LICENSE license.txt

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%.zip data/smw/data data

"C:\Program Files\7-Zip\7z.exe" a ./%patchname%.zip ../shared ../../LICENSE

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%.zip shared/README.md shared/readme.txt LICENSE shared/license.txt

"C:\Program Files\7-Zip\7z.exe" d ./%patchname%.zip shared/unit_tests builds data/smw data/testing

cd ..\..

"C:\Program Files\7-Zip\7z.exe" a ./patches/%patchname%/%patchname%.zip docs/vwf/manual

"C:\Program Files\7-Zip\7z.exe" rn ./patches/%patchname%/%patchname%.zip docs/vwf/manual manual


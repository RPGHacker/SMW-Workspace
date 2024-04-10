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

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%.zip shared shared_temp

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%.zip shared_temp/README.md shared/readme.txt LICENSE shared/license.txt shared_temp/shared.asm shared/shared.asm shared_temp/includes shared/includes

"C:\Program Files\7-Zip\7z.exe" d ./%patchname%.zip shared_temp builds data/smw data/testing

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%.zip code/external/vwfsharedroutines.asm code/blocks/display_once_on_touch/vwfsharedroutines.asm 
"C:\Program Files\7-Zip\7z.exe" a ./%patchname%.zip code/external/vwfsharedroutines.asm 
"C:\Program Files\7-Zip\7z.exe" d ./%patchname%.zip vwftestsuite.asm

cd ..\..

"C:\Program Files\7-Zip\7z.exe" a ./patches/%patchname%/%patchname%.zip docs/vwf/manual
"C:\Program Files\7-Zip\7z.exe" rn ./patches/%patchname%/%patchname%.zip docs/vwf/manual manual

"C:\Program Files\7-Zip\7z.exe" d ./patches/%patchname%/%patchname%.zip manual/shared
"C:\Program Files\7-Zip\7z.exe" a ./patches/%patchname%/%patchname%.zip docs/shared
"C:\Program Files\7-Zip\7z.exe" rn ./patches/%patchname%/%patchname%.zip docs/shared manual/shared


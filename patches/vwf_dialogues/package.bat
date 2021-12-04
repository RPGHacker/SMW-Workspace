@echo off

set patchname=vwf_dialogues

set vwf_dir="%~dp0"

IF EXIST "./%patchname%.zip" (
    del "./%patchname%.zip"
)

cd %vwf_dir%
cd ..

"C:\Program Files\7-Zip\7z.exe" a ./%patchname%/%patchname%.zip %patchname%/README.md ../LICENSE %patchname%/blocks/ %patchname%/fonts/ %patchname%/%patchname%.asm %patchname%/vwfcode.asm %patchname%/vwfconfig.cfg %patchname%/vwffont1.asm %patchname%/vwffont1.bin %patchname%/vwfframes.asm %patchname%/vwfframes.bin %patchname%/vwfmacros.asm %patchname%/messages/smw/vwfmessages.asm %patchname%/vwfpatterns.bin %patchname%/vwftable.txt %patchname%/scripts/generate_widths.py

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%/%patchname%.zip %patchname%/README.md %patchname%/readme.txt LICENSE %patchname%/license.txt

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%/%patchname%.zip %patchname%/messages/smw/vwfmessages.asm %patchname%/vwfmessages.asm

"C:\Program Files\7-Zip\7z.exe" a ./%patchname%/%patchname%.zip shared/README.md ../LICENSE shared/includes shared/shared.asm

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%/%patchname%.zip shared/README.md shared/readme.txt LICENSE shared/license.txt

cd ..

"C:\Program Files\7-Zip\7z.exe" a ./patches/%patchname%/%patchname%.zip docs/vwf/manual

"C:\Program Files\7-Zip\7z.exe" rn ./patches/%patchname%/%patchname%.zip docs/vwf/manual %patchname%/manual


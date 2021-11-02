@echo off

set patchname=vwf_dialogues

IF EXIST "./%patchname%.zip" (
    del "./%patchname%.zip"
)

cd ..

"C:\Program Files\7-Zip\7z.exe" a ./%patchname%/%patchname%.zip %patchname%/README.md ../LICENSE %patchname%/blocks/ %patchname%/fonts/ %patchname%/manual/ %patchname%/%patchname%.asm %patchname%/vwfcode.asm %patchname%/vwfconfig.cfg %patchname%/vwffont1.asm %patchname%/vwffont1.bin %patchname%/vwffontpointers.asm %patchname%/vwfframes.asm %patchname%/vwfframes.bin %patchname%/vwfmessagepointers.asm %patchname%/messages/smw/vwfmessages.asm %patchname%/vwfpatterns.bin %patchname%/vwftable.txt %patchname%/scripts/generate_widths.py

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%/%patchname%.zip %patchname%/README.md %patchname%/readme.txt LICENSE %patchname%/license.txt

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%/%patchname%.zip %patchname%/messages/smw/vwfmessages.asm %patchname%/vwfmessages.asm

"C:\Program Files\7-Zip\7z.exe" a ./%patchname%/%patchname%.zip shared/README.md ../LICENSE shared/includes shared/shared.asm

"C:\Program Files\7-Zip\7z.exe" rn ./%patchname%/%patchname%.zip shared/README.md shared/readme.txt LICENSE shared/license.txt
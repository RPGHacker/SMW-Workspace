; This patch attempts to apply the minimum number of changes to the ROM that you would get from
; just opening it in Lunar Magic and expanding it without touching anything else. The reason for
; this is that if we apply SA-1 Pack to the ROM without opening it in Lunar Magic first, LM will
; give us an annoying warning message box the next time we open it. On the other hand, if we do
; any actual modifications via Lunar Magic and only patch SA-1 Pack afterwards, the ROM will crash.
; Expansion via Lunar Magic is the only thing that will avoid both problems.

; Ideally, Lunar Magic should just have a command line option for expanding the ROM, which would
; remove the necessity for this patch, but right now, that doesn't exist.


cleartable


; asar_expand.asm should take care of expansion.
; org $00FFD7
;  	db $0B


org $0FF024
LunarMagicHeader:
	db $A9
	
	padbyte $00
	pad $0FF0A0
	
	db "Lunar Magic Version 3.31 Public "
	
	db $A9
	db "2021 FuSoYa, Defender of Relm http://fusoya.eludevisibility.org                                I am Naaall, and I love fiiiish!"
.End

	assert .End == $0FF140

org $0FFFE7
	db $00, $00, $F8, $FF, $00, $00, $00, $00, $00, $00, $10, $FF, $00
	db $02, $10, $00, $02, $08, $00, $02, $04, $00, $02, $08, $00


; asar_expand.asm should take care of expansion.
; norom ; pc address mode
; 
; org $1FFFFF
; db $00 ; expand ROM to 2MB

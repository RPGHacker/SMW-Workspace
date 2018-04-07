@asar 1.50

;;;;;;;;;;;;;;;;;;;;;;;;;
;OW Tilemap Reload Patch;
;;;;;;;;;;;;;;;;;;;;;;;;;


incsrc freeconfig.cfg
incsrc ../shared/shared.asm


print "Free 7F4000 v1.0 - (c) RPG Hacker"


math pri on
math round off

pushtable
cleartable


namespace free_7F4000_





;;;;;;;;;
;Hijacks;
;;;;;;;;;


; Code to execute on overworld load

org remap_rom($00A0B9)
	autoclean jsl HandleOWReload
	nop #2





;;;;;;;;;;;;;;;;;
;MAIN CODE START;
;;;;;;;;;;;;;;;;;


freecode

FreecodeStart:





;;;;;;;;;;;;;;;;
;OW Load Hijack;
;;;;;;;;;;;;;;;;


; Hijacks OW load to make it reload some tilemap data if necessary

HandleOWReload:
if !use_dirty_flag_for_ow_reload == 1
	lda remap_ram(!ow_dirty_flag)
	; cmp #$00
	beq .Recover
endif

	{
	.OWTilemapDirty:
		jsl remap_rom($04DAAD)
	}
	
.Recover:
	stz remap_ram($0DDA)
	ldx remap_ram($0DB3)

.Return:
	rtl




	
;;;;;;;;;;;;;;;
;MAIN CODE END;
;;;;;;;;;;;;;;;

print "Patch inserted at $",hex(FreecodeStart),", ",freespaceuse," bytes of free space used."

namespace off


pulltable

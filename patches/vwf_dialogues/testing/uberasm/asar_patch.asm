HEADER
LOROM

!true = 1	;\Do not change these.
!false = 0	;/

;Hihack list
!level           = !false
!OW              = !false
!nmi             = !false
!statusbar       = !false
!statusbar_drawn = !false
!global          = !false
!sprite          = !false
!gamemode        = !true

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SA1 detector:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if read1($00FFD5) == $23
	!SA1 = 1
	sa1rom
else
	!SA1 = 0
endif

; Example usage
if !SA1
	; SA-1 base addresses	;Give thanks to absentCrowned for this:
				;http://www.smwcentral.net/?p=viewthread&t=71953
	!Base1 = $3000		;>$0000-$00FF -> $3000-$30FF
	!Base2 = $6000		;>$0100-$0FFF -> $6100-$6FFF and $1000-$1FFF -> $7000-$7FFF
else
	; Non SA-1 base addresses
	!Base1 = $0000
	!Base2 = $0000
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SA1 ends here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;ignore these -- they are dummy labels that are not used.
;only change freespace in the xkas patch (if you are using xkas_
!level_freespace = $000000
!OW_freespace = $000000
!nmi_freespace = $000000
!statusbar_freespace = $000000
!statusbar_drawn_freespace = $000000
!global_freespace = $000000
!sprite_freespace = $000000
!gamemode_freespace = $000000

macro origin(address)
	freecode
endmacro

macro clean(code)
	autoclean <code>
endmacro

macro sprite_code_conditional(code)
	if !sprite
		<code>
	endif
endmacro

!sprite_RAM = $7FAC80	;>37 bytes for non-sa-1, 67 bytes otherwise.
;^this freeram also positions !Previous mode.

if !SA1
	!previous_mode = !sprite_RAM+66
else
	!previous_mode = !sprite_RAM+36
endif
	if !level
		incsrc hijacks/level.asm
		incsrc code/level_code.asm
		incsrc code/level_init_code.asm
	endif

	if !OW
		incsrc hijacks/overworld.asm
		incsrc code/ow_code.asm
		incsrc code/ow_init_code.asm
	endif
	
	if !nmi
		incsrc hijacks/nmi.asm
		incsrc code/nmi_code.asm
	endif
	
	if !statusbar
		incsrc hijacks/statusbar.asm
		incsrc code/statusbar_code.asm
	endif
	
	if !statusbar_drawn
		incsrc hijacks/statusbar_drawn.asm
		incsrc code/statusbar_drawn_code.asm
	endif

	if !global
		incsrc hijacks/global.asm
		incsrc code/global_code.asm
	endif
	
	if !sprite
		incsrc hijacks/sprites.asm
	endif

	if !gamemode
		incsrc hijacks/gamemode.asm
		incsrc code/gamemode_code.asm
		incsrc code/gamemode_init_code.asm
	endif

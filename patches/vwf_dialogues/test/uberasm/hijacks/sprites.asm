sprite_code:
	if !SA1
		LDX #$16	;>22 for sa-1 slot
	else
		LDX #$0C	;>12 for normal smw sprite slot
	endif
	-
		DEX		;>makes it start at -1
		LDA !sprite_RAM,x
	if !SA1
		ORA !sprite_RAM+22,x	;\Assuming that there are 22 sprite slots.
		ORA !sprite_RAM+44,x	;/
	else
		ORA !sprite_RAM+12,x	;\Assuming that there are 12 sprite slots.
		ORA !sprite_RAM+24,x	;/
	endif
	BNE +
		CPX #$00
		BNE -
		BRA .return
	+
	if !SA1
		LDA $3242,x
	else
		LDA $14C8,x 
	endif
		BEQ .clear
		LDA !sprite_RAM,x
		STA $00
	if !SA1
		LDA !sprite_RAM+22,x
	else
		LDA !sprite_RAM+12,x
	endif
		STA $01
	if !SA1
		LDA !sprite_RAM+44,x
	else
		LDA !sprite_RAM+24,x
	endif
		STA $02
		PHK
		PEA.w .next-1
		JMP [!Base1]
	.next
		CPX #$00
		BNE -
	.return
		RTS
	.clear
		LDA #$00
		STA !sprite_RAM,x
	if !SA1
		STA !sprite_RAM+44,x
		STA !sprite_RAM+22,x
	else
		STA !sprite_RAM+24,x
		STA !sprite_RAM+12,x
	endif
		BRA -

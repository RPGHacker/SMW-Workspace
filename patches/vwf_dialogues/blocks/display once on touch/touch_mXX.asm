; Displays whatever message you specify once, then sets a RAM address to
; prevent the dialogue from being displayed again.

!Message = #$0050	; Message to display
!FreeRAM = $60		; Free RAM Address
!VWFState = $702000	; VWF State register address

JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return

Mario:
	lda !FreeRAM
	beq .Set
	rtl

.Set
	rep #$20
	lda.w !Message
	sta.l !VWFState+1
	sep #$20
	lda.l !VWFState
	bne Return
	lda #$01
	sta.l !VWFState
	sta !FreeRAM

Return:
	rtl
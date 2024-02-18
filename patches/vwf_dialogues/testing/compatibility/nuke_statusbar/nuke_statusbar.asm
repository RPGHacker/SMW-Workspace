lorom

; Note: if you use the powerdown patch, find the line below that mentions that

; 1 enables the coin counter (just internally, you can't actually see it)
; you'll also get a reward (1UP) every 100 coins
; (of course you can change the reward to whatever, if you want)
!enable_coins = 0

if read1($00FFD5) == $23
	sa1rom
	!sa1 = 1
	!base2 = $6000
else
	!sa1 = 0
	!base2 = $0000
endif

org $0081F4			; JSR $008DAC
	BRA + : NOP : +
	
org $008275			; this one nukes the IRQ
	JMP NMI_hijack

org $0082E8			; JSR $008DAC
	BRA + : NOP : +
	
org $008C81			; literally nuke the status bar
	pad $009045		; (but skip over hextodec)
org $009051
	pad $0090D1

org $00985A			; JSR $008CFF
	BRA + : NOP : +
	
org $00A2D5			; JSR $008E1A
	if !enable_coins
		JSR coins
	else
		BRA + : NOP : +
	endif

org $00A5A8			; JSR $008CFF
	BRA + : NOP : +
	
org $00A5D5			; JSR $008E1A
	if !enable_coins
		JSR coins
	else
		BRA + : NOP : +
	endif

org $00F5F8			; don't try dropping anything when getting hurt
	BRA + : NOP #2 : +	; REMOVE THIS IF YOU USE THE POWERDOWN PATCH

org $01C540			; don't store items ever
	BRA + : NOP #11 : +

; use the old status bar area as freespace
org $008C81
NMI_hijack:
	LDA $0D9B|!base2
	BNE .special
	if !sa1
		LDX #$81		; don't do IRQ (lated stored to $4200)
	else
		LDA #$81		; don't do IRQ
		STA $4200
	endif
	LDA $22			; update mirrors
	STA $2111
	LDA $23
	STA $2111
	LDA $24
	STA $2112
	LDA $25
	STA $2112
	LDA $3E
	STA $2105
	LDA $40
	STA $2131
	JMP $82B0
	
.special
	JMP $827A	

if !enable_coins
	coins:
		LDA $13CC|!base2	; add up coins
		BEQ +
		DEC $13CC|!base2
		INC $0DBF|!base2
		LDA $0DBF|!base2
		CMP #$64		; only give a reward with 100 coins
		BCC +
		
		INC $18E4|!base2	; REWARD (1UP)
		
		STZ $0DBF|!base2
	+	RTS
endif

warnpc $009045

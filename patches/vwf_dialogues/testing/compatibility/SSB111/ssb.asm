;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sprite Status Bar v1.1.1B
; coded by edit1754
;
; IMPORTANT NOTE: If you would like to use the sprite goal-point text feature,
;                 You must have No More Sprite Tile Limits patched.
;                 You do /not/ need to have sprite header setting 10 enabled,
;                 but this patch uses the routine from that patch.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
header
lorom

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; values you don't necessarily need to change, and most of the time shouldn't
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		!RAMBuffer = $7F1344	; change this if you're already using it for another ASM hack
					; it uses 0x480 bytes right after the dynamic sprite buffer

		!RAMBuffer2 = $7F17C4	; uses 0x600 bytes. Default is right after the other buffer
					; used for goalpoint fix

		!TransparentTile = $2F*$20
		!CopyToRAM = $30*$20
		!CopyToRAM2 = $54*$20
		!SBGFXSize = $0480
		!GPGFXSize = $0600
		!MarioName = $00*$20
		!LuigiName = $10*$20

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SA-1 detection code - do not modify it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!sa1	= 0
!dp	= $00
!addr	= $0000
		
if read1($00ffd5) == $23
	sa1rom
	
	!sa1	= 1
	!dp	= $3000
	!addr	= $6000
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; levelnum.ips (disassembly) - credit goes to BMF for this
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ORG $05D8B9
		JSR LevelNumCode

ORG $05DC46
LevelNumCode:	LDA.b $0E  		; Load level number, 1st part of hijacked code
		STA.w $010B|!addr	; Store it in free RAM
		ASL A    		; 2nd part of hijacked code
		RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hijacks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $05BEA0
		autoclean JSL LoadLevel

org $009F68
		autoclean JSL GameMode13
		NOP
		NOP

org $00A2A1
		autoclean JSL GameMode14

org $008292
		autoclean JML IRQHack
		NOP

org $008DB1
		autoclean JML SBUploadHack	; $8DAC would be more ideal, but Stripe Image Uploader already uses it
		NOP

org $0299DF
		autoclean JML CoinBlockFix

org $02AD34
		autoclean JML ScoreSprFix

org $07F1DB
		autoclean JML BonusStarFix	; part of goalpoint fix code

org $00AF2D
		BRA +
		NOP #2
+		autoclean JSL GoalTextFix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main Code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro OAMTile(dest,x,y,tile,prop,size)
		LDA.b #<x>
		STA.w !addr|$0200+<dest>+<dest>+<dest>+<dest>
		LDA.b #<y>
		STA.w !addr|$0201+<dest>+<dest>+<dest>+<dest>
		LDA.b #<tile>
		CLC : ADC.w LevelGFXLoc,x
		STA.w !addr|$0202+<dest>+<dest>+<dest>+<dest>
		LDA.b #<prop>
		ORA.w LevelSBProp,x
		STA.w !addr|$0203+<dest>+<dest>+<dest>+<dest>
		LDA.b #<size>
		STA.w !addr|$0420+<dest>
endmacro

macro OAMTileYoshiCoin(num,xpos,dest)
		LDA.w !addr|$0EFF+<num>
		CMP.b #$FC
		BEQ ?NoShowCoin
		LDA.b #<xpos>
		STA.w !addr|$0200+<dest>+<dest>+<dest>+<dest>
		LDA.b #$0F
		STA.w !addr|$0201+<dest>+<dest>+<dest>+<dest>
		LDA.b #$14
		CLC : ADC.w LevelGFXLoc,x
		STA.w !addr|$0202+<dest>+<dest>+<dest>+<dest>
		LDA.b #%00110000
		ORA.w LevelSBProp,x
		STA.w !addr|$0203+<dest>+<dest>+<dest>+<dest>
		LDA.b #$00
		STA.w !addr|$0420+<dest>
?NoShowCoin:
endmacro

macro OAMTileGP(dest,x,y,tile,prop,size)
		LDA.b #<x>
		STA.w !addr|$0300+<dest>+<dest>+<dest>+<dest>,y
		LDA.b #<y>
		STA.w !addr|$0301+<dest>+<dest>+<dest>+<dest>,y
		LDA.b #<tile>+$24
		;CLC : ADC.b #$24
		CLC : ADC.w LevelGFXLoc,x
		STA.w !addr|$0302+<dest>+<dest>+<dest>+<dest>,y
		LDA.b #<prop>
		ORA.w LevelSBProp,x
		STA.w !addr|$0303+<dest>+<dest>+<dest>+<dest>,y
		PHY
		TYA
		LSR #2
		TAY
		LDA.b #<size>
		STA.w !addr|$0460+<dest>,y
		PLY
endmacro

macro OAMTileGPc(dest,x,y,tile,prop,size)
		LDA.b #<x>
		STA.w !addr|$0300+<dest>+<dest>+<dest>+<dest>,y
		LDA.b #<y>
		STA.w !addr|$0301+<dest>+<dest>+<dest>+<dest>,y
		LDA.b #<tile>
		CLC : ADC.w LevelGFXLoc,x
		STA.w !addr|$0302+<dest>+<dest>+<dest>+<dest>,y
		LDA.b #<prop>
		ORA.w LevelSBProp,x
		STA.w !addr|$0303+<dest>+<dest>+<dest>+<dest>,y
		PHY
		TYA
		LSR #2
		TAY
		LDA.b #<size>
		STA.w !addr|$0460+<dest>,y
		PLY
endmacro

macro number(ptr,dest,offset)
		LDA.w #!RAMBuffer+<dest>
		STA.w $2181
		LDY.b #!RAMBuffer>>16
		STY.w $2183
		STZ.w $4300
		LDY.b #$80
		STY.w $4301
		SEP #%00100000
		LDA.w <ptr>
		CMP.b #$FC
		REP #%00100000
		BNE ?NoTrans
		LDA.w #!TransparentTile
		BRA ?Proceed
?NoTrans:	AND.w #$00FF
		CLC : ADC.w #<offset>
		ASL #5
?Proceed:	CLC : ADC.w #Graphics
		STA.w $4302
		LDY.b #Graphics>>16
		STY.w $4304
		LDA.w #$0020
		STA.w $4305
		LDY.b #%00000001
		STY.w $420B
endmacro

macro bonusstar(ptr,dest)
		LDA.w #!RAMBuffer+<dest>
		STA.w $2181
		LDY.b #!RAMBuffer>>16
		STY.w $2183
		STZ.w $4300
		LDY.b #$80
		STY.w $4301
		SEP #%00100000
		LDA.w <ptr>
		CMP.b #$FC
		REP #%00100000
		BNE ?NoTrans
		LDA.w #!TransparentTile
		BRA ?Proceed
?NoTrans:	AND.w #$00FF
		SEC : SBC.w #$0097
		ASL #5
?Proceed:	CLC : ADC.w #Graphics
		STA.w $4302
		LDY.b #Graphics>>16
		STY.w $4304
		LDA.w #$0020
		STA.w $4305
		LDY.b #%00000001
		STY.w $420B
endmacro

macro numberGP(ptr,dest,offset)
		LDA.w #!RAMBuffer2+<dest>
		STA.w $2181
		LDY.b #!RAMBuffer2>>16
		STY.w $2183
		STZ.w $4300
		LDY.b #$80
		STY.w $4301
		LDA.w <ptr>
		AND.w #$00FF
		CLC : ADC.w #<offset>
		ASL #5
		CLC : ADC.w #Graphics
		STA.w $4302
		LDY.b #Graphics>>16
		STY.w $4304
		LDA.w #$0020
		STA.w $4305
		LDY.b #%00000001
		STY.w $420B
endmacro

macro numberGPb(ptr,dest,offset)
		LDA.w #!RAMBuffer2+<dest>
		STA.w $2181
		LDY.b #!RAMBuffer2>>16
		STY.w $2183
		STZ.w $4300
		LDY.b #$80
		STY.w $4301
		LDA.b <ptr>
		AND.w #$00FF
		CLC : ADC.w #<offset>
		ASL #5
		CLC : ADC.w #Graphics
		STA.w $4302
		LDY.b #Graphics>>16
		STY.w $4304
		LDA.w #$0020
		STA.w $4305
		LDY.b #%00000001
		STY.w $420B
endmacro

macro bonusstarGP(ptrx,dest)
		LDA.w #!RAMBuffer2+<dest>
		STA.w $2181
		LDY.b #!RAMBuffer2>>16
		STY.w $2183
		STZ.w $4300
		LDY.b #$80
		STY.w $4301
		SEP #%00100000
		LDA.l <ptrx>,x
		CMP.b #$FC
		REP #%00100000
		BNE ?NoTrans
		LDA.w #!TransparentTile
		BRA ?Proceed
?NoTrans:	AND.w #$00FF
		SEC : SBC.w #$0097
		ASL #5
?Proceed:	CLC : ADC.w #Graphics
		STA.w $4302
		LDY.b #Graphics>>16
		STY.w $4304
		LDA.w #$0020
		STA.w $4305
		LDY.b #%00000001
		STY.w $420B
endmacro

macro transGP(dest)
		LDA.w #!RAMBuffer2+<dest>
		STA.w $2181
		LDY.b #!RAMBuffer2>>16
		STY.w $2183
		STZ.w $4300
		LDY.b #$80
		STY.w $4301
		LDA.w #!TransparentTile+Graphics
		STA.w $4302
		LDY.b #Graphics>>16
		STY.w $4304
		LDA.w #$0020
		STA.w $4305
		LDY.b #%00000001
		STY.w $420B
endmacro

freecode

GameMode13:	ORA.w !addr|$0DB0	; \ hijacked
		STA.w $2106		; / code
		LDA.w !addr|$0100	; \  if game mode
		CMP.b #$13		;  | != 13, then
		BNE ReturnRTL		; /  return
		PHB : PHK : PLB		; back up B, K -> B
		REP #%00100000		; 16-bit A
		BRA InLevel		; Jump to in-level code (second part of on-load code)

GameMode14:	JSL $0586F1		; hijacked code
		LDA.w !addr|$0100	; \  if game mode
		CMP.b #$14		;  | != 14, then 
		BNE ReturnRTL		; /  return
		PHB : PHK : PLB		; back up B, K -> B
		REP #%00100000		; 16-bit A
		BRA InLevel		; Jump to in-level code (second part of on-load code)

ReturnSEPXY:	SEP #%00010000		; 8-bit XY
		PLB			; restore B
ReturnRTL:	RTL

LoadLevel:	STA.b $24		; hijacked code (except for SEP #%00100000)
		REP #%00010000		; 16-bit XY, A is already 8-bit
		SEP #%00100000		; 8-bit A
		PHB : PHK : PLB		; back up B, K -> B
		LDX.w !addr|$010B	; Level number -> X index
		LDA.w LevelEnabled,x	; get SSB-enabled status
		TAY			; index -> Y
		BEQ ReturnSEPXY		; if disabled, return
		SEP #%00010000		; 8-bit XY
		REP #%00100000		; 16-bit A
		LDA.w #!RAMBuffer	; \
		STA.w $2181		;  |
		LDY.b #!RAMBuffer>>16	;  |
		STY.w $2183		;  |
		STZ.w $4300		;  |
		LDY.b #$80		;  | copy main GFX
		STY.w $4301		;  | to RAM buffer
		LDA.w #!CopyToRAM+Graphics
		STA.w $4302		;  |
		LDY.b #Graphics>>16	;  |
		STY.w $4304		;  |
		LDA.w #!SBGFXSize	;  |
		STA.w $4305		;  |
		LDY.b #%00000001	;  |
		STY.w $420B		; /

InLevel:	REP #%00010000
		SEP #%00100000		; 8-bit A
		LDX.w !addr|$010B	; Level number -> X index
		LDA.w LevelEnabled,x	; get SSB-enabled status
		BEQ ReturnSEPXY		; if disabled, return
		%OAMTile(0,$10,$0F,$00,%00110000,%10)
		%OAMTile(1,$20,$0F,$02,%00110000,%10)
		%OAMTile(2,$30,$0F,$04,%00110000,%00)
		%OAMTile(52,$70,$07,$07,%00110000,%10)
		%OAMTile(53,$80,$07,$07,%01110000,%10)
		%OAMTile(54,$70,$17,$07,%10110000,%10)
		%OAMTile(55,$80,$17,$07,%11110000,%10)
		%OAMTile(12,$60,$0F,$05,%00110000,%10)
		%OAMTile(13,$48,$17,$20,%00110000,%00)
		%OAMTile(14,$50,$17,$11,%00110000,%00)
		%OAMTile(42,$98,$0F,$09,%00110000,%10)
		%OAMTile(43,$A0,$0F,$0A,%00110000,%10)
		%OAMTile(15,$C8,$0F,$14,%00110000,%00)
		%OAMTile(33,$B8,$17,$21,%00110000,%00)
		%OAMTile(34,$C0,$17,$22,%00110000,%00)
		%OAMTile(35,$C8,$17,$23,%00110000,%00)
		%OAMTile(36,$D0,$0F,$0C,%00110000,%10)
		%OAMTile(37,$E0,$0F,$0E,%00110000,%10)
		%OAMTileYoshiCoin(0,$40,44)
		%OAMTileYoshiCoin(1,$48,45)
		%OAMTileYoshiCoin(2,$50,46)
		%OAMTileYoshiCoin(3,$58,47)
		LDA.b #$01		; \
		STA.w !addr|$170B	;  | fix a few
		STA.w !addr|$170C	;  | extended sprite
		STA.w !addr|$1711	;  | glitches
		STA.w !addr|$1712	; /
		STZ !addr|$176F
		STZ !addr|$1770
		STZ !addr|$1775
		STZ !addr|$1776
		SEP #%00010000		; 8-bit XY
		REP #%00100000		; 16-bit A
		LDA.w #!RAMBuffer	; \
		STA.w $2181		;  |
		LDY.b #!RAMBuffer>>16	;  |
		STY.w $2183		;  |
		STZ.w $4300		;  |
		LDY.b #$80		;  |
		STY.w $4301		;  |
		LDA.w #!MarioName	;  | upload
		LDY.w !addr|$0DB3	;  | character
		BEQ NotLuigi		;  | name
		LDA.w #!LuigiName	;  |
NotLuigi:	CLC : ADC.w #Graphics	;  |
		STA.w $4302		;  |
		LDY.b #Graphics>>16	;  |
		STY.w $4304		;  |
		LDA.w #$00A0		;  |
		STA.w $4305		;  |
		LDY.b #%00000001	;  |
		STY.w $420B		; /
		%number(!addr|$0F13,$01C0,$05)
		%number(!addr|$0F14,$01E0,$05)
		%number(!addr|$0F16,$0240,$05)
		%number(!addr|$0F17,$0260,$05)
		%number(!addr|$0F25,$0320,$15)
		%number(!addr|$0F26,$0340,$15)
		%number(!addr|$0F27,$0360,$15)
		%number(!addr|$0F29,$0420,$05)
		%number(!addr|$0F2A,$0440,$05)
		%number(!addr|$0F2B,$0460,$05)
		%number(!addr|$0F2C,$0380,$05)
		%number(!addr|$0F2D,$03A0,$05)
		%number(!addr|$0F2E,$03C0,$05)
		%bonusstar(!addr|$0F03,$00A0)
		%bonusstar(!addr|$0F04,$00C0)
		%bonusstar(!addr|$0F1E,$02A0)
		%bonusstar(!addr|$0F1F,$02C0)
		SEP #%00100000
		PLB
		RTL

AllowedModes:
		db $00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$01,$00,$00,$00,$01
		db $00,$00,$01,$01,$01,$01,$00,$00
		db $00,$00,$00,$00,$00

IRQHack:	PHB : PHK : PLB		; back up B, K -> B
		LDX.w !addr|$0100	; \
		LDA.w AllowedModes,x	;  | Check game mode
		BNE IRQCheckLevel	; /
DefaultIRQ:	REP.b #%00010000	; 16-bit X/Y
		LDY.w !addr|$010B	; Level number -> Y index
		LDA.w LevelIRQ,y	; get IRQ start
		SEP.b #%00010000	; 8-bit X/Y
		PLB			; restore B
		TAY			; IRQ start -> Y
		LDA.w $4211		; dummy read
		JML $008297		; JML to rest of default IRQ


IRQCheckLevel:	REP #%00010000		; 16-bit A/XY
		SEP #%00010000		; 8-bit XY
		LDX.w !addr|$010B	; Level number -> X Index
		LDA.w LevelEnabled,x	; get SSB-enabled status
		CMP.b #$00		; \ if SSB disabled,
		BEQ DefaultIRQ		; / then no IRQ hack
		PLB			; restore B
		LDY.b #$E0		; \ all 224
		LDA.w $4211		; / scanlines
		STY.w $4209		; \ Vertical IRQ
		STZ.w $420A		; / trigger counters
		LDA.w !addr|$0DAE	; \ brightness 
		STA.w $2100		; /
		LDA.w !addr|$0D9F	; \ HDMA
		STA.w $420C		; /
		JML $008394		; JML to layer 3 scrolling, etc.

SBUploadHack:	PHB : PHK : PLB		; back up B, K -> B
		REP #%00010000		; 16-bit A/XY
		LDX.w !addr|$010B	; Level number -> X index
		LDA.w LevelEnabled,x	; \  if SSB disabled, then
		BNE +			;  | upload regular SB tilemap
		JMP DrawSB		; /
+		LDA.w !addr|$0100	; \  during level load,
		CMP.b #$12		;  | only the status bar
		BEQ SBDMA		; /  is important
		LDA.b $14		; \
		AND.b #%00000001	;  | alternate
		BNE GoalPtChk		; /
SBDMA:		LDA.w LevelSBProp,x	; \
		AND.b #%00000001	;  | which GFX page
		XBA			; /
		LDA.w LevelGFXLoc,x	; get starting tile of GFX
		SEP #%00010000		; 8-bit XY
		REP #%00100000		; 16-bit A
		LDY.b #%10000000	; \ increment when high
		STY.w $2115		; / byte is accessed
		ASL #4			; x16 (#$10)
		CLC : ADC.w #$6000	; +#$6000
		STA.w $2116		; set as VRAM destination
		LDY.b #$01		; \
		STY.w $4300		;  | rest of
		LDY.b #$18		;  | GFX buffer
		STY.w $4301		;  | transfer
		LDA.w #!RAMBuffer	;  | to VRAM
		STA.w $4302		;  |
		LDY.b #!RAMBuffer>>16	;  |
		STY.w $4304		;  |
		LDA.w #!SBGFXSize	;  |
		STA.w $4305		;  |
		LDY.b #%00000001	;  |
		STY.w $420B		; /
		SEP #%00100000		; 8-bit A
		PLB			; restore B
		JML $008DE6		; JML to end of DrawStatusBar routine
GoalPtChk:	SEP #%00010000		; 8-bit XY
		LDY.w !addr|$1493	; \ no goal text upload
		BEQ NoGoalPt		; / unless level is ending
		REP #%00010000		; 16-bit A/XY
		SEP #%00100000		; 8-bit A
		LDX.w !addr|$010B	; Level number -> X index
		LDA.w LevelSBProp,x	; \
		AND.b #%00000001	;  | which GFX page
		XBA			; /
		LDA.w LevelGFXLoc,x	; get starting tile of GFX
		CLC : ADC.b #$24	; 24 tiles after. NOTE TO SELF: change this when making this changeable
		SEP #%00010000		; 8-bit XY
		REP #%00100000		; 16-bit A
		LDY.b #%10000000	; \ increment when high
		STY.w $2115		; / byte is accessed
		ASL #4			; x16 (#$10)
		CLC : ADC.w #$6000	; +#$6000
		STA.w $2116		; set as VRAM destination
		LDY.b #$01		; \
		STY.w $4300		;  | rest of
		LDY.b #$18		;  | GFX buffer
		STY.w $4301		;  | transfer
		LDA.w #!RAMBuffer2	;  | to VRAM
		STA.w $4302		;  |
		LDY.b #!RAMBuffer2>>16	;  |
		STY.w $4304		;  |
		LDA.w #!GPGFXSize	;  |
		STA.w $4305		;  |
		LDY.b #%00000001	;  |
		STY.w $420B		; /
NoGoalPt:	SEP #%00100000		; 8-bit A
		PLB			; restore B
		JML $008DE6		; JML to end of DrawStatusBar routine
DrawSB:		SEP #%00010000		; 8-bit XY
		PLB			; restore B
		LDA.b #$42		; what A would be (doing this is easier than preserving A)
		STA.w $2116		; \ hijacked
		LDA.b #$50		; / code
		JML $008DB6		; JML to next part of DrawStatusBar routine

CoinBlockFix:	PHX			; backup X
		REP #%00010000		; 16-bit A/XY
		SEP #%00100000		; 8-bit A
		LDX.w !addr|$010B	; Level number -> X index
		PHB : PHK : PLB		; Back up B, K -> B
		LDA.w LevelEnabled,x	; get SSB-enabled status
		STA.b $00		; store to scratch RAM
		PLB			; restore B
		SEP #%00010000		; 8-bit XY
		PLX			; restore X
		LDA.b $00		; load scratch RAM (SSB-enabled status)
		BEQ EndCBF		; no fix if not enabled
		DEX			; \  last 3 slots can't
		CPX.b #$02		;  | be used because
		BMI ReturnCBF		; /  SSB uses them
		JML $0299D4		; back
EndCBF:		DEX			; \ normal, non-SSB
		BMI ReturnCBF		; / level
		JML $0299D4		; back
ReturnCBF:	JML $0299E8		; a RTS in bank 02

ScoreSprFix:	PHX			; backup X
		REP #%00010000		; 16-bit A/XY
		LDX.w !addr|$010B	; Level number -> X index
		PHB : PHK : PLB		; Back up B, K -> B
		LDA.w LevelEnabled,x	; get SSB-enabled status
		STA.b $00		; store to scratch RAM
		PLB			; restore B
		SEP #%00010000		; 8-bit XY
		PLX			; restore X
		LDY.b #$05		; normally we'd have 5 slots available
		LDA.b $00		; \  but if SSB is enabled
		BEQ CODE_02AD36		;  | then we only have
		LDY.b #$03		; /  three available
CODE_02AD36:	LDA.w !addr|$16E1,y	; \
		BEQ Return02AD4B	;  | SMW's code
		DEY			;  |
		BPL CODE_02AD36		;  |
		DEC.w !addr|$18F7	;  |
		BPL CODE_02AD48		;  |
		LDA.b #$03		;  |
		STA.w !addr|$18F7	;  |
CODE_02AD48:	LDY.w !addr|$18F7	; /
Return02AD4B:	RTL

BonusStarFix:
		STZ.w !addr|$1337
		PHA			; \ hijacked
		LSR #3			; / code
		PHA			; backup A
		REP #%00010000		; 16-bit A/XY
		LDX.w !addr|$010B	; Level number -> X index
		PHB : PHK : PLB		; Back up B, K -> B
		LDA.w LevelEnabled,x	; get SSB-enabled status
		PLB			; restore B
		SEP #%00010000		; 8-bit XY
		CMP.b #$00		; \ if not disabled,
		BNE AltBonusStarCode	; / use alternate bonus star code
		PLA			; restore A
		JML $07F1DF

AltBonusStarCode:
		LDA.b #$10
		STA.w !addr|$1692
		JSR GetOAMSlot
		PLA
		LSR
		TAX
		BEQ CODE_07F1ED
		LDA.l $07F1A0,x
		TAX
		JSR CODE_07F200
CODE_07F1ED:	PLA                       
		AND.b #$0F                
		TAX                       
		LDA.l $07F1A0,x       
		TAX                       
		LDA.b #$20                
		STA.b $02            
		JSR.w CODE_07F200         
		RTL

CODE_07F200:	LDA.l $07F0C8,x		; same as original SMW code,
		BMI CODE_07F24A		; but uses second half of OAM
		CLC
		ADC.b #$64                
		CLC                       
		ADC.b $02                   
		STA.w !addr|$0300,y 
		LDA.l $07F134,x       
		CLC                       
		ADC.b #$40                
		STA.w !addr|$0301,y 
		LDA.b #$EF                
		PHX                       
		LDX $04                   
		CPX.b #$10                
		BCS CODE_07F22A           
		TXA                       
		LSR #2
		TAX                       
		LDA.l $07F24E,x       
CODE_07F22A:	STA.w !addr|$0302,y  
		PLX                       
		LDA.b $13      
		LSR                       
		AND.b #$0E                
		ORA.b #$30                
		STA.w !addr|$0303,y  
		PHY                       
		TYA                       
		LSR #2
		TAY                       
		LDA.b #$00
		STA.w !addr|$0460,y
		PLY                       
		INY #4
		INX                       
		BRA CODE_07F200           
CODE_07F24A:	LDX.w !addr|$15E9
		RTS

GoalTextFix:	REP #%00010000		; 16-bit A/XY
		LDX.w !addr|$010B	; Level number -> X index
		PHB : PHK : PLB		; Back up B, K -> B
		LDA.w LevelEnabled,x	; get SSB-enabled status
		PLB			; restore B
		SEP #%00010000		; 8-bit XY
		CMP.b #$00		; \ if not disabled,
		BNE AltGoalTextCode	; / use alternate goal text code
		JML $05CBFF		; routine for normal L3 text

AltGoalTextCode:
		JSR DisplayGPText
		
	if !sa1
		LDA.b #.code
		STA $0183
		LDA.b #.code/256
		STA $0184
		LDA.b #.code/65536
		STA $0185
		LDA #$D0
		STA $2209
	-	LDA $018A
		BEQ -
		STZ $018A
		RTL
	.code
	endif
	
		LDA.w !addr|$13D9
		JSL $0086DF

		dw CODE_05CC66
		dw CODE_05CD76
		dw CODE_05CECA
		dw Return05CFE9

CODE_05CC66:	LDA.b #$10
		STA.w !addr|$1692
		LDY.b #$00
		LDX.w !addr|$0DB3
		LDA.w !addr|$0F48,x
CODE_05CC6E:	CMP.b #$0A
		BCC CODE_05CC77
		SBC.b #$0A
		INY
		BRA CODE_05CC6E
CODE_05CC77:	CPY.w !addr|$0F32
		BNE CODE_05CC84
		CPY.w !addr|$0F33
		BNE CODE_05CC84
		INC.w !addr|$18E4
CODE_05CC84:	LDA.b #$01
		STA.w !addr|$13D5
		REP #%00100000		; 16-bit A
		LDA.w #!RAMBuffer2	; \
		STA.w $2181		;  |
		LDY.b #!RAMBuffer2>>16	;  |
		STY.w $2183		;  |
		STZ.w $4300		;  |
		LDY.b #$80		;  | copy main GFX
		STY.w $4301		;  | to RAM buffer
		LDA.w #!CopyToRAM2+Graphics
		STA.w $4302		;  |
		LDY.b #Graphics>>16	;  |
		STY.w $4304		;  |
		LDA.w #!GPGFXSize	;  |
		STA.w $4305		;  |
		LDY.b #%00000001	;  |
		STY.w $420B		; /
		SEP #%00100000		; 8-bit A
		JSR CODE_05CE4C
		REP #%00100000		; 16-bit A     
		LDA $02
		STA.w !addr|$0F40
		JSR ScoreToDecimal
		JSR UpdateScoreCounter
		SEP #%00100000		; 8-bit A
		LDA.w !addr|$0F31
		BNE TimeXXX
		JMP Time0XX
TimeXXX:	REP.b #%00100000
		%numberGP(!addr|$0F31,$0400,$05)
Time10s:	%numberGP(!addr|$0F32,$0420,$05)
Time1s:		%numberGP(!addr|$0F33,$0440,$05)
		SEP.b #%00100000
		INC.w !addr|$13D9
		LDA.b #$28
		STA.w !addr|$1424
		RTL
Time00X:	REP.b #%00100000
		%transGP($0400)
		%transGP($0420)
		JMP Time1s
Time0XX:	LDA.w !addr|$0F32
		BEQ Time00X
		REP.b #%00100000
		%transGP($0400)
		JMP Time10s

CODE_05CD76:	LDA.w !addr|$1900
		BNE +
		JMP +++
+		DEC.w !addr|$1424
		BPL Return05CDE8
		JSR UpdateBonusCounter
+++		DEC.w !addr|$13D6               
		BPL Return05CDE8          
		LDA.w !addr|$1900
		STA.w !addr|$1424               
		INC.w !addr|$13D9               
		LDA.b #$11                
		STA.w !addr|$1DFC
Return05CDE8:	RTL

CODE_05CE4C:	REP #$20                  ; Accum (16 bit) 
		LDA.w !addr|$0F31               
		ASL
		TAX
		LDA.l $05CE3A,x       
		STA $00                   
		LDA.w !addr|$0F32               
		TAX
		LDA.l $05CE42,x
		AND.w #$00FF
		CLC
		ADC $00                   
		STA $00                   
		LDA.w !addr|$0F33               
		AND.w #$00FF              
		CLC
		ADC $00                   
		STA $00                   
		SEP #$20                  ; Accum (8 bit) 
		LDA $00                   
		STA.w $4202               ; Multiplicand A
		LDA.b #$32                
		STA.w $4203               ; Multplier B
		NOP #4
		LDA.w $4216               ; Product/Remainder Result (Low Byte)
		STA $02                   
		LDA.w $4217               ; Product/Remainder Result (High Byte)
		STA $03                   
		LDA $01                   
		STA.w $4202               ; Multiplicand A
		LDA.b #$32                
		STA.w $4203               ; Multplier B
		NOP #4
		LDA.w $4216               ; Product/Remainder Result (Low Byte)
		CLC
		ADC $03
		STA $03
		RTS

ScoreToDecimal:	LDX.b #$FF		; \  couldn't find original SMW code for this...
		LDA.w !addr|$0F40	;  | so I wrote my own version
-		STA.b $04		;  | this converts the coin score ($0F40)...
		INX			;  | into decimal, with one byte per power of 10
		SEC			;  v
		SBC.w #10000
		BCS -
		STX.b $00
		LDX.b #$FF
		LDA.b $04
-		STA.b $04
		INX
		SEC
		SBC.w #1000
		BCS -
		STX.b $01
		LDX.b #$FF
		LDA.b $04
-		STA.b $04
		INX
		SEC
		SBC.w #100
		BCS -
		STX.b $02
		LDX.b #$FF
		LDA.b $04
-		STA.b $04
		INX
		SEC
		SBC.w #10		;  ^
		BCS -			;  |
		STX.b $03		; /
		RTS

UpdateScoreCounter:
		LDY $00
		BNE Sc0
		JMP Score0XXXX
Sc0:		%numberGPb($00,$04E0,$05)
Sc1:		%numberGPb($01,$0500,$05)
Sc2:		%numberGPb($02,$0520,$05)
Sc3:		%numberGPb($03,$0540,$05)
Sc4:		%numberGPb($04,$0560,$05)
		RTS
Score0XXXX:	LDY $01
		BEQ Score00XXX
		%transGP($04E0)
		JMP Sc1
Score00XXX:	LDY $02
		BEQ Score000XX
		%transGP($04E0)
		%transGP($0500)
		JMP Sc2
Score000XX:	LDY $03
		BEQ Score0000X
		%transGP($04E0)
		%transGP($0500)
		%transGP($0520)
		JMP Sc3
Score0000X:	%transGP($04E0)
		%transGP($0500)
		%transGP($0520)
		%transGP($0540)
		JMP Sc4

CODE_05CECA:	PHB : PHK : PLB
		REP #%00100000
		LDY.b #$00
		LDA.w !addr|$0DB3
		AND.w #$00FF
		BEQ CODE_05CEDB
		LDY.b #$03
CODE_05CEDB:	LDX.b #$02
		LDA.w !addr|$0F40
		BEQ CODE_05CF05
		CMP.w #$0063
		BCS CODE_05CEE9
		LDX.b #$00
CODE_05CEE9:	SEC : SBC.l $05CEC2,x
		STA.w !addr|$0F40
		STA $02
		LDA.l $05CEC6,x
		CLC : ADC.w !addr|$0F34,y
		STA.w !addr|$0F34,y
		LDA.w !addr|$0F36,y
		ADC.w #$0000
		STA.w !addr|$0F36,y
CODE_05CF05:	LDY.w !addr|$1900
		BEQ CODE_05CF36
		SEP #%00100000
		LDA.b $13
		AND.b #$03
		BNE CODE_05CF34
		LDY.w !addr|$0DB3
		LDA.w !addr|$0F48,y
		CLC : ADC.b #$01
		STA.w !addr|$0F48,y
		LDA.w !addr|$1900
		DEC A
		STA.w !addr|$1900
		AND.b #$0F
		CMP.b #$0F
		BNE CODE_05CF34
		LDA.w !addr|$1900
		SEC             
		SBC.b #$06
		STA.w !addr|$1900
CODE_05CF34:	REP #%00100000
CODE_05CF36:	LDA.w !addr|$0F40
		BNE CODE_05CF4D
		LDX.w !addr|$1900
		BNE CODE_05CF4D
		LDY.b #$30
		STY.w !addr|$13D6
		INC.w !addr|$13D9
		LDY.b #$12
		STY.w !addr|$1DFC
CODE_05CF4D:	JSR ScoreToDecimal
		JSR UpdateScoreCounter
		LDA.w !addr|$1424
		BEQ CODE_05CFDC
		SEP #%00100000
		JSR UpdateBonusCounter
CODE_05CFDC:	PLB
		SEP #%00110000
Return05CFE9:	RTL

ReturnGPText:	RTS

DisplayGPText:
	STZ.w !addr|$1337
		LDA.w !addr|$13D9	; \ prevent the split-second glitch
		BEQ ReturnGPText	; / that shows up 50% of the time
		PHB : PHK : PLB		; Back up B, K -> B
		JSR GetOAMSlot		; get slot for sprites
		REP #%00110000		; 16-bit A/XY
		LDX.w !addr|$010B	; Level number -> X index
		LDA.w #$0000		; high byte MUST be zero or tile sizes will glitch
		SEP #%00100000		; 8-bit A
		%OAMTileGPc(0,$68,$3F,$00,%00110000,%00)
		%OAMTileGPc(1,$70,$3F,$01,%00110000,%00)
		%OAMTileGPc(2,$78,$3F,$02,%00110000,%00)
		%OAMTileGPc(3,$80,$3F,$03,%00110000,%00)
		%OAMTileGPc(4,$88,$3F,$04,%00110000,%00)
		%OAMTileGP(5,$48,$4F,$00,%00110000,%10)
		%OAMTileGP(6,$58,$4F,$02,%00110000,%10)
		%OAMTileGP(7,$68,$4F,$04,%00110000,%10)
		%OAMTileGP(8,$80,$4F,$06,%00110000,%10)
		%OAMTileGP(9,$90,$4F,$08,%00110000,%10)
		%OAMTileGP(10,$A0,$4F,$0A,%00110000,%10)
		%OAMTileGP(11,$48,$67,$0F,%00110000,%00)
		%OAMTileGP(12,$50,$5F,$10,%00110000,%10)
		%OAMTileGP(13,$60,$5F,$12,%00110000,%10)
		%OAMTileGP(14,$70,$5F,$14,%00110000,%10)
		%OAMTileGP(15,$80,$5F,$16,%00110000,%10)
		%OAMTileGP(16,$90,$5F,$18,%00110000,%10)
		%OAMTileGP(17,$A0,$5F,$1A,%00110000,%10)
		LDA.w !addr|$13D9
		CMP #$01
		BEQ +
		CMP #$02
		BCS ++
-		JMP +++
+		LDA.w !addr|$1424
		BPL -
++		LDA.w !addr|$1424
		BEQ -
		%OAMTileGP(18,$50,$7F,$0C,%00110000,%00)
		%OAMTileGP(19,$58,$7F,$01,%00110000,%00)
		%OAMTileGP(20,$60,$7F,$0D,%00110000,%00)
		%OAMTileGP(21,$68,$7F,$02,%00110000,%00)
		%OAMTileGP(22,$70,$7F,$04,%00110000,%00)
		%OAMTileGP(23,$78,$7F,$0B,%00110000,%00)
		%OAMTileGP(24,$88,$77,$1C,%00110000,%10)
		%OAMTileGP(25,$98,$77,$1E,%00110000,%10)
+++		SEP #%00010000
		PLB			; restore B
		RTS

UpdateBonusCounter:
		LDA.w !addr|$1900
		AND.b #$0F
		ASL
		TAX
		REP #%00100000
		%bonusstarGP($05CD62,$03E0)
		%bonusstarGP($05CD63,$05E0)
		SEP #%00100000
		LDA.w !addr|$1900
		AND.b #$F0                
		LSR #3
		BNE ++
		REP #%00100000
          	%transGP($03C0)
          	%transGP($05C0)
		SEP #%00100000
		RTS
++		TAX
		REP #%00100000
		%bonusstarGP($05CD62,$03C0)
		%bonusstarGP($05CD63,$05C0)
		SEP #%00100000
		RTS

GetOAMSlot:
		LDY #$FC
	-	LDA $02FD|!addr,y
		CMP #$F0
		BNE +
		CPY #$3C
		BEQ +
		DEY
		DEY
		DEY
		DEY
		BRA -
	+	RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Level Tables - Enable / GFX Offset / Properties / IRQ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LevelEnabled:	db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 00-07
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 08-0F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 10-17
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 18-1F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 20-27
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 28-2F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 30-37
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 38-3F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 40-47
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 48-4F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 50-57
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 58-5F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 60-67
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 68-6F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 70-77
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 78-7F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 80-87
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 88-8F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 90-97
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 98-9F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels A0-A7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels A8-AF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels B0-B7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels B8-BF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels C0-C7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels C8-CF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels D0-D7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels D8-DF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels E0-E7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels E8-EF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels F0-F7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels F8-FF
		db $00,$00,$00,$00,$01,$01,$01,$00 ;Levels 100-107
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 108-10F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 110-117
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 118-11F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 120-127
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 128-12F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 130-137
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 138-13F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 140-147
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 148-14F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 150-157
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 158-15F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 160-167
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 168-16F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 170-177
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 178-17F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 180-187
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 188-18F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 190-197
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 198-19F
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1A0-1A7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1A8-1AF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1B0-1B7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1B8-1BF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1C0-1C7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1C8-1CF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1D0-1D7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1D8-1DF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1E0-1E7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1E8-1EF
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1F0-1F7
		db $00,$00,$00,$00,$00,$00,$00,$00 ;Levels 1F8-1FF

LevelGFXLoc:	db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 00-07
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 08-0F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 10-17
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 18-1F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 20-27
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 28-2F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 30-37
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 38-3F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 40-47
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 48-4F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 50-57
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 58-5F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 60-67
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 68-6F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 70-77
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 78-7F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 80-87
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 88-8F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 90-97
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 98-9F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels A0-A7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels A8-AF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels B0-B7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels B8-BF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels C0-C7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels C8-CF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels D0-D7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels D8-DF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels E0-E7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels E8-EF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels F0-F7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels F8-FF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 100-107
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 108-10F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 110-117
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 118-11F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 120-127
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 128-12F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 130-137
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 138-13F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 140-147
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 148-14F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 150-157
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 158-15F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 160-167
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 168-16F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 170-177
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 178-17F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 180-187
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 188-18F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 190-197
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 198-19F
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1A0-1A7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1A8-1AF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1B0-1B7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1B8-1BF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1C0-1C7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1C8-1CF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1D0-1D7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1D8-1DF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1E0-1E7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1E8-1EF
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1F0-1F7
		db $80,$80,$80,$80,$80,$80,$80,$80 ;Levels 1F8-1FF

LevelSBProp:	db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 00-07
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 08-0F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 10-17
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 18-1F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 20-27
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 28-2F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 30-37
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 38-3F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 40-47
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 48-4F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 50-57
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 58-5F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 60-67
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 68-6F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 70-77
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 78-7F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 80-87
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 88-8F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 90-97
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 98-9F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels A0-A7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels A8-AF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels B0-B7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels B8-BF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels C0-C7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels C8-CF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels D0-D7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels D8-DF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels E0-E7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels E8-EF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels F0-F7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels F8-FF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 100-107
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 108-10F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 110-117
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 118-11F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 120-127
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 128-12F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 130-137
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 138-13F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 140-147
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 148-14F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 150-157
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 158-15F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 160-167
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 168-16F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 170-177
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 178-17F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 180-187
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 188-18F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 190-197
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 198-19F
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1A0-1A7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1A8-1AF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1B0-1B7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1B8-1BF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1C0-1C7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1C8-1CF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1D0-1D7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1D8-1DF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1E0-1E7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1E8-1EF
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1F0-1F7
		db %00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111,%00001111 ;Levels 1F8-1FF

LevelIRQ:	db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 00-07
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 08-0F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 10-17
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 18-1F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 20-27
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 28-2F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 30-37
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 38-3F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 40-47
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 48-4F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 50-57
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 58-5F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 60-67
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 68-6F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 70-77
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 78-7F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 80-87
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 88-8F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 90-97
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 98-9F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels A0-A7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels A8-AF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels B0-B7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels B8-BF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels C0-C7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels C8-CF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels D0-D7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels D8-DF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels E0-E7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels E8-EF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels F0-F7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels F8-FF
		db $24,$24,$24,$24,$01,$01,$01,$24 ;Levels 100-107
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 108-10F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 110-117
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 118-11F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 120-127
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 128-12F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 130-137
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 138-13F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 140-147
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 148-14F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 150-157
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 158-15F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 160-167
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 168-16F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 170-177
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 178-17F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 180-187
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 188-18F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 190-197
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 198-19F
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1A0-1A7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1A8-1AF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1B0-1B7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1B8-1BF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1C0-1C7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1C8-1CF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1D0-1D7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1D8-1DF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1E0-1E7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1E8-1EF
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1F0-1F7
		db $24,$24,$24,$24,$24,$24,$24,$24 ;Levels 1F8-1FF

Graphics:
INCBIN ssb.bin


; from garble.asm that comes with dsx.asm
org $00A08A
		JML GarbleMain

org $04F270			; Nine bytes of freespace in bank 04
GarbleMain:	JSR $DD40	; re-decompress the OW tiles
		LDA !addr|$1B9C
		BEQ DoTheBranch
		JML $00A08F
DoTheBranch:	JML $00A093
;smb3 status bar
;by Ladida
;lm300 + custom powerup support by lx5

	!freeram = $7FB500
	!dp = $0000
	!addr = $0000
	!bank = $800000
	!sa1 = 0
	!gsu = 0

if read1($00FFD6) == $15
	sfxrom
	!freeram = $7FB500
	!dp = $6000
	!addr = !dp
	!bank = $000000
	!gsu = 1
elseif read1($00FFD5) == $23
	sa1rom
	!freeram = $40C600
	!dp = $3000
	!addr = $6000
	!bank = $000000
	!sa1 = 1
endif

!_custom_powerups = 0

if read1($028008) == $5C
	!_custom_powerups = 1
endif

;DONT edit these unless you know what you're doing
!status_tile 	= !freeram+$100
!status_prop 	= !status_tile+$80	;due to shenanigans this should be above+$80
!status_palette = !freeram		;status bar palette is here (64 bytes)
!status_OAM	= $0EFC|!addr		;status bar OAM is here (5 tiles + 32 byte high table)



;;;; STATUS BAR DEFINES ;;;;

incsrc smb3_status_defines.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!l1y_end = !freeram+$40
!l1y_mirror = !freeram+$40+2
!l1y_mirror_alt = !freeram+$40+4
!l2y_mirror = !freeram+$40+6
!l2y_mirror_alt = !freeram+$40+8
!l3_line1 = !freeram+$40+10
!l3_line2 = !freeram+$40+12
!hdmatbl = !freeram+$40+14


;This displays the RAM address on the Asar console window.
print ""
print "RAM address ranges:"
print "l1y_end:             $", hex(!l1y_end), " to $", hex(!l1y_end+1)        
print "l1y_mirror:          $", hex(!l1y_mirror), " to $", hex(!l1y_mirror+1)     
print "l1y_mirror_alt:      $", hex(!l1y_mirror_alt), " to $", hex(!l1y_mirror_alt+1) 
print "l2y_mirror:          $", hex(!l2y_mirror), " to $", hex(!l2y_mirror+1)     
print "l2y_mirror_alt:      $", hex(!l2y_mirror_alt), " to $", hex(!l2y_mirror_alt+1) 
print "l3_line1:            $", hex(!l3_line1), " to $", hex(!l3_line1+1)       
print "l3_line2:            $", hex(!l3_line2), " to $", hex(!l3_line2+1)       
print "hdmatbl:             $", hex(!hdmatbl), " to $", hex(!hdmatbl+(hdmatbl_end-hdmatbl-1))
print ""
print "status_tile:         $", hex(!status_tile), " to $", hex(!status_tile+$7F)
print "-Tile number ranges (32 bytes each):"
print "--Row 0:              $", hex(!status_tile+$00), " to $", hex(!status_tile+$1F)
print "--Row 1:              $", hex(!status_tile+$20), " to $", hex(!status_tile+$3F)
print "--Row 2:              $", hex(!status_tile+$40), " to $", hex(!status_tile+$5F)
print "--Row 3:              $", hex(!status_tile+$60), " to $", hex(!status_tile+$7F)
print ""
print "status_prop:         $", hex(!status_prop), " to $", hex(!status_prop+$7F)
print "-Tile properties ranges (32 bytes each):"
print "--Row 0:              $", hex(!status_prop+$00), " to $", hex(!status_prop+$1F)
print "--Row 1:              $", hex(!status_prop+$20), " to $", hex(!status_prop+$3F)
print "--Row 2:              $", hex(!status_prop+$40), " to $", hex(!status_prop+$5F)
print "--Row 3:              $", hex(!status_prop+$60), " to $", hex(!status_prop+$7F)
print ""
print "status_palette:      $", hex(!status_palette), " to $", hex(!status_palette+$3F)
print "-Palette ranges (8 bytes each):"
print "--Palette 0:          $", hex(!status_palette+$00), " to $", hex(!status_palette+$07)
print "--Palette 1:          $", hex(!status_palette+$08), " to $", hex(!status_palette+$0F)
print "--Palette 2:          $", hex(!status_palette+$10), " to $", hex(!status_palette+$17)
print "--Palette 3:          $", hex(!status_palette+$18), " to $", hex(!status_palette+$1F)
print "--Palette 4:          $", hex(!status_palette+$20), " to $", hex(!status_palette+$27)
print "--Palette 5:          $", hex(!status_palette+$28), " to $", hex(!status_palette+$2F)
print "--Palette 6:          $", hex(!status_palette+$30), " to $", hex(!status_palette+$37)
print "--Palette 7:          $", hex(!status_palette+$38), " to $", hex(!status_palette+$3F)
print ""
print "status_OAM:          $", hex(!status_OAM), " to $", hex(!status_OAM+3)
print ""



;various LM stuff

if read3($00820A|!bank) == $0087AD || read2($00820A|!bank) == $8087AD 
	print "Lunar Magic VRAM modification not detected. Enjoy the bugs! (install it)"
endif

if read1($00A01F|!bank) != $22
	print "Lunar Magic Layer 3 ExGFX hack not detected. Enjoy the bugs! (install it)"
endif

if read1($0081E2|!bank) == $5C
	org read3($0081E3|!bank)+7	;LM hijack that skips position update during lag
	dl LagFix|!bank		;we need to run the sprite DMA so we rewrite it
else
	org $0081E2|!bank
	JMP LagFixPre
endif

org $00A0BF
	autoclean jml HandleOWReload
	nop #1

org $008292|!bank		;run IRQ on this scanline
LDY.b #$C0-!status_fblank

org $0082A4|!bank		;NMI hijack
autoclean JML PreStatusBar
NOP #2

org $00838F|!bank		;IRQ hijack
autoclean JML PostStatusBar
NOP

org $05BEA2|!bank
JML UploadStatusBar

org $0082E8|!bank
BRA $01 : NOP
org $0081F4|!bank
BRA $01 : NOP

org $008DAC|!bank
UploadStatusBar:
LDX $0100|!addr
CPX #$12
BNE +
if !GraphicExGFX >= $0080
STZ $00
LDA #$7EAD : STA $01
LDA.w #!GraphicExGFX
JSL $0FF900|!bank
endif
LDX #$80 : STX $2115
LDA #$4000 : STA $2116
LDA #$1801 : STA $4310
if !GraphicExGFX >= $0080
LDA #$AD00 : STA $4312
LDX #$7E : STX $4314
LDA $8D : STA $4315
else
LDA.w #StatusBarGFX : STA $4312
LDX.b #StatusBarGFX>>16|(!bank>>16) : STX $4314
LDA.w #StatusBarGFX_end-StatusBarGFX : STA $4315
endif
LDX #$02 : STX $420B
LDX #$3F
-
LDA.l StatusBarPAL|!bank,x
STA !status_palette,x
DEX : BPL -
+
SEP #$20	;restore hijack
PLB : RTL

warnpc $008DF9|!bank



org $008CFF|!bank	;initialize !statusloc
LDA $0D9B|!addr
BNE +
if !TilemapExGFX >= $0080
STZ $00
REP #$20
LDA #$7EAD : STA $01
LDA.w #!TilemapExGFX
JSL $0FF900|!bank
SEP #$20
endif

phb
lda.b #!status_tile/$10000
pha
plb

LDX #$FE
LDY #$7F
-
if !TilemapExGFX >= $0080
LDA $7EAD00,x
else
LDA.l StatusBarMAP|!bank,x
endif
STA.w !status_tile,y
if !TilemapExGFX >= $0080
LDA $7EAD01,x
else
LDA.l StatusBarMAP|!bank+1,x
endif
STA.w !status_prop,y
DEX #2
DEY : BPL -

plb

LDX #$33
-
LDA.l OAMTABLE|!bank,x
STA !status_OAM,x
DEX : BPL -
LDX.b #hdmatbl_end-hdmatbl-1
-
LDA.l hdmatbl|!bank,x
STA !hdmatbl,x
DEX : BPL -
LDA #$00
STA !l3_line1
STA !l3_line1+1
STA !l3_line2
STA !l3_line2+1
+
LDA #$28
STA $0F30|!addr
RTS

warnpc $008D8A|!bank

org $009079|!bank
autoclean JSL ItemBoxFix
RTS
LDA $13BF|!addr
LSR #3
TAY
LDA $13BF|!addr
AND #$07
TAX
LDA $1F2F|!addr,y
AND $05B35B|!bank,x
BEQ +
LDA.b #!yicoins_max
STA $1422|!addr
+
LDA $1422|!addr
RTS

chartable:
db !player_1_TILE,!player_2_TILE
db !player_1_PROP,!player_2_PROP

pmetermath:
LDA #$70
STA $4204
STZ $4205
if !pmeter_icon
	LDA.b #!LEN_pmeter+1
else
	LDA.b #!LEN_pmeter
endif
STA $4206
NOP
LDA $13E4|!addr
STA $4204
CLC : ADC #$10
LDA $4214
STA $4206
NOP #2
JMP +
+ RTS

warnpc $0090D1|!bank

org $028060|!bank
db $00		;Y pos of dropped item




;;;;;speed up NMI;;;;;
org $00A4D1|!bank
JSR $AE41

org $00AE41|!bank
REP #$20
LDA $0701|!addr
ASL #3
SEP #$21
ROR #3
XBA
ORA #$40
STA $2132
LDA $0702|!addr
LSR A
SEC : ROR
STA $2132
XBA
STA $2132
RTS
NOP #3
;;;;;;;;;;;;;;;;;;;;;;

org $008E6F|!bank
	jml status_bar_time

status_bar_lives_write:
	txa
	sta !lives
	rts
	
status_bar_score_2_write:
	lda !score,x
	inc
	sta !score,x
	rts 

status_bar_score_1_write:
	lda #$00
	sta !score,x
	rts

status_bar_coins_write:
	sta !coins+$1
	txa
	sta !coins
	rts

warnpc $008E95|!bank




org $008EE0|!bank	;Score hijacks
jsr status_bar_score_read
org $008F0E|!bank
jsr status_bar_score_read
org $008EE7|!bank
if !score != 0
	jsr status_bar_score_3_write
else
	NOP #3
endif
org $008F15|!bank
if !score != 0
	jsr status_bar_score_3_write
else
	NOP #3
endif
org $008ED7|!bank
LDX #$00
org $008F05|!bank
LDX #$00
org $009014|!bank
if !score != 0
	jsr status_bar_score_1_write
else
	NOP #3
endif


org $009034|!bank
if !score != 0
	jsr status_bar_score_2_write
else
	NOP #3
endif

org $008EE5|!bank
LDA #!ZERO_score

org $008F13|!bank
LDA #!ZERO_score

org $008EDE|!bank
if !ZERO_score
	LDX #$00
else

	BRA +	;[Mario score] dont convert leading zero to space (like SMB3)
endif
org $008EEF|!bank
+

org $008F0C|!bank
if !ZERO_score
	LDX #$00
else
	BRA +	;[Luigi score] dont convert leading zero to space (like SMB3)
endif
org $008F1D|!bank
+


org $008F51|!bank	;Lives hijack
if !lives != 0
	if !ZERO_lives
		BNE +
	else
		BRA +
	endif
	LDX #!ZERO_lives
	+
	STA !lives+$1
	jsr status_bar_lives_write
else
	BRA +
	org $008F5B|!bank
	+
endif

org $008F7A|!bank	;Coins hijack
if !coins != 0
	if !ZERO_coins
		BNE +
	else
		BRA +
	endif
	LDX #!ZERO_coins
	+
	jsr status_bar_coins_write
	warnpc $008F84|!bank
else
	BRA +
	org $008F84|!bank
	+
endif

org $008F84|!bank	;near end of status bar routine, let's overwrite everything

	LDY $0DB3|!addr

if !player
	LDX #$00
	LDA.w chartable+2,y
	XBA
	LDA.w chartable,y
	-
	STA !player,x
	XBA
	STA !player+$80,x
	XBA
	INC
	INX
	CPX #!SIZE_player
	BCC -
endif

if !bonus
	LDA $0F48|!addr,x
	JSR $9045
	STA !bonus+1
	TXA
	if !ZERO_bonus
		BNE +
	else
		BRA +
	endif
	LDA #!ZERO_bonus
	+
	STA !bonus
endif

if !yicoins
	if !yicoins_max
		JSR $9079+5
		BEQ ++
		if !ZERO_yicoins
			LDY.b #!TILE_yicoins
			CMP.b #!yicoins_max
			BCC +
			LDA.b #!yicoins_max-1
			LDY.b #!ZERO_yicoins
			+
			STA $00
			TYA
		else
			CMP.b #!yicoins_max+1
			BCC +
			LDA.b #!yicoins_max
			+
			STA $00
			LDA.b #!TILE_yicoins
		endif
		LDX #$00
		-
		STA !yicoins,x
		INX
		CPX $00
		BCC -
		++
	else
		LDA $1422|!addr
		STA !yicoins	;Rewritten Dragon Coins
	endif
endif

if !world
	LDX $13BF|!addr
	LDA.l Worlds|!bank,x	;new counter: current world number
	STA !world
endif

JSR PMeter

autoclean JSL Counters

if !itemboxtype
	JMP $9079	;handles item box item
else
	RTS
endif

status_bar_score_3_write:
	sta !score,x
	rts

status_bar_score_read:
	lda !score,x
	rts

LagFixPre:
BEQ LagFix
JMP $827A

LagFix:
;JSR $A300	;MarioGFXDMA
JSR $8449	;SpriteDMA
;JMP $8275	;skip everything else
JMP $8246

warnpc $008FF9|!bank




org $008C81|!bank	;let's overwrite the original status bar tilemap

PMeter:		;P-meter code below. heavily tweaked from Ersanio's version

autoclean JSL BigNumberHandler

if !pmeter || !pmeter_icon
	if !pmeter
		LDX.b #!LEN_pmeter-1
		LDA.b #!EmptyPal
		XBA
		LDA.b #!EmptyTri
		-
		STA.l !pmeter,x
		XBA
		STA.l !pmeter+$80,x
		XBA
		DEX : BPL -
	endif
	if !pmeter_icon
		LDX #$00
		LDA.b #!EmptyP_PROP
		XBA
		LDA.b #!EmptyP_TILE
		-
		STA.l !pmeter_icon,x
		XBA
		STA.l !pmeter_icon+$80,x
		XBA
		INC
		INX
		CPX.b #!SIZE_pmeter
		BCC -
	endif

	if !pmeter 
		JSR pmetermath
		LDX $4214
		BEQ .skip
		-
		DEX
		CPX.b #!LEN_pmeter
		BCS -
		BVC .notfull
	else
		if !pmeter_icon
			LDA $13E4|!addr
			CMP #$70
			BCC .skip
		endif
	endif

	if !pmeter
	PHX
	endif

	LDA $14
	LDX $74 : BNE +
	BIT #$07 : BNE +
	LDX #!Sound : STX !SoundBank
	+

	if !pmeter_icon
		AND #$10
		BEQ +
		LDX #$00
		LDA.b #!FillP_PROP
		XBA
		LDA.b #!FillP_TILE
		-
		STA !pmeter_icon,x
		XBA
		STA !pmeter_icon+$80,x
		XBA
		INC
		INX
		CPX.b #!SIZE_pmeter
		BCC -
		+
	endif

	if !pmeter
	PLX
	endif

	.notfull
	if !pmeter
		LDA.b #!FillPal
		XBA
		LDA.b #!FillTri
		-
		STA.l !pmeter,x
		XBA
		STA.l !pmeter+$80,x
		XBA
		DEX : BPL -
	endif
endif
.skip
RTS
warnpc $008CFF|!bank





;fix end-level shenanigans

org $00AF29|!bank	;something with mode 7 bosses
BRA + : NOP #6 : +

org $00C924|!bank	;vertical level has proper fade
BCS $08

org $00C9A1|!bank	;dont fade back colors after fade to black
NOP #3

org $00C9DF|!bank	;brightness fade instead of circle zoom
LDY #$0B

org $00C9F8|!bank	;skip brightness/hdma stuff due to above
BRA + : NOP #4 : +

org $00CA4A|!bank	;skip circle zoom stuff, and countdown faster
CLC : ADC #$F8
STA $1433|!addr
RTS

org $05CBFF|!bank	;kill scorecard
RTL





freecode

status_bar_time:
	phb
	phk
	plb

	lda.b #!status_tile>>16
	sta $0F

if !time != 0
	LDA $0F31|!addr
	STA !time+$0
	LDA $0F32|!addr
	STA !time+$1
	LDA $0F33|!addr
	STA !time+$2
	if !ZERO_time
		BVS +
	else
		BRA +	;[Time] dont convert leading zero to space (like SMB3)
	endif

	LDX #$00
	-
	LDA $0F31|!addr,x
	BNE +
	LDA #!ZERO_time
	STA !time,x
	INX
	CPX #$02
	BNE -
	+
endif
	plb
	JML $008E95|!bank

incsrc !CustomCode

--
SEP #$20
BRA ++

BigNumberHandler:
LDX #$1E
-
LDA.l .counters+5,x
BEQ ++
lda.l .counters+2,x
sta $02
sta $05
REP #$21
LDA.l .counters,x
BEQ --
STA $00
ADC #$0020
STA $03
SEP #$20
LDA.l .counters+3,x
TAY
--
LDA [$00],y
BEQ +++
CMP.l .counters+4,x
BEQ +
+++
CLC : ADC.b #!TILE_big_top
STA [$00],y
ADC.b #!TILE_big_bottom
+
STA [$03],y
DEY : BPL --
++
DEX #6 : BPL -
RTL

.counters
dl !coins : db $01,!ZERO_coins,!SIZE_coins
dl !lives : db $01,!ZERO_lives,!SIZE_lives
dl !score : db $05,!ZERO_score,!SIZE_score
dl !time : db $02,!ZERO_time,!SIZE_time
dl !bonus : db $01,!ZERO_bonus,!SIZE_bonus
dl !yicoins : db $00,$00,!SIZE_yicoins


-
LDA #$53 : STA $2109
STZ $2111
STZ $2111
STZ $2112
STZ $2112
if !sa1
STZ $1D04	;clear these just to be safe
STZ $1D05
STZ $1D06
STZ $1D02
endif
JML $0082B0|!bank

;below code is for the normal screen

PreStatusBar:
LDA $0D9B|!addr
BNE -
LDA $0100|!addr
CMP #$04	;this makes it so the title screen has correct $212C-$212F values
BEQ -
CMP #$05
BEQ -

LDA #$53 : STA $2109
LDA $3E : STA $2105
LDA $40 : STA $2131	;color math
LDA #$53 : STA $2109	;layer 3 tilemap location
STZ $2121
LDA.b #!bank>>16 : STA $4314 : STA $4304
LDA $0703|!addr : STA $2122
LDA $0704|!addr : STA $2122
STZ $2115
REP #$21
LDA $22 : STA !hdmatbl+1 : STA !hdmatbl+6
LDA $24 : STA !hdmatbl+3 : STA !hdmatbl+8
LDA !l1y_mirror : STA !hdmatbl+10+3
LDA !l1y_mirror_alt : STA !hdmatbl+10+8
LDA !l2y_mirror : STA !hdmatbl+10+13
LDA !l2y_mirror_alt : STA !hdmatbl+10+18
LDA !l1y_end : STA !hdmatbl+10+23
LDA $0D9D|!addr : STA $212C : STA $212E
LDA #$0907|!addr : STA $4312
LDA #$003E : STA $4315
LDA #$2202 : STA $4310
TAX : STX $420B
;LDY $1426|!addr : BNE +		;fix message box
LDA #$1800 : STA $4310
LDA.w #!status_tile>>8 : STA $4313
LDA.w #!status_tile : STA $4312
LDA !l3_line1  : BEQ +	;fix initial write
STA $2116
LDY #$20 : STY $4315
STX $420B
ORA #$0400 : STA $2116
STY $4315
STX $420B
LDA !l3_line2 : STA $2116
STY $4315
STX $420B
ORA #$0400 : STA $2116
STY $4315
STX $420B
LDA #$0080 : STA $2115
LDA #$1900 : STA $4310
LDA.w #!status_prop : STA $4312
LDA !l3_line1 : STA $2116
STY $4315
STX $420B
ORA #$0400 : STA $2116
STY $4315
STX $420B
LDA !l3_line2 : STA $2116
STY $4315
STX $420B
ORA #$0400 : STA $2116
STY $4315
STX $420B
+
LDY.b #!hdmatbl>>16 : STY $4304
LDA.w #!hdmatbl : STA $4302
LDA #$1103 : STA $4300		;layer 3 X/Y HDMA
SEP #$20
LSR
TSB $0D9F|!addr

if !sa1
;code for setting up a custom sa-1 irq
LDA.b #PostStatusBar
STA $1D04
LDA.b #PostStatusBar>>8
STA $1D05
LDA.b #PostStatusBar>>16
STA $1D06
INC $1D02
LDX #$A1
endif

JML $0082B0|!bank




;below code is for the status bar

-
BIT $4212 : BVC $FB		;wait for h-blank
if !sa1
STZ $1D04	;clear these just to be safe
STZ $1D05
STZ $1D06
STZ $1D02
RTL		;return to the irq handler
else
JML $008394|!bank
endif

PostStatusBar:
if !sa1
;lda $4200
;bne -
phb
phk
plb
else
BNE -
endif
PHD
REP #$30
LDA #$2100 : TCD		;set direct page to $2100
LDA.w #!status_palette : STA $4312
LDA.w #$4000|(!status_palette>>16) : STA $4314
LDA #$2202 : STA $4310		;set up first DMA (palette)
SEP #$30
TAY
LSR : STA $420C
LDA #$33
LDX #$80
BIT $4212 : BVC $FB		;wait for h-blank

STX $00				;f-blank the scanline
STZ $21				;initialize color upload
STA $09				;layer 3 tilemap location & size
STY $420B
INC : STA $4315
STY $25				;clipping window for sprites
LDA #$14 : STA $2C		;layer 3 & sprites on mainscreen
AND #$10 : STA $2E		;no window for layer 3
REP #$21
STZ $30				;disable subscreen & color math
LDA #$0700 : STA $26		;window borders
LDX #$04 : STX $4311
LDA #$00F6 : STA $02		;FirstSprite = x7F
LDX.b #!status_OAM>>16 : STX $4314
LDA.w #!status_OAM : STA $4312
STY $420B
DEY : STY $05			;gfx mode 1 (layer 3 standard priority)
SEP #$20

PLD
BIT $4212 : BVC $FB		;wait for h-blank again
LDA $0DAE|!addr : STA $2100	;restore brightness

REP #$31

LDA $1C
ADC #$00F0
AND #$00F8
ASL #2
ORA #$3000
STA !l3_line1
LDA $1C
AND #$00F8
CMP #$0010
BCS +
ADC #$0100
+
CLC : ADC #$0130
STA !l1y_mirror
SEC : SBC #$0008
STA !l1y_mirror_alt
SBC #$0018
STA !l1y_end

LDA $20
CLC : ADC #$00F0
AND #$00F8
ASL #2
ORA #$3800
STA !l3_line2
LDA $20
AND #$00F8
CMP #$0010
BCS +
ADC #$0100
+
CLC : ADC #$0020
STA !l2y_mirror
SEC : SBC #$0008
STA !l2y_mirror_alt
SEP #$30

if !sa1
STZ $1D04	;clear these just to be safe
STZ $1D05
STZ $1D06
STZ $1D02
PLB
RTL		;return to the irq handler
else
JML $0083B2|!bank
endif

hdmatbl:
db $80 : dw $FFFF,$FFFF
db $40-!status_fblank : dw $FFFF,$FFFF
db $07+!status_fblank : dw $0000+!x_off,$0000
db $08 : dw $0100+!x_off,$0000
db $08 : dw $0000+!x_off,$0000
db $08 : dw $0100+!x_off,$0000
db $01 : dw $0000+!x_off,$0000
db $00
.end

HandleOWReload:
	rep #$20
	ldy.b #!hdmatbl>>16 : STY $4304
	LDA.w #!hdmatbl : STA $4302
	LDA #$1103 : STA $4300		;layer 3 X/Y HDMA
	sep #$20
	lsr
	tsb $0D9F|!addr
	stz $1D04	;clear these just to be safe
	stz $1D05
	stz $1D06
	stz $1D02

	lda $0DBE|!addr
	bpl .code_00A0C7
	jml $00A0C4|!bank
.code_00A0C7
	jml $00A0C7|!bank

ItemBoxFix:
	LDA $0D9B|!addr
	BEQ .level
	LDY #$E0
	LSR
	BIT $0D9B|!addr
	BVC .boss
	LDY #$00
	BCS .boss
	LDA #$F0
	STA $0201|!addr,y
.boss	LDX $0DC2|!addr
	BEQ .ret
	LDA #$78
	STA $0200|!addr,y
	LDA #$0F
	STA $0201|!addr,y
if !_custom_powerups == 1
	rep #$20
	lda.w #read2($02800C)+$2
	sta $8A
	lda.w #read2($02800D)
	sta $8B
	txa
	asl
	tay
	sep #$20
	lda [$8A],y
else
	LDA $8DF9,x
endif
	STA $0202|!addr,y
	JSR .star
	STA $0203|!addr,y
	TYA
	LSR #2
	TAY
	LDA #$02
	STA $0420|!addr,y
.ret	RTL
.star
if !_custom_powerups == 1
	tax
	dey
	lda [$8A],y
	cpx #$03
	bne +
	lda $13
	lsr 
	and #$03
	tax
	lda $8DFE,x
+	
else	
	LDA $8E01,x
	CPX #$03
	BNE +
	LDA $13
	LSR
	AND #$03
	TAX
	LDA $8DFE,x
	LDX #$03
+	ORA #$30
endif	
	RTS
.level
if !itemboxtype == 1
	LDA #$F0
	STA !status_OAM+1
	LDX $0DC2|!addr
	BEQ .ret
	LDA.b #!sprite0_YX>>8
	STA !status_OAM+1
if !_custom_powerups == 1
	rep #$20
	lda.w #read2($02800C)+$2
	sta $8A
	lda.w #read2($02800D)
	sta $8B
	txa
	asl
	tay
	sep #$20
	lda [$8A],y
	sta !status_OAM+2
	jsr .star
	sta !status_OAM+3
else
	JSR .star
	STA !status_OAM+3
	LDA $8DF9,x
	STA !status_OAM+2
endif 
elseif !itemboxtype == 2
	phb
	lda.b #!status_tile/$10000
	pha
	plb
	LDA $0DC2|!addr
	ASL : TAX
	LDY.b #!itembox-!status_tile
	LDA.l itemboxtbl|!bank,x : STA.w !status_tile,y
	LDA.l itemboxtbl|!bank+1,x : STA.w !status_prop,y
	plb
elseif !itemboxtype == 3
	phb
	lda.b #!status_tile/$10000
	pha
	plb
	LDA $0DC2|!addr
	ASL : TAX
	LDY.b #!itembox-!status_tile
	LDA.l itemboxtbl|!bank+1,x
	STA.w !status_prop,y
	STA.w !status_prop+1,y
	STA.w !status_prop+$20,y
	STA.w !status_prop+$21,y
	LDA.l itemboxtbl|!bank,x
	STA.w !status_tile,y
	CPX #$00
	BEQ +
	INC : STA.w !status_tile+1,y
	INC : STA.w !status_tile+$20,y
	INC : STA.w !status_tile+$21,y
	plb
	RTL
+	STA.w !status_tile+1,y
	STA.w !status_tile+$20,y
	STA.w !status_tile+$21,y
	plb
else
endif
	RTL

itemboxtbl:
dw !itemboxblank
dw !itemboxmushroom
dw !itemboxflower
dw !itemboxstar
dw !itemboxfeather


OAMTABLE:	;OAM table mirrored to RAM (and uploaded from there during IRQ)
dw !sprite0_YX,!sprite0_PT	;item box
dw !sprite1_YX,!sprite1_PT	;extra sprite 1
dw !sprite2_YX,!sprite2_PT	;extra sprite 2
dw !sprite3_YX,!sprite3_PT	;extra sprite 3
dw !sprite4_YX,!sprite4_PT	;extra sprite 4
rep 30 : db $55
db !sprite0_S<<7|%00010101	;item box @ high 2 bits (leave the rest alone)
db !sprite4_S<<2|!sprite3_S<<2|!sprite2_S<<2|!sprite1_S<<1

Worlds:
incsrc !Worlds

StatusBarGFX:
if !GraphicExGFX < $0080
incbin !StatusBarGFX
.end
endif
StatusBarMAP:
if !TilemapExGFX < $0080
incbin !StatusBarMAP:0-100
endif
StatusBarPAL:
incbin !StatusBarPAL:0-40
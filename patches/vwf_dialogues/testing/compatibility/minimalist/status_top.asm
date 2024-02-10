;minimalist status bar
;top version

!sa1 = 0
!base = $0000
if read1($00FFD5) == $23
sa1rom
!sa1 = 1
!base = $6000
endif


!bgcolor = $0000	;status bar background color (default=black)

!NULL = $FC		;fill tile in GFX28/29 (used for replacing leading zeroes)


;SMB3 and SMW differ in which counters keep leading zeros and which replace them
;with spaces. the below defines are defaulted to SMB3 behavior
;0 = false (no leading zeroes, replace with spaces)
;1 = true (keep the leading zeroes)

!ZERO_coins = 0
!ZERO_lives = 0
!ZERO_score = 1
!ZERO_time = 1
!ZERO_bonus = 0


;dont edit
!status_tile = $0B05|!base
!status_prop = $0B45|!base
!status_palette = $0B85|!base    ;status bar palette is here (64 bytes max) GHB's EDIT: 32 bytes actually, Palette numbers 0-3 are dynamically uploaded.
!l1y_mirror = $0BC5|!base

;Display on Asar console window of the RAM address range (in case if you DO edit
;the RAM address above).

print "status_tile:             $", hex(!status_tile), " to $", hex(!status_tile+31)   
print "status_prop:             $", hex(!status_prop), " to $", hex(!status_prop+31)   
print "status_palette:          $", hex(!status_palette), " to $", hex(!status_palette+$1F)
print "-Palette 0: $", hex(!status_palette+$00), " to $", hex(!status_palette+$07)
print "-Palette 1: $", hex(!status_palette+$08), " to $", hex(!status_palette+$0F)
print "-Palette 2: $", hex(!status_palette+$10), " to $", hex(!status_palette+$17)
print "-Palette 3: $", hex(!status_palette+$18), " to $", hex(!status_palette+$1F)
print "-Palette 4: Not stored in RAM; uses same palette as level."
print "-Palette 5: Not stored in RAM; uses same palette as level."
print "-Palette 6: Not stored in RAM; uses same palette as level."
print "-Palette 7: Not stored in RAM; uses same palette as level."
print "l1y_mirror:              $", hex(!l1y_mirror), " to $", hex(!l1y_mirror+5)    


;below = location of counters in status bar. only change the added value
;if you want the counter disabled, set it equal to 0
;note that disabling a counter only affects the display, not the functionality

!player		= !status_tile+$1
!time		= !status_tile+$17
!lives		= !status_tile+$3
!itembox	= !status_tile+$12
!coins		= !status_tile+$1D
!yicoins	= !status_tile+$B
!bonus		= !status_tile+$8
!score		= 0


org $008292
LDY #$08		;IRQ starts on this scanline

org $0082A4		;NMI hijack
autoclean JML PreStatusBar
NOP #2

org $00838F		;IRQ hijack
autoclean JML PostStatusBar
NOP


org $008CFF		;Status Bar upload routine
StatusHijack:
LDX #$1F
-
LDA .StatusTiles,x
STA !status_tile,x
LDA .StatusProps,x
STA !status_prop,x
LDA .StatusPal,x
STA !status_palette,x
DEX : BPL -

LDA #$28
STA $0F30|!base
RTS

.StatusTiles
db $FC
db $7C,$26,$27,$27		;lives
db $FC
db $64,$26,$27,$27		;bonus stars
db $FC
db $FC,$FC,$FC,$FC,$FC		;yoshi coins
db $FC
db $5B,$FC,$5C			;item box
db $FC
db $76,$77,$27,$27,$27		;time
db $FC
db $2E,$26,$27,$27		;coins
db $FC

.StatusProps
db $20
db $29,$20,$20,$20		;lives
db $20
db $28,$20,$20,$20		;bonus stars
db $20
db $24,$24,$24,$24,$24		;yoshi coins
db $20
db $21,$28,$21			;item box
db $20
db $20,$20,$24,$24,$24		;time
db $20
db $24,$20,$20,$20		;coins
db $20

.StatusPal
dw !bgcolor,$0000,$7AAB,$7FFF ;Palette 0-3, Palette group 0
dw $7393,$0000,$1E9B,$3B7F ;Palette 4-7, Palette group 1
dw $7393,$0000,$0CFB,$2FEB ;Palette 8-11 ($08-$0B), Palette group 2
dw $7393,$0000,$7FDD,$2D7F ;Palette 12-15 ($0C-$0F), Palette group 3
warnpc $008DF5


org $0082E8
BRA $01 : NOP
org $0081F4
BRA $01 : NOP


org $028052
db $78			;item box X drop ($78)

org $028060
db $09			;item box Y drop ($0F)


;multiple status bar edits

org $008E6F	;Time hijack
if !time
	LDA $0F31|!base
	STA !time
	LDA $0F32|!base
	STA !time+$1
	LDA $0F33|!base
	STA !time+$2
	if !ZERO_time
		BRA +		;[Time] dont convert leading zero to space (like SMB3)
	else
		BVS +
	endif
	LDY #$00
	-
	LDA $0F31|!base,y
	BNE +
	LDA #!NULL
	STA !time,y
	INY
	CPY #$02
	BNE -
	NOP
	+
	warnpc $008E95
else
	BRA +
	org $008E95
	+
endif

org $008F51	;Lives hijack
if !lives
	if !ZERO_lives
		BRA +
	else
		BNE +
	endif
	LDX #!NULL
	+
	STX !lives
	STA !lives+$1
else
	BRA +
	org $008F5B
	+
endif

org $008F7A	;Coins hijack
if !coins
	if !ZERO_coins
		BRA +
	else
		BNE +
	endif
	LDX #!NULL
	+
	STA !coins+$1
	STX !coins
else
	BRA +
	org $008F84
	+
endif

org $008EE0	;Score hijacks
LDA !score,x
org $008F0E
LDA !score,x
org $008EE7
if !score
	STA !score,x
else
	NOP #3
endif
org $008F15
if !score
	STA !score,x
else
	NOP #3
endif
org $008ED7
LDX #$00
org $008F05
LDX #$00
org $009014
if !score
	STZ !score,x
else
	NOP #3
endif
org $009034
if !score
	INC !score,x
else
	NOP #3
endif

org $008EE5
LDA #!NULL

org $008F13
LDA #!NULL

org $008EDE
if !ZERO_score
	BRA +	;[Mario score] dont convert leading zero to space (like SMB3)
else
	LDX #$00
endif
org $008EEF
+

org $008F0C
if !ZERO_score
	BRA +	;[Luigi score] dont convert leading zero to space (like SMB3)
else
	LDX #$00
endif
org $008F1D
+


org $008F86	;near end of status bar routine, let's overwrite everything

if !itembox
	LDX $0DC2|!base		;Item Box Item
	LDA .statuspowerup,x
	STA !itembox
endif

if !player
	LDX $0DB3|!base
	LDA .playertable,x	;Current Player
	STA !player
endif

if !bonus
	LDX $0DB3|!base
	LDA $0F48|!base,x		;Bonus Stars
	PHK
	PEA.w .jslrtsreturn-1
	PEA.w $0084CF-1
	JML $009045
	.jslrtsreturn
	if !ZERO_bonus
		BRA +
	else
		TXY : BNE +
		LDX #!NULL
	endif
	+
	STX !bonus
	STA !bonus+$1
endif

if !yicoins
	LDX #$00		;Yoshi Coins
	LDA $1422|!base
	DEC A : STA $00
	-
	LDA #$2E		;full yoshi coin tile
	LDY $00 : BPL +
	LDA #!NULL		;blank yoshi coin tile
	+
	STA !yicoins,x
	DEC $00 : INX
	CPX #$05 : BCC -	;# of yoshi coins needed to stop display
endif

RTS

.statuspowerup
db $FC,$95,$97,$96,$28
;none, mushroom, flower, star, feather

.playertable
db $7C,$0B	;Mario tile, Luigi tile

warnpc $008FF5



freecode
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
JML $0082B0

PreStatusBar:
LDA $0D9B|!base
BNE -
LDA $0100|!base
CMP #$04	;this makes it so the title screen has correct $212C-$212F values
BEQ -
CMP #$05
BEQ -
STZ $2115
STZ $4314
REP #$21
LDA $1C
ADC #$00F0
AND #$00F8
ASL #2
ORA #$3000
STA !l1y_mirror
STA $2116
LDA #$1800 : STA $4310
LDA.w #!status_tile : STA $4312
LDA #$0020 : STA $4315
LDX #$02 : STX $420B
LDY #$80 : STY $2115
STA $4315
LDA !l1y_mirror : STA $2116
LDA #$1900 : STA $4310
LDA.w #!status_prop : STA $4312
STX $420B
SEP #$20

LDA #$30 : STA $2109
STZ $2111		;static layer 3
STZ $2111
LDA $1C : AND #$F8 : CLC : ADC #$EF : STA $2112
STZ $2112
LDA #$04 : STA $212C	;layer 3 on main+sub
STZ $212E
STZ $2130
STZ $2131
STZ $2121
REP #$20
LDA #$2202 : STA $4310
LDA.w #!status_palette : STA $4312
LDA #$0020 : STA $4315
STX $420B
SEP #$20
print "To view the status bar on BSNES+ debugger, breakpoint at $",pc
LDA #$09 : STA $2105	;gfx mode 1 + layer 3 priority

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
JML $0082B0

PostStatusBar:
BIT $4212 : BVC $FB	;wait for h-blank
LDA #$80 : STA $2100	;f-blank the scanline
LDA #$53 : STA $2109
LDA $22 : STA $2111
LDA $23 : STA $2111
LDA $24 : STA $2112
LDA $25 : STA $2112
LDA $3E : STA $2105
LDA $0D9D|!base : STA $212C	;main screen
STA $212E
LDA $0D9E|!base : STA $212D	;sub screen
STA $212F
LDA $40 : STA $2131	;color math
LDA $44 : STA $2130
STZ $2121
LDA $0703|!base : STA $2122
LDA $0704|!base : STA $2122
STZ $4314
REP #$20
LDA #$0907|!base : STA $4312
LDA #$001E : STA $4315
LDA #$2202 : STA $4310
TAX : STX $420B
SEP #$20
BIT $4212 : BVC $FB	;wait for h-blank again
LDA $0DAE|!base : STA $2100	;restore brightness

if !sa1
STZ $1D04	;clear these just to be safe
STZ $1D05
STZ $1D06
STZ $1D02
RTL		;return to the irq handler
else
JML $0083B2
endif
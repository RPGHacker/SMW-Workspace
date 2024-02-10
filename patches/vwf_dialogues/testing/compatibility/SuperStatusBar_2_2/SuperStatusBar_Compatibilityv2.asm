; Super Status Bar (high(er) compatibility version)
; By Kaijyuu
; See readme for instructions
incsrc "StatusBarDefines/SA1Defines.asm"
incsrc "StatusBarDefines/StatusBarDefines.asm"

print ""
print "Super Status bar RAM range (inclusive): $", hex(!RAM_BAR), " to $", hex(!RAM_BAR+319)
print ""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hijacks:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG $008292					;\Move the cutoff Irq line (not for smw's mode 7 bosses however).
	LDY #!IRQ_line_Y_pos	;/

ORG $00835C					;\Move the cutoff Irq line (for smw's mode 7 bosses).
	LDY #!IRQ_line_Y_pos	;/

ORG $008D8A			;\hijack status bar initilization routine
	autoclean JSL MAIN_2	;|
	NOP			;/ fill in a byte

ORG $008DB6
	BRA SKIP_UNUSED		;>skip past unused code
				; This spot was chosen for compatibility with sprite status bar and stripe image uploader

ORG $008DE2			;>near end of DrawStatusBar
SKIP_UNUSED:
	autoclean JSL MAIN 			;Point to new routine

	RTS



freecode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Tables for tiles.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DATA_TILES:			; This is the data for the tiles not regularly uploaded by SMW
	db $FC,$38		; First number is the tile number, second is the properties
	db $FC,$38		; YXPCCCTT
	db $FC,$38		; Y = y flip, X = flip, P = priority, CCC = palette number (4 color palettes remember)
	db $FC,$38		; TT = page number
	db $FC,$38		; Ex: 38 = 00111000
	db $FC,$38		; priority bit set, palette 7 (of 8)
	db $FC,$38		; FC is a blank tile with SMW's original l3 graphics
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38		; This whole block is for the line above the top of the item box.
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38
	db $FC,$38

DATA_TILES2:			;\Start of second line, the first 14 8x8 spaces on second row.
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/
	;
	; Item box would be here. Already DMA'd in SMW's regular code
	; Not included here for compatibility with the status bar editor tool
	;
DATA_TILES3:
	db $FC,$38		;\End of second line, The last 14 8x8 spaces (the right 14)
	db $FC,$38		;|on the second row
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/
DATA_TILES4:
	; two tiles at the upper middle left
	db $FC,$38		;\Third line, the first two 8x8 spaces (two tiles left from the NAME text).
	db $FC,$38		;/
DATA_TILES5:
	; two tiles at the upper middle right
	db $FC,$38		;\Third line, the last two 8x8 spaces (two tiles right from the coin counter
	db $FC,$38		;/(not the coin and "X" symbol)).
DATA_TILES6:
	; three tiles at the lower middle left
	db $FC,$38		;\Fourth line, the first 3 8x8 spaces before the "X" symbol and lives counter.
	db $FC,$38		;|
	db $FC,$38		;/
DATA_TILES7:
	; two tiles at the lower middle right
	db $FC,$38		;\Fourth line, the last two 8x8 spaces after the last 0 on the score counter.
	db $FC,$38		;/
DATA_TILES8:
	; bottom row
	db $FC,$38		;\Fifth line, the first 14 8x8 spaces.
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/
	;
	; Item box would be here. Already DMA'd in SMW's regular code
	; Not included here for compatibility with the status bar editor tool
	;
DATA_TILES9:
	db $FC,$38		;\Fifth line, the last 14 8x8 spaces.
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/

DMA_BAR:		db	$01,$18,!RAM_BAR,!RAM_BAR>>8,!RAM_BAR>>16,$40,$01
;^ ">>X", where x is how many times the number is divided by 2, so that it converts
;the freeram into DMA table bytes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Main code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN_2:				; Uploads tiles to ram and DMAs new tiles
	PHB
	PHK
	PLB
	PHY
	PHX


	PHB
	LDA #$00		; set bank to 00
	PHA
	PLB
	
	REP #$10		; 16 bit X Y

	LDY #$0007		; 
	LDX #$0063		; Upload status bar tiles to ram
UPLOAD_STATBAR1:		; 
	LDA $8C81,y		; Top of item box
	STA !RAM_BAR,X		; 
	DEX
	DEY
	BPL UPLOAD_STATBAR1
	LDY #$0037		; top middle of status bar
	LDX #$00BB
UPLOAD_STATBAR2:
	LDA $8C89,Y
	STA !RAM_BAR,X
	DEX
	DEY
	BPL UPLOAD_STATBAR2
	LDY #$0035		; low middle of status bar
	LDX #$00FB
UPLOAD_STATBAR3:
	LDA $8CC1,Y
	STA !RAM_BAR,X
	DEX
	DEY
	BPL UPLOAD_STATBAR3
	LDY #$0007		; bottom of item box
	LDX #$0123
UPLOAD_STATBAR4:
	LDA $8CF7,Y
	STA !RAM_BAR,X
	DEX
	DEY
	BPL UPLOAD_STATBAR4

	PLB			; reset bank

	LDY #$005B		; get tiles from here and store to RAM
	LDX #$005B
UPLOAD_STATBAR5:
	LDA DATA_TILES,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR5

	LDY #$001F		
	LDX #$0083
UPLOAD_STATBAR6:
	LDA DATA_TILES3,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR6

	LDY #$0009		
	LDX #$00C5
UPLOAD_STATBAR7:
	LDA DATA_TILES5,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR7

	LDY #$001F		
	LDX #$011B
UPLOAD_STATBAR8:
	LDA DATA_TILES7,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR8

	LDY #$001B		
	LDX #$013F
UPLOAD_STATBAR9:
	LDA DATA_TILES9,Y
	STA !RAM_BAR,x
	DEX
	DEY
	BPL UPLOAD_STATBAR9

      	LDA #$28                ; Recover old code
      	STA $0F30+!addr        ; #$28 -> Timer frame counter 

DMA_STATBAR:

	SEP #$10	; 8 bit X Y	

	LDA #$80
	STA $2115
	LDA #$00
	STA $2116	; DMA it
	LDA #$50
	STA $2117
	LDX #$06
DMA_LOOP:
	LDA DMA_BAR,x
	STA $4310,x
	DEX
	BPL DMA_LOOP	
	LDA #$02
	STA $420B	

	PLX
	PLY
	PLB



	RTL


MAIN:	PHB
	PHY
	PHX		; wrapper thingy
	PHK
	PLB


	REP #$10		; 16 bit X Y

	LDY #$001B
	LDX #$00BA
UPLOAD_STATBARA:
	LDA $0EF9+!addr,Y		; Transfer status bar tiles from RAM
	STA !RAM_BAR,X
	DEX			; top middle of status bar
	DEX
	DEY
	BPL UPLOAD_STATBARA
	LDY #$001A		; low middle of status bar
	LDX #$00FA
UPLOAD_STATBARB:
	LDA $0F15+!addr,Y
	STA !RAM_BAR,X
	DEX
	DEX
	DEY
	BPL UPLOAD_STATBARB

	JMP DMA_STATBAR

	
MainEnd:

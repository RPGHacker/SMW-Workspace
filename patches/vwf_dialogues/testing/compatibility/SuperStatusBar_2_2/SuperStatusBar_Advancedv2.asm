;Super Status Bar Advanced v2, by Kaijyuu. Patch updated by GreenHammerBro.
;See image file "ASSB_map.png" on how to use the status bar tiles.
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

ORG $008D8A			; hijack status bar initilization routine
	autoclean JSL MAIN_2
	NOP			; fill in a byte

ORG $008DB6
	BRA SKIP_UNUSED		; skip past unused code
				; This spot was chosen for compatibility with sprite status bar and stripe image uploader
				; (sprite status bar requires some RAM address tweaks within it's code to be compatible with this)

ORG $008DE2			; near end of DrawStatusBar (error on asar, just because of ":")
SKIP_UNUSED:
	autoclean JSL MAIN 			;Point to new routine

	RTS


ORG $008E1F			; hijack routine that updates status bar tiles in RAM ($008E1A used by uberasm tool)
	autoclean JML MAIN_3

ORG $0090D0		; make this into a JSL routine instead JSR
	RTL


ORG $0090AE
	db !ITEM_X	; set item box item x position 
ORG $0090B3
	db !ITEM_Y	; set item box item y position
ORG $0090B8
	DB !ITEM_PRIORITY	; set item box item priority bits
ORG $0090CC
	DB !ITEM_SIZE		; set item box item size/high x bit

freecode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Tables for tiles.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DATA_TILES:			;\This is the data for the tiles not regularly uploaded by SMW
	db $FC,$38		;|First number is the tile number, second is the properties
	db $FC,$38		;|YXPCCCTT
	db $FC,$38		;|Y = y flip, X = flip, P = priority, CCC = palette number (4 color palettes remember)
	db $FC,$38		;|TT = page number
	db $FC,$38		;|Ex: $38 = 00111000
	db $FC,$38		;|priority bit set, palette 7 (of 8)
	db $FC,$38		;|FC is a blank tile with SMW's original l3 graphics
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|This whole block is the top row of status bar tile space.
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
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;|
	db $FC,$38		;/

DATA_TILES2:			;\Start of second line, the first 14 8x8 spaces on second row
	db $FC,$38		;|seen on ASSB map.png.
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
	db $FC,$38		;|on the second row seen on ASSB_map.png.
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

      	LDA #!TIME_SPEED		; Recover old code
      	STA $0F30+!addr      		; #$28 -> Timer frame counter 

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
	;-------------------------------------------------------------------
	;this code below adds the red timer and/or beeping warning.
	if !timer_warning != 0
	LDA $0F31+!addr	;\If all digits = 0, then no warning
	ORA $0F32+!addr	;|(so its safe to use in a level with no time
	ORA $0F33+!addr	;|limit).
	BEQ no_red_timer	;/
	LDA $0F31+!addr	;\If timer >= 100, then use defualt color
	BNE no_red_timer	;/
	LDA $0F32+!addr	;\If timer >= 10 then no warning sound
	BNE no_warning_sound	;/
	LDA $0F30+!addr	;\If frame counter <> max then don't play 10 second warning
	CMP #!TIME_SPEED	;|
	BNE no_warning_sound	;/
	LDA #$23		;\play sound each time the timer has 1 smw second subtracted
	STA $1DFC+!addr	;/
no_warning_sound:
	LDA.b #%00101100	;".b" so asar reconizes as its a byte; this is the color if < 100
	BRA store_prop
no_red_timer:
	LDA.b #%00111100	;>color for >= 100
store_prop:
	STA !RAM_BAR+!TIME_OFFSET+1	;\digits
	STA !RAM_BAR+!TIME_OFFSET+3	;|
	STA !RAM_BAR+!TIME_OFFSET+5	;/
	STA !RAM_BAR+$A7		;\the word "TIME".
	STA !RAM_BAR+$A9		;|
	STA !RAM_BAR+$AB		;/
	endif
	;-------------------------------------------------------------------
	; If you would like to add any subroutines that are run every frame the status bar is, 
	; feel free to stick them right here. However this runs during v-blank; HDMA AND TOP OF
	; THE SCREEN WILL GLITCH OUT IF YOU PUT TOO MUCH CODES HERE! I don't know how much is
	; the limit that will glitch, if you are too concern, use uberasm (but disable the
	; status bar hijack first) and write HUD using gamemode 13 and 14.

	JMP DMA_STATBAR		;>BUT DO NOT DELETE THIS LINE!!

Imgs: db $2E,$55,$56,$66



DATA_008DF5:		      db $40,$41,$42,$43,$44	;>luigi's name?

DATA_008E06:		      db $B7

DATA_008E07:		      db $C3,$B8,$B9,$BA,$BB,$BA,$BF,$BC
				  db $BD,$BE,$BF,$C0,$C3,$C1,$B9,$C2
				  db $C4,$B7,$C5

MAIN_3:
	PHB
	PHK
	PLB		; wrapper
			; Basically copy/pasted code from all.log
			; modified to use new RAM addresses

CODE_008E1A:		LDA $1493+!addr	;\If level is ending or sprites are locked,  
CODE_008E1D:		ORA $9D			;|branch to $8E6F (restore code before I move the hijack)

;^The reason why this level ending/frozen is checked twice (first included in uberasm tool, then this) is
;because PLB affects the processor flag, therefore BNE (below) will branch.

CODE_008E1F:		BNE CODE_008E6F_OR_008E95
CODE_008E21:		LDA $0D9B+!addr			;\If gamemode trigger = "Bowser's battle mode"
CODE_008E24:		CMP #$C1				;|branch to $8E6F
CODE_008E26:		BEQ CODE_008E6F_OR_008E95		;/
	if !Enable_TIME != 0 ;>begin timer routine.
CODE_008E28:		DEC $0F30+!addr	;\If timer frame counter-1 is positive (-1 is in between #$00-#$7F?)
CODE_008E2B:		BPL CODE_008E6F		;/branch to $8E6F
CODE_008E2D:		LDA #!TIME_SPEED	;\Another timer frame counter?
CODE_008E2F:		STA $0F30+!addr	;/
CODE_008E32:		LDA $0F31+!addr	;\  
CODE_008E35:		ORA $0F32+!addr	;|If time is 0, 
CODE_008E38:		ORA $0F33+!addr	;|branch to $8E6F 
CODE_008E3B:		BEQ CODE_008E6F		;/  
CODE_008E3D:		LDX #$02		;\Check digits?
CODE_008E3F:		DEC $0F31+!addr,X	;|
CODE_008E42:		BPL CODE_008E4C		;|
CODE_008E44:		LDA #$09		;|
CODE_008E46:		STA $0F31+!addr,X	;|
CODE_008E49:		DEX		       
CODE_008E4A:		BPL CODE_008E3F	   
CODE_008E4C:		LDA $0F31+!addr		;\  
CODE_008E4F:		BNE CODE_008E60			;|
CODE_008E51:		LDA $0F32+!addr		;|
CODE_008E54:		AND $0F33+!addr		;|If time is 99, 
CODE_008E57:		CMP #$09			;|speed up the music 
CODE_008E59:		BNE CODE_008E60			;| 
CODE_008E5B:		LDA #$FF			;| 
CODE_008E5D:		STA $1DF9+!addr		;| 
CODE_008E60:		LDA $0F31+!addr		;\  
CODE_008E63:		ORA $0F32+!addr		;| 
CODE_008E66:		ORA $0F33+!addr		;|If time is 0, 
CODE_008E69:		BNE CODE_008E6F			;|JSL to $00F606 
CODE_008E6B:		JSL $00F606			;|
	if !Enable_TIME != 0
CODE_008E6F_OR_008E95:
	endif
CODE_008E6F:		LDA $0F31+!addr		;\Display timer (the number themselves) on HUD

CODE_008E72:		STA !RAM_BAR+!TIME_OFFSET	;| 
CODE_008E75:		LDA $0F32+!addr		;|
CODE_008E78:		STA !RAM_BAR+!TIME_OFFSET+2	;| 
CODE_008E7B:		LDA $0F33+!addr		;| 
CODE_008E7E:		STA !RAM_BAR+!TIME_OFFSET+4	;/

CODE_008E81:		LDX #$00			;\Remove unnecessary digits place.
CODE_008E83:		LDY #$00			;|
CODE_008E85:		LDA $0F31+!addr,Y     		;|
CODE_008E88:		BNE CODE_008E95_IF_THEN		;|
CODE_008E8A:		LDA #$FC			;|
CODE_008E8C:		STA !RAM_BAR+!TIME_OFFSET,X	;/

CODE_008E8F:		INY		       
CODE_008E90:		INX 
			INX		      
CODE_008E91:		CPY #$02		
CODE_008E93:		BNE CODE_008E85
	endif ;>end of timer routine
;------------------------------------------------------------------
	if !Enable_TIME != 1       ;>"if !define <> 1".
CODE_008E6F_OR_008E95:
	endif
CODE_008E95_IF_THEN:
	if !Enable_SCORE != 0 ;>begin score
CODE_008E95:		LDX #$03		
CODE_008E97:		LDA $0F36+!addr,X
CODE_008E9A:		STA $00		   
CODE_008E9C:		STZ $01		   
CODE_008E9E:		REP #$20		  ; 16 bit A ; Accum (16 bit) 
CODE_008EA0:		LDA $0F34+!addr,X	     
CODE_008EA3:		SEC		       
CODE_008EA4:		SBC #$423F	      
CODE_008EA7:		LDA $00		   
CODE_008EA9:		SBC #$000F	      
CODE_008EAC:		BCC CODE_008EBF	   
ADDR_008EAE:		SEP #$20		  ; 8 bit A ; Accum (8 bit) 
ADDR_008EB0:		LDA #$0F		
ADDR_008EB2:		STA $0F36+!addr,X	     
ADDR_008EB5:		LDA #$42		
ADDR_008EB7:		STA $0F35+!addr,X	     
ADDR_008EBA:		LDA #$3F		
ADDR_008EBC:		STA $0F34+!addr,X	     
CODE_008EBF:		SEP #$20		  ; 8 bit A ; Accum (8 bit) 
CODE_008EC1:		DEX		       
CODE_008EC2:		DEX		       
CODE_008EC3:		DEX		       
CODE_008EC4:		BPL CODE_008E97	   	;>loop
CODE_008EC6:		LDA $0F36+!addr	   ;\ Store high byte of Mario's score in $00 
CODE_008EC9:		STA $00		   ;/  
CODE_008ECB:		STZ $01		   ;>Store x00 in $01 
CODE_008ECD:		LDA $0F35+!addr   ;\ Store mid byte of Mario's score in $03 
CODE_008ED0:		STA $03		   ;/ 
CODE_008ED2:		LDA $0F34+!addr   ;\ Store low byte of Mario's score in $02 
CODE_008ED5:		STA $02		   ;/ 
CODE_008ED7:		LDX #$00		
CODE_008ED9:		LDY #$00		
CODE_008EDB:		JSR CODE_009012
CODE_008EDE:		LDX #$00				;\  
CODE_008EE0:		LDA !RAM_BAR+!SCORE_OFFSET,X		;| 
CODE_008EE3:		BNE CODE_008EEF				;|

CODE_008EE5:		LDA #$FC				;|Replace all leading zeroes in the score with spaces 
CODE_008EE7:		STA !RAM_BAR+!SCORE_OFFSET,X		;|
 
CODE_008EEA:		INX					;| 
			INX
CODE_008EEB:		CPX #$0C				;| 
CODE_008EED:		BNE CODE_008EE0				;| >loop
CODE_008EEF:		LDA $0DB3+!addr			; Get current player 
CODE_008EF2:		BEQ CODE_008F1D_IF_THEN			; If player is Mario, branch to $8F1D 
CODE_008EF4:		LDA $0F39+!addr			;\ Store high byte of Luigi's score in $00 
CODE_008EF7:		STA $00					;/  
CODE_008EF9:		STZ $01					; Store x00 in $01 
CODE_008EFB:		LDA $0F38+!addr			;\ Store mid byte of Luigi's score in $03 
CODE_008EFE:		STA $03					;/  
CODE_008F00:		LDA $0F37+!addr			;\ Store low byte of Luigi's score in $02 
CODE_008F03:		STA $02					;/  
CODE_008F05:		LDX #$00		
CODE_008F07:		LDY #$00
	if !Enable_SCORE != 0					;\Somehow asar is complaining me that the subroutine
CODE_008F09:		JSR CODE_009012				;|still exist (and assume its not found) even though
	endif							;/the user disables the bonus stars... very odd.
CODE_008F0C:		LDX #$00				;\  
CODE_008F0E:		LDA !RAM_BAR+!SCORE_OFFSET,X	     	;| 
CODE_008F11:		BNE CODE_008F1D_IF_THEN	   		;|
CODE_008F13:		LDA #$FC				;|Replace all leading zeroes in the score with spaces 
CODE_008F15:		STA !RAM_BAR+!SCORE_OFFSET,X	     	;|

CODE_008F18:		INX		       			;| 
			INX
CODE_008F19:		CPX #$0C				;| 
CODE_008F1B:		BNE CODE_008F0E	   			;/>loop
	endif ;>end score.
;--------------------------------------------------------------------
CODE_008F1D_IF_THEN:
	if !Enable_COINS != 0 ;begin coin routine.
CODE_008F1D:		LDA $13CC+!addr       			;\ If Coin increase isn't x00, 
CODE_008F20:		BEQ CODE_008F3B_IF_THEN	   		;/ branch to $8F3B 
CODE_008F22:		DEC $13CC+!addr       			; Decrease "Coin increase" 
CODE_008F25:		INC $0DBF+!addr			; Increase coins by 1 
CODE_008F28:		LDA $0DBF+!addr			;\  
CODE_008F2B:		CMP #$64				;|If coins<100, branch to $8F3B 
CODE_008F2D:		BCC CODE_008F3B_IF_THEN			;/  
CODE_008F2F:		INC $18E4+!addr     			; Increase lives by 1 
CODE_008F32:		LDA $0DBF+!addr			;\  
CODE_008F35:		SEC					;|Decrease coins by 100 
CODE_008F36:		SBC #$64				;| 
CODE_008F38:		STA $0DBF+!addr			;/
	endif ;>end of coins routine.
CODE_008F3B_IF_THEN:
	if !Enable_LIVES != 0 ;>begin lives
CODE_008F3B:		LDA $0DBE+!addr			;\ If amount of lives is negative, 
CODE_008F3E:		BMI CODE_008F49				;/ branch to $8F49 
CODE_008F40:		CMP #$62				;\ If amount of lives is less than 98, 
CODE_008F42:		BCC CODE_008F49				;/ branch to $8F49 
CODE_008F44:		LDA #$62				;\ Set amount of lives to 98 
CODE_008F46:		STA $0DBE+!addr			;\  
CODE_008F49:		LDA $0DBE+!addr			;\  
CODE_008F4C:		INC A		     			;|Get amount of lives in decimal 
CODE_008F4D:		JSR HexToDec				;/
CODE_008F58:		STA !RAM_BAR+!LIVES_OFFSET+2	       	;/
CODE_008F50:		TXA		       			;\  
CODE_008F51:		BNE CODE_008F55	   			;|If 10s is 0, replace with space 
CODE_008F53:		LDA #$FC				;|
CODE_008F55:		STA !RAM_BAR+!LIVES_OFFSET	      	;> Write lives to status bar.
	endif ;>end of lives

	if !Enable_STARS != 0 ;>begin bonus stars
CODE_008F5B:		LDX $0DB3+!addr       			;\ Get bonus stars 
CODE_008F5E:		LDA $0F48+!addr,X     			;/  
CODE_008F61:		CMP #$64				;\ If bonus stars is less than 100, 
CODE_008F63:		BCC CODE_008F73_IF_THEN	   		;/ branch to $8F73 
CODE_008F65:		LDA #$FF				;\ Start bonus game when the level ends 
CODE_008F67:		STA $1425+!addr       			;/  
CODE_008F6A:		LDA $0F48+!addr,X     			;\  
CODE_008F6D:		SEC		       			;|Subtract bonus stars by 100 
CODE_008F6E:		SBC #$64				;| 
CODE_008F70:		STA $0F48+!addr,X	     			;/
	endif ;end bonus stars
CODE_008F73_IF_THEN:
	if !Enable_COINS != 0 ;>begin coins 2
CODE_008F73:		LDA $0DBF+!addr			;\ Get amount of coins in decimal
CODE_008F76:		JSR HexToDec	    			;/  
CODE_008F7E:		STA !RAM_BAR+!COINS_OFFSET+2	       	;\ Write coins to status bar 
			TXA
			BNE CODE_008F81
CODE_008F7C:		LDA #$FC				;| 
CODE_008F81:		STA !RAM_BAR+!COINS_OFFSET	       	;/
		endif ;>end of coin routine 2
CODE_008F84:		SEP #$20		  		; 8 bit A ; Accum (8 bit)
	if !Enable_STARS != 0 ;>begin bonus stars 2
CODE_008F86:		LDX $0DB3+!addr       			; Load Character into X 
CODE_008F89:		STZ $00		   
CODE_008F8B:		STZ $01		   
CODE_008F8D:		STZ $03		   
CODE_008F8F:		LDA $0F48+!addr,X	     
CODE_008F92:		STA $02		   
CODE_008F94:		LDX #$00		
CODE_008F96:		LDY #$10		
CODE_008F98:		JSR CODE_009051	 
CODE_008F9B:		LDX #$00		
CODE_008F9D:		LDA !RAM_BAR+!STARS_OFFSET,X	     
CODE_008FA0:		BNE CODE_008FAF	   
CODE_008FA2:		LDA #$FC	
CODE_008FA4:		STA !RAM_BAR+!STARS_OFFSET,X	     
CODE_008FA7:		STA !RAM_BAR+!STARS_OFFSET-$40,X
CODE_008FAA:		INX		    
			INX   
CODE_008FAB:		CPX #$02		
CODE_008FAD:		BNE CODE_008F9D	   
CODE_008FAF:		LDA !RAM_BAR+!STARS_OFFSET,X	     
CODE_008FB2:		ASL		       
CODE_008FB3:		TAY		       
CODE_008FB4:		LDA DATA_008E06,Y
CODE_008FB7:		STA !RAM_BAR+!STARS_OFFSET-$40,X
CODE_008FBA:		LDA DATA_008E07,Y       
CODE_008FBD:		STA !RAM_BAR+!STARS_OFFSET,X
CODE_008FC0:		INX	 
			INX	      
CODE_008FC1:		CPX #$04		
CODE_008FC3:		BNE CODE_008FAF ;>loop
	endif ;>end bonus stars 2
			LDA #$00
			PHA
			PLB	
CODE_008FC5:		JSL $009079   ; Draw item box item sprite  
			PHK
			PLB
	if !Enable_NAME != 0 ;>begin name
CODE_008FC8:		LDA $0DB3+!addr       
CODE_008FCB:		BEQ CODE_008FD8_IF_THEN
CODE_008FCD:		LDY #$04      
			LDX #$08	  
CODE_008FCF:		LDA DATA_008DF5,Y	;>player name tiles
   
CODE_008FD2:		STA !RAM_BAR+!NAME_OFFSET,X	     
CODE_008FD5:		DEY	 
			DEX
			DEX	     
CODE_008FD6:		BPL CODE_008FCF		;>loop
	endif ;>end of name
CODE_008FD8_IF_THEN:
	if !Enable_DRAGON != 0
CODE_008FD8:		LDA $1422+!addr	;>yoshi coins	       
CODE_008FDB:		CMP #$05		
CODE_008FDD:		BCC CODE_008FE1	   
CODE_008FDF:		LDA #$00		
CODE_008FE1:		DEC A		     
CODE_008FE2:		STA $00		   
CODE_008FE4:		LDX #$00		
CODE_008FE6:		LDY #!TILE_EMPTY		
CODE_008FE8:		LDA $00		   
CODE_008FEA:		BMI CODE_008FEE	   
CODE_008FEC:		LDY #!TILE_FULL		
CODE_008FEE:		TYA	       
CODE_008FEF:		STA !RAM_BAR+!DRAGON_OFFSET,X
CODE_008FF2:		DEC $00		   
CODE_008FF4:		INX	      
			INX	 
CODE_008FF5:		CPX #$08		
CODE_008FF7:		BNE CODE_008FE6
	endif ;>end of yoshi coins
		PLB
		JML $008FF9	; return
	 	


DATA_008FFA:		      db $01,$00

DATA_008FFC:		      db $A0,$86,$00,$00,$10,$27,$00,$00
				  db $E8,$03,$00,$00,$64,$00,$00,$00
				  db $0A,$00,$00,$00,$01,$00

	if !Enable_SCORE != 0 ;>begin of score 2
CODE_009012:		SEP #$20		  ; 8 bit A ; Accum (8 bit)
			LDA #$00
CODE_009014:		STA !RAM_BAR+!SCORE_OFFSET,X
CODE_009017:		REP #$20		  ; 16 bit A ; Accum (16 bit) 
CODE_009019:		LDA $02		   
CODE_00901B:		SEC		       
CODE_00901C:		SBC DATA_008FFC,Y       
CODE_00901F:		STA $06		   
CODE_009021:		LDA $00		   
CODE_009023:		SBC DATA_008FFA,Y       
CODE_009026:		STA $04		   
CODE_009028:		BCC CODE_009039	   
CODE_00902A:		LDA $06		   
CODE_00902C:		STA $02		   
CODE_00902E:		LDA $04		   
CODE_009030:		STA $00		   
CODE_009032:		SEP #$20		  ; 8 bit A ; Accum (8 bit) 
CODE_009034:		LDA !RAM_BAR+!SCORE_OFFSET,X  
			INC A
			STA !RAM_BAR+!SCORE_OFFSET,x
 
CODE_009037:		BRA CODE_009017	  	;>loop
CODE_009039:		INX   
			INX		    
CODE_00903A:		INY		       
CODE_00903B:		INY		       
CODE_00903C:		INY		       
CODE_00903D:		INY		       
CODE_00903E:		CPY #$18		
CODE_009040:		BNE CODE_009012		;>loop
CODE_009042:		SEP #$20		  ; 8 bit A ; Accum (8 bit) 
Return009044:      	RTS       
	endif ;end of score 2
;--------------------------------------------------------------------------
HexToDec:		   LDX #$00			;| 
CODE_009047:		CMP #$0A			;| 
CODE_009049:		BCC Return009050		;|Sets A to 10s of original A 
CODE_00904B:		SBC #$0A			;|Sets X to 1s of original A 
CODE_00904D:		INX		       		;| 
CODE_00904E:		BRA CODE_009047	   		;|>loop

Return009050:       	RTS
;-------------------------------------------
	if !Enable_STARS != 0 ;>stars subroutine
CODE_009051:		SEP #$20		  	; Accum (8 bit) 
			LDA #$00
CODE_009053:		STA !RAM_BAR+!STARS_OFFSET,X
CODE_009056:		REP #$20		  	; Accum (16 bit) 
CODE_009058:		LDA $02		   
CODE_00905A:		SEC		       
CODE_00905B:		SBC DATA_008FFC,Y       
CODE_00905E:		STA $06		   
CODE_009060:		BCC CODE_00906D	   
CODE_009062:		LDA $06		   
CODE_009064:		STA $02		   
CODE_009066:		SEP #$20		  	; Accum (8 bit) 
CODE_009068:		LDA !RAM_BAR+!STARS_OFFSET,X   
			INC A
			STA !RAM_BAR+!STARS_OFFSET,x	  
CODE_00906B:		BRA CODE_009056		;>loop

CODE_00906D:		INX  
			INX		     
CODE_00906E:		INY		       
CODE_00906F:		INY		       
CODE_009070:		INY		       
CODE_009071:		INY		       
CODE_009072:		CPY #$18		
CODE_009074:		BNE CODE_009051		;>loop
CODE_009076:		SEP #$20		  ; Accum (8 bit) 
Return009078:       RTS      
	endif ;>end of bonus stars

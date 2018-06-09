;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SMW Rex (sprite AB), by imamelia
;;
;; This is a disassembly of sprite AB in SMW, the Rex.
;;
;; Uses first extra bit: NO
;;
;; Modified by RPG Hacker to deal custom damage with HP counter patch.
;; Copy hpconfig.cfg next to this file when inserting it via PIXI.
;; You can set the damage to deal via the extra property bytes.
;; Byte 1 is the low byte and byte 2 the high byte.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incsrc "hpconfig.cfg"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; defines and tables
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XSpeed:
db $10,$F0,$20,$E0

DeathSpeed:
db $F0,$10

XDisp:
db $FC,$00,$FC,$00,$FE,$00,$00,$00,$00,$00,$00,$08
db $04,$00,$04,$00,$02,$00,$00,$00,$00,$00,$08,$00

YDisp:
db $F1,$00,$F0,$00,$F8,$00,$00,$00,$00,$00,$08,$08

Tilemap:
db $8A,$AA,$8A,$AC,$8A,$AA,$8C,$8C,$A8,$A8,$A2,$B2

TileProp:
db %01001001,%00001001

if read1($00FFD5) == $23
	!FreeRAM = !FreeRAM_SA1
	!HurtFlag = !HurtFlag_SA1
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; init routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "INIT ",pc
%SubHorzPos()
TYA		; face the player initially
STA $157C,x	;
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine wrapper
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print "MAIN ",pc
PHB
PHK
PLB
JSR RexMain	; $039517
PLB
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; main routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RexMain:

JSR RexGFX	; draw the Rex

LDA $14C8,x	; check the sprite status
CMP #$08		; if the Rex is not in normal status...
BNE Return00	;
LDA $9D		; or sprites are locked...
BNE Return00	; return

LDA $1558,x	; if the Rex has been fully squished and its remains are still showing...
BEQ Alive		;
STA $15D0,x	; set the "eaten" flag
DEC		; if this is the last frame to show the squished remains...
BNE Return00	;
STZ $14C8,x	; erase the sprite

Return00:		;
RTS		;

Alive:		;
%SubOffScreen()

INC $1570,x	; increment this sprite's frame counter (number of frames on the screen)
LDA $1570,x	;
LSR #2		; frame counter / 4
LDY $C2,x	; if the sprite is half-squished...
BEQ NoHSquish	;
AND #$01	; then it changes animation frame every 4 frames
CLC		;
ADC #$03	; and uses frame indexes 3 and 4
BRA SetFrame	;

NoHSquish:	;

LSR		; if the sprite is not half-squished,
AND #$01	; it changes animation frame every 8 frames

SetFrame:		;

STA $1602,x	; set the frame number

LDA $1588,x	;
AND #$04	; if the Rex is on the ground...
BEQ InAir		;

LDA #$10		; give it some Y speed
STA $AA,x	;

LDY $157C,x	; sprite direction
LDA $C2,x	;
BEQ NoFastSpeed	; if the Rex is half-squished...
INY #2		; increment the speed index so it uses faster speeds
NoFastSpeed:	;
LDA XSpeed,y	; set the sprite X speed
STA $B6,x		;

InAir:		;

LDA $1FE2,x	; if the timer to show the half-smushed Rex is set...
BNE NoUpdate	; don't update sprite position
JSL $81802A	;
NoUpdate:	;

LDA $1588,x	;
AND #$03	; if the sprite is touching the side of an object...
BEQ NoFlipDir	;
LDA $157C,x	;
EOR #$01		; flip its direction
STA $157C,x	;

NoFlipDir:	;

JSL $818032	; interact with other sprites
JSL $81A7DC	; interact with the player
BCC NoContact	; carry clear -> no contact

LDA $1490	; if the player has a star...
BNE StarKill	; run the star-killing routine	        
LDA $154C,x	; if the interaction-disable timer is set...
BNE NoContact	; act as if there were no contact at all

LDA #$08		;
STA $154C,x	; set the interaction-disable timer

LDA $7D		;
CMP #$10		; if the player's Y speed is not between 10 and 8F...
BMI SpriteWins	; then the sprite hurts the player

JSR RexPoints	; give the player some points
JSL $81AA33	; boost the player's speed
JSL $81AB99	; display contact graphics

LDA $140D	; if the player is spin-jumping...
ORA $187A	; or on Yoshi...
BNE SpinKill	; then kill the sprite directly
INC $C2,x	; otherwise, increment the sprite state
LDA $C2,x	;
CMP #$02		; if the sprite state is now 02...
BNE HalfSmushed	;
LDA #$20		; set the time to show the fully-squished remains
STA $1558,x	;
RTS

HalfSmushed:	;

LDA #$0C		; set the time to show the partly-smushed frame
STA $1FE2,x	; (since when is $1FE2,x a misc. sprite table?)
STZ $1662,x	; change the sprite clipping to 0 for the half-smushed Rex
RTS  

SpriteWins:	;

LDA $1497	; if the player is flashing invincible...
ORA $187A	; or is on Yoshi...
BNE NoContact	; just return



; custom HP counter damage start
LDA #$02
STA !HurtFlag
LDA !extra_prop_1,x
STA !FreeRAM
LDA !extra_prop_2,x
STA !FreeRAM+1
; custom HP counter damage end



%SubHorzPos()	;
TYA		; make the Rex turn toward the player
JSL $80F5B7	; and hurt the player

NoContact:	;
RTS		;

SpinKill:		;

LDA #$04		; sprite state = 04
STA $14C8,x	; spin-jump killed
LDA #$1F		; set spin jump animation timer
STA $1540,x	;

JSL $87FC3B	; show star animation

LDA #$08		;
STA $1DF9	; play spin-jump sound effect
RTS		;

StarKill:		;

LDA #$02		; sprite state = 02
STA $14C8,x	; killed (by star) and falling offscreen

LDA #$D0	;
STA $AA,x	; set killed Y speed
%SubHorzPos()	;
LDA DeathSpeed,y	; set killed X speed
STA $B6,x		;

INC $18D2	; increment number of consecutive enemies killed
LDA $18D2	;
CMP #$08		; if the number is 8 or greater...
BCC Not8Yet	;
LDA #$08		; keep it at 8
STA $18D2	;
Not8Yet:		;

JSL $02ACE5	; give points

LDY $18D2	;
CPY #$08		; if the number is less than 8...
BCS Return01	;
TYX		;
LDA $037FFF,x	; play a sound effect depending on that number
STA $1DF9	;
LDX $15E9	;

Return01:		;
RTS		;
					   
RexPoints:	;

PHY		;
LDA $1697	; consecutive enemies stomped
CLC		;
ADC $1626,x	; plus number of enemies this sprite has killed (...huh?)
INC $1697	; increment the counter
TAY		; -> Y
INY		; increment
CPY #$08		; if the result is 8+...
BCS NoSound	; don't play a sound effect
TYX		;
LDA $037FFF,x	; star sounds (X is never 0 here; they start at $038000)
STA $1DF9	;
LDX $15E9	;
NoSound:		;
TYA		;
CMP #$08		; if the number is 8+...
BCC GivePoints	;
LDA #$08		; just use 8 when giving points
GivePoints:	;
JSL $82ACE5	;
PLY		;
RTS		;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; graphics routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RexGFX:

LDA $1558,x	; if the Rex is not squished...
BEQ NoFullSquish	; don't set the squished frame

LDA #$05		;
STA $1602,x	; set the frame (fully squished)

NoFullSquish:	;

LDA $1FE2,x	; if the time to show the half-squished Rex is nonzero...
BEQ NoHalfSquish	;

LDA #$02		;
STA $1602,x	; set the frame (half-squished)

NoHalfSquish:	;

%GetDrawInfo()
  
LDA $1602,x	;
ASL		; frame x 2
STA $03		; tilemap index

LDA $157C,x	;
STA $02		;

PHX		;
LDX #$01		; tiles to draw: 2

GFXLoop:		;

PHX		;
TXA		;
ORA $03		; add in the frame
PHA		; and save the result
LDX $02		; if the sprite direction is 00...
BNE FaceLeft	; then the sprite is facing right...
CLC		;
ADC #$0C	; and we need to add 0C to the X displacement index
FaceLeft:		;
TAX		;
LDA $00		;
CLC		;
ADC XDisp,x	; set the tile X displacement
STA $0300,y	;

PLX		; previous index back
LDA $01		;
CLC		;
ADC YDisp,x	; set the tile Y displacement
STA $0301,y	;

LDA Tilemap,x	;
STA $0302,y	; set the tile number

; set the tile properties depending on direction
LDX $02	
LDA TileProp,x
ORA $64
STA $0303,y	

TYA		;
LSR #2		; OAM index / 4
LDX $03		;
CPX #$0A		; if the frame is 5 (squished)...
TAX		;
LDA #$00		; set the tile size as 8x8
BCS SetTileSize	;
LDA #$02		; if the frame is less than 5, set the tile size to 16x16
SetTileSize:	;
STA $0460,x	;
	PLX		; pull back the tile counter index
INY #4		; increment the OAM index
DEX		; if the tile counter is positive...
BPL GFXLoop	; there are more tiles to draw
				   
PLX		; pull back the sprite index
LDY #$FF		; Y = FF, because we already set the tile size
LDA #$01		; A = 01, because 2 tiles were drawn
JSL $81B7B3	; finish the write to OAM
RTS		;
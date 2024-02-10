;level height adjuster
;by Ladida

;note that the patch is configured to work with the smb3 status bar patch
;many things may appear undesirable if you're not using that

;for those complaining about the title screen cutoff:
;set the FG initial position higher, or hide it with a layer 3 border

	!dp = $0000
	!addr = $0000
	!bank = $800000
	!sa1 = 0
	!gsu = 0

if read1($00FFD6) == $15
	sfxrom
	!dp = $6000
	!addr = !dp
	!bank = $000000
	!gsu = 1
elseif read1($00FFD5) == $23
	sa1rom
	!dp = $3000
	!addr = $6000
	!bank = $000000
	!sa1 = 1
endif


;when layer 1 vertical scrolling is set to "No Vertical Scroll unless Flying/Climbing/Etc",
;the screen will still scroll up a bit (by !offset pixels) when you arent flying etc.
;set this define to 0 if you want to disable this behavior; aka the screen wont scroll up
;at all unless you're flying/climbing/etc (basically how SMW handles it). by default it's
;enabled, in case it results in hiding important elements in certain levels

!vertscroll_oddity = 1


!offset = $20	;position offset. low nibble is cleared. anything above this is just dumb

!altoffset = $10	;alternate offset applied mainly to sprites (idk why its different)




;don't edit anything below

!disp = (!offset&$F0)

!altdisp = (!altoffset&$F0)

macro word(wordpos)	;add offset to word (mainly for layer/camera related addresses)
dw <wordpos>+!disp
endmacro

macro invword(invwordpos)	;subtract offset from word (mainly for sprites)
dw <invwordpos>-!disp
endmacro

macro byte(bytepos)	;add offset to byte
db <bytepos>+!disp
endmacro

macro invbyte(invbytepos)	;subtract offset from byte
db <invbytepos>-!disp
endmacro

macro invworddouble(invdoublepos)	;subtract double offset from word
dw <invdoublepos>-(!disp*2)
endmacro

macro invlownibble(invlownibblepos)	;divide offset by 16, subtract from low nibble
db ((<invlownibblepos>-(!disp>>4))&$0F)|(<invlownibblepos>&$F0)
endmacro

macro lownibble(lownibblepos)	;divide offset by 16, add to low nibble
db (<lownibblepos>+(!disp>>4))&$0F
endmacro

macro alt_word(wordpos)
dw <wordpos>+!altdisp
endmacro

macro alt_invword(invwordpos)
dw <invwordpos>-!altdisp
endmacro

macro alt_byte(bytepos)
db <bytepos>+!altdisp
endmacro

macro alt_invbyte(invbytepos)
db <invbytepos>-!altdisp
endmacro

macro alt_invworddouble(invdoublepos)
dw <invdoublepos>-(!altdisp*2)
endmacro

macro alt_invlownibble(invlownibblepos)
db ((<invlownibblepos>-(!altdisp>>4))&$0F)|(<invlownibblepos>&$F0)
endmacro

macro alt_lownibble(lownibblepos)
db (<lownibblepos>+(!altdisp>>4))&$0F
endmacro



org $00F6B1|!bank
if !vertscroll_oddity
%byte($C0)
else
db $C0
endif

org $00F598|!bank	;dont increase mario ypos if at this position? seems fine at this value
dw $FF80	;$FF80
org $00F5A3|!bank
autoclean JML deathfix

;org $00F6E5|!bank	;LM THROWS A HIJACK AROUND HERE, DUNNO WHY
;dw $000C
;org $00F6EC|!bank	;WE DON'T REALLY NEED THESE ADDRESSES ANYWAYS I THINK
;dw $0018



org $00F69F|!bank	;the SMW camera is bottom-biased. here we try and make it top-biased
%invword($0064)		;position of player for vert screen scroll (up)
%invword($007C)		;position of player for vert screen scroll (down)
org $00F806|!bank	;height of player for vert screen scroll
%invword($0070)


org (read3($00F70E|!bank)+15)
	%invword($00EF)

;org $00F70E|!bank	;seems to be lowest layer 1 position
;%word($00C0)
org $00F75F|!bank
autoclean JSL vertlevelL1POS	;XBA : AND #$FF00

org $05D708|!bank	;init layer 1 pos from level header
%byte($00)
%byte($60)
%byte($C0)
%byte($00)
org $05D70C|!bank	;init layer 2 pos from level header
%byte($60)
%byte($90)
%byte($C0)
%byte($00)

org $05DA76|!bank	;no-yoshi entrance cutscenes (all)
%byte($C0)


;layer 3 y position stuff
org $009FDA|!bank	;high/low tide
%byte($70)		; starting position
org $05C40A|!bank
%byte($30)		; highest position
%byte($A0)		; lowest position (prolly have them swapped)

org $009FDF|!bank	;normal tide
%byte($40)
org $00A004|!bank	;windows & rocks
%byte($C0)
org $00A016|!bank	;???, seems to be used when there's no layer 3 image
%byte($D0)

org $00FF85|!bank	;layer 3 smash. this thing is broken interaction-wise so we make some hacks
%word($00A0)
org $02D49D|!bank
%invbyte($00)
org $02D4A7|!bank
%invbyte($10)
org $02D4AB|!bank
autoclean JML layer3smashhurtfix



;fix sprites and stuff

org $02F5B2|!bank	;ghost house exit
%invbyte($5F)
%invbyte($5F)
%invbyte($8F)
%invbyte($97)
%invbyte($A7)
%invbyte($AF)
%invbyte($8F)
%invbyte($97)
%invbyte($A7)
%invbyte($AF)

org $02F4FB|!bank	;yoshi's house fire (no, he doesn't have an nvidia card)
%invbyte($B0)
org $02F500|!bank
%invbyte($B8)

org $03C4AE|!bank	;disco ball sprite
%invbyte($28)
org $03C5B9|!bank	;disco ball windowing
%invworddouble($005F)
org $03C61E|!bank	;reduce processing by cutting index
%invworddouble($01C0)

org $05C71B|!bank	;layer 2 on/off thing	TODO: Fix weird smash glitch, *HAPPENS IN CLEAN ROM, NVM*
%alt_word($0020)	;should be max positions
%alt_word($00C1)

org $05C973|!bank	;layer 2 smash	NOTE: it glitches at certain points apparently? fsck
%alt_word($00C1)	; init pos?
org $05C8C8|!bank	; other positions
%alt_word($00C0)
%alt_word($00B0)
%alt_word($0070)
%alt_word($00C0)
%alt_word($00C0)
%alt_word($00C0)
%alt_word($0000)
%alt_word($0000)
%alt_word($00C0)
%alt_word($00B0)
%alt_word($00A0)
%alt_word($0070)
%alt_word($00B0)
%alt_word($00B0)
%alt_word($00B0)
%alt_word($0000)
%alt_word($0000)
%alt_word($00B0)
%alt_word($0020)
%alt_word($0020)
%alt_word($0020)
%alt_word($0010)
%alt_word($0010)
%alt_word($0010)
%alt_word($0000)
%alt_word($0000)
%alt_word($0010)
warnpc $05C8FE|!bank

org $05C80E|!bank	;layer 2 rise/fall
%alt_word($00C0)
%alt_word($0000)
%alt_word($00B0)

org $02AAFC|!bank	;boo ceiling
%alt_invbyte($08)

org $02AA0B|!bank	;reappearing boos, frame 1
%alt_invlownibble($31)
%alt_invlownibble($71)
%alt_invlownibble($A1)
%alt_invlownibble($43)
%alt_invlownibble($93)
%alt_invlownibble($C3)
%alt_invlownibble($14)
%alt_invlownibble($65)
%alt_invlownibble($E5)
%alt_invlownibble($36)
%alt_invlownibble($A7)
%alt_invlownibble($39)
%alt_invlownibble($99)
%alt_invlownibble($F9)
%alt_invlownibble($1A)
%alt_invlownibble($7A)
%alt_invlownibble($DA)
%alt_invlownibble($4C)
%alt_invlownibble($AD)
%alt_invlownibble($ED)
org $02AA1F|!bank	;reappearing boos, frame 2
%alt_invlownibble($01)
%alt_invlownibble($51)
%alt_invlownibble($91)
%alt_invlownibble($D1)
%alt_invlownibble($22)
%alt_invlownibble($62)
%alt_invlownibble($A2)
%alt_invlownibble($73)
%alt_invlownibble($E3)
%alt_invlownibble($C7)
%alt_invlownibble($88)
%alt_invlownibble($29)
%alt_invlownibble($5A)
%alt_invlownibble($AA)
%alt_invlownibble($EB)
%alt_invlownibble($2C)
%alt_invlownibble($8C)
%alt_invlownibble($CC)
%alt_invlownibble($FC)
%alt_invlownibble($5D)

org $05CABE|!bank	;???
db $50			;$50
org $05CABF|!bank	;fix autoscroll, hopefully
%lownibble($0C) : %lownibble($0C) : %lownibble($06) : %lownibble($0B)
%lownibble($08) : %lownibble($0C) : %lownibble($03) : %lownibble($02)
%lownibble($09) : %lownibble($03) : %lownibble($09) : %lownibble($02)
%lownibble($06) : %lownibble($06) : %lownibble($07) : %lownibble($05)

%lownibble($08) : %lownibble($05) : %lownibble($0A) : %lownibble($04)
%lownibble($08) : %lownibble($04) : %lownibble($04) : %lownibble($0C)
%lownibble($0C) : %lownibble($07) : %lownibble($07) : %lownibble($05)
%lownibble($05) : %lownibble($0C) : %lownibble($0C) : %lownibble($08)

%lownibble($0C) : %lownibble($0C) : %lownibble($07) : %lownibble($07)
%lownibble($0A) : %lownibble($0A) : %lownibble($0C) : %lownibble($0C)
%lownibble($00) : %lownibble($00) : %lownibble($0A) : %lownibble($0A)
%lownibble($00) : %lownibble($00) : %lownibble($09) : %lownibble($09)

%lownibble($03) : %lownibble($03) : %lownibble($0C) : %lownibble($0C)
%lownibble($0C) : %lownibble($0C) : %lownibble($08) : %lownibble($08)
%lownibble($05) : %lownibble($05) : %lownibble($02) : %lownibble($02)
%lownibble($09) : %lownibble($09) : %lownibble($01) : %lownibble($01)

%lownibble($01) : %lownibble($02) : %lownibble($03) : %lownibble($07)
%lownibble($08) : %lownibble($08) : %lownibble($0C) : %lownibble($0C)
%lownibble($02) : %lownibble($02) : %lownibble($0A) : %lownibble($0A)
%lownibble($02) : %lownibble($02) : %lownibble($0A) : %lownibble($0A)


;org $0CA0EA|!bank	;Yoshi's house decoration (credits)
;%invbyte($2F)

;org $0CA149|!bank	;「﻿ＴＨＡＮＫ  ＹＯＵ」 ヨッシーの家 （右）
;%invword($003F)
;org $0CA17B|!bank	;（左）
;%invword($003F)



freedata

vertlevelL1POS:
XBA
AND #$FF00
CLC : ADC.w #!disp
RTL

layer3smashhurtfix:
CMP #$E0
BCS +
CMP $80
BCC +
JML $02D4AF|!bank
+
JML $02D4EF|!bank

deathfix:
LDA $80
CMP.w #$0100-!disp-$20	;death if at this position+
SEP #$20
BPL +
JML $00F5B6|!bank
-
JML $00F5B2|!bank
+
LDA $1B95|!addr
BEQ -
JML $00F5AF|!bank
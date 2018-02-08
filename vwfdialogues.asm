@asar 1.50
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;VWF Dialogues Patch by RPG Hacker;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


incsrc vwf_dialogues.cfg
incsrc ../shared/shared.asm


print "VWF Dialogues Patch v1.2 - (c) 2018 RPG Hacker"


math pri on
math round off


namespace vwf_dialogues_



;;;;;;;;
;Labels;
;;;;;;;;



; DO NOT EDIT THOSE!!!

if !use_sa1_mapping
	!varram	= !varramSA1
	!backupram	= !backupramSA1
	!tileram	= !tileramSA1
endif

!vwfmode	= !varram	; 1 byte
!message	= !varram+1	; 2 bytes
!counter	= !varram+3	; 1 byte

!width	= !varram+4	; 1 byte
!height	= !varram+5	; 1 byte
!xpos	= !varram+6	; 1 byte
!ypos	= !varram+7	; 1 byte
!boxbg	= !varram+8	; 1 byte
!boxcolor	= !varram+9	; 6 bytes
!boxframe	= !varram+15	; 1 byte
!boxcreate	= !varram+16	; 1 byte
!boxpalette	= !varram+17	; 1 byte
!freezesprites	= !varram+18	; 1 byte
!beep	= !varram+19	; 1 byte
!beepbank	= !varram+20	; 2 bytes
!beepend	= !varram+22	; 1 byte
!beependbank	= !varram+23	; 2 bytes
!beepcursor	= !varram+25	; 1 byte
!beepcursorbank	= !varram+26	; 2 bytes
!beepchoice	= !varram+28	; 1 byte
!beepchoicebank	= !varram+29	; 2 bytes
!font	= !varram+31	; 1 byte
!edge	= !varram+32	; 1 byte
!space	= !varram+33	; 1 byte
!frames	= !varram+34	; 1 byte
!layout	= !varram+35	; 1 byte
!soundoff	= !varram+36	; 1 byte
!speedup	= !varram+37	; 1 byte
!autowait	= !varram+38	; 1 byte

!vrampointer	= !varram+39	; 2 bytes
!currentwidth	= !varram+41	; 1 byte
!currentheight	= !varram+42	; 1 byte
!currentx	= !varram+43	; 1 byte
!currenty	= !varram+44	; 1 byte

!vwftextsource	= !varram+45	; 3 bytes
!vwfbytes	= !varram+48	; 2 bytes
!vwfgfxdest	= !varram+50	; 3 bytes
!vwftilemapdest	= !varram+53	; 3 bytes
!vwfpixel	= !varram+56	; 2 bytes
!vwfmaxwidth	= !varram+58	; 1 byte
!vwfmaxheight	= !varram+59	; 1 byte
!vwfchar	= !varram+60	; 2 bytes
!vwfwidth	= !varram+62	; 1 byte
!vwfroutine	= !varram+63	; 15 bytes
!vwftileram	= !varram+78	; 96 bytes
!tile	= !varram+174	; 1 byte
!property	= !varram+175	; 1 byte
!currentpixel	= !varram+176	; 1 byte
!firsttile	= !varram+177	; 1 byte
!clearbox	= !varram+178	; 1 byte
!wait	= !varram+179	; 1 byte
!timer	= !varram+180	; 1 byte
!teleport	= !varram+181	; 1 byte
!telepdest	= !varram+182	; 2 bytes
!telepprop	= !varram+184	; 1 byte
!forcesfx	= !varram+185	; 1 byte
!widthcarry	= !varram+186	; 1 byte
!choices	= !varram+187	; 1 byte
!cursor	= !varram+188	; 2 bytes
!currentchoice	= !varram+190	; 1 byte
!choicetable	= !varram+191	; 3 bytes
!choicespace	= !varram+194	; 1 byte
!choicewidth	= !varram+195	; 1 byte
!cursormove	= !varram+196	; 1 byte
!nochoicelb	= !varram+197	; 1 byte
!cursorupload	= !varram+198	; 1 byte
!cursorend	= !varram+199	; 1 byte

!paletteupload	= !varram+200	; 1 byte
!palbackup	= !varram+201	; 64 bytes
!cursorfix	= !varram+265	; 1 byte
!cursorvram	= !varram+266	; 2 bytes
!cursorsrc	= !varram+268	; 2 bytes

!rambank	= select(!use_sa1_mapping,$40,$7E)

!8	= 0
!16	= 1
!false	= 0
!true	= 1

!8bit	= "if !bitmode	== !8 :"
!16bit	= "if !bitmode	== !16 :"
!hijack	= "if !hijackbox	== !true :"





;;;;;;;;
;Macros;
;;;;;;;;

; A simple macro to prepare VRAM operations

macro vramprepare(vramsettings, vramaddress, readword, readbyte)
	lda <vramsettings>
	sta $2115
	rep #$20
	lda <vramaddress>
	sta $2116
	<readword>	; "lda $2139" for word VRAM reads
	sep #$20
	<readbyte>	; "lda $2139/$213A" for byte VRAM reads
endmacro





; A simple Macro for DMA transfers

macro dmatransfer(channel, dmasettings, destination, sourcebank, sourcehigh, sourcelow, bytes)
	lda <dmasettings>
	sta $4300
	lda <destination>
	sta $4301
	lda<sourcelow>	; I put the label close to the opcode
	sta $4302	; to allow length definitions
	lda<sourcehigh>
	sta $4303
	lda<sourcebank>
	sta $4304
	rep #$20
	lda <bytes>
	sta $4305
	sep #$20
	lda <channel>
	sta $420B
endmacro



; NEW: A macro for SA-1 DMA (ROM->BWRAM) transfer
macro bwramtransfer(bytes, start, source, destination)
	if !use_sa1_mapping
		lda #$C4
		sta $2230

		stz $2250
		lda.b #<bytes>	; Calculate starting index
		sta $2251
		lda.b #<bytes>>>16
		sta $2252
		lda <start>
		sta $2253
		stz $2254
		nop
		rep #$20
		lda $2306	; Add source address
		clc	; to get new source address
		adc.w #<source>
		sta $2232
		ldy.b #<source>>>16
		sty $2234
		lda.w #<bytes>
		sta $2238
		lda.w #<destination>
		sta $2235
		ldy.b #<destination>>>16
		sty $2237
		sep #$20

		stz $2230
		stz $018C
	else
		%mvntransfer(<bytes>,<start>,<source>,<destination>)
	endif
endmacro

; A macro for MVN transfers

macro mvntransfer(bytes, start, source, destination)
	phb
	lda.b #<bytes>	; Calculate starting index
	sta select(!use_sa1_mapping,$2251,$211B)
	lda.b #<bytes>>>16
	sta select(!use_sa1_mapping,$2252,$211B)
	stz select(!use_sa1_mapping,$2250,$211C)
	lda <start>
	sta select(!use_sa1_mapping,$2253,$211C)
	if !use_sa1_mapping
		stz $2254
		nop
	endif
	rep #$30
	lda select(!use_sa1_mapping,$2306,$2134)	; Add source address
	clc : adc.w #<source>	; to get new source address
	tax
	ldy.w #<destination>	; Destination address
	lda.w #<bytes>-1	; Number of bytes
	db $54	; MVN opcode in Hex
	db <destination>>>16
	db <source>>>16
	sep #$30
	plb
endmacro





; Macros for new banks

!PrevFreespace	= AutoFreespaceCleaner

macro nextbank()
	freedata : prot !PrevFreespace
	cleartable
	!PrevFreespace += a
	!PrevFreespace:
endmacro


macro binary(identifier, data)
	Data<identifier>:
	incbin <data>
endmacro


macro source(identifier, data)
	Data<identifier>:
	incsrc <data>
endmacro





; Macros for text files

macro textstart()
	cleartable
	table vwftable.txt
endmacro

macro textend()
	!8bit db $00
	db %00001000,%01111000,%11010001,%11000000,$01,%00100000
	dw $7FFF,$0000
	db %11110100
	db %00001111,$13,$13,$23,$29

	!8bit db $FA
	!8bit db $FF
	!16bit dw $FFFA
	!16bit dw $FFFF
endmacro





;;;;;;;;;
;Hijacks;
;;;;;;;;;


org remap_rom($008064)
	autoclean jml InitCall	; Initialize RAM to prevent glitches
	nop ; workaround for Asar bug	; or game crashes

org remap_rom($0081F2)
	jml VBlank	; V-Blank code goes here
	nop

org remap_rom($008297)
	jml NMIHijack	; Hijack NMI for various things
	nop #$2

org remap_rom($0086E2)
	jml InitMode	; Call RAM Init Routine on Title Screen

org remap_rom($00A1DF)
!hijack jsl MessageBox	; Hijack message box to call VWF dialogue

org remap_rom($00A2A9)
	jml Buffer	; Buffer data before loading up to VRAM
	nop #2	; in V-Blank





;;;;;;;;;;;;;;;;;
;MAIN CODE START;
;;;;;;;;;;;;;;;;;


freecode : prot Kleenex

FreecodeStart:





;;;;;;;;;;;;;;;;;;;;
;RAM Initialization;
;;;;;;;;;;;;;;;;;;;;


; This section handles RAM initialization. It initializes the used
; RAM addresses at game startup, title screen and Game Over to
; prevent glitches and possible crahses.

InitCall:
	jsr InitRAM	; RAM init on game start
	lda #$03
	sta $2101
	jml remap_rom($008069)



InitMode:
	sty $00
	pha
	lda remap_ram($0100)
	cmp #$03
	bne .NoTitle
	jsr InitRAM	; RAM init on Title Screen

.NoTitle
	pla
	rep #$30
	jml remap_rom($0086E6)



InitRAM:
	phx
	rep #$30
	ldx #$0000
	lda #$0000

.InitVarRAM
	sta !varram,x	; Initialize RAM
	inx #2
	cpx #$010E	; Number of bytes
	bne .InitVarRAM
	sep #$30

.SetDefaults
	lda #!defbg	; Set default values
	sta !boxbg
	lda #!defframe
	sta !boxframe

	lda.b #!bgcolor
	sta !boxcolor
	lda.b #!bgcolor>>8
	sta !boxcolor+1

.End
	plx
	rts





;;;;;;;;;;;;;;;;;;;;
;Message Box Hijack;
;;;;;;;;;;;;;;;;;;;;


; This hijacks SMW's original message routine to work with VWF
; dialogues.

MessageBox:
	lda !vwfmode	; Already displaying a message?
	beq .CallDialogue
	stz remap_ram($1426)
	rtl

.CallDialogue
	lda remap_ram($1426)	; Yoshi Special Message?
	cmp #$03
	bne .NoYoshi
	lda #$01
	sta !message
	bra .SetMessage

.NoYoshi
	lda remap_ram($0109)	; Intro Level Message?
	beq .NoIntro
	lda #$00
	sta !message
	bra .SetMessage

.NoIntro
	lda remap_rom($03BB9B)	; Inside Yoshi's House? (LM hacked
	cmp #$FF	; ROM only)
	bne .HackedROM
	lda #$28

.HackedROM
	cmp remap_ram($13BF)
	bne .NoYoshiHouse
	lda remap_ram($187A)	; Currently riding Yoshi?
	beq .NoYoshiHouse
	lda #$02
	sta remap_ram($1426)

.NoYoshiHouse
	lda remap_ram($13BF)	; No special message, use regular message
	asl	; formula
	clc
	adc remap_ram($1426)
	dec
	sta !message

.SetMessage
	lda #$00
	sta !message+1
	stz remap_ram($1426)
	lda #$01
	sta !vwfmode

.End
	rtl





;;;;;;;;;;;;
;NMI Hijack;
;;;;;;;;;;;;

; This changes the NMI Routine to move layer 3 and disable IRQ during
; dialogues.

NMIHijack:
	phx
	lda !vwfmode
	tax
	lda.l .NMITable,x
	bne .SpecialNMI	; If NMITable = $00 load regular NMI
	sty $4209
	stz $420A
	stz $11
	lda #$A1
	sta $4200
	stz $2111
	stz $2111
	stz $2112
	stz $2112
	bra .End

.SpecialNMI
	stz $11	; Else load special NMI
	lda #$81	; Disable IRQ
	sta $4200
	stz $2111	; Set layer 3 X scroll to $0100
	lda #$01
	sta $2111
	lda #$1F	; Set layer 3 Y scroll to $011F
	sta $2112
	lda #$01
	sta $2112

.End
	plx
	jml remap_rom($0082B0)

.NMITable
	db $00,$00,$00,$01,$01
	db $01,$01,$01,$01,$01
	db $01,$01,$01,$00,$00





;;;;;;;;;;;;;
;Tile Buffer;
;;;;;;;;;;;;;

; This buffers code to save time in V-Blank.

Buffer:
if !use_sa1_mapping
	lda.b #.Main
	sta $3180
	lda.b #.Main/256
	sta $3181
	lda.b #.Main/65536
	sta $3182
	jsr $1E80

	lda $1C
	pha
	lda $1D
	pha
	jml remap_rom($00A2AF)

.Main
	phb
	phk
	plb
else
	phx
	phy
	pha
	phb
	php
	phk
	plb
endif

	lda remap_ram($13D4)
	beq .NoPause
	bra .End

.NoPause
	lda !vwfmode	; Prepare jump to routine
	beq .End
	asl
	tax
	lda .Routinetable,x
	sta $00
	inx
	lda .Routinetable,x
	sta $01
	phk
	pla
	sta $02

	lda !freezesprites	; Freeze sprites if flag is set
	beq .NoFreezeSprites
	lda #$02
	sta remap_ram($13FB)
	sta $9D
	sta remap_ram($13D3)
	lda $15
	and #$BF
	sta $15
	lda $16
	and #$BF
	sta $16
	lda $17
	and #$BF
	sta $17
	lda $18
	and #$BF
	sta $18

.NoFreezeSprites
	jml [remap_ram($0000)]

.End
if !use_sa1_mapping
	plb
	rtl
else
	plp	; Return
	plb
	pla
	ply
	plx

	lda $1C
	pha
	lda $1D
	pha
	jml remap_rom($00A2AF)
endif

.Routinetable
	dw .End,.End,VWFSetup,BufferGraphics,.End
	dw .End,BufferWindow,VWFInit,TextCreation,CollapseWindow
	dw .End,.End,.End,.End,.End





VWFSetup:
	jsr GetMessage
	jsr LoadHeader
	jmp Buffer_End

LoadHeader:
	lda !vwftextsource
	sta $00
	lda !vwftextsource+1
	sta $01
	lda !vwftextsource+2
	sta $02

	ldy #$00

	!8bit lda [$00],y	; Font
	!8bit sta !font
	!8bit iny

	lda [$00],y	; X position
	lsr #3
	sta !xpos

	rep #$20	; Y position
	lda [$00],y
	xba
	and #$07C0
	lsr #6
	sep #$20
	sta !ypos
	iny

	lda [$00],y	; Width
	and #$3C
	lsr #2
	sta !width

	rep #$20	; Height
	lda [$00],y
	xba
	and #$03C0
	lsr #6
	sep #$20
	sta !height
	iny

	lda [$00],y	; Edge
	and #$3C
	lsr #2
	sta !edge

	rep #$20	; Space
	lda [$00],y
	xba
	and #$03C0
	lsr #6
	sep #$20
	sta !space
	iny

	lda [$00],y	; Text speed
	and #$3F
	sta !frames
	iny

	lda [$00],y	; Auto wait
	sta !autowait
	iny

	lda [$00],y	; Box creation style
	lsr #4
	sta !boxcreate
	iny

	lda [$00],y	; Letter color
	sta !boxcolor+2
	iny
	lda [$00],y
	sta !boxcolor+3
	iny

	lda [$00],y	; Shading color
	sta !boxcolor+4
	iny
	lda [$00],y
	sta !boxcolor+5
	iny

	lda [$00],y	; Freeze sprites?
	lsr #7
	sta !freezesprites
	sta remap_ram($13FB)
	sta $9D
	sta remap_ram($13D3)

	lda !freezesprites
	beq .NoFreezeSprites
	and #$BF
	sta $15
	lda $16
	and #$BF
	sta $16
	lda $17
	and #$BF
	sta $17
	lda $18
	and #$BF
	sta $18

.NoFreezeSprites
	lda [$00],y	; Letter palette
	and #$70
	lsr #4
	sta !boxpalette

	lda [$00],y	; Layout
	and #$08
	lsr #3
	sta !layout

	lda [$00],y	; Speed up
	and #$04
	lsr #2
	sta !speedup

	lda [$00],y	; Disable sounds
	and #$01
	sta !soundoff
	iny

	lda !soundoff
	bne .NoSounds
	rep #$20	; SFX banks
	lda [$00],y
	and #$00C0
	lsr #6
	clc
	adc #$1DF9
	sta !beepbank
	lda [$00],y
	and #$0030
	lsr #4
	clc
	adc #$1DF9
	sta !beependbank
	lda [$00],y
	and #$000C
	lsr #2
	clc
	adc #$1DF9
	sta !beepcursorbank
	lda [$00],y
	and #$0003
	clc
	adc #$1DF9
	sta !beepchoicebank
	sep #$20
	iny

	lda [$00],y	; SFX numbers
	sta !beep
	iny
	lda [$00],y
	sta !beepend
	iny
	lda [$00],y
	sta !beepcursor
	iny
	lda [$00],y
	sta !beepchoice
	iny

	rep #$20
	lda $00
	clc
	adc #$0005
	sta $00

.NoSounds
	rep #$20
	lda $00
	clc
	!8bit adc #$000C
	!16bit adc #$000B
	sta !vwftextsource
	sep #$20


.ValidationChecks
	lda !width	; Validate all inputs
	cmp #$10
	bcc .WidthCheck2
	lda #$0F
	sta !width
	bra .WidthOK

.WidthCheck2
	cmp #$00
	bne .WidthOK
	lda #$01
	sta !width


.WidthOK
	lda !height
	cmp #$0E
	bcc .HeightCheck2
	lda #$0D
	sta !height
	bra .HeightOK

.HeightCheck2
	cmp #$00
	bne .HeightOK
	lda #$01
	sta !height


.HeightOK
	lda !width
	asl
	inc #2
	sta $0F
	clc
	adc !xpos
	cmp #$21
	bcc .XPosOK
	lda #$20
	sec
	sbc $0F
	sta !xpos


.XPosOK
	lda !height
	asl
	inc #2
	sta $0F
	clc
	adc !ypos
	cmp #$1D
	bcc .YPosOK
	lda #$1C
	sec
	sbc $0F
	sta !ypos

.YPosOK
	lda !width
	cmp #$03
	bcs .EdgeOK
	lda !edge
	and #$07
	sta !edge
	lda !width
	cmp #$02
	bcs .EdgeOK
	lda #$00
	sta !edge


.EdgeOK
	lda !boxcreate
	cmp #$05
	bcc .StyleOK
	lda #$04
	sta !boxcreate

.StyleOK
	rts





BufferGraphics:
	rep #$30
	ldx #$0000
	lda #$0000

.DrawEmpty
	sta !tileram,x	; Draw empty tile
	inx #2
	cpx #$0010
	bne .DrawEmpty
	sep #$30

	jsr ClearScreen

	; Copy text box graphics over to RAM

	%bwramtransfer($0010,!boxbg,Patterns,!tileram+16)
	%bwramtransfer($0090,!boxframe,Frames,!tileram+32)

	jmp Buffer_End


; This routine clears the screen by filling the tilemap with $00.

ClearScreen:
	lda Emptytile
	sta !tile
	lda !boxpalette
	asl #2
	ora Emptytile+1
	sta !property
	rep #$30
	ldx #$0000
	lda !tile

.InitTilemap
	sta !tileram+$3900,x
	inx #2
	cpx #$0700
	bne .InitTilemap

	sep #$30
	rts




BufferWindow:
	lda !counter	; Buffer text box tilemap
	bne .SkipInit
	lda #$00	; Text box init
	sta !currentwidth
	sta !currentheight
	lda !xpos
	clc
	adc !width
	sta !currentx
	lda !ypos
	clc
	adc !height
	sta !currenty
	lda #$01
	sta !counter

.SkipInit
	lda !boxcreate	; Prepare jump to routine
	asl
	tax
	lda.l .Routinetable,x
	sta $00
	inx
	lda.l .Routinetable,x
	sta $01
	phk
	pla
	sta $02

	jml [remap_ram($0000)]

.Routinetable
	dw .NoBox,.SoEBox,.SoMBox,.MMZBox,.InstBox

.End
	jmp Buffer_End



.NoBox
	lda #$02	; No text box
	sta !counter
	jmp .End



.SoEBox
	lda !xpos
	sta !currentx
	lda !ypos
	sta !currenty
	lda !width
	asl
	sta !currentwidth
	jsr DrawBox

	lda !height
	asl
	cmp !currentheight
	bne .SoEEnd
	lda #$02
	sta !counter

.SoEEnd
	lda !currentheight
	inc
	sta !currentheight
	jmp .End



.SoMBox
	lda !width
	asl
	cmp !currentwidth
	beq .ExpandVert
	jsr SoMLine
	lda !currentwidth
	inc #2
	sta !currentwidth
	lda !currentx
	dec
	sta !currentx
	jmp .End

.ExpandVert
	lda !height
	asl
	cmp !currentheight
	bcc .SoMEnd
	jsr DrawBox
	lda !currentheight
	inc #2
	sta !currentheight
	lda !currenty
	dec
	sta !currenty
	jmp .End

.SoMEnd
	lda #$02
	sta !counter
	jmp .End



.MMZBox
	lda !xpos
	sta !currentx
	lda !ypos
	sta !currenty
	lda !height
	asl
	sta !currentheight
	jsr DrawBox

	lda !width
	asl
	cmp !currentwidth
	bne .MMZEnd
	lda #$02
	sta !counter

.MMZEnd
	lda !currentwidth
	inc
	sta !currentwidth
	jmp .End



.InstBox
	lda !xpos
	sta !currentx
	lda !ypos
	sta !currenty
	lda !width
	asl
	sta !currentwidth
	lda !height
	asl
	sta !currentheight
	jsr DrawBox

.InstEnd
	lda #$02
	sta !counter
	jmp .End



SoMLine:
	lda !currentx
	sta $00
	lda !currenty
	sta $01
	lda #$01
	sta $02
	jsr GetTilemapPos
	rep #$20
	lda.w #!tileram+$3900
	clc
	adc $03
	sta $03
	sep #$20
	lda.b #!tileram+$3900>>16
	sta $05

	ldy #$00
	lda.b #!framepalette<<2|$20
	xba
	jsr LineLoop

	ldy #$40
	lda.b #!framepalette<<2|$A0
	xba
	jsr LineLoop
	rts


LineLoop:
	lda !currentwidth
	lsr
	inc
	tax
	phx
	lda #$08
	rep #$20
	and #$BFFF
	sta [$03],y
	dex
	iny #2
	inc

.Loop1
	cpx #$00
	beq .Prepare2
	sta [$03],y
	dex
	iny #2
	bra .Loop1

.Prepare2
	ora #$4000
	plx

.Loop2
	cpx #$01
	beq .End
	sta [$03],y
	dex
	iny #2
	bra .Loop2

.End
	dec
	sta [$03],y
	sep #$20
	rts


; This routine takes the variables !currentx, !currenty,
; !currentwidth and !currentheight to create a complete text box
; in RAM, utilizing all of the the subroutines below.

DrawBox:
	lda !currentx	; Create background
	sta $00
	lda !currenty
	sta $01
	lda.b #!tileram+$3900
	sta $03
	lda.b #!tileram+$3900>>8
	sta $04
	lda.b #!tileram+$3900>>16
	sta $05
	lda !currentwidth
	sta $06
	lda !currentheight
	sta $07
	jsr DrawBG

	lda !currentx	; Create frame
	sta $00
	lda !currenty
	sta $01
	lda.b #!tileram+$3900
	sta $03
	lda.b #!tileram+$3900>>8
	sta $04
	lda !currentwidth
	sta $06
	lda !currentheight
	sta $07
	jsr AddFrame
	rts


; This subroutine calculates the correct position of a tilemap with
; $7E0000 as X coordinate and $7E0001 as Y coordinate.
; If $7E0002 = $01 then the tilemap consists of two bytes per tile.
; The result is returned at $7E0003-$7E0004 to be added to the
; tilemap starting address after this routine is done.

GetTilemapPos:
	lda $02	; Tilemap consists of double bytes?
	beq .NoDouble
	lda $00
	asl
	sta $00
	lda #$20
	asl
	bra .Store

.NoDouble
	lda #$20

.Store
	sta select(!use_sa1_mapping,$2251,$211B)	; Multiply Y coordinate by $20/$40
	stz select(!use_sa1_mapping,$2252,$211B)
	stz select(!use_sa1_mapping,$2250,$211C)
	lda $01
	sta select(!use_sa1_mapping,$2253,$211C)
	if !use_sa1_mapping : stz $2254
	lda #$00
	xba
	lda $00
	rep #$20
	clc
	adc select(!use_sa1_mapping,$2306,$2134)
	sta $03
	sep #$20
	lda $02
	beq .End
	lda $00	; Half $7E0000 again if previously doubled
	lsr
	sta $00

.End
	rts


; This draws the background of a text box. $7E0001-$7E0004 are the
; same as in GetTilemapPos, but $7E0002 gets set automatically.
; $7E0006 contains the width and $7E0007 the height of the text box.
; $7E0008-$7E000A are used as temporary variables.

DrawBG:
	lda $06	; Skip if width or height equal $00
	beq .End

	lda $07
	beq .End

	lda $01
	sta $0A
	lda $07	; Load text box height and add y position
	clc	; for a backwards loop
	adc $01
	sta $01
	lda #$01
	sta $02
	lda $03
	sta $08
	lda $04
	sta $09

.InstLoopY
	jsr GetTilemapPos	; Get tilemap position
	rep #$20
	lda $08
	clc
	adc $03
	sta $03
	sep #$20
	lda $06
	asl
	tay

	lda !boxpalette
	asl #2
	ora #$20
	xba
	lda #$01
	rep #$20

.InstLoopX
	sta [$03],y	; Create row
	dey #2
	bne .InstLoopX
	sep #$20

	dec $01
	lda $01
	cmp $0A
	bne .InstLoopY	; Loop to create multiple rows

.End
	rts


; A routine which creates a text box frame in RAM. $7E0000-$7E0004
; are used the same way as in GetTilemapPos, except for $7E0002,
; which is used as a temporary variable here. $7E0005 contains the
; tilemap bank, $7E0006 the text box width and $7E0007 the text box
; height. $7E0008-$7E000D are used as temporary variables. At the
; same time $7E000A is the tile number and $7E000B the "flip
; vertically" flag for the DrawTile subroutine.

AddFrame:
	lda $03	; Preserve tilemap address
	sta $08
	lda $04
	sta $09
	jsr SetPos

	lda $07	; Draw central tiles (vertical)
	inc #2
	sta $0C
	lda #$07
	sta $0A
	stz $0B

.VerticalLoop
	jsr DrawTile
	rep #$20
	lda $03
	clc
	adc #$0040
	sta $03
	sep #$20
	dec $0C
	lda $0C
	bne .VerticalLoop

	jsr DrawLine	; Draw top and bottom of text box
	lda #$01
	sta $02
	lda $01
	sta $0D
	inc $01
	jsr SetPos
	lda #$06
	sta $0A
	jsr DrawTile

	lda $0D
	clc
	adc $07
	sta $01
	jsr SetPos
	lda #$80
	sta $0B
	jsr DrawTile
	inc $01
	jsr DrawLine
	lda $0D
	sta $01
	rts


; Draw horizontal lines of the text box frame

DrawLine:
	lda #$04	; Prepare filling
	sta $0A
	jsr SetPos
	lda $06
	beq .ZeroWidth
	inc
	lsr
	sta $0C
	and #$01	; If uneven width skip first tile
	beq .HorizontalLoop
	bra .SkipDraw

.HorizontalLoop
	jsr DrawTile	; Fill lines horizontally

.SkipDraw
	rep #$20
	inc $03
	inc $03
	dey #4
	sep #$20
	dec $0C
	lda $0C
	bne .HorizontalLoop
	lda #$05	; Draw central part
	sta $0A
	jsr DrawTile

	jsr SetPos
	rep #$20
	inc $03
	inc $03
	dey #4
	sep #$20
	lda #$03	; Draw second and second last tile
	sta $0A
	jsr DrawTile

	jsr SetPos

.ZeroWidth
	lda #$02	; Draw outer parts
	sta $0A
	jsr DrawTile
	rts


; A short routine to easier get the position for drawing tiles

SetPos:
	jsr GetTilemapPos
	rep #$20
	lda $08
	clc
	adc $03
	sta $03
	sep #$20
	lda $06	; Use Y register for right half of text box
	asl
	inc #2
	tay
	rts


; Draw one or two tiles in a line

DrawTile:
	lda.b #!framepalette<<2|$20
	ora $0B	; Vertical flip?
	xba
	lda $0A	; Tile number
	rep #$20
	sta [$03]
	cpy #$00
	beq .End
	ora #$4000
	sta [$03],y

.End
	sep #$20
	rts





CollapseWindow:
	lda !counter	; Collapse text box
	bne .SkipInit
	lda !width
	asl
	sta !currentwidth
	lda !height
	asl
	sta !currentheight
	lda !xpos	; Text box init
	sta !currentx
	lda !ypos
	sta !currenty
	lda #$01
	sta !counter

.SkipInit
	lda !boxcreate	; Prepare jump to routine
	asl
	tax
	lda.l .Routinetable,x
	sta $00
	inx
	lda.l .Routinetable,x
	sta $01
	phk
	pla
	sta $02

	jml [remap_ram($0000)]

.Routinetable
	dw .NoBox,.SoEBox,.SoMBox,.MMZBox,.InstBox

.End
	jmp Buffer_End



.NoBox
	jsr ClearScreen
	lda #$02
	sta !counter
	jmp .End



.SoEBox
	lda !xpos
	sta !currentx
	lda !ypos
	sta !currenty
	lda !width
	asl
	sta !currentwidth
	jsr DrawBox

	lda !ypos
	clc
	adc !currentheight
	inc #2
	sta $01
	jsr ClearHoriz

	lda !currentheight
	bne .SoEEnd
	lda #$02
	sta !counter

.SoEEnd
	lda !currentheight
	dec
	sta !currentheight
	jmp .End



.SoMBox
	lda !currentheight
	beq .CollapseHorz

	lda !currenty
	sta $01
	jsr ClearHoriz

	lda !currenty
	clc
	adc !currentheight
	inc #1
	sta $01
	jsr ClearHoriz

	lda !currentheight
	dec #2
	sta !currentheight
	lda !currenty
	inc
	sta !currenty

	jsr DrawBox
	jmp .End

.CollapseHorz
	lda !currentwidth
	beq .SoMEnd

	lda !currentx
	sta $00
	jsr ClearVert

	lda !currentx
	clc
	adc !currentwidth
	inc #1
	sta $00
	jsr ClearVert

	lda !currentwidth
	dec #2
	sta !currentwidth
	lda !currentx
	inc
	sta !currentx

	jsr SoMLine
	jmp .End

.SoMEnd
	lda #$02
	sta !counter
	jmp .End



.MMZBox
	lda !xpos
	sta !currentx
	lda !ypos
	sta !currenty
	lda !height
	asl
	sta !currentheight
	jsr DrawBox

	lda !xpos
	clc
	adc !currentwidth
	inc #2
	sta $00
	jsr ClearVert

	lda !currentwidth
	bne .MMZEnd
	lda #$02
	sta !counter

.MMZEnd
	lda !currentwidth
	dec
	sta !currentwidth
	jmp .End




.InstBox
	jsr ClearScreen
	lda #$02
	sta !counter
	jmp .End



; Clears a vertical line at X position $7E0000.

ClearVert:
	lda Emptytile
	sta !tile
	lda !boxpalette
	asl #2
	ora Emptytile+1
	sta !property
	stz $01
	lda #$01
	sta $02
	jsr GetTilemapPos
	lda.b #!tileram+$3900>>16
	sta $05
	rep #$20
	lda.w #!tileram+$3900
	clc
	adc $03
	sta $03
	ldy #$00

.FillLoop
	lda !tile
	sta [$03]
	lda $03
	clc
	adc #$0040
	sta $03
	iny
	cpy #$1C
	bne .FillLoop
	sep #$20
	rts


; Clears a horizontal line at Y position $7E0001.

ClearHoriz:
	lda Emptytile
	sta !tile
	lda !boxpalette
	asl #2
	ora Emptytile+1
	sta !property
	stz $00
	lda #$01
	sta $02
	jsr GetTilemapPos
	lda.b #!tileram+$3900>>16
	sta $05
	rep #$20
	lda.w #!tileram+$3900
	clc
	adc $03
	sta $03
	ldy #$00
	lda !tile

.FillLoop
	sta [$03],y
	iny #2
	cpy #$40
	bne .FillLoop
	sep #$20
	rts





VWFInit:
	jsr GetMessage
	jsr LoadHeader

if !use_sa1_mapping
	lda.b #.PaletteStuff
	sta $0183
	lda.b #.PaletteStuff/256
	sta $0184
	lda.b #.PaletteStuff/65536
	sta $0185
	lda #$d0
	sta $2209
-	lda $018A
	beq -
	stz $018A

	jsr ClearBox
.End
	jmp Buffer_End

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.PaletteStuff
endif
	lda !boxpalette	; Update letter color
	asl #2
	inc
	inc
	asl
	phy
	tay
	ldx #$00

.BoxColorLoop
	lda !boxcolor+2,x
	sta remap_ram($0703),y
	inx
	iny
	cpx #$04
	bne .BoxColorLoop

	ply
	lda #$01
	sta !paletteupload

if !use_sa1_mapping
	rtl
else
	jsr ClearBox

.End
	jmp Buffer_End
endif

InitLine:
	lda #$01
	sta !firsttile
	lda !edge	; Reset pixel count
	sta !currentpixel
	lda #$00
	sta !widthcarry

	lda !width	; Reset available width
	asl #4
	sec
	sbc !currentpixel
	sec
	sbc !currentpixel
	sta !vwfmaxwidth

	lda !currentchoice
	beq .NoChoicePixels
	lda !currentpixel
	clc
	adc !choicewidth
	sta !currentpixel
	lda !vwfmaxwidth
	sec
	sbc !choicewidth
	sta !vwfmaxwidth
	jmp .RegularLayout

.NoChoicePixels
	lda !layout	; Centered layout?
	bne .Centered
	jmp .RegularLayout

.Centered
	lda #$00
	sta !vwfwidth
	sta !currentwidth
	lda !vwftextsource
	pha
	lda !vwftextsource+1
	pha
	lda !vwftextsource+2
	pha
	lda !font
	pha

.WidthBegin
	jsr WordWidth

	lda !widthcarry
	beq .NoCarry
	lda #$00
	sta !widthcarry
	lda !currentwidth
	bne .WidthEnd
	lda !vwfwidth
	sta !currentwidth
	bra .WidthEnd

.NoCarry
	lda !vwfwidth
	sta !currentwidth
	!16bit rep #$20
	lda !vwfchar
	!8bit cmp #$FE
	!16bit cmp #$FFFE
	!16bit sep #$20
	bne .WidthEnd

	lda !vwfwidth
	clc
	adc !space
	bcs .WidthEnd
	cmp !vwfmaxwidth
	bcs .WidthEnd
	sta !vwfwidth
	bra .WidthBegin

.WidthEnd
	lda !vwfmaxwidth
	sec
	sbc !currentwidth
	lsr
	clc
	adc !currentpixel
	sta !currentpixel

	pla
	sta !font
	pla
	sta !vwftextsource+2
	pla
	sta !vwftextsource+1
	pla
	sta !vwftextsource
	!16bit rep #$20
	!16bit lda #$0000
	!8bit lda #$00
	sta !vwfchar
	!16bit sep #$20

.RegularLayout
	lda #$00
	sta !currentx
	lda !currenty
	inc #2
	sta !currenty
	cmp !vwfmaxheight
	bcc .NoClearBox
	lda !choices
	beq .NoChoicesClear
	lda #$01
	sta !cursormove
	bra .NoClearBox

.NoChoicesClear
	lda #$01
	sta !clearbox

	lda !autowait
	beq .NoClearBox
	cmp #$01
	beq .ButtonWait
	lda !autowait
	sta !wait
	bra .NoClearBox

.ButtonWait
	jsr EndBeep
	!8bit lda #$FA
	!16bit rep #$20
	!16bit lda #$FFFA
	sta !vwfchar
	!16bit sep #$20

.NoClearBox
	rep #$20
	lda !tile	; Increment tile counter
	inc #2
	sta !tile
	and #$03FF
	asl #4
	clc
	adc.w #!tileram	; Add starting address
	sta $09
	sep #$20
	lda.b #!tileram>>16
	sta $0B

if !use_sa1_mapping
	lda #$01
	sta $2250
endif
	lda !currentpixel
	sta select(!use_sa1_mapping,$2251,$4204)

.NoNewTile
	stz select(!use_sa1_mapping,$2252,$4205)
	lda #$08
	sta select(!use_sa1_mapping,$2253,$4206)
if !use_sa1_mapping
	stz $2254
	nop
	bra $00
else
	nop #8
endif
	lda select(!use_sa1_mapping,$2308,$4216)
	sta !currentpixel
	rep #$20
	lda select(!use_sa1_mapping,$2306,$4214)
	asl
	clc
	adc !tile
	sta !tile
	sep #$20
	lda select(!use_sa1_mapping,$2306,$4214)
	clc
	adc !currentx
	sta !currentx

	lda !currentchoice
	beq .End
	dec
	sta !currentchoice
	bne .End
	lda #$01
	sta !cursormove

.End
	rts


ClearBox:
	jsr ClearScreen
	lda !boxcreate
	beq .Init
	lda !xpos
	sta !currentx
	lda !ypos
	sta !currenty
	lda !width
	asl
	sta !currentwidth
	lda !height
	asl
	sta !currentheight
	jsr DrawBox
	bra .Init

.Init
	lda #$FE
	sta !currenty
	lda #$09
	sta !tile
	lda !boxpalette
	asl #2
	ora Emptytile+1
	sta !property
	lda !height
	asl
	sta !vwfmaxheight
	jsr InitLine
	rts


GetMessage:
	lda !message
	sta select(!use_sa1_mapping,$2251,$211B)
	lda !message+1
	sta select(!use_sa1_mapping,$2252,$211B)
	stz select(!use_sa1_mapping,$2250,$211C)
	lda #$03
	sta select(!use_sa1_mapping,$2253,$211C)
if !use_sa1_mapping
	stz select(!use_sa1_mapping,$2254,$2306)
	nop
endif
	rep #$20
	lda select(!use_sa1_mapping,$2306,$2134)
	clc
	adc.w #Pointers
	sta $00
	sep #$20
	lda.b #Pointers>>16
	sta $02
	ldy #$00
	lda [$00],y
	sta !vwftextsource
	iny
	lda [$00],y
	sta !vwftextsource+1
	iny
	lda [$00],y
	sta !vwftextsource+2
	rts





TextCreation:
	lda !wait
	beq .NoWait
	jmp .End

.NoWait
	lda !cursormove
	bne .Cursor
	jmp .NoCursor


.Cursor
	lda !currentchoice
	bne .NotZeroCursor
	lda #$01
	sta !currentchoice
	stz $0F
	jsr BackupTilemap
	jmp .DisplayCursor

.NotZeroCursor
	lda $16
	and #$0C
	bne .CursorMove
	lda $18
	and #$80
	cmp #$80
	beq .ChoicePressed
	jmp .End

.ChoicePressed
	jsr ButtonBeep
	jmp .CursorEnd

.CursorMove
	lda #$01
	sta $0F
	jsr BackupTilemap
	lda $16
	and #$0C
	cmp #$08
	bcs .CursorUp
	lda !currentchoice
	inc
	sta !currentchoice
	bra .CursorSFX

.CursorUp
	lda !currentchoice
	dec
	sta !currentchoice

.CursorSFX
	jsr CursorBeep
	lda !currentchoice
	beq .ZeroCursor
	lda !choices
	cmp !currentchoice
	bcs .DisplayCursor
	lda #$01
	sta !currentchoice
	bra .DisplayCursor

.ZeroCursor
	lda !choices
	sta !currentchoice

.DisplayCursor
	lda #$01
	sta !cursorupload
	stz $0F
	jsr BackupTilemap
	%mvntransfer($0060, #$00, !tileram+$38A0, !vwftileram)
	lda !choicespace
	cmp #$08
	bcs .NoChoiceCombine
	lda !choicewidth
	clc
	adc !edge
	lsr #3
	asl
	tax
	rep #$20
	lda !tileram+$3894,x
	and #$03FF
	asl #4
	clc
	adc.w #!tileram
	sta $03
	sep #$20
	lda.b #!tileram>>16
	sta $05

	lda !choicewidth
	clc
	adc !edge
	lsr #3
	asl #5
	tax
	ldy #$00

.CombineLoop
	lda !vwftileram,x
	inx
	ora !vwftileram,x
	dex
	eor #$FF
	and [$03],y
	ora !vwftileram,x
	sta !vwftileram,x
	inx
	iny
	cpy #$20
	bne .CombineLoop

.NoChoiceCombine
	jmp .End

.CursorEnd
	lda #$01
	sta !cursorend
	jmp .End


.NoCursor
	!16bit rep #$20
	lda !vwfchar
	!8bit cmp #$FA
	!16bit cmp #$FFFA
	!16bit sep #$20
	bne .NoButton
	jmp .End

.NoButton
	lda !clearbox
	beq .NoClearBox
	jsr ClearBox
	jmp .End

.NoClearBox
	jsr ReadPointer
	!16bit rep #$20
	lda [$00]
	sta !vwfchar
	!16bit inc $00
	!8bit cmp #$EC
	!16bit cmp #$FFEC
	bcs .Jump
	!16bit sep #$20
	jmp .WriteLetter

.Jump
	sec
	!8bit sbc #$EC
	!16bit sbc #$FFEC
	!16bit sep #$20
	asl
	tax
	lda.l .Routinetable,x
	sta $0C
	inx
	lda.l .Routinetable,x
	sta $0D
	phk
	pla
	sta $0E
	!16bit jsr IncPointer
	jml [remap_ram($000C)]

.Routinetable
	dw .EC_PlayBGM
	dw .ED_ClearBox
	dw .EE_ChangeColor
	dw .EF_Teleport
	dw .F0_Choices
	dw .F1_Execute
	dw .F2_ChangeFont
	dw .F3_ChangePalette
	dw .F4_Character
	dw .F5_RAMCharacter
	dw .F6_HexValue
	dw .F7_DecValue
	dw .F8_TextSpeed
	dw .F9_WaitFrames
	dw .FA_WaitButton
	dw .FB_TextPointer
	dw .FC_LoadMessage
	dw .FD_LineBreak
	dw .FE_Space
	dw .FF_End

.EC_PlayBGM
	ldy #$01
	lda [$00],y
	sta remap_ram($1DFB)
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.ED_ClearBox
	lda !choices
	beq .EDNoChoices
	jmp .FD_LineBreak

.EDNoChoices
	lda #$01
	sta !clearbox
	jsr IncPointer
	jmp TextCreation

.EE_ChangeColor
if !use_sa1_mapping
	lda.b #.EE_ChangeColor_SNES
	sta $0183
	lda.b #.EE_ChangeColor_SNES/256
	sta $0184
	lda.b #.EE_ChangeColor_SNES/65536
	sta $0185
	lda #$d0
	sta $2209
	ldy #$01
-	lda $018A
	beq -
	stz $018A

	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.EE_ChangeColor_SNES
endif
	phx
	ldy #$01
	lda [$00],y
	asl
	tax
	iny
	lda [$00],y
	sta remap_ram($0703),x
	iny
	lda [$00],y
	sta remap_ram($0704),x
	plx
	lda #$01
	sta !paletteupload
if !use_sa1_mapping
	rtl
else
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton
endif

.EF_Teleport
	ldy #$01
	lda [$00],y
	sta !telepdest
	iny
	lda [$00],y
	sta !telepdest+1
	iny
	lda [$00],y
	sta !telepprop
	lda #$01
	sta !teleport
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.F0_Choices
	jsr ReadPointer

	lda !firsttile
	eor #$01
	sta !nochoicelb

	ldy #$01
	lda [$00],y
	lsr #4
	pha
	cmp !height
	bcc .ChoiceStore
	beq .ChoiceStore
	lda !height

.ChoiceStore
	sta !choices
	inc
	sta !currentchoice
	lda !vwfmaxheight
	sec
	sbc !currenty
	beq .F0ClearForce
	sec
	sbc !nochoicelb
	sec
	sbc !nochoicelb
	lsr
	cmp !choices
	bcs .CreateCursor

.F0ClearForce
	pla
	lda #$01
	sta !clearbox
	jmp .F0ClearOptions

.CreateCursor
	lda [$00],y
	and #$0F
	sta !choicespace
	iny
	lda [$00],y
	sta !cursor
	!16bit iny
	!16bit lda [$00],y
	!16bit sta !cursor+1
	!16bit jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer

	lda !vwftextsource
	sta !choicetable
	lda !vwftextsource+1
	sta !choicetable+1
	lda !vwftextsource+2
	sta !choicetable+2
	lda !edge
	and #$07
	sta !currentpixel
	lda !firsttile
	sta !nochoicelb
	lda #$01
	sta !firsttile

	!16bit lda !cursor+1
	!16bit sta !font

	jsr GetFont

	rep #$20
	lda #$0001
	sta $0C
	lda.w #!cursor
	sta $00
	lda.w #!tileram+$38A0
	sta $09
	sep #$20
	lda.b #!cursor>>16
	sta $02
	lda.b #!tileram+$38A0>>16
	sta $0B

	lda !currentx
	pha
	lda !tile
	pha
	lda #$00
	sta !currentx

	lda !currentpixel
	sta $0E
	lda !firsttile
	sta $0F

	jsl GenerateVWF

	lda !vwfwidth
	clc
	adc !choicespace
	sta !choicewidth

	lda !boxcreate
	beq .F0NoBG

	rep #$20
	lda #$0006
	sta $06
	lda.w #!tileram+$10
	sta $00
	lda.w #!tileram+$38A0
	sta $03
	sep #$20
	lda.b #!tileram+$10>>16
	sta $02
	lda.b #!tileram+$38A0>>16
	sta $05

	jsl AddPattern

.F0NoBG
	rep #$20
	lda.w #!tileram+$38A0
	sta $09
	sep #$20
	lda.b #!tileram+$38A0>>16
	sta $0B

	lda !currentx
	asl #5
	clc
	adc $09
	sta $09

	lda !currentpixel
	clc
	adc !choicespace
	sta !choicespace
	cmp #$08
	bcs .NoChoiceWipe

	jsr WipePixels

.NoChoiceWipe
	pla
	sta !tile
	pla
	sta !currentx

	lda #$00
	sta $0D
	xba
	pla
	sta $0C
	asl
	clc
	adc $0C
	rep #$20
	clc
	adc !vwftextsource
	sta !vwftextsource
	sep #$20

	jsr InitLine
	lda !nochoicelb
	beq .F0NotStart
	lda !currenty
	dec #2
	sta !currenty

.F0NotStart
	lda !clearbox
	beq .F0Return
	lda !currentchoice
	inc
	sta !currentchoice

.F0ClearOptions
	lda !autowait
	beq .F0NoAutowait
	cmp #$01
	beq .F0ButtonWait
	lda !autowait
	sta !wait
	bra .F0NoAutowait

.F0ButtonWait
	jsr EndBeep
	!16bit rep #$20
	!16bit lda #$FFFA
	!8bit lda #$FA
	sta !vwfchar
	!16bit sep #$20

.F0NoAutowait
	jmp TextCreation

.F0Return
	jmp .NoButton

.F1_Execute
	lda #$22
	sta !vwfroutine
	ldy #$01
	lda [$00],y
	sta !vwfroutine+1
	iny
	lda [$00],y
	sta !vwfroutine+2
	iny
	lda [$00],y
	sta !vwfroutine+3
	lda #$6B
	sta !vwfroutine+4
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jsl !vwfroutine
	jmp .NoButton

.F2_ChangeFont
	ldy #$01
	lda [$00],y
	sta !font
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.F3_ChangePalette
	lda !property
	and #$E3
	sta !property
	ldy #$01
	lda [$00],y
	asl #2
	inc
	asl
	phx
	tax
	lda [$00],y
	asl #2
	ora !property
	sta !property
	lda !boxcolor
	sta remap_ram($0703),x
	lda !boxcolor+1
	sta remap_ram($0704),x
	lda #$01
	sta !paletteupload
	plx
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.F4_Character
	jsr IncPointer
	jsr ReadPointer
	!16bit rep #$20
	lda [$00]
	sta !vwfchar
	!16bit sep #$20
	jmp .WriteLetter

.F5_RAMCharacter
	ldy #$01
	lda [$00],y
	sta $0C
	iny
	lda [$00],y
	sta $0D
	iny
	lda [$00],y
	sta $0E
	!16bit rep #$20
	lda [$0C]
	sta !vwfroutine
	!16bit sep #$20
	lda #$FB
	sta !vwfroutine+1+!bitmode
	!16bit lda #$FF
	!16bit sta !vwfroutine+3
	rep #$20
	lda $00
	inc #4
	sta !vwfroutine+2+!bitmode+!bitmode
	sep #$20
	lda $02
	sta !vwfroutine+4+!bitmode+!bitmode
	lda.b #!vwfroutine
	sta !vwftextsource
	lda.b #!vwfroutine>>8
	sta !vwftextsource+1
	lda.b #!vwfroutine>>16
	sta !vwftextsource+2
	jmp .NoButton

.F6_HexValue
	ldy #$01
	lda [$00],y
	sta $0C
	iny
	lda [$00],y
	sta $0D
	iny
	lda [$00],y
	sta $0E
	lda [$0C]
	lsr #4
	sta !vwfroutine
	!16bit lda #$00
	!16bit sta !vwfroutine+1
	lda [$0C]
	and #$0F
	sta !vwfroutine+1+!bitmode
	!16bit lda #$00
	!16bit sta !vwfroutine+3
	lda #$FB
	sta !vwfroutine+2+!bitmode+!bitmode
	!16bit lda #$FF
	!16bit sta !vwfroutine+5
	rep #$20
	lda $00
	inc #4
	sta !vwfroutine+3+!bitmode+!bitmode+!bitmode
	sep #$20
	lda $02
	sta !vwfroutine+5+!bitmode+!bitmode+!bitmode
	lda.b #!vwfroutine
	sta !vwftextsource
	lda.b #!vwfroutine>>8
	sta !vwftextsource+1
	lda.b #!vwfroutine>>16
	sta !vwftextsource+2
	jmp .NoButton

.F7_DecValue
	lda #$FB
	!8bit sta !vwfroutine+5
	!16bit sta !vwfroutine+10
	!16bit lda #$FF
	!16bit sta !vwfroutine+11
	rep #$20
	lda $00
	clc
	adc #$0005
	!8bit sta !vwfroutine+6
	!16bit sta !vwfroutine+12
	sep #$20
	lda $02
	!8bit sta !vwfroutine+8
	!16bit sta !vwfroutine+14

	ldy #$01
	lda [$00],y
	sta $07
	iny
	lda [$00],y
	sta $08
	iny
	lda [$00],y
	sta $09
	iny
	lda [$00],y
	pha
	and #$F0
	sta $04
	jsr HextoDec

	stz $00
	stz $01
	lda $04
	bne .SixteenBit
	inc $00
	inc $00
	!16bit inc $00
	!16bit inc $00

.SixteenBit
	pla
	and #$0F
	beq .NoZeros
	lda $05
	!16bit asl
	clc
	adc $00
	sta $00

.NoZeros
	rep #$20
	lda.w #!vwfroutine
	clc
	adc $00
	sta !vwftextsource
	sep #$20
	lda.b #!vwfroutine>>16
	sta !vwftextsource+2

	jmp .NoButton

.F8_TextSpeed
	ldy #$01
	lda [$00],y
	sta !frames
	jsr IncPointer
	jsr IncPointer
	jmp .End

.F9_WaitFrames
	ldy #$01
	lda [$00],y
	sta !wait
	lda #$01
	sta !forcesfx
	jsr IncPointer
	jsr IncPointer
	jmp .End

.FA_WaitButton
	jsr EndBeep
	jsr IncPointer
	jmp .End

.FB_TextPointer
	ldy #$01
	lda [$00],y
	sta !vwftextsource
	iny
	lda [$00],y
	sta !vwftextsource+1
	iny
	lda [$00],y
	sta !vwftextsource+2
	jmp .NoButton

.FC_LoadMessage
	ldy #$01
	lda [$00],y
	sta !message
	iny
	lda [$00],y
	sta !message+1
	lda !vwfmode
	dec
	sta !vwfmode
	lda #$01
	sta !clearbox
	jmp VWFInit

.FD_LineBreak
	!16bit rep #$20
	!16bit lda #$FFFD
	!8bit lda #$FD
	sta !vwfchar
	!16bit sep #$20
	jsr IncPointer
	jsr InitLine
	lda !clearbox
	ora !cursormove
	beq .FDReturn
	jmp TextCreation

.FDReturn
	jmp .NoButton

.FE_Space
	jsr IncPointer
	lda !vwfmaxwidth
	cmp !space
	bcs .PutSpace
	jsr InitLine
	lda !clearbox
	ora !cursormove
	bne .SpaceClearBox
	jmp .FEReturn

.SpaceClearBox
	jmp TextCreation

.PutSpace
	lda !vwfmaxwidth
	sec
	sbc !space
	sta !vwfmaxwidth

if !use_sa1_mapping
	lda #$01
	sta $2250
endif
	lda !currentpixel
	clc
	adc !space
	sta select(!use_sa1_mapping,$2251,$4204)
	cmp #$08
	bcc .NoNewTile
	lda #$01
	sta !firsttile

.NoNewTile
	stz select(!use_sa1_mapping,$2252,$4205)
	lda #$08
	sta select(!use_sa1_mapping,$2253,$4206)
if !use_sa1_mapping
	stz $2254
	nop
	bra $00
else
	nop #8
endif
	lda select(!use_sa1_mapping,$2308,$4216)
	sta !currentpixel
	rep #$20
	lda select(!use_sa1_mapping,$2306,$4214)
	asl
	clc
	adc !tile
	sta !tile
	sep #$20
	lda select(!use_sa1_mapping,$2306,$4214)
	clc
	adc !currentx
	sta !currentx

	lda #$00	; Preserve everything and get width
	sta !vwfwidth	; of next word (for word wrap)
	lda !vwftextsource
	pha
	lda !vwftextsource+1
	pha
	lda !vwftextsource+2
	pha
	lda !font
	pha
	lda !vwfchar
	pha
	!16bit lda !vwfchar+1
	!16bit pha

	jsr WordWidth

	!16bit pla
	!16bit sta !vwfchar+1
	pla
	sta !vwfchar
	pla
	sta !font
	pla
	sta !vwftextsource+2
	pla
	sta !vwftextsource+1
	pla
	sta !vwftextsource

	lda !widthcarry
	bne .FECarrySet
	lda !vwfmaxwidth
	cmp !vwfwidth
	bcs .FEReturn

.FECarrySet
	lda #$00
	sta !widthcarry
	jsr InitLine
	lda !clearbox
	ora !cursormove
	beq .FEReturn
	jmp TextCreation

.FEReturn
	jmp .NoButton

.FF_End
	lda !choices
	beq .FFNoChoices
	jmp .FD_LineBreak

.FFNoChoices
	jsr IncPointer
	jmp .End

.WriteLetter
	!16bit lda !vwfchar+1
	!16bit sta !font
	jsr GetFont

	rep #$20
	lda #$0001
	sta $0C
	lda !vwftextsource
	sta $00
	sep #$20
	lda !vwftextsource+2
	sta $02

	lda [$00]	; Check if enough width available
	tay
	lda !vwfmaxwidth
	cmp [$06],y
	bcs .Create
	jsr InitLine
	jsr GetFont
	rep #$20
	lda #$0001
	sta $0C
	lda !vwftextsource
	sta $00
	sep #$20
	lda !vwftextsource+2
	sta $02

	lda !clearbox
	ora !cursormove
	beq .Create
	jmp TextCreation

.Create
	jsr IncPointer
	!16bit jsr IncPointer
	lda [$06],y
	sta !vwfwidth
	jsr WriteTilemap

	jsr GetDestination

	lda $09
	sta !vwfgfxdest
	lda $0A
	sta !vwfgfxdest+1
	lda $0B
	sta !vwfgfxdest+2

	lda !firsttile
	bne .NoWipe
	lda !boxcreate
	beq .NoWipe

	jsr WipePixels

.NoWipe
	lda !currentpixel
	sta $0E
	lda !firsttile
	sta $0F

	jsl GenerateVWF

	lda !boxcreate
	beq .End
	lda.b #!tileram+$10
	sta $00
	lda.b #!tileram+$10>>8
	sta $01
	lda.b #!tileram+$10>>16
	sta $02

	lda !vwfgfxdest
	sta $03
	lda !vwfgfxdest+1
	sta $04
	lda !vwfgfxdest+2
	sta $05

	lda #$06
	sta $06

	jsl AddPattern

.End
	jmp Buffer_End



GetFont:
	lda #$06	; Multiply font number with 6
	sta select(!use_sa1_mapping,$2251,$211B)
	stz select(!use_sa1_mapping,$2252,$211B)
	stz select(!use_sa1_mapping,$2250,$211C)
	lda !font
	sta select(!use_sa1_mapping,$2253,$211C)
if !use_sa1_mapping
	stz $2254
	nop
endif
	rep #$20
	lda select(!use_sa1_mapping,$2306,$2134)
	clc
	adc.w #Fonttable	; Add starting address
	sta $00
	sep #$20
	lda.b #Fonttable>>16
	sta $02
	ldy #$00

.Loop
	lda [$00],y	; Load addresses from table
	sta remap_ram($0003),y
	iny
	cpy #$06
	bne .Loop
	rts


GetDestination:
	rep #$20
	lda !tile
	and #$03FF	; Multiply tile number with 16
	asl #4
	clc
	adc.w #!tileram	; Add starting address
	sta $09
	sep #$20
	lda.b #!tileram>>16
	sta $0B
	rts


IncPointer:
	rep #$20
	lda !vwftextsource
	inc
	sta !vwftextsource
	sep #$20
	rts


ReadPointer:
	rep #$20
	lda !vwftextsource
	sta $00
	sep #$20
	lda !vwftextsource+2
	sta $02
	rts


Beep:
	lda !soundoff
	beq .Begin
	rts

.Begin
	lda !forcesfx
	bne .Play
	lda !frames
	bne .Play
	lda $13
	and #$01
	beq .Play
	bra .Return

.Play
	lda #$00
	sta !forcesfx
	rep #$20
	lda !beepbank
	sta $00
	sep #$20
	lda.b #!rambank
	sta $02
	lda !beep
	sta [$00]

.Return
	rts

EndBeep:
	lda !soundoff
	beq .Begin
	rts

.Begin
	rep #$20
	lda !beependbank
	sta $00
	sep #$20
	lda.b #!rambank
	sta $02
	lda !beepend
	sta [$00]
	rts

CursorBeep:
	lda !soundoff
	beq .Begin
	rts

.Begin
	rep #$20
	lda !beepcursorbank
	sta $00
	sep #$20
	lda.b #!rambank
	sta $02
	lda !beepcursor
	sta [$00]
	rts

ButtonBeep:
	lda !soundoff
	beq .Begin
	rts

.Begin
	rep #$20
	lda !beepchoicebank
	sta $00
	sep #$20
	lda.b #!rambank
	sta $02
	lda !beepchoice
	sta [$00]
	rts


WriteTilemap:
	rep #$20
	lda $00
	pha
	lda $02
	pha
	lda $04
	pha
	sep #$20
	lda !currentx	; Get tilemap address
	inc
	clc
	adc !xpos
	sta $00
	lda !currenty
	inc
	clc
	adc !ypos
	sta $01
	lda #$01
	sta $02
	jsr GetTilemapPos
	lda.b #!tileram+$3900>>16
	sta $05
	sta !vwftilemapdest+2
	rep #$20
	lda.w #!tileram+$3900
	clc
	adc $03
	sta $03
	sta !vwftilemapdest

	lda !vwfwidth
	clc
	adc !currentpixel
	tax
	lda !tile
	ldy #$02

	sta [$03]	; Write to tilemap
	cpx #$09
	bcc .SecondLine
	inc #2
	sta [$03],y
	cpx #$11
	bcc .SecondLine
	inc #2
	iny #2
	sta [$03],y

.SecondLine
	lda !tile
	inc
	ldy #$40
	sta [$03],y
	cpx #$09
	bcc .Return
	inc #2
	iny #2
	sta [$03],y
	cpx #$11
	bcc .Return
	inc #2
	iny #2
	sta [$03],y

.Return
	pla
	sta $04
	pla
	sta $02
	pla
	sta $00
	sep #$20
	rts


WipePixels:
	lda !currentpixel	; Wipe pixels to prevent overlapping
	tax	; graphics
	ldy #$00

.Loop
	lda [$09],y
	and .Pixeltable,x
	sta [$09],y

	iny
	cpy #$20
	bne .Loop
	rts

.Pixeltable
	db $00,$80,$C0,$E0,$F0,$F8,$FC,$FE

;$07 : Address
;$04 : Bitmode
;$05 : Zeros

HextoDec:
	jsr Convert8Bit
	jsr GetZeros
	!16bit lda #$00
	!16bit sta !vwfroutine+1
	!16bit sta !vwfroutine+3
	!16bit sta !vwfroutine+5
	!16bit sta !vwfroutine+7
	!16bit sta !vwfroutine+9
	rts

Convert8Bit:
	stz $00
	stz $01
	stz $02
	stz $03
	lda [$07]
	ldy $04
	cpy #$00
	beq .Hundreds
	jsr Convert16Bit

.Hundreds
	cmp #$64
	bcc .Tens
	inc $02
	sec
	sbc #$64
	bra .Hundreds

.Tens
	cmp #$0A
	bcc .Ones
	inc $03
	sec
	sbc #$0A
	bra .Tens

.Ones
	sta !vwfroutine+4+!bitmode+!bitmode+!bitmode+!bitmode
	lda $03
	sta !vwfroutine+3+!bitmode+!bitmode+!bitmode
	lda $02
	sta !vwfroutine+2+!bitmode+!bitmode

	rts

Convert16Bit:
	rep #$20
	lda [$07]

.Tenthousands
	cmp #$2710
	bcc .Thousands
	inc $00
	sec
	sbc #$2710
	bra .Tenthousands

.Thousands
	cmp #$03E8
	bcc .Hundreds
	inc $01
	sec
	sbc #$03E8
	bra .Thousands

.Hundreds
	cmp #$0064
	bcc .End
	inc $02
	sec
	sbc #$0064
	bra .Hundreds

.End
	pha
	lda $00
	sta !vwfroutine
	pla
	sep #$20
	rts

GetZeros:
	stz $05
	dec $05
	stz $06
	ldy $04
	beq .Hundreds

.Tenthousands
	inc $05
	lda !vwfroutine
	beq .Thousands
	bra .End

.Thousands
	inc $05
	lda !vwfroutine+1+!bitmode
	beq .Hundreds
	bra .End

.Hundreds
	inc $05
	lda !vwfroutine+2+!bitmode+!bitmode
	beq .Tens
	bra .End

.Tens
	inc $05
	lda !vwfroutine+3+!bitmode+!bitmode+!bitmode
	beq .Ones
	bra .End

.Ones
	inc $05

.End
	rts



WordWidth:
	!8bit jsr GetFont

.Begin
	jsr ReadPointer
	!16bit rep #$20
	lda [$00]
	sta !vwfchar
	!8bit cmp #$EC
	!16bit cmp #$FFEC
	bcs .Jump
	!16bit sep #$20
	!16bit jsr IncPointer
	jsr IncPointer
	jmp .Add

.Jump
	sec
	!8bit sbc #$EC
	!16bit sbc #$FFEC
	!16bit sep #$20
	asl
	tax
	lda.l .Routinetable,x
	sta $0C
	inx
	lda.l .Routinetable,x
	sta $0D
	phk
	pla
	sta $0E
	!16bit jsr IncPointer
	jsr IncPointer
	jsr ReadPointer
	jml [remap_ram($000C)]

.Routinetable
	dw .EC_PlayBGM
	dw .ED_ClearBox
	dw .EE_ChangeColor
	dw .EF_Teleport
	dw .F0_Choices
	dw .F1_Execute
	dw .F2_ChangeFont
	dw .F3_ChangePalette
	dw .F4_Character
	dw .F5_RAMCharacter
	dw .F6_HexValue
	dw .F7_DecValue
	dw .F8_TextSpeed
	dw .F9_WaitFrames
	dw .FA_WaitButton
	dw .FB_TextPointer
	dw .FC_LoadMessage
	dw .FD_LineBreak
	dw .FE_Space
	dw .FF_End

.EE_ChangeColor
.EF_Teleport
.F1_Execute
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jmp .Begin

.F2_ChangeFont
	lda [$00]
	sta !font
	jsr IncPointer
	jmp WordWidth

.F3_ChangePalette
	jsr IncPointer
	jmp .Begin

.F4_Character
	!16bit rep #$20
	lda [$00]
	sta !vwfchar
	!16bit sep #$20
	!16bit jsr IncPointer
	jsr IncPointer
	jmp .Add

.F5_RAMCharacter
	ldy #$01
	lda [$00]
	sta $0C
	lda [$00],y
	sta $0D
	iny
	lda [$00],y
	sta $0E
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	!16bit rep #$20
	lda [$0C]
	sta !vwfchar
	!16bit sep #$20
	jmp .Add

.F6_HexValue
	ldy #$01
	lda [$00]
	sta $0C
	lda [$00],y
	sta $0D
	iny
	lda [$00],y
	sta $0E
	lda [$0C]
	lsr #4
	sta !vwfroutine
	!16bit lda #$00
	!16bit sta !vwfroutine+1
	lda [$0C]
	and #$0F
	sta !vwfroutine+1+!bitmode
	!16bit lda #$00
	!16bit sta !vwfroutine+3
	lda #$FB
	sta !vwfroutine+2+!bitmode+!bitmode
	!16bit lda #$FF
	!16bit sta !vwfroutine+5
	rep #$20
	lda $00
	inc #3
	sta !vwfroutine+3+!bitmode+!bitmode+!bitmode
	sep #$20
	lda $02
	sta !vwfroutine+5+!bitmode+!bitmode+!bitmode
	lda.b #!vwfroutine
	sta !vwftextsource
	lda.b #!vwfroutine>>8
	sta !vwftextsource+1
	lda.b #!vwfroutine>>16
	sta !vwftextsource+2
	jmp .Begin

.F7_DecValue
	lda #$FB
	!8bit sta !vwfroutine+5
	!16bit sta !vwfroutine+10
	!16bit lda #$FF
	!16bit sta !vwfroutine+11
	rep #$20
	lda $00
	clc
	adc #$0004
	!8bit sta !vwfroutine+6
	!16bit sta !vwfroutine+12
	sep #$20
	lda $02
	!8bit sta !vwfroutine+8
	!16bit sta !vwfroutine+14

	ldy #$01
	lda [$00]
	sta $07
	lda [$00],y
	sta $08
	iny
	lda [$00],y
	sta $09
	iny
	lda [$00],y
	pha
	and #$F0
	sta $04
	jsr HextoDec

	stz $00
	stz $01
	lda $04
	bne .SixteenBit
	inc $00
	inc $00
	!16bit inc $00
	!16bit inc $00

.SixteenBit
	pla
	and #$0F
	beq .NoZeros
	lda $05
	!16bit asl
	clc
	adc $00
	sta $00

.NoZeros
	rep #$20
	lda.w #!vwfroutine
	clc
	adc $00
	sta !vwftextsource
	sep #$20
	lda.b #!vwfroutine>>16
	sta !vwftextsource+2

	jmp WordWidth

.EC_PlayBGM
.F8_TextSpeed
.F9_WaitFrames
	jsr IncPointer
	jmp .Begin

.FA_WaitButton
	jmp .Begin

.FB_TextPointer
	ldy #$01
	lda [$00]
	sta !vwftextsource
	lda [$00],y
	sta !vwftextsource+1
	iny
	lda [$00],y
	sta !vwftextsource+2
	jmp .Begin

.ED_ClearBox
.F0_Choices
.FC_LoadMessage
.FD_LineBreak
.FE_Space
.FF_End
	jmp .Return

.Add
	!16bit lda !vwfchar+1
	!16bit sta !font
	!16bit jsr GetFont
	lda !vwfchar
	tay
	lda [$06],y
	clc
	adc !vwfwidth
	bcs .End
	cmp !vwfmaxwidth
	bcc .Continue
	beq .Continue
	bra .End

.Continue
	sta !vwfwidth
	jmp .Begin

.End
	lda #$01
	sta !widthcarry

.Return
	rts





;;;;;;;;;;;;;;
;V-Blank Code;
;;;;;;;;;;;;;;

; This loads up graphics and tilemaps to VRAM.

VBlank:
	phx
	phy
	pha
	phb
	php
	phk
	plb

	lda remap_ram($13D4)
	beq .NoPause
	bra .End

.NoPause
	lda !vwfmode	; Prepare jump to routine
	beq .End

	lda !paletteupload	; This code takes care of palette upload requests
	beq .skip
	lda #$00
	sta !paletteupload
	sta $2121
	%dmatransfer(#$01,#$02,#$22,".b #!rambank",".b #$07",".b #$03",#$0040)
.skip

	lda !vwfmode
	asl
	tax
	lda .Routinetable,x
	sta $00
	inx
	lda .Routinetable,x
	sta $01
	phk
	pla
	sta $02

	lda #$F0	; Hide Status Bar item
	sta remap_ram($02E1)

	jml [remap_ram($0000)]

.End
	plp	; Return
	plb
	pla
	ply
	plx

	lda !vwfmode	; Skip Status Bar in dialogues
	bne .SkipStatusBar
	lda remap_ram($0D9B)
	lsr
	bcs .SkipStatusBar
	phk	; Display Status Bar
	per $0006
	pea $84CE
	jml remap_rom($008DAC)

.SkipStatusBar
	jml remap_rom($0081F7)

.Routinetable
	dw .End,PrepareBackup,Backup,PrepareScreen,SetupColor
	dw BackupEnd,CreateWindow,PrepareScreen,TextUpload,CreateWindow
	dw PrepareBackup,Backup,SetupColor,BackupEnd,VBlankEnd






VBlankEnd:
	lda remap_ram($0109)	; Check if in the intro
	beq .NotIntroLevel
	jsl remap_rom($05B15B)
	jmp .NotSwitchPallace

.NotIntroLevel
	lda remap_ram($13D2)	; Check if in a Switch Pallace
	beq .NotSwitchPallace
	ldx remap_ram($191E)
	lda .SwitchTable,x
	sta remap_ram($13D2)
	inc remap_ram($1DE9)
	lda #$01
	sta remap_ram($13CE)
	jsl remap_rom($05B165)

.NotSwitchPallace
	lda !freezesprites
	beq .NoFreezeSprites
	lda #$00
	sta remap_ram($13FB)
	sta $9D
	sta remap_ram($13D3)
	sta !freezesprites

.NoFreezeSprites
	lda !teleport	; Check if teleport set
	beq .NoTeleport

	lda #$00
	sta !teleport

	lda $5B
	beq .Horizontal

	ldx $97
	bra .SetupTeleport

.Horizontal
	ldx $95

.SetupTeleport
	lda !telepdest
	sta remap_ram($19B8),x
	lda !telepdest+1
	ora #$04
	ora !telepprop
	sta remap_ram($19D8),x

.Teleport
	lda #$06
	sta $71
	stz $89
	stz $88

.NoTeleport
	lda #$00	; VWF dialogue end
	sta !vwfmode

	jmp VBlank_End

.SwitchTable
	db $04,$01,$02,$03




PrepareBackup:
	lda #$08	; Prepare backup of layer 3
	sta !counter
	rep #$20
	lda #$0000
	sta !vrampointer
	sep #$20

	lda #$04	; Hide layer 3
	trb remap_ram($0D9D)
	lda remap_ram($0D9D)
	sta $212C

.End
	lda !vwfmode
	inc
	sta !vwfmode
	jmp VBlank_End





Backup:
	rep #$20

	lda !vrampointer
	asl a
	clc
	adc.w #!backupram	; Adjust destination address
	sta $00

	lda #$4000	; Adjust VRAM address
	clc
	adc !vrampointer
	sta $02

	sep #$20

	lda !vwfmode
	cmp #$02
	beq .Backup
	jmp .Restore

.Backup
	%vramprepare(#$80,$02,"lda $2139","")
	%dmatransfer(#$01,#$81,#$39,".b #!backupram>>16",".b $01",".b $00",#$0800)
	jmp .Continue

.Restore
	%vramprepare(#$80,$02,"","")
	%dmatransfer(#$01,#$01,#$18,".b #!backupram>>16",".b $01",".b $00",#$0800)

.Continue
	rep #$20	; Adjust pointer
	lda !vrampointer
	clc
	adc #$0400
	sta !vrampointer
	sep #$20

	lda !counter	; Reduce iteration counter
	dec
	sta !counter
	bne .NotDone

.End
	lda !vwfmode
	inc
	sta !vwfmode

.NotDone
	jmp VBlank_End





BackupEnd:
	lda #$04	; Display layer 3
	tsb remap_ram($0D9D)
	lda remap_ram($0D9D)
	sta $212C

.End
	lda !vwfmode
	inc
	sta !vwfmode
	jmp VBlank_End





SetupColor:
	stz $2121	; Backup or restore layer 3 colors
	lda !vwfmode
	cmp #$04
	beq .Backup
.Restore
	%mvntransfer($0040, #$00, !palbackup, select(!use_sa1_mapping,$400703,$7E0703))
	%dmatransfer(#$01,#$02,#$22,".b #!rambank",".b #$07",".b #$03",#$0040)
	jmp .End

.Backup
	%dmatransfer(#$01,#$82,#$3B,".b #!rambank",".b #$07",".b #$03",#$0040)
	%mvntransfer($0040, #$00, select(!use_sa1_mapping,$400703,$7E0703), !palbackup)

	lda !boxpalette	; Set BG and letter color
	asl #2
	inc
	asl
	phy
	tay
	ldx #$00

.BoxColorLoop
	lda !boxcolor,x
	sta remap_ram($0703),y
	iny
	inx
	cpx #$06
	bne .BoxColorLoop

	ply
	lda #!framepalette	; Set frame color
	asl #2
	inc
	asl
	phx
	tax
	phk
	pla
	sta $02
	lda #$06
	sta $211B
	stz $211B
	stz $211C
	lda !boxframe
	sta $211C
	nop
	rep #$20
	lda $2134
	clc
	adc.w #Palettes
	sta $00
	sep #$20
	ldy #$00

.FrameColorLoop
	lda [$00],y
	sta remap_ram($0703),x
	inx
	iny
	cpy #$06
	bne .FrameColorLoop
	plx

	lda #$01
	sta !paletteupload

.End
	lda !vwfmode
	inc
	sta !vwfmode
	jmp VBlank_End





PrepareScreen:
	%vramprepare(#$80,#$4000,"","")	; Upload graphics and tilemap to VRAM
	%dmatransfer(#$01,#$01,#$18,".b #!tileram>>16",".b #!tileram>>8",".b #!tileram",#$00B0)

	%vramprepare(#$80,#$5C80,"","")
	%dmatransfer(#$01,#$01,#$18,".b #!tileram+$3900>>16",".b #!tileram+$3900>>8",".b #!tileram+$3900",#$0700)

.End
	lda !vwfmode
	inc
	sta !vwfmode
	jmp VBlank_End





CreateWindow:
	%vramprepare(#$80,#$5C80,"","")
	%dmatransfer(#$01,#$01,#$18,".b #!tileram+$3900>>16",".b #!tileram+$3900>>8",".b #!tileram+$3900",#$0700)

	lda !counter
	cmp #$02
	bne .Return

.End
	lda #$00
	sta !counter
	lda !vwfmode
	inc
	sta !vwfmode

.Return
	jmp VBlank_End


TextUpload:
	lda !cursorfix
	beq .SkipCursor
	dec
	sta !cursorfix

	%vramprepare(#$80,!cursorvram,"","")
	%dmatransfer(#$01,#$01,#$18,".b #!tileram+$3900>>16"," !cursorsrc+1"," !cursorsrc",#$0046)

.SkipCursor
	lda !wait	; Wait for frames?
	beq .NoFrames
	lda !wait
	dec
	sta !wait
	jmp .Return

.NoFrames
	lda !cursormove
	bne .Cursor
	jmp .NoCursor


.Cursor
	lda !cursorupload
	bne .UploadCursor
	jmp .NoCursorUpload

.UploadCursor
	lda #$00
	sta !cursorupload

	%vramprepare(#$80,#$5C50,"","")
	%dmatransfer(#$01,#$01,#$18,".b #!vwftileram>>16",".b #!vwftileram>>8",".b #!vwftileram",#$0060)

	lda !edge
	lsr #3
	sta !currentx
	lda !currenty
	pha
	sec
	sbc !choices
	sec
	sbc !choices
	sta !currenty
	lda !currentchoice
	dec
	asl
	clc
	adc !currenty
	sta !currenty
	lda #$00
	sta !vwfwidth
	lda !edge
	and #$07
	clc
	adc !choicewidth
	sta !currentpixel
	rep #$20
	lda !tile
	and #$FC00
	ora #$038A
	sta !tile
	sep #$20
	jsr WriteTilemap
	pla
	sta !currenty

	rep #$20
	lda !vwftilemapdest
	sec
	sbc.w #!tileram+$3900
	lsr
	clc
	adc #$5C80
	sta $00
	sep #$20
	%vramprepare(#$80,$00,"","")
	%dmatransfer(#$01,#$01,#$18," !vwftilemapdest+2"," !vwftilemapdest+1"," !vwftilemapdest",#$0046)

	jmp .Return

.NoCursorUpload
	lda !cursorend
	bne .CursorEnd
	jmp .Return

.CursorEnd
	lda #$00
	sta !cursorend
	lda !currentchoice
	dec
	sta !currentchoice
	asl
	clc
	adc !currentchoice
	tay
	lda !choicetable
	sta $00
	lda !choicetable+1
	sta $01
	lda !choicetable+2
	sta $02
	lda [$00],y
	sta !vwftextsource
	iny
	lda [$00],y
	sta !vwftextsource+1
	iny
	lda [$00],y
	sta !vwftextsource+2
	lda #$00
	sta !cursormove
	sta !choices
	sta !currentchoice
	sta !vwfchar
	!16bit sta !vwfchar+1
	lda #$01
	sta !clearbox
	jmp .Return


.NoCursor
	!16bit rep #$20
	lda !vwfchar	; Dialogue done?
	!8bit cmp #$FF
	!16bit cmp #$FFFF
	bne .NoEnd
	!16bit lda #$0000
	!8bit lda #$00
	sta !vwfchar
	!16bit sep #$20
	jmp .End

.NoEnd
	!8bit cmp #$FA	; Waiting for A button?
	!16bit cmp #$FFFA
	!16bit sep #$20
	beq .CheckButton
	jmp .Upload

.CheckButton
	lda $18
	and #$80
	cmp #$80
	bne .NotPressed
	jsr ButtonBeep
	lda #$00
	sta !vwfchar
	!16bit sta !vwfchar+1
	lda #$00
	sta !timer

.NotPressed
	lda !boxcreate
	bne .CheckTimer
	jmp .Return

.CheckTimer
	lda !timer	; Display arrow if waiting for button
	inc
	sta !timer
	cmp #$21
	bcc .NoReset
	lda #$00
	sta !timer

.NoReset
	lda !xpos
	clc
	adc !width
	inc
	sta $00
	lda !height
	asl
	clc
	adc !ypos
	inc
	sta $01
	stz $02
	jsr GetTilemapPos
	rep #$20
	lda #$5C80
	clc
	adc $03
	sta $03
	sep #$20

	%vramprepare(#$00,$03,"","")

	lda !timer
	cmp #$11
	bcs .Arrow
	lda #$05
	bra .Display

.Arrow
	lda #$0A

.Display
	sta $2118
	jmp .Return

.Upload
	lda !clearbox
	beq .Begin
	lda #$00
	sta !clearbox
	%vramprepare(#$80,#$5C80,"","")
	%dmatransfer(#$01,#$01,#$18,".b #!tileram+$3900>>16",".b #!tileram+$3900>>8",".b #!tileram+$3900",#$0700)
	jmp .Return

.Begin
	rep #$20	; Upload GFX
	lda !vwfgfxdest
	sec
	sbc.w #!tileram
	lsr
	clc
	adc #$4000
	sta $00
	sep #$20
	%vramprepare(#$80,$00,"","")
	%dmatransfer(#$01,#$01,#$18," !vwfgfxdest+2"," !vwfgfxdest+1"," !vwfgfxdest",#$0060)

	rep #$20	; Upload Tilemap
	lda !vwftilemapdest
	sec
	sbc.w #!tileram+$3900
	lsr
	clc
	adc #$5C80
	sta $00
	sep #$20
	%vramprepare(#$80,$00,"","")
	%dmatransfer(#$01,#$01,#$18," !vwftilemapdest+2"," !vwftilemapdest+1"," !vwftilemapdest",#$0046)

	jsr Beep

	lda !frames
	sta !wait

	lda !speedup
	beq .Return
	!16bit rep #$20
	lda !vwfchar
	!8bit cmp #$F9
	!16bit cmp #$FFF9
	!16bit sep #$20
	beq .Return
	lda $15
	and #$80
	cmp #$80
	bne .Return
	lda #$00
	sta !wait
	jmp .Return

.End
	lda !vwfmode
	inc
	sta !vwfmode

.Return
	jmp VBlank_End



BackupTilemap:
	lda !edge
	lsr #3
	clc
	adc !xpos
	inc
	sta $00

	lda !currenty
	sec
	sbc !choices
	sec
	sbc !choices
	sta $01
	lda !currentchoice
	dec
	asl
	clc
	adc $01
	clc
	adc !ypos
	inc
	sta $01

	lda #$01
	sta $02

	jsr GetTilemapPos

	lda.b #!tileram+$3900>>16
	sta $05
	rep #$20
	lda.w #!tileram+$3900
	clc
	adc $03
	sta $03
	sep #$20

	lda $0F
	beq .Backup
	jmp .Restore

.Backup
	rep #$20
	ldy #$02
	lda [$03]
	sta !tileram+$3894
	lda [$03],y
	sta !tileram+$3896
	iny #2
	lda [$03],y
	sta !tileram+$3898
	ldy #$40
	lda [$03],y
	sta !tileram+$389A
	iny #2
	lda [$03],y
	sta !tileram+$389C
	iny #2
	lda [$03],y
	sta !tileram+$389E
	sep #$20

	rts

.Restore
	rep #$20
	ldy #$02
	lda !tileram+$3894
	sta [$03]
	lda !tileram+$3896
	sta [$03],y
	iny #2
	lda !tileram+$3898
	sta [$03],y
	ldy #$40
	lda !tileram+$389A
	sta [$03],y
	iny #2
	lda !tileram+$389C
	sta [$03],y
	iny #2
	lda !tileram+$389E
	sta [$03],y
	sep #$20

	rep #$20
	lda $03
	sec
	sbc.w #!tileram+$3900
	lsr
	clc
	adc #$5C80
	sta !cursorvram
	lda $03
	sta !cursorsrc
	lda #$01
	sta !cursorfix
	sep #$20
	;%vramprepare(#$80,$00,"","")
	;%dmatransfer(#$01,#$01,#$18," $05"," $04"," $03",#$0046)
	;Vitor Vilela's note:
	;Here is one big issue with the cursor.
	;This code actually is outside V-Blank and now I have to upload the following:
	;VRAM: $00-$01
	;Source: $03-$05
	;Bytes: #$0046
	;I don't know if the tile gets preserved or not for the current frame.
	;But for now I will have to preverse at least, $00-$01 and $03-$04, which means more 4 bytes
	;of free ram, plus the upload flag, so 5 more bytes of free ram.
	rts





;;;;;;;;;;;;;;
;VWF Routines;
;;;;;;;;;;;;;;

; The actual VWF Creation routine.

print ""
print "VWF Creation Routine at address $",pc,"."

;$00 : Text
;$03 : GFX 1
;$06 : Width
;$09 : Destination
;$0C : Number of Bytes -> GFX 2
;$0E : Current Pixel
;$0F : First Tile?

GenerateVWF:
	lda $0E
	sta !currentpixel
	lda $0F
	sta !firsttile
	rep #$20
	lda $0C
	sta !vwfbytes
	sep #$20
	lda $05	; Get GFX 2 Offset
	sta $0E
	rep #$20
	lda $03
	clc
	adc #$0020
	sta $0C

.Read
	lda [$00]	; Read character
	inc $00
	!16bit inc $00
	!8bit sep #$20
	sta !vwfchar
	!16bit sep #$20
	!16bit lda !vwfchar+1
	!16bit sta !font
	!16bit jsr GetFont
	!16bit lda $05
	!16bit sta $0E
	!16bit rep #$20
	!16bit lda $03
	!16bit clc
	!16bit adc #$0020
	!16bit sta $0C
	!16bit sep #$20
	!16bit lda !vwfchar
	tay
	lda [$06],y	; Get width
	sta !vwfwidth
	lda !vwfmaxwidth
	sec
	sbc !vwfwidth
	sta !vwfmaxwidth

.Begin
	lda !vwfchar	; Get letter offset into Y
	sta select(!use_sa1_mapping,$2251,$211B)
	stz select(!use_sa1_mapping,$2252,$211B)
	stz select(!use_sa1_mapping,$2250,$211C)
	lda #$40
	sta select(!use_sa1_mapping,$2253,$211C)
	if !use_sa1_mapping : stz $2254
	rep #$10
	ldy select(!use_sa1_mapping,$2306,$2134)
	ldx #$0000

.Draw
	lda !currentpixel
	sta $0F
	lda [$03],y	; Load one pixelrow of letter
	sta !vwftileram,x
	lda [$0C],y
	sta !vwftileram+32,x
	lda #$00
	sta !vwftileram+64,x

.Check
	lda $0F
	beq .Skip
	lda !vwftileram,x	; Shift to the right
	lsr
	sta !vwftileram,x
	lda !vwftileram+32,x
	ror
	sta !vwftileram+32,x
	lda !vwftileram+64,x
	ror
	sta !vwftileram+64,x
	dec $0F
	bra .Check

.Skip
	iny
	inx
	cpx #$0020
	bne .Draw
	sep #$10
	ldx #$00
	ldy #$00

	lda !firsttile	; Skip one step if first tile in line
	beq .Combine
	lda #$00
	sta !firsttile
	bra .Copy

.Combine
	lda !vwftileram,x	; Combine old graphic with new
	ora [$09],y
	sta [$09],y
	inx
	iny
	cpx #$20
	bne .Combine

.Copy
	lda !vwftileram,x	; Copy remaining part of letter
	sta [$09],y
	inx
	iny
	cpx #$60
	bne .Copy

if !use_sa1_mapping
	lda #$01
	sta $2250
endif
	lda !currentpixel	; Adjust destination address
	clc
	adc !vwfwidth
	sta select(!use_sa1_mapping,$2251,$4204)
	stz select(!use_sa1_mapping,$2252,$4205)
	lda #$08
	sta select(!use_sa1_mapping,$2253,$4206)
if !use_sa1_mapping
	stz $2254
	nop
	bra $00
else
	nop #8
endif
	lda select(!use_sa1_mapping,$2308,$4216)
	sta !currentpixel
	rep #$20
	lda select(!use_sa1_mapping,$2306,$4214)
	asl
	clc
	adc !tile
	sta !tile
	sep #$20
	lda select(!use_sa1_mapping,$2306,$4214)
	clc
	adc !currentx
	sta !currentx
	lda select(!use_sa1_mapping,$2306,$4214)
	sta select(!use_sa1_mapping,$2251,$211B)
	stz select(!use_sa1_mapping,$2250,$211B)
	stz select(!use_sa1_mapping,$2252,$211C)
	lda #$20
	sta select(!use_sa1_mapping,$2253,$211C)
if !use_sa1_mapping
	stz $2254
	nop
endif
	rep #$20
	lda select(!use_sa1_mapping,$2306,$2134)
	clc
	adc $09
	sta $09

	lda !vwfbytes	; Adjust number of bytes
	dec
	sta !vwfbytes
	beq .End
	jmp .Read

.End
	sep #$20
	rtl





; Adds the background pattern to letters.

print "Pattern Addition Routine at address $",pc,"."


;$00 : Graphic
;$03 : Destination
;$06 : Number of tiles

AddPattern:
	ldy #$00

.Combine
	iny
	lda [$03],y
	eor #$FF
	dey
	and [$00],y
	ora [$03],y
	sta [$03],y

	iny #2
	cpy #$10
	bne .Combine

	rep #$20
	lda $03
	clc
	adc #$0010
	sta $03
	sep #$20
	dec $06
	lda $06
	bne AddPattern

.End
	rtl





Emptytile:
	db $00,$20





;;;;;;;;;;;;;;;;
;[CUSTOMTABLES];
;;;;;;;;;;;;;;;;

Fonttable:
incsrc vwffontpointers.asm

Palettes:
incsrc vwfframes.asm





;;;;;;;;;;;;;;;;
;External Files;
;;;;;;;;;;;;;;;;

Frames:
incbin vwfframes.bin

Patterns:
incbin vwfpatterns.bin

Font1:
incbin vwffont1.bin
.Width
incsrc vwffont1.asm

print ""

print "VWF State register at address $",hex(!vwfmode),"."
print "Message register at address $",hex(!message),"."
print "BG GFX register at address $",hex(!boxbg),"."
print "BG Color register at address $",hex(!boxcolor),"."
print "Frame GFX register at address $",hex(!boxframe),"."

print ""
print "See Readme for details!"
print ""
print "Patch inserted at $",hex(FreecodeStart),", ",freespaceuse," bytes of free space used."

freedata
!PrevFreespace:

Pointers:
incsrc vwfmessagepointers.asm

%nextbank()

Text:
incsrc vwfmessages.asm

print "Text data insterted at $",hex(Text),"."

;-------------------------------------------------------------
;INSERT DATA HERE!





;END
;-------------------------------------------------------------
print ""
print ""
freedata : prot !PrevFreespace : Kleenex: db $00	;ignore this line, it must be last in the patch for technical reasons

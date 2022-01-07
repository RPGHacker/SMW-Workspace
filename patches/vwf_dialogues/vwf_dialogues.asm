@asar 1.90

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;VWF Dialogues Patch by RPG Hacker;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


incsrc vwfconfig.cfg
incsrc ../shared/shared.asm


print ""
print "VWF Dialogues Patch - (c) 2010-2022 RPG Hacker"
print ""


math round off

pushtable
cleartable


namespace vwf_dialogues_





;;;;;;;;
;Labels;
;;;;;;;;



; DO NOT EDIT ANYTHING HERE, UNLESS YOU KNOW EXACTLY WHAT YOU'RE DOING!
!palettebackupram = $7E0703

if !use_sa1_mapping
	!varram	= !varramSA1
	!backupram	= !backupramSA1
	!tileram	= !tileramSA1
	!palettebackupram	= !palettebackupramSA1
endif


!varrampos #= 0

macro claim_varram(define, size)
	!<define> := !varram+!varrampos
	!varrampos #= !varrampos+<size>
endmacro


%claim_varram(vwfmode, 1)				; Contains the current state of the text box.
%claim_varram(message, 2)				; The 16-bit message number to display

%claim_varram(boxbg, 1)
%claim_varram(boxcolor, 6)
%claim_varram(boxframe, 1)

; RPG Hacker: RAM addresses defined above this point won't automatically get cleared on opening message boxes.
!vwf_ram_clear_start_pos #= !varrampos

%claim_varram(counter, 1)

%claim_varram(width, 1)
%claim_varram(height, 1)
%claim_varram(xpos, 1)
%claim_varram(ypos, 1)
%claim_varram(boxcreate, 1)
%claim_varram(boxpalette, 1)
%claim_varram(freezesprites, 1)				; Flag indicating that the textbox has frozen all sprites.
%claim_varram(beep, 1)					; The sound effect ID to play for the text beep noise.
%claim_varram(beepbank, 2)				; The RAM address stored to by the above.
%claim_varram(beepend, 1)				; The sound effect ID to play for the "wait for A" sound effect.
%claim_varram(beependbank, 2)				; The RAM address stored to by the above.
%claim_varram(beepcursor, 1)				; The sound effect ID to play when moving the cursor
%claim_varram(beepcursorbank, 2)			; The RAM address stored to by the above.
%claim_varram(beepchoice, 1)				; The sound effect ID to play when pressing A.
%claim_varram(beepchoicebank, 2)			; The RAM address stored to by the above.
%claim_varram(font, 1)
%claim_varram(edge, 1)
%claim_varram(space, 1)
%claim_varram(frames, 1)
%claim_varram(layout, 1)
%claim_varram(soundoff, 1)				; Flag that disables all the normal textbox sounds
%claim_varram(speedup, 1)				; Flag indicating that the current textbox can be sped up when A is held.
%claim_varram(autowait, 1)

%claim_varram(vrampointer, 2)
%claim_varram(currentwidth, 1)
%claim_varram(currentheight, 1)
%claim_varram(currentx, 1)
%claim_varram(currenty, 1)

%claim_varram(vwftextsource, 3)				; 24-bit pointer to the current text data.
%claim_varram(vwfbytes, 2)
%claim_varram(vwfgfxdest, 3)
%claim_varram(vwftilemapdest, 3)			; 24-bit pointer to the location in the tile buffer to read from when uploading the textbox tilemap.
%claim_varram(vwfpixel, 2)
%claim_varram(vwfmaxwidth, 1)
%claim_varram(vwfmaxheight, 1)
%claim_varram(vwfchar, 2)
%claim_varram(vwfwidth, 1)
%claim_varram(vwfroutine, 15)
%claim_varram(vwftileram, 96)
%claim_varram(tile, 1)
%claim_varram(property, 1)
%claim_varram(currentpixel, 1)
%claim_varram(firsttile, 1)
%claim_varram(clearbox, 1)
%claim_varram(wait, 1)
%claim_varram(timer, 1)
%claim_varram(teleport, 1)				; Flag indicating whether a teleport should take place.
%claim_varram(telepdest, 1)				; Data that gets stored to the table at $19B8 when the teleport function is active.
%claim_varram(telepprop, 1)				; Data that gets stored to the table at $19D8 when the teleport function is active.
%claim_varram(forcesfx, 1)
%claim_varram(widthcarry, 1)
%claim_varram(choices, 1)
%claim_varram(cursor, 2)
%claim_varram(currentchoice, 1)
%claim_varram(choicetable, 3)
%claim_varram(choicespace, 1)
%claim_varram(choicewidth, 1)
%claim_varram(cursormove, 1)
%claim_varram(nochoicelb, 1)
%claim_varram(cursorupload, 1)
%claim_varram(cursorend, 1)

%claim_varram(paletteupload, 1)				; Flag indicating that the layer 3 palettes should be updated.
%claim_varram(palbackup, 64)				; Backup of the layer 3 palettes.
%claim_varram(cursorfix, 1)
%claim_varram(cursorvram, 2)
%claim_varram(cursorsrc, 2)
%claim_varram(arrowvram, 2)
%claim_varram(enddialog, 1)
%claim_varram(swapmessageid, 2)
%claim_varram(swapmessagesettings, 1)

%claim_varram(messageasmopcode, 1)			; Determines whether MessageASM code will run. Contains either $5C (JML) or $6B (RTL)
%claim_varram(messageasmloc, 3)				; 24-bit pointer to the current MessageASM routine.
%claim_varram(vwfactiveflag, 1)				; Flag indicating that a VWF Message is active. Used to tell the VWF system to close the current text box before opening the new one.
%claim_varram(skipmessageflag, 1)			; Flag indicating that the message skip function is enabled for the current textbox.
%claim_varram(skipmessageloc, 3)			; 24-bit pointer to the text data that will be jumped to if start is pressed and message skipping is enabled.
%claim_varram(l3priorityflag, 1)			; Backup of the layer 3 priority bit in register $2105
%claim_varram(l3transparencyflag, 1)			; Backup of the layer 3 color math settings from RAM address $40 (mirror of $2131) 
%claim_varram(l3mainscreenflag, 1)			; Backup of the layer 3 main screen bit from RAM address $0D9D (mirror of $212C)
%claim_varram(l3subscreenflag, 1)			; Backup of the layer 3 sub screen bit from RAM address $0D9E (mirror of $212D)
%claim_varram(isnotatstartoftext, 1)			; Flag indicating that the text box has just been cleared. Intended to provide an easy way to sync up MessageASM code with the start of a new textbox.
%claim_varram(initialskipmessageflag, 1)		; Flag indicating that the current textbox originally had the message skip function enabled. Intended to allow you to revert the state of the other skip message flag if it's been disabled.
%claim_varram(vwfbufferdest, 3)				; 24-bit pointer to the location in the tile buffer to read from when uploading text graphics.
%claim_varram(vwfbufferindex, 1)			; Index to the text graphics buffer determining where in the buffer to store tiles.

; RPG Hacker: Make sure both of these stacks have the same size. Stack 1 will be copied into stack 2 at run-time.
!vwf_text_macro_stack_size = 60
%claim_varram(vwfstackindex1, 1)						; Defines a stack of text pointers for the text macro system (to support nested macros)
%claim_varram(vwfstack1, !vwf_text_macro_stack_size)	; 
%claim_varram(vwfstackindex2, 1)						; Same as above, but for the WordWidth function.
%claim_varram(vwfstack2, !vwf_text_macro_stack_size)	;

%claim_varram(vwftbufferedtextpointerindex, 1)		; Index for the which 24-bit buffered text macro pointer should be updated.
%claim_varram(vwftbufferedtextindex, 2)			; 16-bit index into the text buffer, used for handling where to write in the table for consecuative text buffers.
%claim_varram(vwftbufferedtextpointers, !num_reserved_text_macros*3)	; 24-bit pointer table for the buffered text macros.
%claim_varram(vwftextbuffer, !buffered_text_macro_buffer_size)			; Buffer dedicated for uploading VWF text to in order to display variable text.

!vwfbuffer_emptytile = !tileram
!vwfbuffer_bgtile = !tileram+$10
!vwfbuffer_frame = !tileram+$20
!vwfbuffer_letters = !tileram+$20
!vwfbuffer_choicebackup = !tileram+$0420
!vwfbuffer_cursor = !tileram+$042C
!vwfbuffer_textboxtilemap = !tileram+$048C
;!vwfbuffer_choicebackup = !tileram+$3894
;!vwfbuffer_cursor = !tileram+$38A0
;!vwfbuffer_textboxtilemap = !tileram+$3900

!rambank	= select(!use_sa1_mapping,$40,$7E)

false	= 0
true	= 1

!8bit_mode_only     = "if !bitmode == BitMode.8Bit :"
!16bit_mode_only    = "if !bitmode == BitMode.16Bit :"

!vwf_current_message_name = ""
!vwf_current_message_asm_name = ""
!vwf_current_message_id = $10000
!vwf_header_present = false
!vwf_current_text_file_id = -1

!vwf_num_messages = 0
!vwf_highest_message_id = 0

!vwf_num_text_macros = 0
!vwf_num_text_macro_groups = 0

!vwf_num_fonts = 0
!vwf_num_text_files = 0

!vwf_prev_freespace = AutoFreespaceCleaner

if !use_sa1_mapping
	!dma_channel_nmi = 2
	!dma_channel_non_nmi = 0
else
	; RPG Hacker: I don't know if this distinction is actually necessary, but I don't even want to risk breaking compatibility.
	!dma_channel_nmi = 0
	!dma_channel_non_nmi = 0
endif

!cpu_snes = 0
!cpu_sa1 = 1

if !assembler_ver >= 20000
	!vwf_default_table_file = "vwftable_utf8.txt"
else
	!vwf_default_table_file = "vwftable_ascii.txt"
endif

; RPG Hacker: IMPORTANT: Adjust this define when adding any new commands to the patch!
!vwf_lowest_reserved_hex = $FFE7



incsrc vwfmacros.asm



if !bitmode == BitMode.16Bit
	warn "16-bit mode is deprecated and might be removed in the future."
endif





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



; RPG Hacker: This org is currently necessary, otherwise the struct above produces incorrect addresses??
org $008000

; DMA register helper
struct DMA_Regs $4300
    .Control: skip 1		; $43x0
    .Destination: skip 1	; $43x1
    .Source_Address:		; $43x2 - $43x4
		.Source_Address_Word:
			.Source_Address_Low: skip 1
			.Source_Address_High: skip 1
		.Source_Address_Bank: skip 1
    .Size:					; $43x5 - $43x7
		.Size_Word:
			.Size_Low: skip 1
			.Size_High: skip 1
		skip 1	; $43x7 used by HDMA only
endstruct align $10



; Helpers for defining DMA source address
function dma_source_indirect(address) = $01000000|(address&$FFFFFF)
function dma_source_indirect_word(address, bank) = ((bank&$FF)<<24)|(address&$FFFFFF)

!dma_write_once = #$01
!dma_write_twice = #$02
!dma_read_once = #$81
!dma_read_twice = #$82

; A simple Macro for DMA transfers
macro dmatransfer(channel, dmasettings, destination, source, bytes)
	assert <channel> >= 0 && <channel> <= 7,"%dmatransfer() channel parameter must be a value between 0 and 7. Current: <channel>"
	
	assert <destination> >= $2100 && <destination> <= $21FF, "Invalid destination passed to %dmatransfer(): <destination>. Must be a PPU register between $2100 and $21FF."
	
	!source_resolved #= <source>
	!dma_source_address_mode #= ((!source_resolved>>24)&$FF)
	
	!source_without_header #= !source_resolved&$FFFFFF
	
	if !dma_source_address_mode == 0
		!dma_source_low = "lda.b #!source_without_header"
		!dma_source_high = "lda.b #!source_without_header>>8"
		!dma_source_bank = "lda.b #!source_without_header>>16"
	elseif !dma_source_address_mode == 1
		!dma_source_low = "lda !source_without_header"
		!dma_source_high = "lda !source_without_header+1"
		!dma_source_bank = "lda !source_without_header+2"
	else
		!dma_source_low = "lda !source_without_header"
		!dma_source_high = "lda !source_without_header+1"
		!dma_source_bank = "lda.b #!dma_source_address_mode"
	endif

	lda <dmasettings>
	sta.w DMA_Regs[<channel>].Control
	lda.b #<destination>
	sta.w DMA_Regs[<channel>].Destination
	!dma_source_low
	sta.w DMA_Regs[<channel>].Source_Address_Low
	!dma_source_high
	sta.w DMA_Regs[<channel>].Source_Address_High
	!dma_source_bank
	sta.w DMA_Regs[<channel>].Source_Address_Bank
	rep #$20
	lda <bytes>
	sta.w DMA_Regs[<channel>].Size_Word
	sep #$20
	lda.b #(1<<<channel>)
	sta $420B
endmacro



; A macro for MVN transfers

macro mvntransfer(bytes, source, destination, current_cpu, ...)
	!currently_on_sa1_cpu = and(equal(<current_cpu>,!cpu_sa1),!use_sa1_mapping)

	phb
if sizeof(...) > 0
	lda.b #<bytes>	; Calculate starting index
	sta select(!currently_on_sa1_cpu,$2251,$211B)
	lda.b #<bytes>>>8
	sta select(!currently_on_sa1_cpu,$2252,$211B)
	stz select(!currently_on_sa1_cpu,$2250,$211C)
	lda <0>
	sta select(!currently_on_sa1_cpu,$2253,$211C)
	if !currently_on_sa1_cpu
		stz $2254
		nop
	endif
	
	rep #$31
	lda select(!currently_on_sa1_cpu,$2306,$2134)	; Add source address
	adc.w #<source>	; to get new source address
	tax
else
	rep #$30
	ldx.w #<source>
endif
	ldy.w #<destination>	; Destination address
	lda.w #<bytes>-1	; Number of bytes
	
	mvn bank(<destination>), bank(<source>)
	
	sep #$30
	plb
endmacro




; NEW: A macro for SA-1 DMA (ROM->BWRAM) transfer

macro bwramtransfer(bytes, start, source, destination)
	if !use_sa1_mapping && !sa1_use_dma_for_gfx_transfer
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
		rep #$21
		lda $2306	; Add source address
		adc.w #<source>	; to get new source address
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
		%mvntransfer(<bytes>, <source>, <destination>, !cpu_sa1, <start>)
	endif
endmacro





;;;;;;;;;
;Hijacks;
;;;;;;;;;


; Initialize RAM to prevent glitches or game crashes
org remap_rom($008064)
	autoclean jml InitCall		; workaround for Asar bug
	nop

; V-Blank code goes here
org remap_rom($0081F2)
	jml VBlank
	nop

; Hijack NMI for various things
org remap_rom($008297)
if !use_sa1_mapping
	ldx #$A1
	jml NMIHijack
else
	jml NMIHijack
	nop #$2
endif

; Restore hijacked code from older versions of the patch
; This hijack location was highly questionable to begin with.
org remap_rom($0086E2)
	sty $00
	rep #$30

; Call RAM Init Routine on Title Screen
org remap_rom($0096B4)
	jml InitMode

; Check if a message is active before fading out.
org remap_rom($009F37)
	jml MosaicGamemodeHijack
	nop

org remap_rom($009F6F)
	jml FadeGamemodeHijack
	nop

; Hijack message box to call VWF dialogue
org remap_rom($00A1DA)
	jml OriginalMessageBox
	nop

; SRAM expansion ($07 => 2^7 kb = 128 kb)
if !patch_sram_expansion != false && read1(remap_rom($00FFD8)) < $07
	org remap_rom($00FFD8)
		db $07
endif





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
	jsr InitDefaults
	lda #$03
	sta $2101
	jml remap_rom($008069)



InitMode:
	jsr InitRAM	; RAM init on Title Screen
	jsr InitDefaults
	ldx #$07
	lda #$FF
	jml remap_rom($0096B8)



; RPG Hacker: This routine is for initializing values that shouldn't be reset on opening a message box.
; Things like border or color settings, that should persist between text boxes.
InitDefaults:
	lda #$00
	sta !vwfmode
	sta !message
	sta !message+1

	lda #!defbg	; Set default values
	sta !boxbg
	lda #!defframe
	sta !boxframe

	lda.b #!bgcolor
	sta !boxcolor
	lda.b #!bgcolor>>8
	sta !boxcolor+1
	rts
	
	

InitVWFRAM:
	jsr InitRAM
	lda !vwfmode
	inc
	sta !vwfmode
	jmp Buffer_End

InitRAM:
	phx
	rep #$30
	ldx #$0000
	lda #$0000

.InitVarRAM
	sta !varram+!vwf_ram_clear_start_pos,x	; Initialize RAM
	inx #2
	cpx #!varrampos-!vwf_ram_clear_start_pos	; Number of bytes
	bcc .InitVarRAM
	sep #$30
	
	lda #$6B
	sta !messageasmopcode
.End
	plx
	rts

;;;;;;;;;;;;;;;;;;;;
;Level fade out Hijack;
;;;;;;;;;;;;;;;;;;;;

MosaicGamemodeHijack:
	jsr CheckIfVWFActive
	dec remap_ram($0DB1)
	BPL +
	jml remap_rom($009F3C)
+
	jml remap_rom($009F6E)

FadeGamemodeHijack:
	jsr CheckIfVWFActive
	dec remap_ram($0DB1)
	BPL +
	jml remap_rom($009F74)
+
	jml remap_rom($009F6E)

CheckIfVWFActive:
	lda remap_ram($0DAF)				;\ If the level is fading in, return
	beq .NotActive					;/
	lda !vwfmode					;\ If no VWF message is active, return.
	beq .NotActive					;/
.Entry2
	cmp #$09					;\ If not in VWF mode 09 (display text), don't increment the VWF mode here
	bne .NotTextCreation				;/
	inc						;\ Force the text box to close if one is already open.
	sta !vwfmode					;/
.NotTextCreation
	inc remap_ram($0DB1)				; Delay the fade out from happpening
	jsr Buffer					; Run the VWF buffer code.
.NotActive
	rts

;;;;;;;;;;;;;;;;;;;;
;Message Box Hijack;
;;;;;;;;;;;;;;;;;;;;


; This hijacks SMW's original message routine to work with VWF
; dialogues.

OriginalMessageBox:
	; Our VWF processing needs to run, even if the game frame itself doesn't.
	; So we just do it before we decide to skip the frame simulation.
	jsl VWFBufferRt

	lda remap_ram($1426)
	beq .NoOriginalMessageBoxRequested
	
if !hijackbox == true
	ldx #$00
	;lda !vwfmode	; Already displaying a message?
	;beq .CallDialogue
	;stz remap_ram($1426)
	;rtl

.CallDialogue
	lda remap_ram($1426)	; Yoshi Special Message?
	cmp #$03
	bne .NoYoshi
	lda #$01
	bra .SetMessage

.NoYoshi
	lda remap_ram($0109)	; Intro Level Message?
	beq .NoIntro
	lda #$00
	bra .SetMessage

.NoIntro
	lda remap_rom($03BB9B)	; Inside Yoshi's House? (LM hacked ROM only)
	cmp #$FF
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
.SetMessage
	stz remap_ram($1426)
	jsl DisplayAMessage
else	
	jml remap_rom($00A1DF)	; Run original message box and skip frame simulation
endif
	
.NoOriginalMessageBoxRequested
	; New code: If our own message box is open, also don't simulate frame.
	lda !freezesprites
	beq .RunGameFrame
	
	jml remap_rom($00A1E3)	; Skip frame simulation
	
.RunGameFrame
	jml remap_rom($00A1E4)	; Don't skip frame simulation





;;;;;;;;;;;;
;NMI Hijack;
;;;;;;;;;;;;

; This changes the NMI Routine to move layer 3 and disable IRQ during
; dialogues.

NMIHijack:
	stz $11
	lda !vwfmode
	tax
	lda.l .NMITable,x
	bne .SpecialNMI	; If NMITable = $00 load regular NMI
	sty $4209
	stz $420A
	stz $2111
	stz $2111
	stz $2112
	stz $2112
	ldx #$A1
	bra .End

.SpecialNMI
	stz $2111	; Set layer 3 X scroll to $0100
	lda #$01
	sta $2111
	lda #$1F	; Set layer 3 Y scroll to $011F
	sta $2112
	lda #$01
	sta $2112
	ldx #$81	; Disable IRQ
	
.End
if !use_sa1_mapping
	pha
	txa
	sta $01,s
	pla
else
	stx $4200
endif
	jml remap_rom($0082B0)

.NMITable
	db $00,$00,$00,$00,$01
	db $01,$01,$01,$01,$01
	db $01,$01,$01,$01,$00
	db $00





;;;;;;;;;;;;;
;Tile Buffer;
;;;;;;;;;;;;;

; This buffers code to save time in V-Blank.

VWFBufferRt:
	jsr Buffer
	rtl

Buffer:
if !use_sa1_mapping
	lda.b #.Main
	sta $3180
	lda.b #.Main/256
	sta $3181
	lda.b #.Main/65536
	sta $3182
	jsr $1E80
	rts

.Main
	jsr .Sub
	rtl

.Sub
	phb
	phk
	plb
else
	phb
	phk
	plb
	phx
	phy
	pha
	php
endif

	lda remap_ram($13D4)
	beq .NoPause
	jmp .End

.NoPause
	lda !vwfactiveflag				;\ Is another message trying to display?
	beq .NotForceClose				;/ If not, skip past this code
	lda !vwfmode					;\ Did the currently active message finish closing?
	beq .NotActive					;/ If so, make the new message appear
	cmp #$09					;\ Is the previous message in VWF mode 09 (display text)?
	bne .NotTextCreation				;/ If not, don't advance the VWF mode
	inc						;\ Increment the VWF mode to skip past the display text mode.
	sta !vwfmode					;/
.NotTextCreation
	bra .NotForceClose

.NotActive
	lda #$01
	sta !vwfmode
	lda #$00
	sta !vwfactiveflag
	lda #$6B
	sta !messageasmopcode
	bra .End

.NotForceClose
	lda !vwfmode	; Prepare jump to routine
	beq .End
	cmp #$01					;\ If in VWF mode 01 (initialize RAM), don't run the MessageASM code
	beq .NoMessageASM				;/
	phb						;\ Run whatever MessageASM routine was defined in the message header.
	lda !messageasmopcode+3				;|
	pha						;|
	plb						;|
	jsl !messageasmopcode				;|
	plb						;/
.NoMessageASM
	lda !vwfmode
	asl
	tax
	jmp (.Routinetable,x)

.End
if !use_sa1_mapping
else
	plp	; Return
	pla
	ply
	plx
endif
	plb
	rts

.Routinetable
	dw .End,InitVWFRAM,.End,VWFSetup,BufferGraphics,.End
	dw .End,BufferWindow,VWFInit,TextCreation,CollapseWindow
	dw .End,.End,.End,.End,.End





VWFSetup:
	lda #$00	;\ Ensure that the !enddialog flag gets properly cleared
	sta !enddialog	;/
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
	!8bit_mode_only lda #$0C
	!16bit_mode_only lda #$0B
	sta $03
	stz $04

	ldy #$00

	!8bit_mode_only lda [$00],y	; Font
	!8bit_mode_only sta !font
	!8bit_mode_only iny

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
	and #%00001111
	sta !boxcreate	
	
	lda [$00],y		; Message skip flag
	and #$02
	sta !skipmessageflag
	sta !initialskipmessageflag
	lda [$00],y		; Message ASM Flag
	and #$01
	beq .NoMessageASM
	lda #$5C
	bra .StoreMessageASMOpcode
.NoMessageASM
	lda #$6B
.StoreMessageASMOpcode
	sta !messageasmopcode
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

	lda $03
	clc
	adc #$05
	sta $03

.NoSounds
	lda !initialskipmessageflag
	beq .NoMessageSkipPointer
	rep #$21
	lda [$00],y		; Message skip location (address)
	sta !skipmessageloc
	sep #$20
	iny
	iny
	lda [$00],y		; Message skip location (bank)
	sta !skipmessageloc+2
	iny
	lda $03
	clc
	adc #$03
	sta $03
	
.NoMessageSkipPointer
	lda !messageasmopcode
	cmp #$5C
	bne .NoMessageASMPointer
	rep #$21
	lda [$00],y		; Message ASM location (address)
	sta !messageasmopcode+1
	sep #$20
	iny
	iny
	lda [$00],y		; Message ASM location (bank)
	sta !messageasmopcode+3
	iny
	lda $03
	clc
	adc #$03
	sta $03

.NoMessageASMPointer
	rep #$21
	lda $00
	adc $03
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
	jsr .Start
	jmp Buffer_End

.Start
	rep #$30
	ldx #$0000
	lda #$0000

.DrawEmpty
	sta !vwfbuffer_emptytile,x	; Draw empty tile
	inx #2
	cpx #$0010
	bne .DrawEmpty
	sep #$30

	jsr ClearScreen

	; Copy text box graphics over to RAM

	%bwramtransfer($0010,!boxbg,Patterns,!vwfbuffer_bgtile)
	%bwramtransfer($0090,!boxframe,Frames,!vwfbuffer_frame)

	rts


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
	sta !vwfbuffer_textboxtilemap,x
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
	jmp (.Routinetable,x)

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
	rep #$21
	lda.w #!vwfbuffer_textboxtilemap
	adc $03
	sta $03
	sep #$20
	lda.b #!vwfbuffer_textboxtilemap>>16
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
	lda.b #!vwfbuffer_textboxtilemap
	sta $03
	lda.b #!vwfbuffer_textboxtilemap>>8
	sta $04
	lda.b #!vwfbuffer_textboxtilemap>>16
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
	lda.b #!vwfbuffer_textboxtilemap
	sta $03
	lda.b #!vwfbuffer_textboxtilemap>>8
	sta $04
	; RPG Hacker: Technically unneeded, because the function above never overwrites $05,
	; but I still prefer to have this here so that I don't wonder why it's missing every
	; single time. This "optimization" never really saved much, anyways.
	lda.b #!vwfbuffer_textboxtilemap>>16
	sta $05
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
	lda #$40
	bra .Store

.NoDouble
	lda #$20

.Store
	sta select(!use_sa1_mapping,$2251,$211B)	; Multiply Y coordinate by $20/$40
	stz select(!use_sa1_mapping,$2252,$211B)
	stz select(!use_sa1_mapping,$2250,$211C)
	lda $01
	sta select(!use_sa1_mapping,$2253,$211C)
	if !use_sa1_mapping
		stz $2254
	endif
	lda #$00
	xba
	lda $00
	rep #$21
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
	rep #$21
	lda $08
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
	lda #$01
	sta $02
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
	rep #$21
	lda $03
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
	rep #$21
	lda $08
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
	jmp (.Routinetable,x)

.Routinetable
	dw .NoBox,.SoEBox,.SoMBox,.MMZBox,.InstBox

.End	
	lda !counter
	cmp #$02	
	bne .NotDone

	; RPG Hacker: Check if we still have a message box stored to show after the current one.
	lda !swapmessagesettings
	and.b #%10000010
	cmp.b #%10000010
	bne .NoNextMessage
	
	jsr PrepareNextMessage
	
.NoNextMessage
.NotDone
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

	lda !currentheight
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
	lda.b #!vwfbuffer_textboxtilemap>>16
	sta $05
	rep #$21
	lda.w #!vwfbuffer_textboxtilemap
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
	lda.b #!vwfbuffer_textboxtilemap>>16
	sta $05
	rep #$21
	lda.w #!vwfbuffer_textboxtilemap
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
	
	; RPG Hacker: Because an "Absolute Long Indexed, Y" mode doesn't exist...
	lda.b #!palettebackupram
	sta $00
	lda.b #!palettebackupram>>8
	sta $01
	lda.b #!palettebackupram>>16
	sta $02

.BoxColorLoop
	lda !boxcolor+2,x
	sta [$00],y
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
	sta !vwfbufferindex

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
	lda !currenty				;\ This fixes an oddity where the next line's width is calculated when at the end of a text box.
	inc #2					;| This would cause a text macro to break if it spanned more than one text box.
	cmp !vwfmaxheight			;|
	bcs .AtEndOfTextBox			;/
	jsr WordWidth

.AtEndOfTextBox
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
	!16bit_mode_only rep #$20
	lda !vwfchar
	!8bit_mode_only cmp #$FE
	!16bit_mode_only cmp #$FFFE
	!16bit_mode_only sep #$20
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
	!16bit_mode_only rep #$20
	!16bit_mode_only lda #$0000
	!8bit_mode_only lda #$00
	sta !vwfchar
	!16bit_mode_only sep #$20

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
	dec
	sta !wait
	bra .NoClearBox

.ButtonWait
	jsr EndBeep
	!8bit_mode_only lda #$FA
	!16bit_mode_only rep #$20
	!16bit_mode_only lda #$FFFA
	sta !vwfchar
	!16bit_mode_only sep #$20

.NoClearBox
	rep #$20
	lda !tile	; Increment tile counter
	inc #2
	sta !tile
	and #$03FF
	asl #4
	clc
	adc.w #!vwfbuffer_emptytile	; Add starting address
	sta $09
	sep #$20
	lda.b #!vwfbuffer_emptytile>>16
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
	stz $2254
	nop
endif
	rep #$21
	lda select(!use_sa1_mapping,$2306,$2134)
	adc.w #Pointers
	sta $00
	lda.w #Pointers>>16
	sta $02
	ldy #$02
	lda [$00]
	sta !vwftextsource
	sep #$20
	lda [$00],y
	sta !vwftextsource+2
	rts





TextCreation:
	lda !skipmessageflag
	beq .DontSkip
	
	; RPG Hacker: If skipping is enabled, check if we're about to cross the skip location.
	; If so, disable skipping for the current message. This is so that if someone presses
	; start after reaching the skip location, it won't loop around and display the skip
	; text again.
	lda !vwftextsource
	cmp !skipmessageloc
	bne .SkipLocationNotReached
	lda !vwftextsource+1
	cmp !skipmessageloc+1
	bne .SkipLocationNotReached
	lda !vwftextsource+2
	cmp !skipmessageloc+2
	bne .SkipLocationNotReached
	
	lda #$00
	sta !skipmessageflag
	bra .DontSkip
	
.SkipLocationNotReached
	lda !vwfchar
	cmp #$ED
	beq .DontSkip
	cmp #$FF
	beq .DontSkip
	lda $15				; Did the player press start?
	and #$10			;
	cmp #$10			; If so, allow the message to be closed early
	bne .DontSkip			;
	rep #$20
	lda !skipmessageloc
	sta !vwftextsource
	!16bit_mode_only lda #$FFEB
	!16bit_mode_only sta !vwfchar
	sep #$20
	lda !skipmessageloc+2
	sta !vwftextsource+2
	!8bit_mode_only lda #$EB
	!8bit_mode_only sta !vwfchar
	lda #$00
	sta !wait
	sta !cursormove
	sta !cursorupload
	sta !cursorend
	sta !choices
	sta !currentchoice
	sta !skipmessageflag
	inc
	sta !clearbox
	jmp .NoButton

.DontSkip
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
	%mvntransfer($0060, !vwfbuffer_cursor, !vwftileram, !cpu_sa1)	

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
	lda !vwfbuffer_choicebackup,x
	and #$03FF
	asl #4
	clc
	adc.w #!vwfbuffer_emptytile
	sta $03
	sep #$20
	lda.b #!vwfbuffer_emptytile>>16
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
	!16bit_mode_only rep #$20
	lda !vwfchar
	!8bit_mode_only cmp #$FA
	!16bit_mode_only cmp #$FFFA
	!16bit_mode_only sep #$20
	bne .NoButton
	jmp .End

.NoButton
	lda !clearbox
	beq .NoClearBox
	jsr ClearBox
	jmp .End

.NoClearBox	
	; RPG Hacker: This was previously called from the SNES CPU, which isn't supported, because
	; GetTilemapPos uses SA-1 multiplication in SA-1 builds. Therefore, I'm preprocessing the address
	; and storing it in a variable for later use.
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
	rep #$21
	lda #$5C80
	adc $03
	sta !arrowvram
	sep #$20

	lda #$01
	sta !isnotatstartoftext
	jsr ReadPointer
	!16bit_mode_only rep #$20
	lda [$00]
	sta !vwfchar
	!16bit_mode_only inc $00
	!8bit_mode_only cmp.b #!vwf_lowest_reserved_hex
	!16bit_mode_only cmp.w #!vwf_lowest_reserved_hex
	bcs .Jump
	!16bit_mode_only sep #$20
	jmp .WriteLetter

.Jump
	sec
	!8bit_mode_only sbc.b #!vwf_lowest_reserved_hex
	!16bit_mode_only sbc.w #!vwf_lowest_reserved_hex
	!16bit_mode_only sep #$20
	asl
	tax
	!16bit_mode_only jsr IncPointer
	jmp (.Routinetable,x)

.Routinetable
	dw .E7_EndTextMacro
	dw .E8_TextMacro
	dw .E9_TextMacroGroup
	dw .FF_End	; Reserved
	dw .EB_LockTextBox
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

.E7_EndTextMacro
	jsr HandleVWFStackByte1_Pull
	sta !vwftextsource+2
	jsr HandleVWFStackByte1_Pull
	sta !vwftextsource+1
	jsr HandleVWFStackByte1_Pull
	sta !vwftextsource
	jmp TextCreation

.E8_TextMacro
	rep #$20
	lda $00
	clc
	adc.w #$0003
	sep #$20
	
	jsr HandleVWFStackByte1_Push
	xba
	jsr HandleVWFStackByte1_Push
	lda $02
	jsr HandleVWFStackByte1_Push
	
	ldy #$01
	rep #$30
	lda.b [$00],y
	
.TextMacroShared
	sta $0C
	asl
	clc
	adc $0C
	cmp #!num_reserved_text_macros*3
	bcs ..NotBufferedText
	tax
	lda !vwftbufferedtextpointers,x
	sta !vwftextsource
	sep #$30
	lda !vwftbufferedtextpointers+2,x
	bra +

..NotBufferedText
	sec
	sbc #!num_reserved_text_macros*3
	tax
	lda TextMacroPointers,x
	sta !vwftextsource
	sep #$30
	lda TextMacroPointers+2,x
+
	sta !vwftextsource+2	
	jmp TextCreation
	
.E9_TextMacroGroup	
	rep #$20
	lda $00
	clc
	adc.w #$0005
	sep #$20
	
	jsr HandleVWFStackByte1_Push
	xba
	jsr HandleVWFStackByte1_Push
	lda $02
	jsr HandleVWFStackByte1_Push
	
	; Load RAM address	
	ldy #$01
	lda.b [$00],y
	sta $0C
	iny
	lda.b [$00],y
	sta $0D
	iny
	lda.b [$00],y
	sta $0E
	
	lda #$00
	pha
	lda [$0C]
	pha
	
	; Load group ID
	iny
	lda #$00
	xba
	lda.b [$00],y
		
	rep #$20
	sta $0C
	asl
	clc
	adc $0C
	tax
	sep #$20
	
	lda TextMacroGroupPointers,x
	sta $0C
	lda TextMacroGroupPointers+1,x
	sta $0D
	lda TextMacroGroupPointers+2,x
	sta $0E
	
	rep #$30
	pla
	asl
	tay
	lda [$0C],y
	clc
	adc.w #!num_reserved_text_macros
	
	jmp .TextMacroShared

.EB_LockTextBox
	lda #$01
	sta !forcesfx
	; RPG Hacker: In 16-bit mode, the $FF part of the command is automatically skipped.
	; Need to decrement the pointer here, otherwise the text box will explode.
	!16bit_mode_only jsr DecPointer
	jmp .End

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
	lda #$D0
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
	sta !palettebackupram,x
	iny
	lda [$00],y
	sta !palettebackupram+1,x
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
	stz $03
	lda [$00],y
	lsr
	rol $03
	asl #4
	sta $04
	iny
	lda [$00],y
	and #$0E
	ora $03
	ora $04
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
	!16bit_mode_only iny
	!16bit_mode_only lda [$00],y
	!16bit_mode_only sta !cursor+1
	!16bit_mode_only jsr IncPointer
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

	!16bit_mode_only lda !cursor+1
	!16bit_mode_only sta !font

	jsr GetFont

	rep #$20
	lda #$0001
	sta $0C
	lda.w #!cursor
	sta $00
	lda.w #!vwfbuffer_cursor
	sta $09
	sep #$20
	lda.b #!cursor>>16
	sta $02
	lda.b #!vwfbuffer_cursor>>16
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
	lda.w #!vwfbuffer_bgtile
	sta $00
	lda.w #!vwfbuffer_cursor
	sta $03
	sep #$20
	lda.b #!vwfbuffer_bgtile>>16
	sta $02
	lda.b #!vwfbuffer_cursor>>16
	sta $05

	jsl AddPattern

.F0NoBG
	rep #$20
	lda.w #!vwfbuffer_cursor
	sta $09
	sep #$20
	lda.b #!vwfbuffer_cursor>>16
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
	rep #$21
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
	dec
	sta !wait
	bra .F0NoAutowait

.F0ButtonWait
	jsr EndBeep
	!16bit_mode_only rep #$20
	!16bit_mode_only lda #$FFFA
	!8bit_mode_only lda #$FA
	sta !vwfchar
	!16bit_mode_only sep #$20

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
	sta !palettebackupram,x
	lda !boxcolor+1
	sta !palettebackupram+1,x
	lda #$01
	sta !paletteupload
	plx
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.F4_Character
	jsr IncPointer
	jsr ReadPointer
	!16bit_mode_only rep #$20
	lda [$00]
	sta !vwfchar
	!16bit_mode_only sep #$20
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
	!16bit_mode_only rep #$20
	lda [$0C]
	sta !vwfroutine
	!16bit_mode_only sep #$20
	lda #$FB
	sta !vwfroutine+1+!bitmode
	!16bit_mode_only lda #$FF
	!16bit_mode_only sta !vwfroutine+3
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
	!16bit_mode_only lda #$00
	!16bit_mode_only sta !vwfroutine+1
	lda [$0C]
	and #$0F
	sta !vwfroutine+1+!bitmode
	!16bit_mode_only lda #$00
	!16bit_mode_only sta !vwfroutine+3
	lda #$FB
	sta !vwfroutine+2+!bitmode+!bitmode
	!16bit_mode_only lda #$FF
	!16bit_mode_only sta !vwfroutine+5
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
	!8bit_mode_only sta !vwfroutine+5
	!16bit_mode_only sta !vwfroutine+10
	!16bit_mode_only lda #$FF
	!16bit_mode_only sta !vwfroutine+11
	rep #$21
	lda $00
	adc #$0005
	!8bit_mode_only sta !vwfroutine+6
	!16bit_mode_only sta !vwfroutine+12
	sep #$20
	lda $02
	!8bit_mode_only sta !vwfroutine+8
	!16bit_mode_only sta !vwfroutine+14

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
	!16bit_mode_only inc $00
	!16bit_mode_only inc $00

.SixteenBit
	pla
	and #$0F
	beq .NoZeros
	lda $05
	!16bit_mode_only asl
	clc
	adc $00
	sta $00

.NoZeros
	rep #$21
	lda.w #!vwfroutine
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
	lda #$6B
	sta !messageasmopcode
	ldy #$01
	lda [$00],y
	sta !swapmessageid
	iny
	lda [$00],y
	sta !swapmessageid+1
	lda #%10000000
	sta !swapmessagesettings
	jsr IncPointer
	jsr IncPointer
	
	; RPG Hacker: Backwards compatibility hack. Uses a magic hex to determine
	; if this is the new command format. Can be removed once version 1.3 has
	; been released for a considerable amount of time.
	lda !swapmessageid
	and !swapmessageid+1
	cmp #$FF
	bne .Legacy
	
	iny
	lda [$00],y
	sta !swapmessageid
	iny
	lda [$00],y
	sta !swapmessageid+1
	iny
	lda [$00],y		; Settings
	ora #%10000000
	sta !swapmessagesettings
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	
.Legacy
	; RPG Hacker: If we don't have the "show close animation" flag set, prepare the next message right now.
	lda !swapmessagesettings
	and.b #%10000010
	cmp.b #%10000000
	bne .DontStartNow
	
	jsr PrepareNextMessage
	
.DontStartNow
	lda #$01
	sta !enddialog
	jmp .End
	

.FD_LineBreak
	!16bit_mode_only rep #$20
	!16bit_mode_only lda #$FFFD
	!8bit_mode_only lda #$FD
	sta !vwfchar
	!16bit_mode_only sep #$20
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
	!16bit_mode_only lda !vwfchar+1
	!16bit_mode_only pha

	jsr WordWidth

	!16bit_mode_only pla
	!16bit_mode_only sta !vwfchar+1
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
	lda #$01
	sta !enddialog
	jsr IncPointer
	jmp .End

.WriteLetter
	!16bit_mode_only lda !vwfchar+1
	!16bit_mode_only sta !font
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
	!16bit_mode_only jsr IncPointer
	lda [$06],y
	sta !vwfwidth
	jsr WriteTilemap

	jsr GetDestination

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
	rep #$20
	lda.w #!vwfbuffer_bgtile
	sta $00
	lda !vwfbufferdest
	sta $03
	sep #$20
	lda.b #!vwfbuffer_bgtile>>16
	sta $02
	lda !vwfbufferdest+2
	sta $05

	lda #$06
	sta $06

	jsl AddPattern

.End
	jmp Buffer_End

HandleVWFStackByte1:
.Pull
	lda !vwfstackindex1
	dec
	sta !vwfstackindex1
	tax
	lda !vwfstack1,x
	rts

.Push
	pha
	lda !vwfstackindex1
	tax
	inc
	sta !vwfstackindex1
	pla
	sta !vwfstack1,x
	rts

HandleVWFStackByte2:
.Pull
	lda !vwfstackindex2
	dec
	sta !vwfstackindex2
	tax
	lda !vwfstack2,x
	rts

.Push
	pha
	lda !vwfstackindex2
	tax
	inc
	sta !vwfstackindex2
	pla
	sta !vwfstack2,x
	rts

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
	rep #$21
	lda select(!use_sa1_mapping,$2306,$2134)
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
	adc.w #!vwfbuffer_emptytile	; Add starting address
	sta !vwfgfxdest
	lda !vwfbufferindex
	and #$003F	; Multiply tile number with 16
	asl #4
	clc
	adc.w #!vwfbuffer_letters	; Add starting address
	sta !vwfbufferdest
	sta $09
	sep #$20
	lda.b #!vwfbuffer_letters>>16
	sta !vwfgfxdest+2
	sta !vwfbufferdest+2
	sta $0B
	rts


IncPointer:
	rep #$20
	lda !vwftextsource
	inc
	sta !vwftextsource
	sep #$20
	rts


DecPointer:
	rep #$20
	lda !vwftextsource
	dec
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
	bne .Return

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
	lda.b #!vwfbuffer_textboxtilemap>>16
	sta $05
	sta !vwftilemapdest+2
	rep #$21
	lda.w #!vwfbuffer_textboxtilemap
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
	!16bit_mode_only lda #$00
	!16bit_mode_only sta !vwfroutine+1
	!16bit_mode_only sta !vwfroutine+3
	!16bit_mode_only sta !vwfroutine+5
	!16bit_mode_only sta !vwfroutine+7
	!16bit_mode_only sta !vwfroutine+9
	rts

Convert8Bit:
	stz $00
	stz $01
	stz $02
	stz $03
	lda [$07]
	ldy $04
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
	; RPG Hacker: In order to make this function work reliably with the text macro system,
	; we need to make a copy of the current text macro stack whenever we call it.
	; I tested using a simple loop for this, because text macro stacks of more than one
	; element should be rare, and simple loops sound like they should be faster for few iterations.
	; However, in my testing, the MVN solution turned out to be faster even for simple stacks.
	lda !vwfstackindex1
	sta !vwfstackindex2
	beq .NoStackCopy
	
	xba
	lda.b #$00
	xba
	
	rep #$30
	
	dec		; -1 because of how MVN works
	
	ldx.w #!vwfstack1
	ldy.w #!vwfstack2
	
	phb
	mvn bank(!vwfstack2), bank(!vwfstack1)
	plb
	
	sep #$30
	
.NoStackCopy

.GetFont
	!8bit_mode_only jsr GetFont

.Begin
	jsr ReadPointer
	!16bit_mode_only rep #$20
	lda [$00]
	sta !vwfchar
	!8bit_mode_only cmp.b #!vwf_lowest_reserved_hex
	!16bit_mode_only cmp.w #!vwf_lowest_reserved_hex
	bcs .Jump
	!16bit_mode_only sep #$20
	!16bit_mode_only jsr IncPointer
	jsr IncPointer
	jmp .Add

.Jump
	sec
	!8bit_mode_only sbc.b #!vwf_lowest_reserved_hex
	!16bit_mode_only sbc.w #!vwf_lowest_reserved_hex
	!16bit_mode_only sep #$20
	asl
	tax
	!16bit_mode_only jsr IncPointer
	jsr IncPointer
	jsr ReadPointer
	jmp (.Routinetable,x)

.Routinetable
	dw .E7_EndTextMacro
	dw .E8_TextMacro
	dw .E9_TextMacroGroup
	dw .FF_End	; Reserved
	dw .EB_LockTextBox
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

.E7_EndTextMacro
	jsr HandleVWFStackByte2_Pull
	sta !vwftextsource+2
	jsr HandleVWFStackByte2_Pull
	sta !vwftextsource+1
	jsr HandleVWFStackByte2_Pull
	sta !vwftextsource
	jmp .Begin

.E8_TextMacro
	rep #$20
	lda $00
	clc
	adc.w #$0002
	sep #$20
	
	jsr HandleVWFStackByte2_Push
	xba
	jsr HandleVWFStackByte2_Push
	lda $02
	jsr HandleVWFStackByte2_Push
	
	rep #$30
	lda.b [$00]
	
.TextMacroShared
	sta $0C
	asl
	clc
	adc $0C
	cmp #!num_reserved_text_macros*3
	bcs ..NotBufferedText
	tax
	lda !vwftbufferedtextpointers,x
	sta !vwftextsource
	sep #$30
	lda !vwftbufferedtextpointers+2,x
	bra +

..NotBufferedText
	sec
	sbc #!num_reserved_text_macros*3
	tax
	lda TextMacroPointers,x
	sta !vwftextsource
	sep #$30
	lda TextMacroPointers+2,x
+
	sta !vwftextsource+2
	jmp .Begin
	
.E9_TextMacroGroup
	rep #$20
	lda $00
	clc
	adc.w #$0004
	sep #$20
	
	jsr HandleVWFStackByte2_Push
	xba
	jsr HandleVWFStackByte2_Push
	lda $02
	jsr HandleVWFStackByte2_Push
	
	; Load RAM address
	lda.b [$00]
	sta $0C	
	ldy #$01
	lda.b [$00],y
	sta $0D
	iny
	lda.b [$00],y
	sta $0E
	
	lda #$00
	pha
	lda [$0C]
	pha
	
	; Load group ID
	iny
	lda #$00
	xba
	lda.b [$00],y
		
	rep #$20
	sta $0C
	asl
	clc
	adc $0C
	tax
	sep #$20
	
	lda TextMacroGroupPointers,x
	sta $0C
	lda TextMacroGroupPointers+1,x
	sta $0D
	lda TextMacroGroupPointers+2,x
	sta $0E
	
	rep #$30
	pla
	asl
	tay
	lda [$0C],y
	clc
	adc.w #!num_reserved_text_macros

	jmp .TextMacroShared

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
	jmp .GetFont

.F3_ChangePalette
	jsr IncPointer
	jmp .Begin

.F4_Character
	!16bit_mode_only rep #$20
	lda [$00]
	sta !vwfchar
	!16bit_mode_only sep #$20
	!16bit_mode_only jsr IncPointer
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
	!16bit_mode_only rep #$20
	lda [$0C]
	sta !vwfchar
	!16bit_mode_only sep #$20
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
	!16bit_mode_only lda #$00
	!16bit_mode_only sta !vwfroutine+1
	lda [$0C]
	and #$0F
	sta !vwfroutine+1+!bitmode
	!16bit_mode_only lda #$00
	!16bit_mode_only sta !vwfroutine+3
	lda #$FB
	sta !vwfroutine+2+!bitmode+!bitmode
	!16bit_mode_only lda #$FF
	!16bit_mode_only sta !vwfroutine+5
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
	!8bit_mode_only sta !vwfroutine+5
	!16bit_mode_only sta !vwfroutine+10
	!16bit_mode_only lda #$FF
	!16bit_mode_only sta !vwfroutine+11
	rep #$21
	lda $00
	adc #$0004
	!8bit_mode_only sta !vwfroutine+6
	!16bit_mode_only sta !vwfroutine+12
	sep #$20
	lda $02
	!8bit_mode_only sta !vwfroutine+8
	!16bit_mode_only sta !vwfroutine+14

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
	!16bit_mode_only inc $00
	!16bit_mode_only inc $00

.SixteenBit
	pla
	and #$0F
	beq .NoZeros
	lda $05
	!16bit_mode_only asl
	clc
	adc $00
	sta $00

.NoZeros
	rep #$21
	lda.w #!vwfroutine
	adc $00
	sta !vwftextsource
	sep #$20
	lda.b #!vwfroutine>>16
	sta !vwftextsource+2

	jmp .GetFont

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

.EB_LockTextBox
.ED_ClearBox
.F0_Choices
.FC_LoadMessage
.FD_LineBreak
.FE_Space
.FF_End
	jmp .Return

.Add
	!16bit_mode_only lda !vwfchar+1
	!16bit_mode_only sta !font
	!16bit_mode_only jsr GetFont
	lda !vwfchar
	tay
	lda [$06],y
	clc
	adc !vwfwidth
	bcs .End
	cmp !vwfmaxwidth
	bcc .Continue
	bne .End

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
	%dmatransfer(!dma_channel_nmi,!dma_write_twice,$2122,!palettebackupram,#$0040)
.skip

	lda !vwfmode
	asl
	tax
	lda #$F0	; Hide Status Bar item
	sta remap_ram($02E1)

	jmp (.Routinetable,x)

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
	dw .End,.End,PrepareBackup,Backup,PrepareScreen,SetupColor
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
	lda #$00
	sta !freezesprites
	
	lda !teleport	; Check if teleport set
	beq .NoTeleport

	lda #$00
	sta !teleport

if read1($05D7B9) == $22					;\ Account for LM 3.00's level dimension hijacks.
	jsl.l read3($05D7BA)					;|
else								;/
	lda $5B
	lsr
	bcc .Horizontal

	ldx $97
	bra .SetupTeleport

.Horizontal
	ldx $95

.SetupTeleport
endif
	lda !telepdest
	sta remap_ram($19B8),x
	lda !telepprop
	ora #$04
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

	lda !vwfmode
	cmp #$02
	bne .dontpreserveL3
	lda $3E
	sta !l3priorityflag
	lda remap_ram($0D9E)
	sta !l3subscreenflag
	lda $40
	sta !l3transparencyflag
	lda remap_ram($0D9D)
	sta !l3mainscreenflag

.dontpreserveL3

	lda #$04	; Hide layer 3
	trb remap_ram($0D9D)
	trb remap_ram($0D9E)
	lda remap_ram($0D9D)
	sta $212C
	lda remap_ram($0D9E)
	sta $212D

.End
	lda !vwfmode
	inc
	sta !vwfmode
	jmp VBlank_End





Backup:
	rep #$21
	lda #$4000	; Adjust VRAM address
	adc !vrampointer
	sta $02

	lda !vrampointer
	asl a
	clc
	adc.w #!backupram	; Adjust destination address
	sta $00

	lda !vrampointer	; Adjust pointer
	clc
	adc #$0400
	sta !vrampointer
	sep #$20

	lda !vwfmode
	cmp #$03
	beq .Backup
	jmp .Restore

.Backup
	%vramprepare(#$80,$02,"lda $2139","")
	%dmatransfer(!dma_channel_nmi,!dma_read_once,$2139,dma_source_indirect_word($00, bank(!backupram)),#$0800)
	jmp .Continue

.Restore
	%vramprepare(#$80,$02,"","")
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,dma_source_indirect_word($00, bank(!backupram)),#$0800)

.Continue
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
	lda !vwfmode
	cmp #$06
	bne .layer3Subscreen
	lda #$08
	tsb $3E
	lda remap_ram($0D9D)
	ora #$04
	tsb $212C
	trb $40

.End
	lda !vwfmode
	inc
	sta !vwfmode
	jmp VBlank_End

.layer3Subscreen
	lda !l3subscreenflag
	and #$04
	ora remap_ram($0D9E)
	sta remap_ram($0D9E)
	sta $212D
	lda !l3mainscreenflag
	and #$04
	ora remap_ram($0D9D)
	sta remap_ram($0D9D)
	sta $212C
	lda !l3priorityflag
	sta $3E
	lda !l3transparencyflag
	and #$04
	ora $40
	sta $40
	BRA .End





SetupColor:
	stz $2121	; Backup or restore layer 3 colors
	lda !vwfmode
	cmp #$05
	beq .Backup
.Restore
	%mvntransfer($0040, !palbackup, !palettebackupram, !cpu_snes)
	%dmatransfer(!dma_channel_nmi,!dma_write_twice,$2122,!palettebackupram,#$0040)
	jmp .End

.Backup
	%dmatransfer(!dma_channel_nmi,!dma_read_twice,$213B,!palettebackupram,#$0040)
	%mvntransfer($0040, !palettebackupram, !palbackup, !cpu_snes)
	
	jsr InitBoxColors

.End
	lda !vwfmode
	inc
	sta !vwfmode
	jmp VBlank_End
	
	
InitBoxColors:
	lda !boxpalette	; Set BG and letter color
	asl #2
	inc
	asl
	phy
	tay
	ldx #$00	
	
	; RPG Hacker: Because an "Absolute Long Indexed, Y" mode doesn't exist...
	lda.b #!palettebackupram
	sta $00
	lda.b #!palettebackupram>>8
	sta $01
	lda.b #!palettebackupram>>16
	sta $02

.BoxColorLoop
	lda !boxcolor,x
	sta [$00],y
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
	lda.b #bank(Palettes+2)
	sta $02
	lda #$00
	xba
	lda !boxframe
	rep #$21
	asl #3
	adc.w #Palettes+2
	sta $00
	sep #$20
	ldy #$00

.FrameColorLoop
	lda [$00],y
	sta !palettebackupram,x
	inx
	iny
	cpy #$06
	bne .FrameColorLoop
	plx

	lda #$01
	sta !paletteupload
	
	rts





PrepareScreen:
	%vramprepare(#$80,#$4000,"","")	; Upload graphics and tilemap to VRAM
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,!vwfbuffer_emptytile,#$00B0)

	%vramprepare(#$80,#$5C80,"","")
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,!vwfbuffer_textboxtilemap,#$0700)

.End
	lda !vwfmode
	inc
	sta !vwfmode
	jmp VBlank_End





CreateWindow:
	%vramprepare(#$80,#$5C80,"","")
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,!vwfbuffer_textboxtilemap,#$0700)

	lda !counter
	cmp #$02
	bne .Return

.End
	lda #$00
	sta !counter
	lda !vwfmode
	inc
	sta !vwfmode
	
	; RPG Hacker: Check if we still have "next message" stored from the "load message" command.
	; If so, we gotta jump back to an earlier step.
	lda !swapmessagesettings
	and.b #%10000010
	cmp.b #%10000010
	bne .NoNextMessage
	
	jsr StartNextMessage
	
.NoNextMessage
.Return
	jmp VBlank_End


TextUpload:
	lda !cursorfix
	beq .SkipCursor
	dec
	sta !cursorfix

	%vramprepare(#$80,!cursorvram,"","")
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,dma_source_indirect_word(!cursorsrc, bank(!vwfbuffer_textboxtilemap)),#$0046)

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
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,!vwftileram,#$0060)

	rep #$20
	lda !vwftilemapdest
	sec
	sbc.w #!vwfbuffer_textboxtilemap
	lsr
	clc
	adc #$5C80
	sta $00
	sep #$20

	%vramprepare(#$80,$00,"","")
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,dma_source_indirect(!vwftilemapdest),#$0046)

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
	!16bit_mode_only sta !vwfchar+1
	lda #$01
	sta !clearbox
	jmp .Return


.NoCursor
	lda !enddialog	; Dialogue done?
	beq .NoEnd
	lda #$00
	sta !enddialog
	!16bit_mode_only rep #$20
	!16bit_mode_only lda #$0000
	!8bit_mode_only lda #$00
	sta !vwfchar
	!16bit_mode_only sep #$20
	
	; RPG Hacker: Display next message now if we're coming from a "load message"
	; command and don't have the "show close animation" flag set.
	lda !swapmessagesettings
	and.b #%10000010
	cmp.b #%10000000
	bne .NoNextMessage
	
	jsr StartNextMessage
	jmp VBlank_End
	
.NoNextMessage
	jmp .End

.NoEnd
	!16bit_mode_only rep #$20
	lda !vwfchar
	!8bit_mode_only cmp #$FA	; Waiting for A button?
	!16bit_mode_only cmp #$FFFA
	!16bit_mode_only sep #$20
	!16bit_mode_only sep #$20
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
	!16bit_mode_only sta !vwfchar+1
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
	%vramprepare(#$00,!arrowvram,"","")

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
	sta !isnotatstartoftext
	%vramprepare(#$80,#$5C80,"","")
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,!vwfbuffer_textboxtilemap,#$0700)
	jmp .Return

.Begin
	rep #$20	; Upload GFX
	lda !vwfgfxdest
	sec
	sbc.w #!vwfbuffer_emptytile
	lsr
	clc
	adc #$4000
	sta $00
	sep #$20
	%vramprepare(#$80,$00,"","")
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,dma_source_indirect(!vwfbufferdest),#$0060)

	rep #$20	; Upload Tilemap
	lda !vwftilemapdest
	sec
	sbc.w #!vwfbuffer_textboxtilemap
	lsr
	clc
	adc #$5C80
	sta $00
	sep #$20
	%vramprepare(#$80,$00,"","")
	%dmatransfer(!dma_channel_nmi,!dma_write_once,$2118,dma_source_indirect(!vwftilemapdest),#$0046)

	jsr Beep

	lda !frames
	sta !wait

	lda !speedup
	beq .Return
	!16bit_mode_only rep #$20
	lda !vwfchar
	!8bit_mode_only cmp #$F9
	!16bit_mode_only cmp #$FFF9
	!16bit_mode_only sep #$20
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
	
	
; RPG Hacker: This is split into two routines, because some code needs to run in the buffering phase,
; and other code needs to run in the graphics upload phase. It might actually be save to do all of it
; in the same one, but I don't even want to risk it, especially not with SA-1 compatibility being a factor.
PrepareNextMessage:
	lda !swapmessageid
	sta !message
	lda !swapmessageid+1
	sta !message+1
	
	lda !swapmessagesettings
	bit.b #%00000001
	beq .NoOpenAnim
	
	jsr BufferGraphics_Start
	jsr GetMessage
	jsr LoadHeader
	
	bra .Return
	
.NoOpenAnim	
	jsr BufferGraphics_Start
	
.Return	
	rts
	
	
StartNextMessage:
	lda !swapmessagesettings
	bit.b #%00000001
	beq .NoOpenAnim
	
	lda #$06
	sta !vwfmode
	
	jsr InitBoxColors
	
	bra .Return
	
.NoOpenAnim	
	lda #$08
	sta !vwfmode
	
.Return
	lda #$00
	sta !swapmessagesettings
	sta !swapmessageid
	sta !swapmessageid+1
	
	rts




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

	lda.b #!vwfbuffer_textboxtilemap>>16
	sta $05
	rep #$21
	lda.w #!vwfbuffer_textboxtilemap
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
	sta !vwfbuffer_choicebackup
	lda [$03],y
	sta !vwfbuffer_choicebackup+$02
	iny #2
	lda [$03],y
	sta !vwfbuffer_choicebackup+$04
	ldy #$40
	lda [$03],y
	sta !vwfbuffer_choicebackup+$06
	iny #2
	lda [$03],y
	sta !vwfbuffer_choicebackup+$08
	iny #2
	lda [$03],y
	sta !vwfbuffer_choicebackup+$0A
	sep #$20

	rts

.Restore
	rep #$20
	ldy #$02
	lda !vwfbuffer_choicebackup
	sta [$03]
	lda !vwfbuffer_choicebackup+$02
	sta [$03],y
	iny #2
	lda !vwfbuffer_choicebackup+$04
	sta [$03],y
	ldy #$40
	lda !vwfbuffer_choicebackup+$06
	sta [$03],y
	iny #2
	lda !vwfbuffer_choicebackup+$08
	sta [$03],y
	iny #2
	lda !vwfbuffer_choicebackup+$0A
	sta [$03],y
	sep #$20

	;Vitor Vilela's note:
	;Here is one big issue with the cursor.
	;This code actually is outside V-Blank and now I have to upload the following:
	;VRAM: $00-$01
	;Source: $03-$05
	;Bytes: #$0046
	;I don't know if the tile gets preserved or not for the current frame.
	;But for now I will have to preverse at least, $00-$01 and $03-$04, which means more 4 bytes
	;of free ram, plus the upload flag, so 5 more bytes of free ram.
	rep #$20
	lda $03
	sec
	sbc.w #!vwfbuffer_textboxtilemap
	lsr
	clc
	adc #$5C80
	sta !cursorvram
	lda $03
	sta !cursorsrc
	sep #$20
	lda #$01
	sta !cursorfix

	rts





;;;;;;;;;;;;;;
;VWF Routines;
;;;;;;;;;;;;;;

; The actual VWF Creation routine.

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
	rep #$21
	lda $03
	adc #$0020
	sta $0C

.Read
	lda [$00]	; Read character
	inc $00
	!16bit_mode_only inc $00
	!8bit_mode_only sep #$20
	sta !vwfchar
	!16bit_mode_only sep #$20
	!16bit_mode_only lda !vwfchar+1
	!16bit_mode_only sta !font
	!16bit_mode_only jsr GetFont
	!16bit_mode_only lda $05
	!16bit_mode_only sta $0E
	!16bit_mode_only rep #$21
	!16bit_mode_only lda $03
	!16bit_mode_only adc #$0020
	!16bit_mode_only sta $0C
	!16bit_mode_only sep #$20
	!16bit_mode_only lda !vwfchar
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
	txy

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
	pha
	clc
	adc !tile
	sta !tile
	pla
	clc
	sep #$20
	adc !vwfbufferindex
	sta !vwfbufferindex
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
	rep #$21
	lda select(!use_sa1_mapping,$2306,$2134)
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

	rep #$21
	lda $03
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

Palettes:
incsrc vwfframes.asm





;;;;;;;;;;;;;;;;
;External Files;
;;;;;;;;;;;;;;;;

Frames:
incbin vwfframes.bin

Patterns:
incbin vwfpatterns.bin

Code:
incsrc vwfcode.asm


%vwf_first_bank()

MainDataStart:
incsrc vwfdata.asm


; RPG Hacker: Would prefer to call this in vwfmacros.asm, but that
; would throw an error on !default_font, because it wouldn't know
; how many fonts have actually been added yet.
%vwf_verfiy_default_arguments()

%vwf_next_bank()

%vwf_generate_pointers()


print ""
print "Patch inserted at $",hex(FreecodeStart),"."

!temp_i #= 0
while !temp_i < !vwf_num_text_files
	print "Text data !temp_i inserted at $",hex(TextFile!temp_i),"."
	!temp_i #= !temp_i+1
endwhile
undef "temp_i"

!temp_i #= 0
while !temp_i < !vwf_num_fonts
	print "Font data !temp_i inserted at $",hex(Font!temp_i),"."
	!temp_i #= !temp_i+1
endwhile
undef "temp_i"

print freespaceuse," bytes of free space used."
print dec(!varrampos)," bytes of \!varram used."

print ""
print "VWF Creation Routine at address $",hex(GenerateVWF),"."
print "Pattern Addition Routine at address $",hex(AddPattern),"."
print "DisplayAMessage routine located at $",hex(DisplayAMessage),"."

print ""
print "VWF State register at address $",hex(!vwfmode),"."
print "Message register at address $",hex(!message),"."
print "BG GFX register at address $",hex(!boxbg),"."
print "BG Color register at address $",hex(!boxcolor),"."
print "Frame GFX register at address $",hex(!boxframe),"."
print "Abort Dialogue Processing register at address $",hex(!enddialog),"."
;print "MessageASM opcode register at address $",hex(!messageasmopcode),"."
;print "Active VWF Message Flag at address $",hex(!vwfactiveflag),"."

print ""
print "See Readme for details!"

print ""


freedata : prot !vwf_prev_freespace : Kleenex: db $00	;ignore this line, it must be at the end of the patch for technical reasons
;print "End of VWF data at $",pc,"."

namespace off


pulltable

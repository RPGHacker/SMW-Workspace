;-------------------------------------------------------

; Custom code meant for your VWF messages goes here.

;-------------------------------------------------------

; Some useful routines for your VWF messages.


; This routine lets you display a message and force the current textbox to close if one is already up.
; Call this routine from within your custom block/sprite/patch code.
; Entry code:
; lda.w #MessageNumber
; ldx.w #MessageNumber>>8
; jsl DisplayAMessage


DisplayAMessage:
	sta !message
	txa
	sta !message+1
	lda !vwfmode
	bne .ForceActiveMessageToClose
	inc
	sta !vwfmode
	lda #$6B
	sta !messageasmopcode
	rtl

.ForceActiveMessageToClose
	lda #$01
	sta !vwfactiveflag
	rtl


; This routine allows you to change the text pointer to wherever you specify
; Entry code:
; lda.b #TextPointer
; ldx.b #TextPointer>>8
; ldy.b #TextPointer>>16
; jsl ChangeVWFTextPtr

ChangeVWFTextPtr:
	sta !vwftextsource
	txa
	sta !vwftextsource+1
	tya
	sta !vwftextsource+2
	rtl

; This routine allows you to change the MessageASM pointer to wherever you specify
; Entry code:
; lda.b #ASMPointer
; ldx.b #ASMPointer>>8
; ldy.b #ASMPointer>>16
; jsl ChangeMessageASMPtr

ChangeMessageASMPtr:
	sta !messageasmloc
	txa
	sta !messageasmloc+1
	tya
	sta !messageasmloc+2
	rtl

; This routine allows you to change the message skip pointer to wherever you specify
; Entry code:
; lda.b #TextPointer
; ldx.b #TextPointer>>8
; ldy.b #TextPointer>>16
; jsl ChangeMessageSkipPtr

ChangeMessageSkipPtr:
	sta !skipmessageloc
	txa
	sta !skipmessageloc+1
	tya
	sta !skipmessageloc+2
	rtl

; This routine lets you check if the player skipped the current message with start.
; It only works if the current message was set to be skippable initially. 
;Entry code:
; jsl CheckIfMessageWasSkipped
; bcs .MessageWasSkipped

CheckIfMessageWasSkipped:
	clc
	lda !initialskipmessageflag
	beq .NoSkipping
	lda !skipmessageflag
	bne .NoSkipping
	sec
.NoSkipping
	rtl
	
	
; Resets all buffered text macros.
; The text buffer is reset to position 0, and the ID for the next text macro is reset to 0.
ResetBufferedTextMacros:
	lda #$00
	sta !vwftbufferedtextpointerindex
	sta !vwftbufferedtextindex
	sta !vwftbufferedtextindex+1
	rtl
	
	
; Begins constructing a new buffered text macro, starting at text macro ID 0 and incrementing
; that ID for every additional call to this routine. Must be followed by calls to AddToBufferedTextMacro
; and, eventually, a call to EndBufferedTextMacro to finish the macro.
BeginBufferedTextMacro:
	lda !vwftbufferedtextpointerindex
	cmp.b #!num_reserved_text_macros*3
	bcc .NumOkay
	
	; If we try using too many buffered text macros, generate an error message inside the text box and return.
	lda.b #HandleTextMacroIdOverflow0_Content
	ldx.b #HandleTextMacroIdOverflow0_Content>>8
	ldy.b #HandleTextMacroIdOverflow0_Content>>16
	jsl ChangeVWFTextPtr
	rtl
	
.NumOkay
	tax
	rep #$21
	lda.w #!vwftextbuffer
	adc !vwftbufferedtextindex
	sta !vwftbufferedtextpointers,x
	sep #$20
	
	inx #2
	lda.b #bank(!vwftextbuffer)
	sta !vwftbufferedtextpointers,x
	
	inx
	txa
	sta !vwftbufferedtextpointerindex
	
	rtl
	
	
; Adds text to to a buffered text macro that was started with BeginBufferedTextMacro.
;
; Usage:
; lda.b #StrData
; sta $00
; lda.b #StrData>>8
; sta $01
; lda.b #StrData>>16
; sta $02
; jsl AddToBufferedTextMacro
;
; Alternatively, you may use the %add_to_buffered_text_macro() macro like this:
; 
; %add_to_buffered_text_macro(StrData)
;
; This routine assumes that the text data is preceded by a 16-bit length, specifying
; the amount of bytes to copy. Example:
; 
; StrData:
;	dw .End-.Start
;	.End
;	db "ABC"
;	.Start
;
; The easiest way to achieve this is to use the %vwf_inline() macro, which automatically
; adds the length specifier and supports all the macros that regular messages support.
; Example:
;
; StrData:
;	%vwf_inline( %vwf_text("ABC") ) 
AddToBufferedTextMacro:
	rep #$30
	
	; Load our source address into X so that we can overwrite $00 and $01 down below.
	ldx $00
	inx #2	; Skip past length specifier
	
	; Also load the length while we still have the pointer in $00.
	lda [$00]
	pha
	
	; Verify that it isn't over the limit already.
	adc !vwftbufferedtextindex
	cmp.w #!buffered_text_macro_buffer_size+1
	bcc .SizeOkay
	
	; If we overflow the buffer, generate an error message inside the text box and return.
	pla
	sep #$30
	lda.b #HandleTextMacroBufferOverflow0_Content
	ldx.b #HandleTextMacroBufferOverflow0_Content>>8
	ldy.b #HandleTextMacroBufferOverflow0_Content>>16
	jsl ChangeVWFTextPtr
	rtl
	
.SizeOkay
	; Construct the destination address.
	lda.w #!vwftextbuffer
	clc
	adc !vwftbufferedtextindex
	tay
	
	; Construct an MVN in RAM. It's the only way to specify the source bank dynamically.
	; Conveniently, that one is already stored in $02, so we only need to overwrite $00 and $01.
	; Plus $03 to store an RTL.
	lda.w #($54)|((!vwftbufferedtextpointers>>8)&$FF00)	; $54 = MVN opcode
	sta $00
	lda.w #$6B	; $6B = RTL opcode
	sta $03
	
	lda $01,s	; Don't want to pull the length off the stack yet
	dec		; MVN needs length-1
	
	; Not sure if this will work in SA-1 builds, but let's see.
	phb
	jsl remap_ram($7E0000)
	plb
	
	pla
	clc
	adc !vwftbufferedtextindex
	sta !vwftbufferedtextindex
	
	sep #$30
	
	rtl
	
; Convenience macro, for when we want to add to a hard-coded address to the buffer. 
macro add_to_buffered_text_macro(address)
	lda.b #<address>
	sta $00
	lda.b #<address>>>8
	sta $01
	lda.b #<address>>>16
	sta $02
	jsl AddToBufferedTextMacro
endmacro
	

; Finishes construction of a buffered text macro that was started by calling BeginBufferedTextMacro.
; After calling this macro, the respective text macro can be used in messages via %vwf_execute_buffered_text_macro(id).
; To get the ID number of a macro, count the number of calls BeginBufferedTextMacro since your call to ResetBufferedTextMacros
; and subtract 1. So the first call to BeginBufferedTextMacro would be text macro 0, the second call would be text macro 1 etc.
EndBufferedTextMacro:
	%add_to_buffered_text_macro(.EndMacroData)
	rtl
	
.EndMacroData
	%vwf_inline( %vwf_text_macro_end() )


; These two routines lets you toggle MessageASM. Call directly with the $F1 command or within a MessageASM routine.

ToggleMessageASMPtr:
.Disable
	lda #$6B
	bra +

.Enable
	lda #$5C
+
	sta !messageasmopcode
	rtl


; These three routines let you warp to the overworld and trigger an event (if desired).
; Call directly with the $F1 command.
; Note that if you're using Lunar Magic 3.00+, then you can set a secondary entrance to exit to the overworld.
; In that case, use the $EF command and set it to the appropriate secondary entrance.

CloseMessageAndGoToOverworld:
.NormalExit
	lda #$01
	tay
	bra +

.SecretExit
	lda #$02
	ldy #$01
	bra +

.StartPlusSelect
	lda #$80
	ldy #$00
+
	sta remap_ram($0DD5)
	sty remap_ram($13CE)
	inc remap_ram($1DE9)
	lda #$0B
	sta remap_ram($0100)
	rtl


; This file contains mostly shared routines.
; That is, routines that will be callable from both inside and outside of the patch.
macro vwf_register_shared_routine(label)
	if !vwf_num_shared_routines == !vwf_max_num_shared_routines
		error "Exceeded the reserved maximum number of shared routines. To add more shared routines, you need to increase \!vwf_max_num_shared_routines in vwfconfig.cfg and port everything to a clean ROM!"
	endif

	<label>:
	.SharedRoutineStart
	
	!{vwf_shared_routine_!{vwf_num_shared_routines}_label_name} = <label>
	
	!vwf_num_shared_routines #= !vwf_num_shared_routines+1
endmacro


macro vwf_generate_shared_routines_table()
	pushtable
	
	%vwf_label_name_ascii_table()
	
	dw !vwf_num_shared_routines
	
	!temp_i #= 0
	while !temp_i < !vwf_num_shared_routines	
		; Use 0 as a terminator. There currently is no "string_length()" in Asar.
		; Shouldn't make much of a difference, anyways.
		db "!{vwf_shared_routine_!{temp_i}_label_name}",0
		dl !{vwf_shared_routine_!{temp_i}_label_name}_Jump
	
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"
	
	pulltable
endmacro


macro vwf_generate_shared_routines_jump_table()
	!temp_reserved #= !vwf_max_num_shared_routines*4
	
	!temp_i #= 0	
	while !temp_i < !vwf_num_shared_routines
		!{vwf_shared_routine_!{temp_i}_label_name}_Jump:
			jml !{vwf_shared_routine_!{temp_i}_label_name}
	
		!temp_reserved #= !temp_reserved-4
		!temp_i #= !temp_i+1
	endwhile	
	undef "temp_i"
	
	skip !temp_reserved
	undef "temp_reserved"
endmacro



; The actual VWF creation routine. Renders VWF text into a memory buffer.
;
; Included as a shared routine for advanced users only. Probably not useful,
; nor needed, for average users of this patch.
;
; NOTE: Uses SA-1 registers in SA-1 ROMs. When using an SA-1 ROM, make sure
; to call this from the SA-1 CPU only.
; 
; Parameters:
; $00: Pointer (24-bit) to the raw character data
;      1 byte per character in 8-bit mode, 2 bytes per character in 16-bit mode.
;      Each value here is considered a character index into the font.
;      No special commands are supported here.
; $03: Pointer (24-bit) to font
; $06: Pointer (24-bit) to character width table
; $09: Pointer (24-bit) to memory buffer receiving VWF text
; $0C: Length of the text data in characters
;      During processing: Pointer (24-bit) to font, offset by two 8x8 tile (to access right half of 16x16 tiles)
; $0E: Current pixel offset into destination memory buffer
; $0F: #$01 if this is writing first tile in the current buffer, otherwise #$00
;      Used as temporary memory during processing
%vwf_register_shared_routine(VWF_GenerateVWF)
	!vwf_var_ram_and_gfx_ram_in_same_bank #= equal(bank(!vwf_var_ram), bank(!vwf_gfx_ram))

	phb
	lda.b #bank(!vwf_var_ram)
	pha
	plb
	
	lda.b $0E
	sta.w !vwf_current_pixel
	lda.b $0F
	sta.w !vwf_first_tile
	lda.b $05			; Get GFX 2 Offset
	sta.b $0E
	rep #$21
	lda.b $0C
	sta.w !vwf_num_bytes
	lda.b $03
	adc.w #$0020
	sta.b $0C
.Read:
	lda.b [$00]	; Read character
	inc.b $00
if !vwf_bit_mode == VWF_BitMode.8Bit
	and.w #$00FF
	sta.w !vwf_char				; !vwf_char_width is written to here as well, but it's initialized later anyway.
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	inc.b $00
	sta.w !vwf_char
	ldy.w !vwf_char+1
	sty.w !vwf_font
	jsr .GetFont
	ldy.b $05			; Required here because .GetFont overwrites $0E
	sty.b $0E
	lda.b $03
	clc
	adc.w #$0020
	sta.b $0C
	lda.w !vwf_char
	and.w #$00FF
endif
	rep #$10
	tay
	xba
	lsr
	lsr
	adc.w #$001E
	tax
	sep #$20
	lda.b [$06],y
	sta.w !vwf_char_width
	lda.w !vwf_max_width
	sec
	sbc.w !vwf_char_width		; Get width
	sta.w !vwf_max_width
.Begin:
	txy
	ldx.w #$001E
	rep #$20
.Draw:
	lda.b [$03],y		; Load one pixelrow of letter
	sta.w !vwf_tile_ram,x
	lda.b [$0C],y
	sta.w !vwf_tile_ram+32,x
	stz.w !vwf_tile_ram+64,x
	dey
	dey
	dex
	dex
	bpl.b .Draw
	sep #$30
	ldx.b #$0E
.Shift:
	ldy.w !vwf_current_pixel
	beq .Skip
	lda.w !vwf_char_width
	cmp.b #$09
	bcs.b .HandleWideLetter
.HandleSmallLetter:
..Check2:
	tya
..Check:
	lsr.w !vwf_tile_ram,x	; Shift to the right
	ror.w !vwf_tile_ram+32,x
	lsr.w !vwf_tile_ram+1,x
	ror.w !vwf_tile_ram+33,x
	lsr.w !vwf_tile_ram+16,x
	ror.w !vwf_tile_ram+48,x
	lsr.w !vwf_tile_ram+17,x
	ror.w !vwf_tile_ram+49,x
	dec
	bne.b ..Check
	dex
	dex
	bpl.b ..Check2
	bra.b .Skip

.HandleWideLetter:
..Check2:
	tya
..Check:
	lsr.w !vwf_tile_ram,x	; Shift to the right
	ror.w !vwf_tile_ram+32,x
	ror.w !vwf_tile_ram+64,x
	lsr.w !vwf_tile_ram+1,x
	ror.w !vwf_tile_ram+33,x
	ror.w !vwf_tile_ram+65,x
	lsr.w !vwf_tile_ram+16,x
	ror.w !vwf_tile_ram+48,x
	ror.w !vwf_tile_ram+80,x
	lsr.w !vwf_tile_ram+17,x
	ror.w !vwf_tile_ram+49,x
	ror.w !vwf_tile_ram+81,x
	dec
	bne.b ..Check
	dex
	dex
	bpl.b ..Check2
.Skip:
if !vwf_var_ram_and_gfx_ram_in_same_bank != false
	ldy.b #$00
else
	ldx.b #$00
	txy
endif
	lda.b #$00
	pha
	
	lda.w !vwf_current_pixel	; Adjust destination address
	clc
	adc.w !vwf_char_width
	sta $0F
	
	lsr #3						; Compute quotient of division by 8
	pha
	
	lda.b #$00
	pha	
	
	lda $0F						; Compute remainder of division by 8
	and.b #%00000111
	pha

	lda.w !vwf_first_tile		; Skip one step if first tile in line
	beq .Combine
	stz.w !vwf_first_tile
	rep #$20
	bra.b .Copy

.Combine:
	rep #$20
-:
if !vwf_var_ram_and_gfx_ram_in_same_bank != false
	lda.w !vwf_tile_ram,y	; Combine old graphic with new
	ora.b ($09),y
	sta.b ($09),y
else
	lda.w !vwf_tile_ram,x	; Combine old graphic with new
	ora.b [$09],y
	sta.b [$09],y
	inx
	inx
endif
	iny
	iny
	cpy.b #$20
	bne.b -
.Copy:
if !vwf_var_ram_and_gfx_ram_in_same_bank != false
	lda.w !vwf_tile_ram,y	; Copy remaining part of letter
	sta.b ($09),y
else
	lda.w !vwf_tile_ram,x	; Copy remaining part of letter
	sta.b [$09],y
	inx
	inx
endif
	iny
	iny
	cpy.b #$60
	bne.b .Copy
	lda $03,s
	asl
	pha
	clc
	adc.w !vwf_tile
	sta.w !vwf_tile
	pla
	clc
	sep #$20
	adc.w !vwf_buffer_index
	sta.w !vwf_buffer_index
	lda $01,s
	sta.w !vwf_current_pixel
	lda $03,s
	clc
	adc.w !vwf_current_x
	sta.w !vwf_current_x
	rep #$21
	pla
	pla
	; The XBA here is necessary, because bytes are stored on the stack in reverse order
	; due to the fact we use stack-relative indexing to access them.
	xba
	adc.b $09
	sta.b $09
	dec.w !vwf_num_bytes		; Adjust number of bytes
	beq .End
	jmp .Read

.End:
	sep #$20
	
	plb
	
	rtl

; RPG Hacker: There's now a local copy of this routine, because optimizations to GenerateVWF
; made it incompatible with the other one, and this is simply the easiest way to fix that.
if !vwf_bit_mode == VWF_BitMode.16Bit
.GetFont:
	lda.w !vwf_font
	and.w #$00FF
	asl				; This essentially multiplies by 6 (implemented as a 4n + 2n)
	sta $0E
	asl
	adc $0E	
	clc
	adc.w #FontTable	; Add starting address
	sta.b $00
	ldy.b #FontTable>>16
	sty.b $02
	ldy.b #$00

.Loop
	; RPG Hacker: Don't like this very much, but this lda opcode only exists for the Y
	; register, and this sta opcode only exists for the X register...
	tyx
	lda.b [$00],y	; Load addresses from table
	sta.b remap_ram($03),x
	iny #2
	cpy.b #$06
	bne .Loop
	rts
endif



; Adds the background pattern to VWF text in memory.
; 
; Included as a shared routine for advanced users only. Probably not useful,
; nor needed, for average users of this patch.
; 
; Parameters:
; $00: Pointer (24-bit) to pattern GFX
; $03: Pointer (24-bit) to memory buffer containing VWF text created via VWF_GenerateVWF
; $06: Number of tiles in memory buffer
%vwf_register_shared_routine(VWF_AddPattern)
.Begin
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
	bne .Begin

.End
	rtl


; This routine checks whether a VWF Dialogues message box is currently open.
; 
; Usage:
; jsl VWF_IsMessageActive
; bne .MessageIsActive
%vwf_register_shared_routine(VWF_IsMessageActive)	
	lda !vwf_mode
	rtl


; This routine lets you display a message and force the current textbox to close if one is already up.
; Call this routine from within your custom block/sprite/patch code.
; 
; Entry code:
; lda.b #MessageNumber
; ldx.b #MessageNumber>>8
; jsl VWF_DisplayAMessage
%vwf_register_shared_routine(VWF_DisplayAMessage)
	sta !vwf_message
	txa
	sta !vwf_message+1
	lda !vwf_mode
	bne .ForceActiveMessageToClose
	inc
	sta !vwf_mode
	lda #$00
	sta !vwf_message_asm_enabled
	rtl

.ForceActiveMessageToClose
	lda #$01
	sta !vwf_active_flag
	rtl


; This routine allows you to change the text pointer to wherever you specify
; 
; Entry code:
; lda.b #TextPointer
; ldx.b #TextPointer>>8
; ldy.b #TextPointer>>16
; jsl VWF_ChangeVWFTextPtr
%vwf_register_shared_routine(VWF_ChangeVWFTextPtr)
	sta !vwf_text_source
	txa
	sta !vwf_text_source+1
	tya
	sta !vwf_text_source+2
	rtl


; This routine allows you to change the MessageASM pointer to wherever you specify
; 
; Entry code:
; lda.b #ASMPointer
; ldx.b #ASMPointer>>8
; ldy.b #ASMPointer>>16
; jsl VWF_ChangeMessageASMPtr
%vwf_register_shared_routine(VWF_ChangeMessageASMPtr)
	sta !vwf_message_asm_loc
	txa
	sta !vwf_message_asm_loc+1
	tya
	sta !vwf_message_asm_loc+2
	rtl


; This routine lets you toggle MessageASM. Call directly with the %vwf_execute_subroutine() command or within a MessageASM routine.
%vwf_register_shared_routine(VWF_ToggleMessageASM)
	lda !vwf_message_asm_enabled
	eor #%00000001
	sta !vwf_message_asm_enabled
	rtl


; This routine allows you to change the message skip pointer to wherever you specify
; 
; Entry code:
; lda.b #TextPointer
; ldx.b #TextPointer>>8
; ldy.b #TextPointer>>16
; jsl VWF_ChangeMessageSkipPtr
%vwf_register_shared_routine(VWF_ChangeMessageSkipPtr)
	sta !vwf_skip_message_loc
	txa
	sta !vwf_skip_message_loc+1
	tya
	sta !vwf_skip_message_loc+2
	rtl


; This routine lets you toggle message skip. Call directly with the %vwf_execute_subroutine() command or within a MessageASM routine.
%vwf_register_shared_routine(VWF_ToggleMessageSkip)
	lda !vwf_skip_message_flag
	and.b #$01
	eor.b #$01
	sta !vwf_skip_message_flag
	rtl


; This routine lets you check if the player skipped the current message with start.
; 
; Usage:
; jsl VWF_WasMessageSkipped
; bne .message_was_skipped
%vwf_register_shared_routine(VWF_WasMessageSkipped)
	lda !vwf_message_was_skipped	
	rtl


; These three routines let you warp to the overworld and trigger an event (if desired).
; Call directly with the %vwf_execute_subroutine() command.
; Note that if you're using Lunar Magic 3.00+, then you can set a secondary entrance to exit to the overworld.
; In that case, use the %vwf_setup_teleport() command and set it to the appropriate secondary entrance.
%vwf_register_shared_routine(VWF_CloseMessageAndGoToOverworld_NormalExit)
	lda #$01
	tay
	bra VWF_CloseMessageAndGoToOverworld_End
	
%vwf_register_shared_routine(VWF_CloseMessageAndGoToOverworld_SecretExit)
	lda #$02
	ldy #$01
	bra VWF_CloseMessageAndGoToOverworld_End

%vwf_register_shared_routine(VWF_CloseMessageAndGoToOverworld_StartPlusSelect)
	lda #$80
	ldy #$00

VWF_CloseMessageAndGoToOverworld_End:
	sta remap_ram($0DD5)
	sty remap_ram($13CE)
	inc remap_ram($1DE9)
	lda #$0B
	sta remap_ram($0100)
	rtl
	
	
; Resets all buffered text macros.
; The text buffer is reset to position 0, and the ID for the next text macro is reset to 0.
%vwf_register_shared_routine(VWF_ResetBufferedTextMacros)
	lda #$00
	sta !vwf_tm_buffers_text_pointer_index
	sta !vwf_tm_buffers_text_index
	sta !vwf_tm_buffers_text_index+1
	rtl
	
	
; Begins constructing a new buffered text macro, starting at text macro ID 0 and incrementing
; that ID for every additional call to this routine. Must be followed by calls to VWF_AddToBufferedTextMacro
; and, eventually, a call to VWF_EndBufferedTextMacro to finish the macro.
%vwf_register_shared_routine(VWF_BeginBufferedTextMacro)
	lda !vwf_tm_buffers_text_pointer_index
	cmp.b #!vwf_num_reserved_text_macros*3
	bcc .NumOkay
	
	; If we try using too many buffered text macros, generate an error message inside the text box and return.
	lda.b #HandleTextMacroIdOverflow0_Content
	ldx.b #HandleTextMacroIdOverflow0_Content>>8
	ldy.b #HandleTextMacroIdOverflow0_Content>>16
	jsl VWF_ChangeVWFTextPtr
	rtl
	
.NumOkay
	tax
	rep #$21
	lda.w #!vwf_tm_buffers_text_buffer
	adc !vwf_tm_buffers_text_index
	sta !vwf_tm_buffers_text_pointers,x
	sep #$20
	
	inx #2
	lda.b #bank(!vwf_tm_buffers_text_buffer)
	sta !vwf_tm_buffers_text_pointers,x
	
	inx
	txa
	sta !vwf_tm_buffers_text_pointer_index
	
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
; jsl VWF_AddToBufferedTextMacro
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
%vwf_register_shared_routine(VWF_AddToBufferedTextMacro)
	rep #$30
	
	; Load our source address into X so that we can overwrite $00 and $01 down below.
	ldx $00
	inx #2	; Skip past length specifier
	
	; Also load the length while we still have the pointer in $00.
	lda [$00]
	pha
	
	; Verify that it isn't over the limit already.
	adc !vwf_tm_buffers_text_index
	cmp.w #!vwf_buffered_text_macro_buffer_size+1
	bcc .SizeOkay
	
	; If we overflow the buffer, generate an error message inside the text box and return.
	pla
	sep #$30
	lda.b #HandleTextMacroBufferOverflow0_Content
	ldx.b #HandleTextMacroBufferOverflow0_Content>>8
	ldy.b #HandleTextMacroBufferOverflow0_Content>>16
	jsl VWF_ChangeVWFTextPtr
	rtl
	
.SizeOkay
	; Construct the destination address.
	lda.w #!vwf_tm_buffers_text_buffer
	clc
	adc !vwf_tm_buffers_text_index
	tay
	
	; Construct an MVN in RAM. It's the only way to specify the source bank dynamically.
	; Conveniently, that one is already stored in $02, so we only need to overwrite $00 and $01.
	; Plus $03 to store an RTL.
	lda.w #($54)|((!vwf_tm_buffers_text_pointers>>8)&$FF00)	; $54 = MVN opcode
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
	adc !vwf_tm_buffers_text_index
	sta !vwf_tm_buffers_text_index
	
	sep #$30
	
	rtl

	
; Convenience macro, for when we want to add a hard-coded address to the buffer.
macro add_to_buffered_text_macro(address)
	lda.b #<address>
	sta $00
	lda.b #<address>>>8
	sta $01
	lda.b #<address>>>16
	sta $02
	jsl VWF_AddToBufferedTextMacro
endmacro
	

; Finishes construction of a buffered text macro that was started by calling BeginBufferedTextMacro.
; After calling this macro, the respective text macro can be used in messages via %vwf_execute_buffered_text_macro(id).
; To get the ID number of a macro, count the number of calls to BeginBufferedTextMacro since your call to ResetBufferedTextMacros
; and subtract 1. So the first call to BeginBufferedTextMacro would be text macro 0, the second call would be text macro 1 etc.
%vwf_register_shared_routine(VWF_EndBufferedTextMacro)
	%add_to_buffered_text_macro(.EndMacroData)
	rtl
	
.EndMacroData
	%vwf_inline( %vwf_text_macro_end() )

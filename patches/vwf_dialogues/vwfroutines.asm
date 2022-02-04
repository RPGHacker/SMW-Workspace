
; This file contains mostly shared routines.
; That is, routines that will be callable from both inside and outside of the patch.
macro vwf_register_shared_routine(label)
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
		dl !{vwf_shared_routine_!{temp_i}_label_name}
	
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"
	
	pulltable
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
%vwf_register_shared_routine(VWF_GenerateVWF)
	lda $0E
	sta !vwf_current_pixel
	lda $0F
	sta !vwf_first_tile
	rep #$20
	lda $0C
	sta !vwf_num_bytes
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
	!vwf_16bit_mode_only inc $00
	!vwf_8bit_mode_only sep #$20
	sta !vwf_char
	!vwf_16bit_mode_only sep #$20
	!vwf_16bit_mode_only lda !vwf_char+1
	!vwf_16bit_mode_only sta !vwf_font
	!vwf_16bit_mode_only jsr GetFont
	!vwf_16bit_mode_only lda $05
	!vwf_16bit_mode_only sta $0E
	!vwf_16bit_mode_only rep #$21
	!vwf_16bit_mode_only lda $03
	!vwf_16bit_mode_only adc #$0020
	!vwf_16bit_mode_only sta $0C
	!vwf_16bit_mode_only sep #$20
	!vwf_16bit_mode_only lda !vwf_char
	tay
	lda [$06],y	; Get width
	sta !vwf_char_width
	lda !vwf_max_width
	sec
	sbc !vwf_char_width
	sta !vwf_max_width

.Begin
	lda !vwf_char	; Get letter offset into Y
	sta.w select(!use_sa1_mapping,$2251,$211B)
	stz.w select(!use_sa1_mapping,$2252,$211B)
	stz.w select(!use_sa1_mapping,$2250,$211C)
	lda #$40
	sta.w select(!use_sa1_mapping,$2253,$211C)
	if !use_sa1_mapping : stz $2254
	rep #$10
	ldy.w select(!use_sa1_mapping,$2306,$2134)
	ldx #$0000

.Draw
	lda !vwf_current_pixel
	sta $0F
	lda [$03],y	; Load one pixelrow of letter
	sta !vwf_tile_ram,x
	lda [$0C],y
	sta !vwf_tile_ram+32,x
	lda #$00
	sta !vwf_tile_ram+64,x

.Check
	lda $0F
	beq .Skip
	lda !vwf_tile_ram,x	; Shift to the right
	lsr
	sta !vwf_tile_ram,x
	lda !vwf_tile_ram+32,x
	ror
	sta !vwf_tile_ram+32,x
	lda !vwf_tile_ram+64,x
	ror
	sta !vwf_tile_ram+64,x
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

	lda !vwf_first_tile	; Skip one step if first tile in line
	beq .Combine
	lda #$00
	sta !vwf_first_tile
	bra .Copy

.Combine
	lda !vwf_tile_ram,x	; Combine old graphic with new
	ora [$09],y
	sta [$09],y
	inx
	iny
	cpx #$20
	bne .Combine

.Copy
	lda !vwf_tile_ram,x	; Copy remaining part of letter
	sta [$09],y
	inx
	iny
	cpx #$60
	bne .Copy

if !use_sa1_mapping
	lda #$01
	sta $2250
endif
	lda !vwf_current_pixel	; Adjust destination address
	clc
	adc !vwf_char_width
	sta.w select(!use_sa1_mapping,$2251,$4204)
	stz.w select(!use_sa1_mapping,$2252,$4205)
	lda #$08
	sta.w select(!use_sa1_mapping,$2253,$4206)
if !use_sa1_mapping
	stz $2254
	nop
	bra $00
else
	nop #8
endif
	lda.w select(!use_sa1_mapping,$2308,$4216)
	sta !vwf_current_pixel
	rep #$20
	lda.w select(!use_sa1_mapping,$2306,$4214)
	asl
	pha
	clc
	adc !vwf_tile
	sta !vwf_tile
	pla
	clc
	sep #$20
	adc !vwf_buffer_index
	sta !vwf_buffer_index
	lda.w select(!use_sa1_mapping,$2306,$4214)
	clc
	adc !vwf_current_x
	sta !vwf_current_x
	lda.w select(!use_sa1_mapping,$2306,$4214)
	sta.w select(!use_sa1_mapping,$2251,$211B)
	stz.w select(!use_sa1_mapping,$2250,$211B)
	stz.w select(!use_sa1_mapping,$2252,$211C)
	lda #$20
	sta.w select(!use_sa1_mapping,$2253,$211C)
if !use_sa1_mapping
	stz $2254
	nop
endif
	rep #$21
	lda.w select(!use_sa1_mapping,$2306,$2134)
	adc $09
	sta $09

	lda !vwf_num_bytes	; Adjust number of bytes
	dec
	sta !vwf_num_bytes
	beq .End
	jmp .Read

.End
	sep #$20
	rtl

skip 16



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

skip 16


; This routine checks whether a VWF Dialogues message box is currently open.
; 
; Usage:
; jsl VWF_IsMessageActive
; bne .MessageIsActive
%vwf_register_shared_routine(VWF_IsMessageActive)	
	lda !vwf_mode
	rtl

skip 16


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
	lda #$6B
	sta !vwf_message_asm_opcode
	rtl

.ForceActiveMessageToClose
	lda #$01
	sta !vwf_active_flag
	rtl

skip 16


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

skip 16


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

skip 16


; This routine lets you toggle MessageASM. Call directly with the %vwf_execute_subroutine() command or within a MessageASM routine.
%vwf_register_shared_routine(VWF_ToggleMessageASM)
	lda !vwf_message_asm_opcode
	cmp #$5C
	bne .Enable

.Disable
	lda #$6B
	bra +

.Enable
	lda #$5C
+
	sta !vwf_message_asm_opcode
	rtl

skip 16


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

skip 16


; This routine lets you toggle message skip. Call directly with the %vwf_execute_subroutine() command or within a MessageASM routine.
%vwf_register_shared_routine(VWF_ToggleMessageSkip)
	lda !vwf_skip_message_flag
	and.b #$01
	eor.b #$01
	sta !vwf_skip_message_flag
	rtl
	
skip 16


; This routine lets you check if the player skipped the current message with start.
; 
; Usage:
; jsl VWF_WasMessageSkipped
; bne .message_was_skipped
%vwf_register_shared_routine(VWF_WasMessageSkipped)
	lda !vwf_message_was_skipped	
	rtl

skip 16


; These three routines let you warp to the overworld and trigger an event (if desired).
; Call directly with the $F1 command.
; Note that if you're using Lunar Magic 3.00+, then you can set a secondary entrance to exit to the overworld.
; In that case, use the $EF command and set it to the appropriate secondary entrance.
%vwf_register_shared_routine(VWF_CloseMessageAndGoToOverworld)
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

skip 16
	
	
; Resets all buffered text macros.
; The text buffer is reset to position 0, and the ID for the next text macro is reset to 0.
%vwf_register_shared_routine(VWF_ResetBufferedTextMacros)
	lda #$00
	sta !vwf_tm_buffers_text_pointer_index
	sta !vwf_tm_buffers_text_index
	sta !vwf_tm_buffers_text_index+1
	rtl

skip 16
	
	
; Begins constructing a new buffered text macro, starting at text macro ID 0 and incrementing
; that ID for every additional call to this routine. Must be followed by calls to AddToBufferedTextMacro
; and, eventually, a call to EndBufferedTextMacro to finish the macro.
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

skip 16
	
	
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

skip 16

	
; Convenience macro, for when we want to add to a hard-coded address to the buffer. 
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
; To get the ID number of a macro, count the number of calls BeginBufferedTextMacro since your call to ResetBufferedTextMacros
; and subtract 1. So the first call to BeginBufferedTextMacro would be text macro 0, the second call would be text macro 1 etc.
%vwf_register_shared_routine(VWF_EndBufferedTextMacro)
	%add_to_buffered_text_macro(.EndMacroData)
	rtl
	
.EndMacroData
	%vwf_inline( %vwf_text_macro_end() )

skip 16

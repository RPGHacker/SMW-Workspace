asar 1.90

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;VWF Dialogues Patch by RPG Hacker;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


incsrc data/vwfconfig.cfg
incsrc shared/shared.asm


print ""
print "VWF Dialogues Patch - (c) 2010-2024 RPG Hacker"
print ""


pushtable
cleartable


namespace vwf_dialogues_






;;;;;;;;;;;;;;;;;;;;
;Labels and Defines;
;;;;;;;;;;;;;;;;;;;;


; DO NOT EDIT ANYTHING HERE, UNLESS YOU KNOW EXACTLY WHAT YOU'RE DOING!


assert !vwf_backup_duration_in_frames >= 8, "\!vwf_backup_duration_in_frames must have a value of at least 8."
assert floor($4000/!vwf_backup_duration_in_frames)*!vwf_backup_duration_in_frames == $4000, "$4000 is not divisible by the value of \!vwf_backup_duration_in_frames (currently ",dec(!vwf_backup_duration_in_frames),"). Try a diffrent value."
assert !vwf_clear_screen_duration_in_frames >= 1, "\!vwf_clear_screen_duration_in_frames must have a value of at least 1."
assert floor($0700/!vwf_clear_screen_duration_in_frames)*!vwf_clear_screen_duration_in_frames == $0700, "$700 is not divisible by the value of \!vwf_clear_screen_duration_in_frames (currently ",dec(!vwf_clear_screen_duration_in_frames),"). Try a diffrent value."


%define_enum(VWF_BitMode, 8Bit, 16Bit)


; Sanitize a few defines that have a likelihood of being problematic so that don't have to use parentheses everywhere.
!vwf_default_advance_button_mask := (!vwf_default_advance_button_mask)
!vwf_select_choice_button_mask := (!vwf_select_choice_button_mask)
!vwf_skip_message_button_mask := (!vwf_skip_message_button_mask)


!vwf_palette_backup_ram = $7E0703

if !use_sa1_mapping
	!vwf_var_ram	= !vwf_var_ram_sa1
	!vwf_backup_ram	= !vwf_backup_ram_sa1
	!vwf_gfx_ram	= !vwf_gfx_ram_sa1
	!vwf_palette_backup_ram	= !vwf_palette_backup_ram_sa1
endif

!vwf_debug_vblank_time ?= false


!vwf_var_rampos #= 0

macro vwf_claim_varram(define, size)
	if defined("vwf_<define>")
		error "%vwf_claim_varram(): \!vwf_<define> already defined."
	endif
	
	!vwf_<define> := !vwf_var_ram+!vwf_var_rampos
	!vwf_var_rampos #= !vwf_var_rampos+(<size>)
	
	; RPG Hacker: This assignment serves no other purpose other than to force a symbol export.
	vwf_<define> = !vwf_<define>
endmacro


%vwf_claim_varram(mode, 1)          ; Contains the current state of the text box.
%vwf_claim_varram(message, 2)       ; The 16-bit message number to display

%vwf_claim_varram(box_bg, 1)
%vwf_claim_varram(box_color, 6)
%vwf_claim_varram(box_frame, 1)

; RPG Hacker: RAM addresses defined above this point won't automatically get cleared on opening message boxes.
!vwf_ram_clear_start_pos #= !vwf_var_rampos

%vwf_claim_varram(sub_step, 1)

%vwf_claim_varram(width, 1)
%vwf_claim_varram(height, 1)
%vwf_claim_varram(x_pos, 1)
%vwf_claim_varram(y_pos, 1)
%vwf_claim_varram(box_create, 1)
%vwf_claim_varram(box_palette, 1)
%vwf_claim_varram(freeze_sprites, 1)         ; Flag indicating that the textbox has frozen all sprites.
%vwf_claim_varram(beep, 1)                   ; The sound effect ID to play for the text beep noise.
%vwf_claim_varram(beep_bank, 2)              ; The RAM address stored to by the above.
%vwf_claim_varram(beep_end, 1)               ; The sound effect ID to play for the "wait for A" sound effect.
%vwf_claim_varram(beep_end_bank, 2)          ; The RAM address stored to by the above.
%vwf_claim_varram(beep_cursor, 1)            ; The sound effect ID to play when moving the cursor
%vwf_claim_varram(beep_cursor_bank, 2)       ; The RAM address stored to by the above.
%vwf_claim_varram(beep_choice, 1)            ; The sound effect ID to play when pressing A.
%vwf_claim_varram(beep_choice_bank, 2)       ; The RAM address stored to by the above.
%vwf_claim_varram(font, 1)
%vwf_claim_varram(edge, 1)
%vwf_claim_varram(space, 1)
%vwf_claim_varram(frames, 1)
%vwf_claim_varram(text_alignment, 1)
%vwf_claim_varram(sound_disabled, 1)         ; Flag that disables all the normal textbox sounds
%vwf_claim_varram(speed_up, 1)               ; Flag indicating that the current textbox can be sped up when A is held.
%vwf_claim_varram(auto_wait, 1)
%vwf_claim_varram(auto_wait_num_frames, 1)

%vwf_claim_varram(vram_pointer, 2)
%vwf_claim_varram(clear_box_remaining_bytes, 2)
%vwf_claim_varram(current_width, 1)
%vwf_claim_varram(current_height, 1)
%vwf_claim_varram(current_x, 1)
%vwf_claim_varram(current_y, 1)

%vwf_claim_varram(text_source, 3)            ; 24-bit pointer to the current text data.
%vwf_claim_varram(num_bytes, 2)
%vwf_claim_varram(gfx_dest, 3)
%vwf_claim_varram(tilemap_dest, 3)           ; 24-bit pointer to the location in the tile buffer to read from when uploading the textbox tilemap.
%vwf_claim_varram(max_width, 1)
%vwf_claim_varram(max_height, 1)
%vwf_claim_varram(char, 2)
%vwf_claim_varram(char_offset, 2)
%vwf_claim_varram(char_width, 1)
%vwf_claim_varram(routine, 15)
%vwf_claim_varram(tile_ram, 96)
%vwf_claim_varram(tile, 1)
%vwf_claim_varram(property, 1)
%vwf_claim_varram(current_pixel, 1)
%vwf_claim_varram(first_tile, 1)
%vwf_claim_varram(clear_box, 1)
%vwf_claim_varram(wait, 1)
%vwf_claim_varram(timer, 1)
%vwf_claim_varram(teleport, 1)               ; Flag indicating whether a teleport should take place.
%vwf_claim_varram(teleport_dest, 1)          ; Data that gets stored to the table at $19B8 when the teleport function is active.
%vwf_claim_varram(teleport_prop, 1)          ; Data that gets stored to the table at $19D8 when the teleport function is active.
%vwf_claim_varram(exit_to_ow, 1)             ; Stores whether we want to exit to the overworld, and how
%vwf_claim_varram(force_sfx, 1)
%vwf_claim_varram(width_carry, 1)
%vwf_claim_varram(choices, 1)
%vwf_claim_varram(cursor, 2)
%vwf_claim_varram(current_choice, 1)
%vwf_claim_varram(choice_table, 3)
%vwf_claim_varram(choice_space, 1)
%vwf_claim_varram(choice_width, 1)
%vwf_claim_varram(cursor_move, 1)
%vwf_claim_varram(no_choice_lb, 1)
%vwf_claim_varram(cursor_upload, 1)
%vwf_claim_varram(cursor_end, 1)

%vwf_claim_varram(palette_upload, 1)         ; Flag indicating that the layer 3 palettes should be updated.
%vwf_claim_varram(palette_backup, 64)        ; Backup of the layer 3 palettes.
%vwf_claim_varram(cursor_fix, 1)
%vwf_claim_varram(cursor_vram, 2)
%vwf_claim_varram(cursor_source, 2)
%vwf_claim_varram(arrow_vram, 2)
%vwf_claim_varram(end_dialog, 1)
%vwf_claim_varram(swap_message_id, 2)
%vwf_claim_varram(swap_message_settings, 1)

%vwf_claim_varram(message_asm_enabled, 1)       ; Determines whether MessageASM code will run.
%vwf_claim_varram(message_asm_loc, 3)           ; 24-bit pointer to the current MessageASM routine.
%vwf_claim_varram(active_flag, 1)               ; Flag indicating that a VWF Message is active. Used to tell the VWF system to close the current text box before opening the new one.
%vwf_claim_varram(skip_message_flag, 1)         ; Flag indicating that the message skip function is enabled for the current textbox.
%vwf_claim_varram(skip_message_loc, 3)          ; 24-bit pointer to the text data that will be jumped to if start is pressed and message skipping is enabled.
%vwf_claim_varram(l3_priority_flag, 1)          ; Backup of the layer 3 priority bit in register $2105
%vwf_claim_varram(l3_transparency_flag, 1)      ; Backup of the layer 3 color math settings from RAM address $40 (mirror of $2131) 
%vwf_claim_varram(l3_main_screen_flag, 1)       ; Backup of the layer 3 main screen bit from RAM address $0D9D (mirror of $212C)
%vwf_claim_varram(l3_sub_screen_flag, 1)        ; Backup of the layer 3 sub screen bit from RAM address $0D9E (mirror of $212D)
%vwf_claim_varram(at_start_of_text, 1)   		; Flag indicating that the text box has not been cleared yet. Intended to provide an easy way to sync up MessageASM code with the start of a new textbox.
%vwf_claim_varram(message_was_skipped, 1)       ; Flag indicating whether the message was skipped by the player pressing Start
%vwf_claim_varram(buffer_dest, 3)               ; 24-bit pointer to the location in the tile buffer to read from when uploading text graphics.
%vwf_claim_varram(buffer_index, 1)              ; Index to the text graphics buffer determining where in the buffer to store tiles.

; RPG Hacker: Make sure both of these stacks have the same size. Stack 1 will be copied into stack 2 at run-time.
!vwf_text_macro_stack_size = 60
%vwf_claim_varram(tm_stack_index_1, 1)                       ; Defines a stack of text pointers for the text macro system (to support nested macros)
%vwf_claim_varram(tm_stack_1, !vwf_text_macro_stack_size)    ; 
%vwf_claim_varram(tm_stack_index_2, 1)                       ; Same as above, but for the WordWidth function.
%vwf_claim_varram(tm_stack_2, !vwf_text_macro_stack_size)    ;

%vwf_claim_varram(tm_buffers_text_pointer_index, 1)          ; Index for the which 24-bit buffered text macro pointer should be updated.
%vwf_claim_varram(tm_buffers_text_index, 2)                  ; 16-bit index into the text buffer, used for handling where to write in the table for consecuative text buffers.
%vwf_claim_varram(tm_buffers_text_pointers, !vwf_num_reserved_text_macros*3)    ; 24-bit pointer table for the buffered text macros.
%vwf_claim_varram(tm_buffers_text_buffer, !vwf_buffered_text_macro_buffer_size) ; Buffer dedicated for uploading VWF text to in order to display variable text.

%vwf_claim_varram(create_window_start_pos, 2) ; Start position and length for CreateWindow DMA.
%vwf_claim_varram(create_window_length, 2)

%vwf_claim_varram(wait_for_button_mask, 2)    ; Button mask for "wait for button" command.

!vwf_buffer_empty_tile = !vwf_gfx_ram
!vwf_buffer_bg_tile = !vwf_gfx_ram+$10
!vwf_buffer_frame = !vwf_gfx_ram+$20
!vwf_buffer_letters = !vwf_gfx_ram+$20
!vwf_buffer_choice_backup = !vwf_gfx_ram+$0420
!vwf_buffer_cursor = !vwf_gfx_ram+$042C
!vwf_buffer_text_box_tilemap = !vwf_gfx_ram+$048C		; 0x700 bytes

!vwf_ram_bank = select(!use_sa1_mapping,$40,$7E)

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

!vwf_num_shared_routines = 0

!vwf_prev_freespace = AutoFreespaceCleaner

if !use_sa1_mapping
	!vwf_dma_channel_nmi = 2
	!vwf_dma_channel_non_nmi = 0
else
	; RPG Hacker: I don't know if this distinction is actually necessary, but I don't even want to risk breaking compatibility.
	!vwf_dma_channel_nmi = 0
	!vwf_dma_channel_non_nmi = 0
endif

!vwf_cpu_snes = 0
!vwf_cpu_sa1 = 1

; RPG Hacker: IMPORTANT: Adjust this define when adding any new commands to the patch!
!vwf_lowest_reserved_hex = $FFE6



incsrc vwfmacros.asm



if !vwf_bit_mode == VWF_BitMode.16Bit
	warn "16-bit mode is deprecated and might be removed in the future."
endif





;;;;;;;;
;Macros;
;;;;;;;;



; A macro for MVN transfers.

macro vwf_mvn_transfer(bytes, source, destination, current_cpu, ...)
	!temp_currently_on_sa1_cpu = and(equal(<current_cpu>,!vwf_cpu_sa1),!use_sa1_mapping)

	phb
if sizeof(...) > 0
	!temp_start_index := <...[0]>
	!temp_log2 #= floor(log2(<bytes>))
	
	if 2**!temp_log2 == <bytes>
		; RPG Hacker: The multiplier is logarithmic - we can use a number of ASL to do the multiplication.
		; If the exponent gets too large, this might be less performant than an actual multiplication,
		; but I don't think we'll ever get to those severe dimensions, so I won't optimize for them.
		lda.b #$00
		xba
		lda !temp_start_index
		rep #$31
		asl #!temp_log2
		adc.w #<source>
		tax
	elseif !temp_currently_on_sa1_cpu == !vwf_cpu_snes && <bytes> < $100
		; If the number of bytes is representable as a single byte (we assume the start index to always be
		; representable as a single byte), and we're currently on the SNES CPU, do the multiplication via the
		; regular multiplication registers instead of the mode 7 registers (this can prevent certain quirks).
		lda.b #<bytes>	; Calculate starting index
		sta $4202
		lda !temp_start_index
		sta $4203
		rep #$31
		lda.w #<source>
		nop #2
		adc $4216
		tax
	else
		; If none of the above is possible, fall back to a generic solution.
		lda.b #<bytes>	; Calculate starting index
		sta.w select(!temp_currently_on_sa1_cpu,$2251,$211B)
		lda.b #<bytes>>>8
		sta.w select(!temp_currently_on_sa1_cpu,$2252,$211B)
		stz.w select(!temp_currently_on_sa1_cpu,$2250,$211C)
		lda !temp_start_index
		sta.w select(!temp_currently_on_sa1_cpu,$2253,$211C)
		if !temp_currently_on_sa1_cpu
			stz $2254
			nop
		endif
		
		rep #$31
		lda.w select(!temp_currently_on_sa1_cpu,$2306,$2134)	; Add source address
		adc.w #<source>	; to get new source address
		tax
	endif
	
	undef "temp_log2"
	undef "temp_start_index"
else
	rep #$30
	ldx.w #<source>
endif
	ldy.w #<destination>	; Destination address
	lda.w #<bytes>-1	; Number of bytes
	
	mvn bank(<destination>), bank(<source>)
	
	sep #$30
	plb
	
	undef "temp_currently_on_sa1_cpu"
endmacro



; A macro for SA-1 DMA (ROM->BWRAM) transfer.

macro vwf_bwram_transfer(bytes, start, source, destination)
	if !use_sa1_mapping && !vwf_sa1_use_dma_for_gfx_transfer
		lda #$C4
		sta $2230

		stz $2250
		lda.b #<bytes>    ; Calculate starting index
		sta $2251
		lda.b #<bytes>>>16
		sta $2252
		lda <start>
		sta $2253
		stz $2254
		nop
		rep #$21
		lda $2306         ; Add source address
		adc.w #<source>   ; to get final source address.
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
		%vwf_mvn_transfer(<bytes>, <source>, <destination>, !vwf_cpu_sa1, <start>)
	endif
endmacro



; A macro that defines character mappings for just the ASCII characters that are allowed in label names.
; Note: In Asar 1.9, just calling cleartable should do the job. But I'm not sure if that'll still work in Asar 2.0,
; so have this slightly annoying solution instead.

macro vwf_label_name_ascii_table()
	'0' = $30
	'1' = $31
	'2' = $32
	'3' = $33
	'4' = $34
	'5' = $35
	'6' = $36
	'7' = $37
	'8' = $38
	'9' = $39
	
	'A' = $41
	'B' = $42
	'C' = $43
	'D' = $44
	'E' = $45
	'F' = $46
	'G' = $47
	'H' = $48
	'I' = $49
	'J' = $4A
	'K' = $4B
	'L' = $4C
	'M' = $4D
	'N' = $4E
	'O' = $4F
	'P' = $50
	'Q' = $51
	'R' = $52
	'S' = $53
	'T' = $54
	'U' = $55
	'V' = $56
	'W' = $57
	'X' = $58
	'Y' = $59
	'Z' = $5A
	
	'_' = $5F
	
	'a' = $61
	'b' = $62
	'c' = $63
	'd' = $64
	'e' = $65
	'f' = $66
	'g' = $67
	'h' = $68
	'i' = $69
	'j' = $6A
	'k' = $6B
	'l' = $6C
	'm' = $6D
	'n' = $6E
	'o' = $6F
	'p' = $70
	'q' = $71
	'r' = $72
	's' = $73
	't' = $74
	'u' = $75
	'v' = $76
	'w' = $77
	'x' = $78
	'y' = $79
	'z' = $7A
endmacro
	
	
	
; Handles checking if any of the allowed buttons is pressed in stuff like the "!press_button" commands or options.
	
macro vwf_check_if_any_button_pressed(button_mask)	
	lda $18
	xba
	
	; RPG Hacker: Not sure, if this part is really necessary. From what I understand, the highest two bits of $16
	; are set if either of (A/B) or (X/Y) is pressed. I want to get X or Y separately, though, so I clear out these
	; bits if $18 indicates that either A or X are currently pressed. I feel like there should be a more
	; straight-forward way of querying the B and Y buttons specifically?
	lda $18
	eor.b #%11000000
	ora.b #%00111111
	and $16
	
	rep #$20
	and<button_mask>
	sep #$20	
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
	; This code should never get executed. It's literally only here because
	; static freespace requires an autoclean. A prot won't work.
	autoclean jml SharedRoutinesJumpTable
	nop

; SRAM expansion ($07 => 2^7 kb = 128 kb)
if !vwf_patch_sram_expansion != false && read1(remap_rom($00FFD8)) < $07
	org remap_rom($00FFD8)
		db $07
endif

; Hijack reserve item box draw routine to hide the item when a dialog is open.
org remap_rom($009090)
	jml CheckHideReserveItem
	nop





;;;;;;;;;;;;;;;;;
;MAIN CODE START;
;;;;;;;;;;;;;;;;;

freecode : prot Kleenex

FreecodeStart:





;;;;;;;;;;;;;;;;;
;Shared Routines;
;;;;;;;;;;;;;;;;;

SharedRoutines:
	incsrc vwfroutines.asm	

SharedRoutinesTable:
	%vwf_generate_shared_routines_table()





;;;;;;;;;;;;;;;;;;;;
;RAM Initialization;
;;;;;;;;;;;;;;;;;;;;

; This section handles RAM initialization. It initializes the used
; RAM addresses at game startup, title screen and Game Over to
; prevent glitches and possible crashes.

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
	sta !vwf_mode
	sta !vwf_message
	sta !vwf_message+1

	lda #!vwf_default_text_box_bg_pattern	; Set default values
	sta !vwf_box_bg
	lda #!vwf_default_text_box_frame
	sta !vwf_box_frame

	lda.b #!vwf_default_text_box_bg_color
	sta !vwf_box_color
	lda.b #!vwf_default_text_box_bg_color>>8
	sta !vwf_box_color+1
	rts
	
	

InitVWFRAM:
	jsr InitRAM
	lda !vwf_mode
	inc
	sta !vwf_mode
	jmp Buffer_End

InitRAM:
	phx
	rep #$30
	ldx #$0000
	lda #$0000

.InitVarRAM
	sta !vwf_var_ram+!vwf_ram_clear_start_pos,x	; Initialize RAM
	inx #2
	cpx #!vwf_var_rampos-!vwf_ram_clear_start_pos	; Number of bytes
	bcc .InitVarRAM
	sep #$30
	
	lda #$00
	sta !vwf_message_asm_enabled
.End
	plx
	rts

;;;;;;;;;;;;;;;;;;;;;;;
;Level Fade Out Hijack;
;;;;;;;;;;;;;;;;;;;;;;;

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
	lda !vwf_mode					;\ If no VWF message is active, return.
	beq .NotActive					;/
.Entry2
	cmp #$09					;\ If not in VWF mode 09 (display text), don't increment the VWF mode here
	bne .NotTextCreation				;/
	inc						;\ Force the text box to close if one is already open.
	sta !vwf_mode					;/
.NotTextCreation
	inc remap_ram($0DB1)				; Delay the fade out from happpening
	jsr Buffer					; Run the VWF buffer code.
.NotActive
	rts
	
	
	
	

;;;;;;;;;;;;;;;;;;;;
;Message Box Hijack;
;;;;;;;;;;;;;;;;;;;;

; RPG Hacker: This needs to go right in front of OriginalMessageBox.
; It's the pointer to the SharedRoutines table, and Asar will search
; backwards from OriginalMessageBox to find it.
pushtable

%vwf_label_name_ascii_table()

db "VWFR"
dl SharedRoutinesTable

cleartable


; This hijacks SMW's original message routine to work with VWF
; dialogues.

OriginalMessageBox:
	; Our VWF processing needs to run, even if the game frame itself doesn't.
	; So we just do it before we decide to skip the frame simulation.
	jsl VWFBufferRt

	lda remap_ram($1426)
	beq .NoOriginalMessageBoxRequested
	
if !vwf_hijack_message_box == true
	ldx #$00
	;lda !vwf_mode	; Already displaying a message?
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
	jsl VWF_DisplayAMessage
else	
	jsl remap_rom($05B10C)	; Run original message box
	jml remap_rom($00A1E3)	; Skip frame simulation
endif
	
.NoOriginalMessageBoxRequested
	; New code: If our own message box is open, also don't simulate frame.
	lda !vwf_freeze_sprites
	beq .RunGameFrame
	
	jml remap_rom($00A1E3)	; Skip frame simulation
	
.RunGameFrame
	jml remap_rom($00A1E4)	; Don't skip frame simulation





;;;;;;;;;;;;;;;;;;;;;;;;;
;Reserve Item Box Hijack;
;;;;;;;;;;;;;;;;;;;;;;;;;

CheckHideReserveItem:
	lda !vwf_mode
	bne .Hide
	
	ldy.w remap_ram($0DC2)
	beq .Hide
	
	jml remap_rom($009095)

.Hide
	jml remap_rom($0090D0)





;;;;;;;;;;;;
;NMI Hijack;
;;;;;;;;;;;;

; This changes the NMI Routine to move layer 3 and disable IRQ during
; dialogues.

NMIHijack:
	stz $11
	lda !vwf_mode
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
	lda !vwf_active_flag				;\ Is another message trying to display?
	beq .NotForceClose				;/ If not, skip past this code
	lda !vwf_mode					;\ Did the currently active message finish closing?
	beq .NotActive					;/ If so, make the new message appear
	cmp #$09					;\ Is the previous message in VWF mode 09 (display text)?
	bne .NotTextCreation				;/ If not, don't advance the VWF mode
	inc						;\ Increment the VWF mode to skip past the display text mode.
	sta !vwf_mode					;/
.NotTextCreation
	bra .NotForceClose

.NotActive
	lda #$01
	sta !vwf_mode
	lda #$00
	sta !vwf_active_flag
	sta !vwf_message_asm_enabled
	bra .End

.NotForceClose
	lda !vwf_mode	; Prepare jump to routine
	beq .End
	cmp #$01					; If in VWF mode 01 (initialize RAM), don't run the MessageASM code
	beq .NoMessageASM
	
	lda !vwf_message_asm_enabled
	beq .NoMessageASM
	
	lda !vwf_message_asm_loc	; Run whatever MessageASM routine was defined in the message header.
	sta $00
	lda !vwf_message_asm_loc+1
	sta $01
	lda !vwf_message_asm_loc+2
	sta $02
	
	phb
	phk
	pea .MessageASMEnd-1
	
	lda $02
	pha
	plb						
	
	jml [$0000]
	
.MessageASMEnd
	plb
	
.NoMessageASM
	lda !vwf_mode
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
	dw InitBoxPalette,BufferWindow,VWFInit,TextCreation,CollapseWindow
	dw .End,.End,.End,.End,.End





VWFSetup:
	lda #$00	;\ Ensure that the !vwf_end_dialog flag gets properly cleared
	sta !vwf_end_dialog	;/
	jsr GetMessage
	jsr LoadHeader
	jmp Buffer_End

LoadHeader:
	lda !vwf_text_source
	sta $00
	lda !vwf_text_source+1
	sta $01
	lda !vwf_text_source+2
	sta $02

	ldy #$00

if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$00],y	; Font
	sta !vwf_font
	iny
endif

	lda [$00],y	; X position
	lsr #3
	sta !vwf_x_pos

	rep #$20	; Y position
	lda [$00],y
	xba
	and #$07C0
	lsr #6
	sep #$20
	sta !vwf_y_pos
	iny

	lda [$00],y	; Width
	and #$3C
	lsr #2
	sta !vwf_width

	rep #$20	; Height
	lda [$00],y
	xba
	and #$03C0
	lsr #6
	sep #$20
	sta !vwf_height
	iny

	lda [$00],y	; Edge
	and #$3C
	lsr #2
	sta !vwf_edge

	rep #$20	; Space
	lda [$00],y
	xba
	and #$03C0
	lsr #6
	sep #$20
	sta !vwf_space
	iny

	lda [$00],y	; Text speed
	and #$3F
	sta !vwf_frames
	iny

	lda.b #$00	; Auto wait
	sta !vwf_auto_wait_num_frames
	lda [$00],y
	sta !vwf_auto_wait
	cmp.b #VWF_AutoWait.WaitFrames.Start
	bcc .NoAutoWaitFrames
	
	iny
	lda [$00],y
	sta !vwf_auto_wait_num_frames
	
.NoAutoWaitFrames
	iny

	lda [$00],y	; Box creation style
	lsr #4
	and #%00001111
	sta !vwf_box_create	
	
	lda [$00],y		; Message skip flag
	and.b #%00000010
	lsr
	sta !vwf_skip_message_flag
	lda #$00
	sta !vwf_message_was_skipped
	lda [$00],y		; Message ASM Flag
	and.b #%00000001
	beq .NoMessageASM
	lda #$01
	bra .StoreMessageASMSetting
.NoMessageASM
	lda #$00
.StoreMessageASMSetting
	sta !vwf_message_asm_enabled
	iny

	lda [$00],y	; Letter color
	sta !vwf_box_color+2
	iny
	lda [$00],y
	sta !vwf_box_color+3
	iny

	lda [$00],y	; Shading color
	sta !vwf_box_color+4
	iny
	lda [$00],y
	sta !vwf_box_color+5
	iny

	lda [$00],y	; Freeze sprites?
	lsr #7
	sta !vwf_freeze_sprites
	
	lda [$00],y	; Letter palette
	and #$70
	lsr #4
	sta !vwf_box_palette

	lda [$00],y	; Text alignment
	and #$08
	lsr #3
	sta !vwf_text_alignment

	lda [$00],y	; Speed up
	and #$04
	lsr #2
	sta !vwf_speed_up

	lda [$00],y	; Disable sounds
	and #$01
	sta !vwf_sound_disabled
	iny

	lda !vwf_sound_disabled
	bne .NoSounds
	rep #$20	; SFX banks
	lda [$00],y
	and #$00C0
	lsr #6
	clc
	adc #$1DF9
	sta !vwf_beep_bank
	lda [$00],y
	and #$0030
	lsr #4
	clc
	adc #$1DF9
	sta !vwf_beep_end_bank
	lda [$00],y
	and #$000C
	lsr #2
	clc
	adc #$1DF9
	sta !vwf_beep_cursor_bank
	lda [$00],y
	and #$0003
	clc
	adc #$1DF9
	sta !vwf_beep_choice_bank
	sep #$20
	iny

	lda [$00],y	; SFX numbers
	sta !vwf_beep
	iny
	lda [$00],y
	sta !vwf_beep_end
	iny
	lda [$00],y
	sta !vwf_beep_cursor
	iny
	lda [$00],y
	sta !vwf_beep_choice
	iny

.NoSounds
	lda !vwf_skip_message_flag
	beq .NoMessageSkipPointer
	rep #$21
	lda [$00],y		; Message skip location (address)
	sta !vwf_skip_message_loc
	sep #$20
	iny
	iny
	lda [$00],y		; Message skip location (bank)
	sta !vwf_skip_message_loc+2
	iny
	
.NoMessageSkipPointer
	lda !vwf_message_asm_enabled
	beq .NoMessageASMPointer
	rep #$21
	lda [$00],y		; Message ASM location (address)
	sta !vwf_message_asm_loc
	sep #$20
	iny
	iny
	lda [$00],y		; Message ASM location (bank)
	sta !vwf_message_asm_loc+2
	iny

.NoMessageASMPointer
	tya
	sta $03
	stz $04
	rep #$21
	lda $00
	adc $03
	sta !vwf_text_source
	sep #$20


.ValidationChecks
	lda !vwf_width	; Validate all inputs
	cmp #$10
	bcc .WidthCheck2
	lda #$0F
	sta !vwf_width
	bra .WidthOK

.WidthCheck2
	cmp #$00
	bne .WidthOK
	lda #$01
	sta !vwf_width


.WidthOK
	lda !vwf_height
	cmp #$0E
	bcc .HeightCheck2
	lda #$0D
	sta !vwf_height
	bra .HeightOK

.HeightCheck2
	cmp #$00
	bne .HeightOK
	lda #$01
	sta !vwf_height


.HeightOK
	lda !vwf_width
	asl
	inc #2
	sta $0F
	clc
	adc !vwf_x_pos
	cmp #$21
	bcc .XPosOK
	lda #$20
	sec
	sbc $0F
	sta !vwf_x_pos


.XPosOK
	lda !vwf_height
	asl
	inc #2
	sta $0F
	clc
	adc !vwf_y_pos
	cmp #$1D
	bcc .YPosOK
	lda #$1C
	sec
	sbc $0F
	sta !vwf_y_pos

.YPosOK
	lda !vwf_width
	cmp #$03
	bcs .EdgeOK
	lda !vwf_edge
	and #$07
	sta !vwf_edge
	lda !vwf_width
	cmp #$02
	bcs .EdgeOK
	lda #$00
	sta !vwf_edge


.EdgeOK
	lda !vwf_box_create
	cmp #$05
	bcc .StyleOK
	lda #$04
	sta !vwf_box_create

.StyleOK
	rts





BufferGraphics:
	lda !vwf_sub_step
	bne .Return

	jsr .Start
	
.Return
	jmp Buffer_End

.Start
	rep #$30
	ldx #$0000
	lda #$0000

.DrawEmpty
	sta !vwf_buffer_empty_tile,x	; Draw empty tile
	inx #2
	cpx #$0010
	bne .DrawEmpty
	sep #$30

	jsr ClearScreen

	; Copy text box graphics over to RAM

	%vwf_bwram_transfer($0010, !vwf_box_bg, BgPatterns, !vwf_buffer_bg_tile)
	%vwf_bwram_transfer($0090, !vwf_box_frame, Frames, !vwf_buffer_frame)

	rts


; This routine clears the screen by filling the tilemap with $00.

ClearScreen:
	phb
	lda.b #bank(!vwf_gfx_ram)
	pha
	plb

	lda.l Emptytile
	sta.l !vwf_tile
	lda.l !vwf_box_palette
	asl #2
	ora.l Emptytile+1
	sta.l !vwf_property
	rep.b #$20
	ldx.b #$6E
	lda.l !vwf_tile
	
.InitTilemap
	sta.w !vwf_buffer_text_box_tilemap+$0000,x
	sta.w !vwf_buffer_text_box_tilemap+$0070,x
	sta.w !vwf_buffer_text_box_tilemap+$00E0,x
	sta.w !vwf_buffer_text_box_tilemap+$0150,x
	sta.w !vwf_buffer_text_box_tilemap+$01C0,x
	sta.w !vwf_buffer_text_box_tilemap+$0230,x
	sta.w !vwf_buffer_text_box_tilemap+$02A0,x
	sta.w !vwf_buffer_text_box_tilemap+$0310,x
	sta.w !vwf_buffer_text_box_tilemap+$0380,x
	sta.w !vwf_buffer_text_box_tilemap+$03F0,x
	sta.w !vwf_buffer_text_box_tilemap+$0460,x
	sta.w !vwf_buffer_text_box_tilemap+$04D0,x
	sta.w !vwf_buffer_text_box_tilemap+$0540,x
	sta.w !vwf_buffer_text_box_tilemap+$05B0,x
	sta.w !vwf_buffer_text_box_tilemap+$0620,x
	sta.w !vwf_buffer_text_box_tilemap+$0690,x
	
	dex #2	
	bpl.b .InitTilemap
	
	sep.b #$20
	
	plb
	
	rts
	
	
	

; Calculates the start position and number of bytes to copy for the DMA in CreateWindow.
; This is mainly an optimization to use up less V-Blank time for smaller text boxes.
; Write the starting line number (Y position) to $7E0001 and the number of lines to draw
; to $7E0005.
SetWindowCopyArea:
	; First, we calculate the starting line.
	stz $00
	lda.b #$01
	sta $02
	jsr GetTilemapPos
	
	lda $03
	sta !vwf_create_window_start_pos
	lda $04
	sta !vwf_create_window_start_pos+1
	
	; Then we calculate the number of bytes we need to copy.
	; For this, we need to multiply the text box height with #$40 (64 in dec).
	; Since that's exactly 2^6, we can just ASL six times.
	; It's still quicker than an actual multiplication.
	lda.b #$00
	xba
	lda $05
	rep #$20
	
	; Sizes of 0 are bad, so make sure we calculate at last one line.
	bne .NotZero
	inc
	
.NotZero
	asl #6
	
	sta !vwf_create_window_length
	sep #$20
	
	rts




BufferWindow:
	lda !vwf_sub_step	; Buffer text box tilemap
	bne .SkipInit
	lda #$00	; Text box init
	sta !vwf_current_width
	sta !vwf_current_height
	lda !vwf_x_pos
	clc
	adc !vwf_width
	sta !vwf_current_x
	lda !vwf_y_pos
	clc
	adc !vwf_height
	sta !vwf_current_y
	lda #$01
	sta !vwf_sub_step

.SkipInit
	lda !vwf_box_create	; Prepare jump to routine
	asl
	tax
	jmp (.Routinetable,x)

.Routinetable
	dw .NoBox,.SoEBox,.SoMBox,.MMZBox,.InstBox

.End
	lda !vwf_current_y
	bpl .NoUnderflow
	lda.b #$00
	
.NoUnderflow
	sta $01
	lda !vwf_current_height
	inc #2
	sta $05
	
	clc
	adc $01
	
	cmp.b #28+1
	bcc .NoOverflow
	
	lda.b #28
	sec
	sbc $01
	sta $05
	
.NoOverflow
	jsr SetWindowCopyArea

	jmp Buffer_End



.NoBox
	lda #$02	; No text box
	sta !vwf_sub_step
	jmp .End



.SoEBox
	lda !vwf_x_pos
	sta !vwf_current_x
	lda !vwf_y_pos
	sta !vwf_current_y
	lda !vwf_width
	asl
	sta !vwf_current_width
	jsr DrawBox

	lda !vwf_height
	asl
	cmp !vwf_current_height
	bne .SoEEnd
	lda #$02
	sta !vwf_sub_step

.SoEEnd
	lda !vwf_current_height
	inc
	sta !vwf_current_height
	jmp .End



.SoMBox
	lda !vwf_width
	asl
	cmp !vwf_current_width
	beq .ExpandVert
	jsr SoMLine
	lda !vwf_current_width
	inc #2
	sta !vwf_current_width
	lda !vwf_current_x
	dec
	sta !vwf_current_x
	jmp .End

.ExpandVert
	lda !vwf_height
	asl
	cmp !vwf_current_height
	bcc .SoMEnd
	jsr DrawBox
	lda !vwf_current_height
	inc #2
	sta !vwf_current_height
	lda !vwf_current_y
	dec
	sta !vwf_current_y
	jmp .End

.SoMEnd
	lda #$02
	sta !vwf_sub_step
	jmp .End



.MMZBox
	lda !vwf_x_pos
	sta !vwf_current_x
	lda !vwf_y_pos
	sta !vwf_current_y
	lda !vwf_height
	asl
	sta !vwf_current_height
	jsr DrawBox

	lda !vwf_width
	asl
	cmp !vwf_current_width
	bne .MMZEnd
	lda #$02
	sta !vwf_sub_step

.MMZEnd
	lda !vwf_current_width
	inc
	sta !vwf_current_width
	jmp .End



.InstBox
	lda !vwf_x_pos
	sta !vwf_current_x
	lda !vwf_y_pos
	sta !vwf_current_y
	lda !vwf_width
	asl
	sta !vwf_current_width
	lda !vwf_height
	asl
	sta !vwf_current_height
	jsr DrawBox

.InstEnd
	lda #$02
	sta !vwf_sub_step
	jmp .End



SoMLine:
	lda !vwf_current_x
	sta $00
	lda !vwf_current_y
	sta $01
	lda #$01
	sta $02
	jsr GetTilemapPos
	rep #$21
	lda.w #!vwf_buffer_text_box_tilemap
	adc $03
	sta $03
	sep #$20
	lda.b #!vwf_buffer_text_box_tilemap>>16
	sta $05

	ldy #$00
	lda.b #!vwf_frame_palette<<2|$20
	xba
	jsr LineLoop

	ldy #$40
	lda.b #!vwf_frame_palette<<2|$A0
	xba
	jsr LineLoop
	rts


LineLoop:
	lda !vwf_current_width
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


; This routine takes the variables !vwf_current_x, !vwf_current_y,
; !vwf_current_width and !vwf_current_height to create a complete text box
; in RAM, utilizing all of the the subroutines below.

DrawBox:
	lda !vwf_current_x	; Create background
	sta $00
	lda !vwf_current_y
	sta $01
	lda.b #!vwf_buffer_text_box_tilemap
	sta $03
	lda.b #!vwf_buffer_text_box_tilemap>>8
	sta $04
	lda.b #!vwf_buffer_text_box_tilemap>>16
	sta $05
	lda !vwf_current_width
	sta $06
	lda !vwf_current_height
	sta $07
	jsr DrawBG

	lda !vwf_current_x	; Create frame
	sta $00
	lda !vwf_current_y
	sta $01
	lda.b #!vwf_buffer_text_box_tilemap
	sta $03
	lda.b #!vwf_buffer_text_box_tilemap>>8
	sta $04
	; RPG Hacker: Technically unneeded, because the function above never overwrites $05,
	; but I still prefer to have this here so that I don't wonder why it's missing every
	; single time. This "optimization" never really saved much, anyways.
	lda.b #!vwf_buffer_text_box_tilemap>>16
	sta $05
	lda !vwf_current_width
	sta $06
	lda !vwf_current_height
	sta $07
	jsr AddFrame
	rts


; This subroutine calculates the correct position of a tilemap with
; $7E0000 as X coordinate and $7E0001 as Y coordinate.
; If $7E0002 = $01 then the tilemap consists of two bytes per tile.
; The result is returned at $7E0003-$7E0004 to be added to the
; tilemap starting address after this routine is done.

GetTilemapPos:
	; We need to do the calculation in 16-bit mode, so we temporarily
	; copy our X position from $00 (8-bit) into $03 + $04 (16-bit).
	lda $00
	sta $03
	lda.b #$00
	sta $04
	
	xba
	lda $01
	
	rep #$21
	asl #5	; "asl #5" is equal to a multiplication by $20 (32)
	
	ldx $02
	beq .NoDouble
	
	asl		; An additional "asl" makes this a multiplication by $40 (64)
	
	adc $03
	
.NoDouble
	adc $03
	
	sta $03
	sep #$20

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

	lda !vwf_box_palette
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
	lda.b #!vwf_frame_palette<<2|$20
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
	lda !vwf_sub_step	; Collapse text box
	bne .SkipInit
	lda !vwf_width
	asl
	sta !vwf_current_width
	lda !vwf_height
	asl
	sta !vwf_current_height
	lda !vwf_x_pos	; Text box init
	sta !vwf_current_x
	lda !vwf_y_pos
	sta !vwf_current_y
	lda #$01
	sta !vwf_sub_step

.SkipInit
	lda !vwf_box_create	; Prepare jump to routine
	asl
	tax
	jmp (.Routinetable,x)

.Routinetable
	dw .NoBox,.SoEBox,.SoMBox,.MMZBox,.InstBox

.End
	; Since we're shrinking the text box, we might have to copy more tiles than the
	; actual text box size. That's what we use .AdditionalLineCopyTable for.
	lda !vwf_box_create
	asl
	tax
		
	lda !vwf_current_y
	sec
	sbc .AdditionalLineCopyTable,x
	; inc	
	bpl .NoUnderflow
	lda.b #$00
	
.NoUnderflow
	sta $01
	
	lda !vwf_current_height
	clc
	adc .AdditionalLineCopyTable+1,x
	inc #2
	sta $05
	
	clc
	adc $01
	
	cmp.b #28+1
	bcc .NoOverflow
	
	lda.b #28
	sec
	sbc $01
	sta $05
	
.NoOverflow
	jsr SetWindowCopyArea
	
	lda !vwf_sub_step
	cmp #$02	
	bne .NotDone

	; RPG Hacker: Check if we still have a message box stored to show after the current one.
	lda !vwf_swap_message_settings
	and.b #%10000010
	cmp.b #%10000010
	bne .NoNextMessage
	
	jsr PrepareNextMessage
	
.NoNextMessage
.NotDone
	jmp Buffer_End
	
.AdditionalLineCopyTable
	; This table defines how many extra lines (in addition to the lines covering the text box)
	; need to be copied to the screen when collapsing a text box. The idea here is that shrinking
	; the text box should also erase tiles from the previous text box.
	; Each entry here is two bytes, the first one meaning "Y pos to subtract" and the second
	; "height to add".
	db 0, 0; .NoBox
	db 0, 2; .SoEBox
	db 1, 2; .SoMBox
	db 0, 0; .MMZBox
	db 0, 0; .InstBox



.NoBox
	jsr ClearScreen
	lda #$02
	sta !vwf_sub_step
	jmp .End



.SoEBox
	lda !vwf_x_pos
	sta !vwf_current_x
	lda !vwf_y_pos
	sta !vwf_current_y
	lda !vwf_width
	asl
	sta !vwf_current_width
	jsr DrawBox

	lda !vwf_y_pos
	clc
	adc !vwf_current_height
	inc #2
	sta $01
	jsr ClearHoriz

	lda !vwf_current_height
	bne .SoEEnd
	lda #$02
	sta !vwf_sub_step

.SoEEnd
	lda !vwf_current_height
	dec
	sta !vwf_current_height
	jmp .End



.SoMBox
	lda !vwf_current_height
	beq .CollapseHorz

	lda !vwf_current_y
	sta $01
	jsr ClearHoriz

	lda !vwf_current_y
	clc
	adc !vwf_current_height
	inc #1
	sta $01
	jsr ClearHoriz

	lda !vwf_current_height
	dec #2
	sta !vwf_current_height
	lda !vwf_current_y
	inc
	sta !vwf_current_y

	lda !vwf_current_height
	jsr DrawBox
	jmp .End

.CollapseHorz
	lda !vwf_current_width
	beq .SoMEnd

	lda !vwf_current_x
	sta $00
	jsr ClearVert

	lda !vwf_current_x
	clc
	adc !vwf_current_width
	inc #1
	sta $00
	jsr ClearVert

	lda !vwf_current_width
	dec #2
	sta !vwf_current_width
	lda !vwf_current_x
	inc
	sta !vwf_current_x

	jsr SoMLine
	jmp .End

.SoMEnd
	lda #$02
	sta !vwf_sub_step
	jmp .End



.MMZBox
	lda !vwf_x_pos
	sta !vwf_current_x
	lda !vwf_y_pos
	sta !vwf_current_y
	lda !vwf_height
	asl
	sta !vwf_current_height
	jsr DrawBox

	lda !vwf_x_pos
	clc
	adc !vwf_current_width
	inc #2
	sta $00
	jsr ClearVert

	lda !vwf_current_width
	bne .MMZEnd
	lda #$02
	sta !vwf_sub_step

.MMZEnd
	lda !vwf_current_width
	dec
	sta !vwf_current_width
	jmp .End




.InstBox
	jsr ClearScreen
	lda #$02
	sta !vwf_sub_step
	jmp .End



; Clears a vertical line at X position $7E0000.

ClearVert:
	lda Emptytile
	sta !vwf_tile
	lda !vwf_box_palette
	asl #2
	ora Emptytile+1
	sta !vwf_property
	stz $01
	lda #$01
	sta $02
	jsr GetTilemapPos
	lda.b #!vwf_buffer_text_box_tilemap>>16
	sta $05
	rep #$21
	lda.w #!vwf_buffer_text_box_tilemap
	adc $03
	sta $03
	ldy #$00

.FillLoop
	lda !vwf_tile
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
	sta !vwf_tile
	lda !vwf_box_palette
	asl #2
	ora Emptytile+1
	sta !vwf_property
	stz $00
	lda #$01
	sta $02
	jsr GetTilemapPos
	lda.b #!vwf_buffer_text_box_tilemap>>16
	sta $05
	rep #$21
	lda.w #!vwf_buffer_text_box_tilemap
	adc $03
	sta $03
	ldy #$00
	lda !vwf_tile

.FillLoop
	sta [$03],y
	iny #2
	cpy #$40
	bne .FillLoop
	sep #$20
	rts





VWFInit:
	lda !vwf_sub_step
	bne .End
	
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
	lda !vwf_box_palette	; Update letter color
	asl #2
	inc
	inc
	asl
	phy
	tay
	ldx #$00
	
	; RPG Hacker: Because an "Absolute Long Indexed, Y" mode doesn't exist...
	lda.b #!vwf_palette_backup_ram
	sta $00
	lda.b #!vwf_palette_backup_ram>>8
	sta $01
	lda.b #!vwf_palette_backup_ram>>16
	sta $02

.BoxColorLoop
	lda !vwf_box_color+2,x
	sta [$00],y
	inx
	iny
	cpx #$04
	bne .BoxColorLoop

	ply
	lda #$01
	sta !vwf_palette_upload

	; RPG Hacker: Without this, the very first beginning of a text box would not get detected correctly.
	sta !vwf_at_start_of_text
	
	lda #$00
	sta !vwf_char_offset
if !vwf_bit_mode == VWF_BitMode.16Bit	
	sta !vwf_char_offset+1
endif

if !use_sa1_mapping
	rtl
else
	jsr ClearBox

.End
	jmp Buffer_End
endif

InitLine:
	lda #$01
	sta !vwf_first_tile
	lda !vwf_edge	; Reset pixel count
	sta !vwf_current_pixel
	lda #$00
	sta !vwf_width_carry
	sta !vwf_buffer_index

	lda !vwf_width	; Reset available width
	asl #4
	sec
	sbc !vwf_current_pixel
	sec
	sbc !vwf_current_pixel
	sta !vwf_max_width

	lda !vwf_current_choice
	beq .NoChoicePixels
	lda !vwf_current_pixel
	clc
	adc !vwf_choice_width
	sta !vwf_current_pixel
	lda !vwf_max_width
	sec
	sbc !vwf_choice_width
	sta !vwf_max_width
	jmp .TextAlignmentLeft

.NoChoicePixels
	lda !vwf_text_alignment	; Centered alignment?
	bne .TextAlignmentCentered
	jmp .TextAlignmentLeft

.TextAlignmentCentered
	lda #$00
	sta !vwf_char_width
	sta !vwf_current_width
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_char
	sta $0A
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda !vwf_char
	sta $0A
	sep #$20
endif

	jsr WordWidth_Backup

.WidthBegin
	lda !vwf_current_y      ;\ This fixes an oddity where the next line's width is calculated when at the end of a text box.
	inc #2                  ;| This would cause a text macro to break if it spanned more than one text box.
	cmp !vwf_max_height     ;|
	bcs .AtEndOfTextBox     ;/
	jsr WordWidth

.AtEndOfTextBox
	lda !vwf_width_carry
	beq .NoCarry
	lda #$00
	sta !vwf_width_carry
	lda !vwf_current_width
	bne .WidthEnd
	lda !vwf_char_width
	sta !vwf_current_width
	bra .WidthEnd

.NoCarry
	lda !vwf_char_width
	sta !vwf_current_width
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda $0A
	cmp #$FE
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda $0A
	cmp #$FFFE
	sep #$20
endif
	bne .WidthEnd

	lda !vwf_char_width
	clc
	adc !vwf_space
	bcs .WidthEnd
	cmp !vwf_max_width
	bcs .WidthEnd
	sta !vwf_char_width
	bra .WidthBegin

.WidthEnd
	lda !vwf_max_width
	sec
	sbc !vwf_current_width
	lsr
	clc
	adc !vwf_current_pixel
	sta !vwf_current_pixel
	
	jsr WordWidth_Restore

.TextAlignmentLeft
	lda #$00
	sta !vwf_current_x
	lda !vwf_current_y
	inc #2
	sta !vwf_current_y
	cmp !vwf_max_height
	bcc .NoClearBox
	lda !vwf_choices
	beq .NoChoicesClear
	lda #$01
	sta !vwf_cursor_move
	bra .NoClearBox

.NoChoicesClear
	lda #$01
	sta !vwf_clear_box

	jsr ApplyAutoWait

.NoClearBox
	rep #$20
	lda !vwf_tile	; Increment tile counter
	inc #2
	sta !vwf_tile
	and #$03FF
	asl #4
	clc
	adc.w #!vwf_buffer_empty_tile	; Add starting address
	sta $09
	sep #$20
	lda.b #!vwf_buffer_empty_tile>>16
	sta $0B

if !use_sa1_mapping
	lda #$01
	sta $2250
endif
	lda !vwf_current_pixel
	sta.w select(!use_sa1_mapping,$2251,$4204)

.NoNewTile
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
	clc
	adc !vwf_tile
	sta !vwf_tile
	sep #$20
	lda.w select(!use_sa1_mapping,$2306,$4214)
	clc
	adc !vwf_current_x
	sta !vwf_current_x

	lda !vwf_current_choice
	beq .End
	dec
	sta !vwf_current_choice
	bne .End
	lda #$01
	sta !vwf_cursor_move

.End
	rts
	
	
ApplyAutoWait:
	lda !vwf_auto_wait
	beq .Return
	cmp.b #VWF_AutoWait.WaitForA
	beq .ButtonAWait
	cmp.b #VWF_AutoWait.WaitForButton
	beq .ButtonDefaultWait
	lda !vwf_auto_wait_num_frames
	sta !vwf_wait
	bra .Return

.ButtonAWait
	lda.b #VWF_ControllerButton.A
	sta !vwf_wait_for_button_mask
	lda.b #VWF_ControllerButton.A>>8
	sta !vwf_wait_for_button_mask+1
	bra .ButtonWait
	
.ButtonDefaultWait
	lda.b #!vwf_default_advance_button_mask
	sta !vwf_wait_for_button_mask
	lda.b #!vwf_default_advance_button_mask>>8
	sta !vwf_wait_for_button_mask+1

.ButtonWait
	jsr EndBeep
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda #$FA
	sta !vwf_char
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda #$FFFA
	sta !vwf_char
	sep #$20
endif

.Return
	rts


ClearBox:
	jsr ClearScreen
	lda !vwf_box_create
	beq .Init
	lda !vwf_x_pos
	sta !vwf_current_x
	lda !vwf_y_pos
	sta !vwf_current_y
	lda !vwf_width
	asl
	sta !vwf_current_width
	lda !vwf_height
	asl
	sta !vwf_current_height
	jsr DrawBox

.Init
	lda #$FE
	sta !vwf_current_y
	lda #$09
	sta !vwf_tile
	lda !vwf_box_palette
	asl #2
	ora Emptytile+1
	sta !vwf_property
	lda !vwf_height
	asl
	sta !vwf_max_height
	jsr InitLine
	rts


GetMessage:
	rep #$20
	lda !vwf_message
	cmp.w #(PointersEnd-Pointers)/3
	bcc .IdOkay
	
	; ID is too high. Let's load an error handling message.
	lda.w #HandleUndefinedMessage0
	sta !vwf_text_source
	sep #$20
	lda.b #HandleUndefinedMessage0>>16
	sta !vwf_text_source+2
	rts

.IdOkay
	sep #$20
	lda !vwf_message
	sta.w select(!use_sa1_mapping,$2251,$211B)
	lda !vwf_message+1
	sta.w select(!use_sa1_mapping,$2252,$211B)
	stz.w select(!use_sa1_mapping,$2250,$211C)
	lda #$03
	sta.w select(!use_sa1_mapping,$2253,$211C)
if !use_sa1_mapping
	stz $2254
	nop
endif
	rep #$21
	lda.w select(!use_sa1_mapping,$2306,$2134)
	adc.w #Pointers
	sta $00
	lda.w #Pointers>>16
	sta $02
	ldy #$02
	lda [$00]
	sta !vwf_text_source
	sep #$20
	lda [$00],y
	sta !vwf_text_source+2
	rts





TextCreation:
	lda !vwf_clear_box_remaining_bytes
	ora !vwf_clear_box_remaining_bytes+1
	beq .NotWaitingForClearBox
	jmp .End
	
.NotWaitingForClearBox
	lda !vwf_clear_box
	beq .NoInitClearBox
	
	jsr ClearBox
	
	stz $00
	lda !vwf_y_pos
	inc
	sta $01
	lda.b #$01
	sta $02
	jsr GetTilemapPos
	
	lda.b #$00
	sta !vwf_clear_box
	xba
	lda !vwf_height
	
	rep #$20
	asl									; One standalone "asl" because !vwf_height assumes 16-pixel tiles (we need 8-pixel tiles)
	asl #6								; "asl #6" effectively does a multiplication by $40 (64)
	sta !vwf_clear_box_remaining_bytes
	
	lda $03
	lsr									; We need to half this address, because it's being used as a VRAM offset
	sta !vwf_vram_pointer	
	sep #$20
	
	jmp .End

.NoInitClearBox	
	lda !vwf_skip_message_flag
	bne .CheckSkipLocationReached
	jmp .DontSkip
	
	; RPG Hacker: If skipping is enabled, check if we're about to cross the skip location.
	; If so, disable skipping for the current message. This is so that if someone presses
	; start after reaching the skip location, it won't loop around and display the skip
	; text again.
.CheckSkipLocationReached
	lda !vwf_text_source
	cmp !vwf_skip_message_loc
	bne .SkipLocationNotReached
	lda !vwf_text_source+1
	cmp !vwf_skip_message_loc+1
	bne .SkipLocationNotReached
	lda !vwf_text_source+2
	cmp !vwf_skip_message_loc+2
	bne .SkipLocationNotReached
	
	lda #$00
	sta !vwf_skip_message_flag
	bra .DontSkip
	
.SkipLocationNotReached
	lda !vwf_char
	cmp #$ED
	beq .DontSkip
	cmp #$FF
	beq .DontSkip
	; Check if we're trying to skip this message.
	%vwf_check_if_any_button_pressed(".w #!vwf_skip_message_button_mask")
	beq .DontSkip			;
	rep #$20
	lda !vwf_skip_message_loc
	sta !vwf_text_source
if !vwf_bit_mode == VWF_BitMode.16Bit
	lda #$FFEB
	sta !vwf_char
endif
	sep #$20
	lda !vwf_skip_message_loc+2
	sta !vwf_text_source+2
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda #$EB
	sta !vwf_char
endif
	lda #$00
	sta !vwf_wait
	sta !vwf_cursor_move
	sta !vwf_cursor_upload
	sta !vwf_cursor_end
	sta !vwf_choices
	sta !vwf_current_choice
	sta !vwf_skip_message_flag
	inc
	sta !vwf_message_was_skipped
	sta !vwf_clear_box
	jmp TextCreation

.DontSkip
	lda !vwf_wait
	beq .NoWait
	jmp .End

.NoWait
	lda !vwf_cursor_move
	bne .Cursor
	jmp .NoCursor


.Cursor
	lda !vwf_current_choice
	bne .NotZeroCursor
	lda #$01
	sta !vwf_current_choice
	stz $0F
	jsr BackupTilemap
	jmp .DisplayCursor

.NotZeroCursor
	lda $16
	and #$0C
	bne .CursorMove
	%vwf_check_if_any_button_pressed(".w #!vwf_select_choice_button_mask")
	bne .ChoicePressed
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
	lda !vwf_current_choice
	inc
	sta !vwf_current_choice
	bra .CursorSFX

.CursorUp
	lda !vwf_current_choice
	dec
	sta !vwf_current_choice

.CursorSFX
	jsr CursorBeep
	lda !vwf_current_choice
	beq .ZeroCursor
	lda !vwf_choices
	cmp !vwf_current_choice
	bcs .DisplayCursor
	lda #$01
	sta !vwf_current_choice
	bra .DisplayCursor

.ZeroCursor
	lda !vwf_choices
	sta !vwf_current_choice

.DisplayCursor
	lda #$01
	sta !vwf_cursor_upload
	stz $0F
	jsr BackupTilemap
	%vwf_mvn_transfer($0060, !vwf_buffer_cursor, !vwf_tile_ram, !vwf_cpu_sa1)	

	lda !vwf_edge
	lsr #3
	sta !vwf_current_x
	lda !vwf_current_y
	pha
	sec
	sbc !vwf_choices
	sec
	sbc !vwf_choices
	sta !vwf_current_y
	lda !vwf_current_choice
	dec
	asl
	clc
	adc !vwf_current_y
	sta !vwf_current_y
	lda #$00
	sta !vwf_char_width
	lda !vwf_edge
	and #$07
	clc
	adc !vwf_choice_width
	sta !vwf_current_pixel
	rep #$20
	lda !vwf_tile
	and #$FC00
	ora #$038A
	sta !vwf_tile
	sep #$20
	jsr WriteTilemap
	pla
	sta !vwf_current_y
	
	lda !vwf_choice_space
	cmp #$08
	bcs .NoChoiceCombine
	lda !vwf_choice_width
	clc
	adc !vwf_edge
	lsr #3
	asl
	tax
	rep #$20
	lda !vwf_buffer_choice_backup,x
	and #$03FF
	asl #4
	clc
	adc.w #!vwf_buffer_empty_tile
	sta $03
	sep #$20
	lda.b #!vwf_buffer_empty_tile>>16
	sta $05

	lda !vwf_choice_width
	clc
	adc !vwf_edge
	lsr #3
	asl #5
	tax
	ldy #$00

.CombineLoop
	lda !vwf_tile_ram,x
	inx
	ora !vwf_tile_ram,x
	dex
	eor #$FF
	and [$03],y
	ora !vwf_tile_ram,x
	sta !vwf_tile_ram,x
	inx
	iny
	cpy #$20
	bne .CombineLoop

.NoChoiceCombine
	jmp .End

.CursorEnd
	lda #$01
	sta !vwf_cursor_end
	jmp .End


.NoCursor
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_char
	cmp #$FA
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda !vwf_char
	cmp #$FFFA
	sep #$20
endif
	bne .NoButton
	jmp .End

.NoButton
	; RPG Hacker: This was previously called from the SNES CPU, which isn't supported, because
	; GetTilemapPos uses SA-1 multiplication in SA-1 builds. Therefore, I'm preprocessing the address
	; and storing it in a variable for later use.
	lda !vwf_x_pos
	clc
	adc !vwf_width
	inc
	sta $00
	lda !vwf_height
	asl
	clc
	adc !vwf_y_pos
	inc
	sta $01
	stz $02
	jsr GetTilemapPos
	rep #$21
	lda #$5C80
	adc $03
	sta !vwf_arrow_vram
	sep #$20

	lda #$00
	sta !vwf_at_start_of_text
	jsr ReadPointer
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$00]
	sta !vwf_char
	cmp.b #!vwf_lowest_reserved_hex
	bcs .Jump
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda [$00]
	sta !vwf_char
	inc $00
	cmp.w #!vwf_lowest_reserved_hex
	bcs .Jump
	sep #$20
endif
	jmp .WriteLetter

.Jump
	sec
if !vwf_bit_mode == VWF_BitMode.8Bit
	sbc.b #!vwf_lowest_reserved_hex
	asl
	tax
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	sbc.w #!vwf_lowest_reserved_hex
	sep #$20
	asl
	tax
	jsr IncPointer
endif
	jmp (.Routinetable,x)

.Routinetable
	dw .E6_ExitToOw
	dw .E7_EndTextMacro
	dw .E8_TextMacro
	dw .E9_TextMacroGroup
	dw .EA_CharOffset
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
	
.E6_ExitToOw
	ldy #$01
	lda [$00],y
	inc
	sta !vwf_exit_to_ow
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton	

.E7_EndTextMacro
	jsr HandleVWFStackByte1_Pull
	sta !vwf_text_source+2
	jsr HandleVWFStackByte1_Pull
	sta !vwf_text_source+1
	jsr HandleVWFStackByte1_Pull
	sta !vwf_text_source
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
	cmp #!vwf_num_reserved_text_macros*3
	bcs ..NotBufferedText
	tax
	lda !vwf_tm_buffers_text_pointers,x
	sta !vwf_text_source
	sep #$30
	lda !vwf_tm_buffers_text_pointers+2,x
	bra +

..NotBufferedText
	sec
	sbc #!vwf_num_reserved_text_macros*3
	tax
	lda TextMacroPointers,x
	sta !vwf_text_source
	sep #$30
	lda TextMacroPointers+2,x
+
	sta !vwf_text_source+2	
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
	adc.w #!vwf_num_reserved_text_macros
	
	jmp .TextMacroShared
	
.EA_CharOffset
	ldy #$01
	lda [$00],y
	sta !vwf_char_offset
if !vwf_bit_mode == VWF_BitMode.16Bit
	iny
	lda [$00],y
	sta !vwf_char_offset+1
	jsr IncPointer
endif
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.EB_LockTextBox
	lda #$01
	sta !vwf_force_sfx
if !vwf_bit_mode == VWF_BitMode.16Bit
	; RPG Hacker: In 16-bit mode, the $FF part of the command is automatically skipped.
	; Need to decrement the pointer here, otherwise the text box will explode.
	jsr DecPointer
endif
	jmp .End

.EC_PlayBGM
	ldy #$01
	lda [$00],y
	sta remap_ram($1DFB)
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.ED_ClearBox
	lda !vwf_choices
	beq .EDNoChoices
	jmp .FD_LineBreak

.EDNoChoices
	lda #$01
	sta !vwf_clear_box
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
	sta !vwf_palette_backup_ram,x
	iny
	lda [$00],y
	sta !vwf_palette_backup_ram+1,x
	plx
	lda #$01
	sta !vwf_palette_upload
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
	sta !vwf_teleport_dest
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
	sta !vwf_teleport_prop
	lda #$01
	sta !vwf_teleport
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.F0_Choices
	jsr ReadPointer

	lda !vwf_first_tile
	eor #$01
	sta !vwf_no_choice_lb

	ldy #$01
	lda [$00],y
	lsr #4
	pha
	cmp !vwf_height
	bcc .ChoiceStore
	beq .ChoiceStore
	lda !vwf_height

.ChoiceStore
	sta !vwf_choices
	inc
	sta !vwf_current_choice
	lda !vwf_max_height
	sec
	sbc !vwf_current_y
	beq .F0ClearForce
	sec
	sbc !vwf_no_choice_lb
	sec
	sbc !vwf_no_choice_lb
	lsr
	cmp !vwf_choices
	bcs .CreateCursor

.F0ClearForce
	pla
	lda #$01
	sta !vwf_clear_box
	jmp .F0ClearOptions

.CreateCursor
	lda [$00],y
	and #$0F
	sta !vwf_choice_space
	iny
	lda [$00],y
	sta !vwf_cursor
if !vwf_bit_mode == VWF_BitMode.16Bit
	iny
	lda [$00],y
	sta !vwf_cursor+1
	jsr IncPointer
endif
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer

	lda !vwf_text_source
	sta !vwf_choice_table
	lda !vwf_text_source+1
	sta !vwf_choice_table+1
	lda !vwf_text_source+2
	sta !vwf_choice_table+2
	lda !vwf_edge
	and #$07
	sta !vwf_current_pixel
	lda !vwf_first_tile
	sta !vwf_no_choice_lb
	lda #$01
	sta !vwf_first_tile
	
if !vwf_bit_mode == VWF_BitMode.16Bit
	lda !vwf_cursor+1
	sta !vwf_font
endif

	jsr GetFont

	rep #$20
	lda #$0001
	sta $0C
	lda.w #!vwf_cursor
	sta $00
	lda.w #!vwf_buffer_cursor
	sta $09
	sep #$20
	lda.b #!vwf_cursor>>16
	sta $02
	lda.b #!vwf_buffer_cursor>>16
	sta $0B

	lda !vwf_current_x
	pha
	lda !vwf_tile
	pha
	lda #$00
	sta !vwf_current_x

	lda !vwf_current_pixel
	sta $0E
	lda !vwf_first_tile
	sta $0F

	jsl VWF_GenerateVWF

	lda !vwf_char_width
	clc
	adc !vwf_choice_space
	sta !vwf_choice_width

	lda !vwf_box_create
	beq .F0NoBG

	rep #$20
	lda #$0006
	sta $06
	lda.w #!vwf_buffer_bg_tile
	sta $00
	lda.w #!vwf_buffer_cursor
	sta $03
	sep #$20
	lda.b #!vwf_buffer_bg_tile>>16
	sta $02
	lda.b #!vwf_buffer_cursor>>16
	sta $05

	jsl VWF_AddPattern

.F0NoBG
	rep #$20
	lda.w #!vwf_buffer_cursor
	sta $09
	sep #$20
	lda.b #!vwf_buffer_cursor>>16
	sta $0B

	lda !vwf_current_x
	asl #5
	clc
	adc $09
	sta $09

	lda !vwf_current_pixel
	clc
	adc !vwf_choice_space
	sta !vwf_choice_space
	cmp #$08
	bcs .NoChoiceWipe

	jsr WipePixels

.NoChoiceWipe
	pla
	sta !vwf_tile
	pla
	sta !vwf_current_x

	lda #$00
	sta $0D
	xba
	pla
	sta $0C
	asl
	clc
	adc $0C
	rep #$21
	adc !vwf_text_source
	sta !vwf_text_source
	sep #$20

	jsr InitLine
	lda !vwf_no_choice_lb
	beq .F0NotStart
	lda !vwf_current_y
	dec #2
	sta !vwf_current_y

.F0NotStart
	lda !vwf_clear_box
	beq .F0Return
	lda !vwf_current_choice
	inc
	sta !vwf_current_choice

.F0ClearOptions
	jsr ApplyAutoWait

.F0NoAutoWait
	jmp TextCreation

.F0Return
	jmp .NoButton

.F1_Execute
	ldy #$01
	lda [$00],y
	sta $03
	iny
	lda [$00],y
	sta $04
	iny
	lda [$00],y
	sta $05
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	
	phk
	pea .F1_ExecuteEnd-1
	
	jml [$0003]
	
.F1_ExecuteEnd
	jmp .NoButton

.F2_ChangeFont
	ldy #$01
	lda [$00],y
	sta !vwf_font
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.F3_ChangePalette
	lda !vwf_property
	and #$E3
	sta !vwf_property
	ldy #$01
	lda [$00],y
	asl #2
	inc
	asl
	phx
	tax
	lda [$00],y
	sta !vwf_box_palette
	asl #2
	ora !vwf_property
	sta !vwf_property
	lda !vwf_box_color
	sta !vwf_palette_backup_ram,x
	lda !vwf_box_color+1
	sta !vwf_palette_backup_ram+1,x
	lda #$01
	sta !vwf_palette_upload
	plx
	jsr IncPointer
	jsr IncPointer
	jmp .NoButton

.F4_Character
	jsr IncPointer
	jsr ReadPointer
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$00]
	sta !vwf_char
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda [$00]
	sta !vwf_char
	sep #$20
endif
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
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$0C]
	sta !vwf_routine
	lda #$FB
	sta !vwf_routine+1
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda [$0C]
	sta !vwf_routine
	sep #$20
	lda #$FB
	sta !vwf_routine+2
	lda #$FF
	sta !vwf_routine+3
endif
	rep #$20
	lda $00
	inc #4
	sta !vwf_routine+2+(!vwf_bit_mode*2)
	sep #$20
	lda $02
	sta !vwf_routine+4+(!vwf_bit_mode*2)
	lda.b #!vwf_routine
	sta !vwf_text_source
	lda.b #!vwf_routine>>8
	sta !vwf_text_source+1
	lda.b #!vwf_routine>>16
	sta !vwf_text_source+2
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
	sta !vwf_routine
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$0C]
	and #$0F
	sta !vwf_routine+1
	lda #$FB
	sta !vwf_routine+2
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda #$00
	sta !vwf_routine+1
	lda [$0C]
	and #$0F
	sta !vwf_routine+2
	lda #$00
	sta !vwf_routine+3
	lda #$FB
	sta !vwf_routine+4
	lda #$FF
	sta !vwf_routine+5
endif
	rep #$20
	lda $00
	inc #4
	sta !vwf_routine+3+(!vwf_bit_mode*3)
	sep #$20
	lda $02
	sta !vwf_routine+5+(!vwf_bit_mode*3)
	lda.b #!vwf_routine
	sta !vwf_text_source
	lda.b #!vwf_routine>>8
	sta !vwf_text_source+1
	lda.b #!vwf_routine>>16
	sta !vwf_text_source+2
	
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda.b #2
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda.b #4
endif
	sta $03
	lda !vwf_text_source
	sta $00
	lda !vwf_text_source+1
	sta $01
	lda !vwf_text_source+2
	sta $02
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_font
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda.b #$00
endif
	sta $04
	jsr MapDigitsToFont
	
	jmp .NoButton

.F7_DecValue
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda #$FB
	sta !vwf_routine+5
	rep #$21
	lda $00
	adc #$0005
	sta !vwf_routine+6
	sep #$20
	lda $02
	sta !vwf_routine+8
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda #$FB
	sta !vwf_routine+10
	lda #$FF
	sta !vwf_routine+11
	rep #$21
	lda $00
	adc #$0005
	sta !vwf_routine+12
	sep #$20
	lda $02
	sta !vwf_routine+14
endif

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
if !vwf_bit_mode == VWF_BitMode.16Bit
	inc $00
	inc $00
endif

.SixteenBit
	pla
	and #$0F
	beq .NoZeros
	lda $05
if !vwf_bit_mode == VWF_BitMode.16Bit
	asl
endif
	clc
	adc $00
	sta $00

.NoZeros
	rep #$21
	lda.w #!vwf_routine
	adc $00
	sta !vwf_text_source
	sep #$20
	lda.b #!vwf_routine>>16
	sta !vwf_text_source+2
	
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda.b #5
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda.b #10
endif
	sec
	sbc $00
	sta $03
	lda !vwf_text_source
	sta $00
	lda !vwf_text_source+1
	sta $01
	lda !vwf_text_source+2
	sta $02
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_font
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda.b #$00
endif
	sta $04
	jsr MapDigitsToFont

	jmp .NoButton

.F8_TextSpeed
	ldy #$01
	lda [$00],y
	sta !vwf_frames
	jsr IncPointer
	jsr IncPointer
	jmp .End

.F9_WaitFrames
	ldy #$01
	lda [$00],y
	sta !vwf_wait
	lda #$01
	sta !vwf_force_sfx
	jsr IncPointer
	jsr IncPointer
	jmp .End

.FA_WaitButton	
	ldy #$01
	rep #$20
	lda [$00],y
	sta !vwf_wait_for_button_mask
	sep #$20
	
	jsr EndBeep
	
	jsr IncPointer	
	jsr IncPointer
	jsr IncPointer
	jmp .End

.FB_TextPointer
	ldy #$01
	lda [$00],y
	sta !vwf_text_source
	iny
	lda [$00],y
	sta !vwf_text_source+1
	iny
	lda [$00],y
	sta !vwf_text_source+2
	jmp .NoButton

.FC_LoadMessage
	lda #$00
	sta !vwf_message_asm_enabled
	ldy #$01
	lda [$00],y
	sta !vwf_swap_message_id
	iny
	lda [$00],y
	sta !vwf_swap_message_id+1
	lda #%10000000
	sta !vwf_swap_message_settings
	jsr IncPointer
	jsr IncPointer
	
	; RPG Hacker: Backwards compatibility hack. Uses a magic hex to determine
	; if this is the new command format. Can be removed once version 1.3 has
	; been released for a considerable amount of time.
	lda !vwf_swap_message_id
	and !vwf_swap_message_id+1
	cmp #$FF
	bne .Legacy
	
	iny
	lda [$00],y
	sta !vwf_swap_message_id
	iny
	lda [$00],y
	sta !vwf_swap_message_id+1
	iny
	lda [$00],y		; Settings
	ora #%10000000
	sta !vwf_swap_message_settings
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	
.Legacy
	; RPG Hacker: If we don't have the "show close animation" flag set, prepare the next message right now.
	lda !vwf_swap_message_settings
	and.b #%10000010
	cmp.b #%10000000
	bne .DontStartNow
	
	jsr PrepareNextMessage
	
.DontStartNow
	lda #$01
	sta !vwf_end_dialog
	jmp .End
	

.FD_LineBreak
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda #$FD
	sta !vwf_char
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda #$FFFD
	sta !vwf_char
	sep #$20
endif
	jsr IncPointer
	jsr InitLine
	lda !vwf_clear_box
	ora !vwf_cursor_move
	beq .FDReturn
	jmp TextCreation

.FDReturn
	jmp .NoButton

.FE_Space
	jsr IncPointer
	lda !vwf_max_width
	cmp !vwf_space
	bcs .PutSpace
	jsr InitLine
	lda !vwf_clear_box
	ora !vwf_cursor_move
	bne .SpaceClearBox
	jmp .FEReturn

.SpaceClearBox
	jmp TextCreation

.PutSpace
	lda !vwf_max_width
	sec
	sbc !vwf_space
	sta !vwf_max_width

if !use_sa1_mapping
	lda #$01
	sta $2250
endif
	lda !vwf_current_pixel
	clc
	adc !vwf_space
	sta select(!use_sa1_mapping,$2251,$4204)
	cmp #$08
	bcc .NoNewTile
	lda #$01
	sta !vwf_first_tile

.NoNewTile
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
	clc
	adc !vwf_tile
	sta !vwf_tile
	sep #$20
	lda.w select(!use_sa1_mapping,$2306,$4214)
	clc
	adc !vwf_current_x
	sta !vwf_current_x

	lda #$00
	sta !vwf_char_width

	jsr WordWidth_Backup
	jsr WordWidth	
	jsr WordWidth_Restore

	lda !vwf_width_carry
	bne .FECarrySet
	lda !vwf_max_width
	cmp !vwf_char_width
	bcs .FEReturn

.FECarrySet
	lda #$00
	sta !vwf_width_carry
	jsr InitLine
	lda !vwf_clear_box
	ora !vwf_cursor_move
	beq .FEReturn
	jmp TextCreation

.FEReturn
	jmp .NoButton

.FF_End
	lda !vwf_choices
	beq .FFNoChoices
	jmp .FD_LineBreak

.FFNoChoices
	lda #$01
	sta !vwf_end_dialog
	jsr IncPointer
	jmp .End

.WriteLetter
if !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
endif
	lda !vwf_char
	clc
	adc !vwf_char_offset
	sta !vwf_char
if !vwf_bit_mode == VWF_BitMode.16Bit
	sep #$20
endif

if !vwf_bit_mode == VWF_BitMode.16Bit
	lda !vwf_char+1
	sta !vwf_font
endif
	jsr GetFont

	rep #$20
	lda #$0001
	sta $0C
	lda.w #!vwf_char
	sta $00
	sep #$20
	lda.b #bank(!vwf_char)
	sta $02

	lda [$00]	; Check if enough width available
	tay
	lda !vwf_max_width
	cmp [$06],y
	bcs .Create
	jsr InitLine
	jsr GetFont
	rep #$20
	lda #$0001
	sta $0C
	lda.w #!vwf_char
	sta $00
	sep #$20
	lda.b #bank(!vwf_char)
	sta $02

	lda !vwf_clear_box
	ora !vwf_cursor_move
	beq .Create
	jmp TextCreation

.Create
	jsr IncPointer
if !vwf_bit_mode == VWF_BitMode.16Bit
	jsr IncPointer
endif
	lda [$06],y
	sta !vwf_char_width
	jsr WriteTilemap

	jsr GetDestination

	lda !vwf_first_tile
	bne .NoWipe
	lda !vwf_box_create
	beq .NoWipe

	jsr WipePixels

.NoWipe
	lda !vwf_current_pixel
	sta $0E
	lda !vwf_first_tile
	sta $0F

	jsl VWF_GenerateVWF

	lda !vwf_box_create
	beq .End
	rep #$20
	lda.w #!vwf_buffer_bg_tile
	sta $00
	lda !vwf_buffer_dest
	sta $03
	sep #$20
	lda.b #!vwf_buffer_bg_tile>>16
	sta $02
	lda !vwf_buffer_dest+2
	sta $05

	lda #$06
	sta $06

	jsl VWF_AddPattern

.End
	jmp Buffer_End

HandleVWFStackByte1:
.Pull
	lda !vwf_tm_stack_index_1
	dec
	sta !vwf_tm_stack_index_1
	tax
	lda !vwf_tm_stack_1,x
	rts

.Push
	pha
	lda !vwf_tm_stack_index_1
	tax
	inc
	sta !vwf_tm_stack_index_1
	pla
	sta !vwf_tm_stack_1,x
	rts

HandleVWFStackByte2:
.Pull
	lda !vwf_tm_stack_index_2
	dec
	sta !vwf_tm_stack_index_2
	tax
	lda !vwf_tm_stack_2,x
	rts

.Push
	pha
	lda !vwf_tm_stack_index_2
	tax
	inc
	sta !vwf_tm_stack_index_2
	pla
	sta !vwf_tm_stack_2,x
	rts

GetFont:
	lda #$06	; Multiply font number with 6
	sta.w select(!use_sa1_mapping,$2251,$211B)
	stz.w select(!use_sa1_mapping,$2252,$211B)
	stz.w select(!use_sa1_mapping,$2250,$211C)
	lda !vwf_font
	sta.w select(!use_sa1_mapping,$2253,$211C)
if !use_sa1_mapping
	stz $2254
	nop
endif
	rep #$21
	lda.w select(!use_sa1_mapping,$2306,$2134)
	adc.w #FontTable	; Add starting address
	sta $00
	sep #$20
	lda.b #FontTable>>16
	sta $02
	ldy #$00

.Loop
	lda [$00],y	; Load addresses from table
	sta remap_ram($03),y
	iny
	cpy #$06
	bne .Loop
	rts
	
; RPG Hacker: This might make 16-bit builds notably slower.
; Though maybe not, since VWF_GenerateVWF isn't usually called for more than one character.
GetFontLong:
	jsr GetFont
	rtl


GetDestination:
	rep #$20
	lda !vwf_tile
	and #$03FF	; Multiply tile number with 16
	asl #4
	clc
	adc.w #!vwf_buffer_empty_tile	; Add starting address
	sta !vwf_gfx_dest
	lda !vwf_buffer_index
	and #$003F	; Multiply tile number with 16
	asl #4
	clc
	adc.w #!vwf_buffer_letters	; Add starting address
	sta !vwf_buffer_dest
	sta $09
	sep #$20
	lda.b #!vwf_buffer_letters>>16
	sta !vwf_gfx_dest+2
	sta !vwf_buffer_dest+2
	sta $0B
	rts


IncPointer:
	rep #$20
	lda !vwf_text_source
	inc
	sta !vwf_text_source
	sep #$20
	rts


DecPointer:
	rep #$20
	lda !vwf_text_source
	dec
	sta !vwf_text_source
	sep #$20
	rts


ReadPointer:
	rep #$20
	lda !vwf_text_source
	sta $00
	sep #$20
	lda !vwf_text_source+2
	sta $02
	rts


Beep:
	lda !vwf_sound_disabled
	beq .Begin
	rts

.Begin
	lda !vwf_force_sfx
	bne .Play
	lda !vwf_frames
	bne .Play
	lda $13
	and #$01
	bne .Return

.Play
	lda #$00
	sta !vwf_force_sfx
	rep #$20
	lda !vwf_beep_bank
	sta $00
	sep #$20
	lda.b #!vwf_ram_bank
	sta $02
	lda !vwf_beep
	sta [$00]

.Return
	rts

EndBeep:
	lda !vwf_sound_disabled
	beq .Begin
	rts

.Begin
	rep #$20
	lda !vwf_beep_end_bank
	sta $00
	sep #$20
	lda.b #!vwf_ram_bank
	sta $02
	lda !vwf_beep_end
	sta [$00]
	rts

CursorBeep:
	lda !vwf_sound_disabled
	beq .Begin
	rts

.Begin
	rep #$20
	lda !vwf_beep_cursor_bank
	sta $00
	sep #$20
	lda.b #!vwf_ram_bank
	sta $02
	lda !vwf_beep_cursor
	sta [$00]
	rts

ButtonBeep:
	lda !vwf_sound_disabled
	beq .Begin
	rts

.Begin
	rep #$20
	lda !vwf_beep_choice_bank
	sta $00
	sep #$20
	lda.b #!vwf_ram_bank
	sta $02
	lda !vwf_beep_choice
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
	lda !vwf_current_x	; Get tilemap address
	inc
	clc
	adc !vwf_x_pos
	sta $00
	lda !vwf_current_y
	inc
	clc
	adc !vwf_y_pos
	sta $01
	lda #$01
	sta $02
	jsr GetTilemapPos
	lda.b #!vwf_buffer_text_box_tilemap>>16
	sta $05
	sta !vwf_tilemap_dest+2
	rep #$21
	lda.w #!vwf_buffer_text_box_tilemap
	adc $03
	sta $03
	sta !vwf_tilemap_dest

	lda !vwf_char_width
	clc
	adc !vwf_current_pixel
	tax
	lda !vwf_tile
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
	lda !vwf_tile
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
	lda !vwf_current_pixel	; Wipe pixels to prevent overlapping
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
;$04 : Bit mode
;$05 : Zeros

HextoDec:
	jsr Convert8Bit
	jsr GetZeros
if !vwf_bit_mode == VWF_BitMode.16Bit
	lda #$00
	sta !vwf_routine+1
	sta !vwf_routine+3
	sta !vwf_routine+5
	sta !vwf_routine+7
	sta !vwf_routine+9
endif
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
	sta !vwf_routine+4+(!vwf_bit_mode*4)
	lda $03
	sta !vwf_routine+3+(!vwf_bit_mode*3)
	lda $02
	sta !vwf_routine+2+(!vwf_bit_mode*2)

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
	sta !vwf_routine
if !vwf_mode != VWF_BitMode.8Bit
	lda $01
	sta !vwf_routine+1+!vwf_bit_mode
endif
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
	lda !vwf_routine
	beq .Thousands
	bra .End

.Thousands
	inc $05
	lda !vwf_routine+1+!vwf_bit_mode
	beq .Hundreds
	bra .End

.Hundreds
	inc $05
	lda !vwf_routine+2+(!vwf_bit_mode*2)
	beq .Tens
	bra .End

.Tens
	inc $05
	lda !vwf_routine+3+(!vwf_bit_mode*3)
	beq .Ones
	bra .End

.Ones
	inc $05

.End
	rts
	
	

; $00: The address of the number sequence to map (24-bit)
; $03: The length of the sequence to map in bytes
; $04: The font number
MapDigitsToFont:
	lda #$00
	xba
	lda $04
	rep #$20
if !vwf_bit_mode == VWF_BitMode.8Bit
	asl #4
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	asl #5
endif
	clc
	adc.w #FontDigitsTable
	sta $0A
	sep #$20
	lda.b #bank(FontDigitsTable)
	sta $0C
	
	; Highly inefficient loop below. Wish there was an "lda [$00],x"...
	ldy.b #$00
	
.Loop
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$00],y
	tyx
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda [$00],y
	tyx
	asl
endif
	tay
	lda [$0A],y
	txy
	sta [$00],y
if !vwf_bit_mode == VWF_BitMode.8Bit
	iny
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	sep #$20
	iny
	iny
endif
	
	cpy $03
	bcc .Loop
	
	rts



WordWidth:

.GetFont
if !vwf_bit_mode == VWF_BitMode.8Bit
	jsr GetFont
endif

.Begin
	jsr ReadPointer
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$00]
	sta !vwf_char
	cmp.b #!vwf_lowest_reserved_hex
	bcs .Jump
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda [$00]
	sta !vwf_char
	cmp.w #!vwf_lowest_reserved_hex
	bcs .Jump
	sep #$20
	jsr IncPointer
endif
	jsr IncPointer
	jmp .Add

.Jump
	sec
if !vwf_bit_mode == VWF_BitMode.8Bit
	sbc.b #!vwf_lowest_reserved_hex
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	sbc.w #!vwf_lowest_reserved_hex
	sep #$20
endif
	asl
	tax
if !vwf_bit_mode == VWF_BitMode.16Bit
	jsr IncPointer
endif
	jsr IncPointer
	jsr ReadPointer
	jmp (.Routinetable,x)

.Routinetable
	dw .E6_ExitToOw
	dw .E7_EndTextMacro
	dw .E8_TextMacro
	dw .E9_TextMacroGroup
	dw .EA_CharOffset
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
	
.E6_ExitToOw
	jsr IncPointer
	jmp .Begin

.E7_EndTextMacro
	jsr HandleVWFStackByte2_Pull
	sta !vwf_text_source+2
	jsr HandleVWFStackByte2_Pull
	sta !vwf_text_source+1
	jsr HandleVWFStackByte2_Pull
	sta !vwf_text_source
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
	cmp #!vwf_num_reserved_text_macros*3
	bcs ..NotBufferedText
	tax
	lda !vwf_tm_buffers_text_pointers,x
	sta !vwf_text_source
	sep #$30
	lda !vwf_tm_buffers_text_pointers+2,x
	bra +

..NotBufferedText
	sec
	sbc #!vwf_num_reserved_text_macros*3
	tax
	lda TextMacroPointers,x
	sta !vwf_text_source
	sep #$30
	lda TextMacroPointers+2,x
+
	sta !vwf_text_source+2
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
	adc.w #!vwf_num_reserved_text_macros

	jmp .TextMacroShared
	
.EA_CharOffset
	ldy #$01
	lda [$00]
	sta !vwf_char_offset
if !vwf_bit_mode == VWF_BitMode.16Bit
	lda [$00],y
	sta !vwf_char_offset+1
	jsr IncPointer
endif
	jsr IncPointer
	jmp .Begin

.EE_ChangeColor
.EF_Teleport
.F1_Execute
	jsr IncPointer
	jsr IncPointer
	jsr IncPointer
	jmp .Begin

.F2_ChangeFont
	lda [$00]
	sta !vwf_font
	jsr IncPointer
	jmp .GetFont

.F3_ChangePalette
	jsr IncPointer
	jmp .Begin

.F4_Character
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$00]
	sta !vwf_char
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda [$00]
	sta !vwf_char
	sep #$20
	jsr IncPointer
endif
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
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$0C]
	sta !vwf_char
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda [$0C]
	sta !vwf_char
	sep #$20
endif
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
	sta !vwf_routine
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda [$0C]
	and #$0F
	sta !vwf_routine+1
	lda #$FB
	sta !vwf_routine+2
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda #$00
	sta !vwf_routine+1
	lda [$0C]
	and #$0F
	sta !vwf_routine+2
	lda #$00
	sta !vwf_routine+3
	lda #$FB
	sta !vwf_routine+4
	lda #$FF
	sta !vwf_routine+5
endif
	rep #$20
	lda $00
	inc #3
	sta !vwf_routine+3+(!vwf_bit_mode*3)
	sep #$20
	lda $02
	sta !vwf_routine+5+(!vwf_bit_mode*3)
	lda.b #!vwf_routine
	sta !vwf_text_source
	lda.b #!vwf_routine>>8
	sta !vwf_text_source+1
	lda.b #!vwf_routine>>16
	sta !vwf_text_source+2
	
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda.b #2
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda.b #4
endif
	sta $03
	lda !vwf_text_source
	sta $00
	lda !vwf_text_source+1
	sta $01
	lda !vwf_text_source+2
	sta $02
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_font
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda.b #$00
endif
	sta $04
	jsr MapDigitsToFont
	
	jmp .Begin

.F7_DecValue
	lda #$FB
if !vwf_bit_mode == VWF_BitMode.8Bit
	sta !vwf_routine+5
	rep #$21
	lda $00
	adc #$0004
	sta !vwf_routine+6
	sep #$20
	lda $02
	sta !vwf_routine+8
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	sta !vwf_routine+10
	lda #$FF
	sta !vwf_routine+11
	rep #$21
	lda $00
	adc #$0004
	sta !vwf_routine+12
	sep #$20
	lda $02
	sta !vwf_routine+14
endif

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
if !vwf_bit_mode == VWF_BitMode.16Bit
	inc $00
	inc $00
endif

.SixteenBit
	pla
	and #$0F
	beq .NoZeros
	lda $05
if !vwf_bit_mode == VWF_BitMode.16Bit
	asl
endif
	clc
	adc $00
	sta $00

.NoZeros
	rep #$21
	lda.w #!vwf_routine
	adc $00
	sta !vwf_text_source
	sep #$20
	lda.b #!vwf_routine>>16
	sta !vwf_text_source+2
	
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda.b #5
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda.b #10
endif
	sec
	sbc $00
	sta $03
	lda !vwf_text_source
	sta $00
	lda !vwf_text_source+1
	sta $01
	lda !vwf_text_source+2
	sta $02
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_font
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	lda.b #$00
endif
	sta $04
	jsr MapDigitsToFont

	jmp .GetFont

.EC_PlayBGM
.F8_TextSpeed
.F9_WaitFrames
	jsr IncPointer
	jmp .Begin

.FA_WaitButton
	jsr IncPointer
	jsr IncPointer
	jmp .Begin

.FB_TextPointer
	ldy #$01
	lda [$00]
	sta !vwf_text_source
	lda [$00],y
	sta !vwf_text_source+1
	iny
	lda [$00],y
	sta !vwf_text_source+2
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
if !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
endif
	lda !vwf_char
	clc
	adc !vwf_char_offset
	sta !vwf_char
if !vwf_bit_mode == VWF_BitMode.16Bit
	sep #$20
endif

if !vwf_bit_mode == VWF_BitMode.16Bit
	lda !vwf_char+1
	sta !vwf_font
	jsr GetFont
endif
	lda !vwf_char
	tay
	lda [$06],y
	clc
	adc !vwf_char_width
	bcs .End
	cmp !vwf_max_width
	bcc .Continue
	bne .End

.Continue
	sta !vwf_char_width
	jmp .Begin

.End
	lda #$01
	sta !vwf_width_carry

.Return	
	; RPG Hacker: This is necessary, because some outside code checks
	; if the last character this routine read was a space.
	; I don't even remember why. It's literally been over a decade since I initially wrote this.
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_char
	sta $0A
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda !vwf_char
	sta $0A
	sep #$20
endif
	
	rts
	
	
; RPG Hacker: These routines are kinda stinky.
; Their purpose was to simplify code by removing duplication.
; However, I feel they just made the code even more complicated.
.Backup
	pla
	sta $0B
	pla
	sta $0C

	lda !vwf_text_source
	pha
	lda !vwf_text_source+1
	pha
	lda !vwf_text_source+2
	pha
	lda !vwf_font
	pha
	lda !vwf_char
	pha
	lda !vwf_char_offset
	pha
if !vwf_bit_mode == VWF_BitMode.16Bit
	lda !vwf_char+1
	pha
	lda !vwf_char_offset+1
	pha
endif

	lda $0C
	pha
	lda $0B
	pha

	; RPG Hacker: In order to make the WordWidth function work reliably with the text macro system,
	; we need to make a copy of the current text macro stack whenever we begin calculating widths.
	; I tested using a simple loop for this, because text macro stacks of more than one
	; element should be rare, and simple loops sound like they should be faster for few iterations.
	; However, in my testing, the MVN solution turned out to be faster even for simple stacks.
.CheckCopyTextMacroStack
	lda !vwf_tm_stack_index_1
	sta !vwf_tm_stack_index_2
	beq .NoStackCopy

.DoStackCopy	
	xba
	lda.b #$00
	xba
	
	rep #$30
	
	dec		; -1 because of how MVN works
	
	ldx.w #!vwf_tm_stack_1
	ldy.w #!vwf_tm_stack_2
	
	phb
	mvn bank(!vwf_tm_stack_2), bank(!vwf_tm_stack_1)
	plb
	
	sep #$30
	
.NoStackCopy
	rts

	
.Restore
	pla
	sta $0B
	pla
	sta $0C
	
if !vwf_bit_mode == VWF_BitMode.16Bit
	pla
	sta !vwf_char_offset+1
	pla
	sta !vwf_char+1
endif
	pla
	sta !vwf_char_offset
	pla
	sta !vwf_char
	pla
	sta !vwf_font
	pla
	sta !vwf_text_source+2
	pla
	sta !vwf_text_source+1
	pla
	sta !vwf_text_source

	lda $0C
	pha
	lda $0B
	pha
	
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
	lda !vwf_mode	; Prepare jump to routine
	beq .End
	
if !vwf_debug_vblank_time != false
	macro vwf_debug_waste_time()
		lda #$FF
	?Again:
		dec
		bne ?Again
	endmacro
	
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
	%vwf_debug_waste_time()
endif

	lda !vwf_palette_upload	; This code takes care of palette upload requests
	beq .skip
	lda #$00
	sta !vwf_palette_upload
	sta $2121
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteTwice, $2122, !vwf_palette_backup_ram, $0040)
.skip

	lda !vwf_mode
	asl
	tax

	jmp (.Routinetable,x)

.End
	plp	; Return
	plb
	pla
	ply
	plx

	lda !vwf_mode	; Skip Status Bar in dialogues
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
	dw .End,.End,PrepareBackup,Backup,PrepareScreen,BackupPalette
	dw BackupEnd,CreateWindow,PrepareScreen,TextUpload,CreateWindow
	dw PrepareBackup,Backup,BackupPalette,BackupEnd,VBlankEnd






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
	sta !vwf_freeze_sprites
	
	lda !vwf_teleport	; Check if teleport set
	beq .NoTeleport

	lda #$00
	sta !vwf_teleport

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
	lda !vwf_teleport_dest
	sta remap_ram($19B8),x
	lda !vwf_teleport_prop
	ora #$04
	sta remap_ram($19D8),x

.Teleport
	lda #$06
	sta $71
	stz $89
	stz $88

.NoTeleport
	lda !vwf_exit_to_ow
	beq .NoExitToOw
	
	dec
	bne +
	
	jsl VWF_CloseMessageAndGoToOverworld_StartPlusSelect
	bra .NoExitToOw
	
+	
	dec
	bne +
	
	jsl VWF_CloseMessageAndGoToOverworld_NormalExit
	bra .NoExitToOw
	
+
	jsl VWF_CloseMessageAndGoToOverworld_SecretExit
	
.NoExitToOw
	lda #$00	; VWF dialogue end
	sta !vwf_mode

	jmp VBlank_End

.SwitchTable
	db $04,$01,$02,$03




PrepareBackup:
	lda.b #!vwf_backup_duration_in_frames	; Prepare backup of layer 3
	sta !vwf_sub_step
	rep #$20
	lda #$0000
	sta !vwf_vram_pointer
	sep #$20

	lda !vwf_mode
	cmp #$02
	bne .DontPreserveL3
	lda $3E
	sta !vwf_l3_priority_flag
	lda remap_ram($0D9E)
	sta !vwf_l3_sub_screen_flag
	lda $40
	sta !vwf_l3_transparency_flag
	lda remap_ram($0D9D)
	sta !vwf_l3_main_screen_flag

.DontPreserveL3
	lda #$04	; Hide layer 3
	trb remap_ram($0D9D)
	trb remap_ram($0D9E)
	lda remap_ram($0D9D)
	sta $212C
	lda remap_ram($0D9E)
	sta $212D

.End
	lda !vwf_mode
	inc
	sta !vwf_mode
	jmp VBlank_End





Backup:
	!vwf_backup_size_per_frame #= $4000/!vwf_backup_duration_in_frames
	!vwf_vram_pointer_adjust_per_frame #= !vwf_backup_size_per_frame/2

	rep #$21
	lda #$4000	; Adjust VRAM address
	adc !vwf_vram_pointer
	sta $02

	lda !vwf_vram_pointer
	asl a
	clc
	adc.w #!vwf_backup_ram	; Adjust destination address
	sta $00

	lda !vwf_vram_pointer	; Adjust pointer
	clc
	adc.w #!vwf_vram_pointer_adjust_per_frame
	sta !vwf_vram_pointer
	sep #$20

	lda !vwf_mode
	cmp #$03
	beq .Backup
	jmp .Restore

.Backup
	%configure_vram_access(VRamAccessMode.Read, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, $02)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.ReadOnce, $2139, dma_source_indirect_word($00, bank(!vwf_backup_ram)), !vwf_backup_size_per_frame)
	jmp .Continue

.Restore
	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, $02)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, dma_source_indirect_word($00, bank(!vwf_backup_ram)), !vwf_backup_size_per_frame)

.Continue
	lda !vwf_sub_step	; Reduce iteration counter
	dec
	sta !vwf_sub_step
	bne .NotDone

.End
	lda !vwf_mode
	inc
	sta !vwf_mode

.NotDone
	jmp VBlank_End





BackupEnd:
	lda !vwf_mode
	cmp #$06
	bne .Layer3Subscreen
	lda #$08
	tsb $3E
	lda remap_ram($0D9D)
	ora #$04
	sta $212C
	lda.b #$04
	trb $40

.End
	lda !vwf_mode
	inc
	sta !vwf_mode
	jmp VBlank_End

.Layer3Subscreen
	lda !vwf_l3_sub_screen_flag
	and #$04
	ora remap_ram($0D9E)
	sta remap_ram($0D9E)
	sta $212D
	lda !vwf_l3_main_screen_flag
	and #$04
	ora remap_ram($0D9D)
	sta remap_ram($0D9D)
	sta $212C
	lda !vwf_l3_priority_flag
	sta $3E
	lda !vwf_l3_transparency_flag
	and #$04
	ora $40
	sta $40
	bra .End





BackupPalette:
	stz $2121	; Backup or restore layer 3 colors
	lda !vwf_mode
	cmp #$05
	beq .Backup
.Restore
	%vwf_mvn_transfer($0040, !vwf_palette_backup, !vwf_palette_backup_ram, !vwf_cpu_snes)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteTwice, $2122, !vwf_palette_backup_ram, $0040)
	jmp .End

.Backup
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.ReadTwice, $213B, !vwf_palette_backup_ram, $0040)
	%vwf_mvn_transfer($0040, !vwf_palette_backup_ram, !vwf_palette_backup, !vwf_cpu_snes)

.End
	lda !vwf_mode
	inc
	sta !vwf_mode
	jmp VBlank_End
	
	
InitBoxPalette:
	jsr LoadBoxPalette
	
	;lda !vwf_mode
	;inc
	;sta !vwf_mode
	jmp Buffer_End
	
	
LoadBoxPalette:
	lda !vwf_box_palette	; Set BG and letter color
	asl #2
	inc
	asl
	phy
	tay
	ldx #$00	
	
	; RPG Hacker: Because an "Absolute Long Indexed, Y" mode doesn't exist...
	lda.b #!vwf_palette_backup_ram
	sta $00
	lda.b #!vwf_palette_backup_ram>>8
	sta $01
	lda.b #!vwf_palette_backup_ram>>16
	sta $02

.BoxColorLoop
	lda !vwf_box_color,x
	sta [$00],y
	iny
	inx
	cpx #$06
	bne .BoxColorLoop

	ply
	lda #!vwf_frame_palette	; Set frame color
	asl #2
	inc
	asl
	phx
	tax
	lda.b #bank(FramePalettes+2)
	sta $02
	lda #$00
	xba
	lda !vwf_box_frame
	rep #$21
	asl #3
	adc.w #FramePalettes+2
	sta $00
	sep #$20
	ldy #$00

.FrameColorLoop
	lda [$00],y
	sta !vwf_palette_backup_ram,x
	inx
	iny
	cpy #$06
	bne .FrameColorLoop
	plx

	lda #$01
	sta !vwf_palette_upload
	
	rts





PrepareScreen:
	; Upload graphics and tilemap to VRAM	
	!vwf_prepare_screen_size_per_frame #= $0700/!vwf_clear_screen_duration_in_frames
	!vwf_prepare_screen_vram_pointer_adjust_per_frame #= !vwf_prepare_screen_size_per_frame/2
	
	lda !vwf_sub_step
	bne .SkipEmptyTile
	
	rep #$20
	lda.w #$0000
	sta !vwf_vram_pointer
	sep #$20
	
	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, #$4000)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, !vwf_buffer_empty_tile, $00B0)

.SkipEmptyTile
	rep #$21	
	lda.w #$5C80
	adc !vwf_vram_pointer
	sta $02
	
	lda !vwf_vram_pointer
	asl a
	clc
	adc.w #!vwf_buffer_text_box_tilemap
	sta $00
	
	lda !vwf_vram_pointer
	clc
	adc.w #!vwf_prepare_screen_vram_pointer_adjust_per_frame
	sta !vwf_vram_pointer
	sep #$20
	
	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, $02)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, dma_source_indirect_word($00, bank(!vwf_buffer_text_box_tilemap)), !vwf_prepare_screen_size_per_frame)
	
	lda !vwf_sub_step
	inc	
	sta !vwf_sub_step
	cmp.b #!vwf_clear_screen_duration_in_frames
	
	bne .Return

.End
	lda.b #$00
	sta !vwf_sub_step
	
	lda !vwf_mode
	cmp.b #$04
	bne .NoNextMessage
	
	; Check if we're coming from a "display message" command.
	; If so, we need to skip parts of the initialization process.
	lda !vwf_swap_message_settings
	bit.b #%10000000
	beq .NoNextMessage
	
	lda #$00
	sta !vwf_swap_message_settings
	lda.b #$06
	sta !vwf_mode
	jmp VBlank_End
	
.NoNextMessage
	lda !vwf_mode
	inc
	sta !vwf_mode
	
.Return
	jmp VBlank_End





CreateWindow:
	rep #$20
	lda !vwf_create_window_start_pos
	lsr
	clc
	adc #$5C80
	sta $00
	
	lda.w #!vwf_buffer_text_box_tilemap
	clc
	adc !vwf_create_window_start_pos
	sta $02
	sep #$20

	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, $00)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, dma_source_indirect_word($02, bank(!vwf_buffer_text_box_tilemap)), dma_size_indirect(!vwf_create_window_length))

	lda !vwf_sub_step
	cmp #$02
	bne .Return

.End
	lda #$00
	sta !vwf_sub_step
	lda !vwf_mode
	inc
	sta !vwf_mode
	
	; RPG Hacker: Check if we still have "next message" stored from the "load message" command.
	; If so, we gotta jump back to an earlier step.
	lda !vwf_swap_message_settings
	and.b #%10000010
	cmp.b #%10000010
	bne .NoNextMessage
	
	jsr StartNextMessage
	
.NoNextMessage
.Return
	jmp VBlank_End





TextUpload:
	lda !vwf_cursor_fix
	beq .SkipCursor
	dec
	sta !vwf_cursor_fix

	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, !vwf_cursor_vram)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, dma_source_indirect_word(!vwf_cursor_source, bank(!vwf_buffer_text_box_tilemap)), $0046)

.SkipCursor
	lda !vwf_wait	; Wait for frames?
	beq .NoFrames
	lda !vwf_wait
	dec
	sta !vwf_wait
	jmp .Return

.NoFrames
	lda !vwf_cursor_move
	bne .Cursor
	jmp .NoCursor


.Cursor
	lda !vwf_cursor_upload
	bne .UploadCursor
	jmp .NoCursorUpload

.UploadCursor
	lda #$00
	sta !vwf_cursor_upload

	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, #$5C50)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, !vwf_tile_ram, $0060)

	rep #$20
	lda !vwf_tilemap_dest
	sec
	sbc.w #!vwf_buffer_text_box_tilemap
	lsr
	clc
	adc #$5C80
	sta $00
	sep #$20

	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, $00)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, dma_source_indirect(!vwf_tilemap_dest), $0046)

	jmp .Return

.NoCursorUpload
	lda !vwf_cursor_end
	bne .CursorEnd
	jmp .Return

.CursorEnd
	lda #$00
	sta !vwf_cursor_end
	lda !vwf_current_choice
	dec
	sta !vwf_current_choice
	asl
	clc
	adc !vwf_current_choice
	tay
	lda !vwf_choice_table
	sta $00
	lda !vwf_choice_table+1
	sta $01
	lda !vwf_choice_table+2
	sta $02
	lda [$00],y
	sta !vwf_text_source
	iny
	lda [$00],y
	sta !vwf_text_source+1
	iny
	lda [$00],y
	sta !vwf_text_source+2
	lda #$00
	sta !vwf_cursor_move
	sta !vwf_choices
	sta !vwf_current_choice
	sta !vwf_char
if !vwf_bit_mode == VWF_BitMode.16Bit
	sta !vwf_char+1
endif
	lda #$01
	sta !vwf_clear_box
	jmp .Return


.NoCursor
	lda !vwf_end_dialog	; Dialogue done?
	beq .NoEnd
	lda #$00
	sta !vwf_end_dialog
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda #$00
	sta !vwf_char
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda #$0000
	sta !vwf_char
	sep #$20
endif
	
	; RPG Hacker: Display next message now if we're coming from a "load message"
	; command and don't have the "show close animation" flag set.
	lda !vwf_swap_message_settings
	and.b #%10000010
	cmp.b #%10000000
	bne .NoNextMessage
	
	jsr StartNextMessage
	jmp VBlank_End
	
.NoNextMessage
	jmp .End

.NoEnd
	; Are we waiting for an A button press?
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_char
	cmp #$FA
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda !vwf_char
	cmp #$FFFA
	sep #$20
endif
	beq .CheckButton
	jmp .CheckClearBox

.CheckButton
	%vwf_check_if_any_button_pressed(" !vwf_wait_for_button_mask")
	beq .NotPressed
	jsr ButtonBeep
	lda #$00
	sta !vwf_char
if !vwf_bit_mode == VWF_BitMode.16Bit
	sta !vwf_char+1
endif
	lda #$00
	sta !vwf_timer

.NotPressed
	lda !vwf_box_create
	bne .CheckTimer
	jmp .Return

.CheckTimer
	lda !vwf_timer	; Display arrow if waiting for button
	inc
	sta !vwf_timer
	cmp #$21
	bcc .NoReset
	lda #$00
	sta !vwf_timer

.NoReset
	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnLowByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, !vwf_arrow_vram)

	lda !vwf_timer
	cmp #$11
	bcs .Arrow
	lda #$05
	bra .Display

.Arrow
	lda #$0A

.Display
	sta $2118
	jmp .Return

.CheckClearBox
	lda !vwf_clear_box_remaining_bytes
	ora !vwf_clear_box_remaining_bytes+1
	bne .ProcessClearBox
	
	jmp .UploadTextGfx
	
.ProcessClearBox
	; Calculations below here could be moved out of V-Blank if necessary to reduce the risk of V-Blank overflow.
	
	rep #$20
	lda.w #$5C80
	clc
	adc !vwf_vram_pointer
	sta $02	
	
	lda !vwf_vram_pointer
	asl a
	clc
	adc.w #!vwf_buffer_text_box_tilemap
	sta $00
	
	lda !vwf_vram_pointer
	clc
	adc.w #!vwf_prepare_screen_vram_pointer_adjust_per_frame
	sta !vwf_vram_pointer
	
	lda !vwf_clear_box_remaining_bytes
	cmp.w #!vwf_prepare_screen_size_per_frame+1
	bcc .FinalClearFrame
	
	lda.w #!vwf_prepare_screen_size_per_frame
	
.FinalClearFrame
	sta $04
	sep #$20
	
	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, $02)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, dma_source_indirect_word($00, bank(!vwf_buffer_text_box_tilemap)), dma_size_indirect_dp($04))
	
	rep #$20
	lda !vwf_clear_box_remaining_bytes
	sec
	sbc $04
	sta !vwf_clear_box_remaining_bytes	
	sep #$20
	
	beq .ClearDone
	
	jmp .Return
	
.ClearDone
	lda.b #$00
	sta !vwf_clear_box
	lda.b #$01
	sta !vwf_at_start_of_text
	
	jmp .Return

.UploadTextGfx
	rep #$20	; Upload GFX
	lda !vwf_gfx_dest
	sec
	sbc.w #!vwf_buffer_empty_tile
	lsr
	clc
	adc #$4000
	sta $00
	sep #$20
	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, $00)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, dma_source_indirect(!vwf_buffer_dest), $0060)

	rep #$20	; Upload Tilemap
	lda !vwf_tilemap_dest
	sec
	sbc.w #!vwf_buffer_text_box_tilemap
	lsr
	clc
	adc #$5C80
	sta $00
	sep #$20
	%configure_vram_access(VRamAccessMode.Write, VRamIncrementMode.OnHighByte, VRamIncrementSize.1Byte, VRamAddressRemap.None, $00)
	%dma_transfer(!vwf_dma_channel_nmi, DmaMode.WriteOnce, $2118, dma_source_indirect(!vwf_tilemap_dest), $0046)

	jsr Beep

	lda !vwf_frames
	sta !vwf_wait

	lda !vwf_speed_up
	beq .Return
if !vwf_bit_mode == VWF_BitMode.8Bit
	lda !vwf_char
	cmp #$F9
elseif !vwf_bit_mode == VWF_BitMode.16Bit
	rep #$20
	lda !vwf_char
	cmp #$FFF9
	sep #$20
endif
	beq .Return
	lda $15
	and #$80
	cmp #$80
	bne .Return
	lda #$00
	sta !vwf_wait
	jmp .Return

.End
	lda !vwf_mode
	inc
	sta !vwf_mode

.Return
	jmp VBlank_End
	
	
; RPG Hacker: This is split into two routines, because some code needs to run in the buffering phase,
; and other code needs to run in the graphics upload phase. It might actually be save to do all of it
; in the same one, but I don't even want to risk it, especially not with SA-1 compatibility being a factor.
PrepareNextMessage:
	lda !vwf_swap_message_id
	sta !vwf_message
	lda !vwf_swap_message_id+1
	sta !vwf_message+1
	
	lda !vwf_swap_message_settings
	bit.b #%00000001
	beq .NoOpenAnim
	
	jsr BufferGraphics_Start
	jsr GetMessage
	jsr LoadHeader
	
	jsr LoadBoxPalette
	
	bra .Return
	
.NoOpenAnim	
	jsr BufferGraphics_Start
	
.Return	
	rts
	
	
StartNextMessage:
	lda !vwf_swap_message_settings
	bit.b #%00000001
	beq .NoOpenAnim
	
	lda.b #$04
	sta !vwf_mode
	lda.b #$00
	
	bra .Return
	
.NoOpenAnim	
	lda.b #$08
	sta !vwf_mode
	lda.b #$00
	sta !vwf_swap_message_settings
	
.Return
	sta !vwf_swap_message_id
	sta !vwf_swap_message_id+1
	
	rts




BackupTilemap:
	lda !vwf_edge
	lsr #3
	clc
	adc !vwf_x_pos
	inc
	sta $00

	lda !vwf_current_y
	sec
	sbc !vwf_choices
	sec
	sbc !vwf_choices
	sta $01
	lda !vwf_current_choice
	dec
	asl
	clc
	adc $01
	clc
	adc !vwf_y_pos
	inc
	sta $01

	lda #$01
	sta $02

	jsr GetTilemapPos

	lda.b #!vwf_buffer_text_box_tilemap>>16
	sta $05
	rep #$21
	lda.w #!vwf_buffer_text_box_tilemap
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
	sta !vwf_buffer_choice_backup
	lda [$03],y
	sta !vwf_buffer_choice_backup+$02
	iny #2
	lda [$03],y
	sta !vwf_buffer_choice_backup+$04
	ldy #$40
	lda [$03],y
	sta !vwf_buffer_choice_backup+$06
	iny #2
	lda [$03],y
	sta !vwf_buffer_choice_backup+$08
	iny #2
	lda [$03],y
	sta !vwf_buffer_choice_backup+$0A
	sep #$20

	rts

.Restore
	rep #$20
	ldy #$02
	lda !vwf_buffer_choice_backup
	sta [$03]
	lda !vwf_buffer_choice_backup+$02
	sta [$03],y
	iny #2
	lda !vwf_buffer_choice_backup+$04
	sta [$03],y
	ldy #$40
	lda !vwf_buffer_choice_backup+$06
	sta [$03],y
	iny #2
	lda !vwf_buffer_choice_backup+$08
	sta [$03],y
	iny #2
	lda !vwf_buffer_choice_backup+$0A
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
	sbc.w #!vwf_buffer_text_box_tilemap
	lsr
	clc
	adc #$5C80
	sta !vwf_cursor_vram
	lda $03
	sta !vwf_cursor_source
	sep #$20
	lda #$01
	sta !vwf_cursor_fix

	rts
	




Emptytile:
	db $00,$20





;;;;;;;;;;;;;;;;;;;
;Main Data Section;
;;;;;;;;;;;;;;;;;;;

!frame_palette_num_math = ((FramePalettesEnd-FramePalettes)/8)

!frame_num_math = ((FramesEnd-Frames)/(9*8*2))


!num_frames := !frame_palette_num_math
NumFrames:
	db !num_frames
	
	
Frames:
incbin data/gfx/vwfframes.bin
FramesEnd:

FramePalettes:
	%vwf_define_frames()
FramePalettesEnd:


assert !frame_num_math == round(!frame_num_math, 0), "vwfframes.bin has an unexpected size. Should be divisible by ",dec(9*8*2),"."

assert !frame_palette_num_math == round(!frame_palette_num_math, 0), "%vwf_define_frames() has an unexpected size. Should be divisible by 8."

assert !frame_num_math == !frame_palette_num_math, "The number of text box frames in vwfframes.bin and the number of frame properties in %vwf_define_frames() mismatch. Found ",double(!frame_num_math)," frames and ",double(!frame_palette_num_math)," frame properties."


!bg_pattern_num_math = ((BgPatternsEnd-BgPatterns)/(8*2))


!num_bg_patterns := !bg_pattern_num_math
NumBgPatterns:
	db !num_bg_patterns
	
	
BgPatterns:
incbin data/gfx/vwfbgpatterns.bin
BgPatternsEnd:


assert !bg_pattern_num_math == round(!bg_pattern_num_math, 0), "vwfbgpatterns.bin has an unexpected size. Should be divisible by ",dec(8*2),"."


%vwf_first_bank()

MainDataStart:
	; RPG Hacker: Using ?= for this, so that we can overwrite it for the test suite.
	!vwf_data_include ?= %vwf_define_data()
	!vwf_data_include

; RPG Hacker: Would prefer to call this in vwfmacros.asm, but that
; would throw an error on !vwf_default_font, because it wouldn't know
; how many fonts have actually been added yet.
%vwf_verfiy_default_arguments()

%vwf_next_bank()

%vwf_generate_pointers()
	
	
; Shared routine tables go here.
; We put them into a static free space so that they don't move when we modify the patch.
freespace ram,static
	
SharedRoutinesJumpTable:
	%vwf_generate_shared_routines_jump_table()
	
SharedRoutinesJumpTableEnd:


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
print dec(!vwf_var_rampos)," bytes of \!vwf_var_ram used."

print ""
print "Shared routines jump table inserted at start address $",hex(SharedRoutinesJumpTable)
print "Reserved ",dec(SharedRoutinesJumpTableEnd-SharedRoutinesJumpTable)," bytes of free space for shared routines jump table."
print ""

!temp_i #= 0
while !temp_i < !vwf_num_shared_routines
	print "Shared routine '!{vwf_shared_routine_!{temp_i}_label_name}' at address $",hex(!{vwf_shared_routine_!{temp_i}_label_name}),"."

	!temp_i #= !temp_i+1
endwhile
undef "temp_i"


print ""
print "VWF State register at address $",hex(!vwf_mode),"."
print "Message register at address $",hex(!vwf_message),"."
print "BG GFX register at address $",hex(!vwf_box_bg),"."
print "BG Color register at address $",hex(!vwf_box_color),"."
print "Frame GFX register at address $",hex(!vwf_box_frame),"."
print "Abort Dialogue Processing register at address $",hex(!vwf_end_dialog),"."
;print "Active VWF Message Flag at address $",hex(!vwf_active_flag),"."

print ""
print "Check the manual for details!"

print ""


freedata : prot !vwf_prev_freespace : Kleenex: db $00	;ignore this line, it must be at the end of the patch for technical reasons
;print "End of VWF data at $",pc,"."

namespace off


pulltable

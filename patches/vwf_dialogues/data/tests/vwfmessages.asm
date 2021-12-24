;-------------------------------------------------------

; DIALOG DATA BEGIN

; Text macros:

%vwf_register_text_macro("Option2Text", %vwf_wrap( %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_text(" "), %vwf_set_text_palette($04), %vwf_text("Message Boxes"), %vwf_set_text_palette(!default_text_palette), %vwf_text(" Test") ))
%vwf_register_text_macro("Option3Text", %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_text(" "), %vwf_set_text_palette($05), %vwf_text("Pointers"), %vwf_set_text_palette(!default_text_palette), %vwf_text(" Test") )


; Messages:

; RPG Hacker: Really, message $0050 (Yoshi's House) is the most important one for us, since it's the quickest one to get to.
;-------------------------------------------------------

%vwf_message_start(0050)	; Message 104-1

	%vwf_header(vwf_x_pos(0), vwf_y_pos(0), vwf_width(15), vwf_height(13), vwf_text_alignment(TextAlignment.Centered))
	
.Start
	%vwf_change_colors(vwf_get_color_index_2bpp($04, !vwf_text_color_id), vwf_make_color_15(15, 15, 31), vwf_make_color_15(0, 0, 0))
	%vwf_change_colors(vwf_get_color_index_2bpp($05, !vwf_text_color_id), vwf_make_color_15(6, 31, 6), vwf_make_color_15(0, 0, 0))
	%vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(31, 12, 12), vwf_make_color_15(0, 0, 0))
	
if !assembler_ver >= 20000
	%vwf_set_text_palette($05) : %vwf_text("🐾") : %vwf_space()
	%vwf_set_text_palette(!default_text_palette) : %vwf_text("👉 Pléäse sèlêct â teßt 👈") : %vwf_space()
	%vwf_set_text_palette($05) : %vwf_text("🐾")
	%vwf_set_text_palette(!default_text_palette) : %vwf_line_break()
else
	%vwf_set_text_palette($05) : %vwf_char($00AC) : %vwf_space()
	%vwf_set_text_palette(!default_text_palette) : %vwf_text("Please select a test") : %vwf_space()
	%vwf_set_text_palette($05) : %vwf_char($00AC)
	%vwf_set_text_palette(!default_text_palette) : %vwf_line_break()
endif
	
	%vwf_display_options(TestSelection,
		%vwf_wrap( %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_text(" "),
			%vwf_set_text_palette($06), %vwf_text("Commands"),
			%vwf_set_text_palette(!default_text_palette), %vwf_text(" Test") ),
		%vwf_execute_text_macro("Option2Text"),
		%vwf_execute_text_macro("Option3Text"),
		%vwf_wrap( %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_set_text_palette(!default_text_palette), %vwf_text(" Teleport Test") ),
		%vwf_wrap( %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_set_text_palette(!default_text_palette), %vwf_text(" Change Appearance Test") ),
		%vwf_text("Reserved"),
		%vwf_text("Reserved"),
		%vwf_text("Reserved"),
		%vwf_text("Reserved"),
		%vwf_text("Reserved"),
		%vwf_text("Reserved"),
		%vwf_text("Exit"))
		
	;%vwf_change_colors(-1, $0000)
	;%vwf_change_colors($100, $0000)
	;%vwf_change_colors($1A)
	;%vwf_change_colors($FF, $0000, $0000)
	;%vwf_change_colors($1A, $0000)
	;%vwf_change_colors($1A, $10000)
	;%vwf_change_colors($1A, -1)
	
	%vwf_set_option_location(TestSelection, 0)
		%vwf_text("This is a line.") : %vwf_line_break()
		%vwf_text("This is a new line.") : %vwf_line_break()
		%vwf_text("Now some text...") : %vwf_wait_frames(60) : %vwf_text(" with a long pause.") : %vwf_wait_frames(30) : %vwf_line_break()
		%vwf_set_text_speed(5) : %vwf_text("This text appears very slowly.") : %vwf_set_text_speed(0) : %vwf_line_break()
		%vwf_wait_for_a() : %vwf_clear()
		
		%vwf_text("Time for some numbers!") : %vwf_line_break()
		%vwf_text("Mario's current coins: ") : %vwf_decimal($7E0DBF, AddressSize.8Bit, true) : %vwf_line_break()
		%vwf_text("Mario's X pos: ") : %vwf_decimal($7E00D1, AddressSize.16Bit) : %vwf_line_break()
		%vwf_text("Current X speed (unsigned dec): ") : %vwf_decimal($7E007B) : %vwf_line_break()
		%vwf_text("Current X speed (hex): $") : %vwf_hex($7E007B) : %vwf_line_break()
		%vwf_text("Current text box color : $") : %vwf_hex(!boxcolor+1) : %vwf_hex(!boxcolor) : %vwf_line_break()
		%vwf_text("Current timer: ") : %vwf_char_at_address($7E0F31) : %vwf_char_at_address($7E0F32) : %vwf_char_at_address($7E0F33) : %vwf_line_break()
		%vwf_wait_for_a() : %vwf_clear()
		
		%vwf_text("ThisLongTextDoesContain") : %vwf_char(' ') : %vwf_text("ANonBreakingSpace") : %vwf_line_break()
		%vwf_wait_for_a() : %vwf_clear()	
		
		%vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(31, 24, 2), vwf_make_color_15(0, 0, 0))
		%vwf_text("Have some text in a ") : %vwf_set_text_palette($06) : %vwf_text("different color ") : %vwf_set_text_palette(!default_text_palette) : %vwf_text("- hooray!") : %vwf_line_break()
		%vwf_wait_for_a() : %vwf_clear()
		
		%vwf_set_font($01)
		
		pushtable
		cleartable
		table "vwftable_font2.txt"
		%vwf_text("Here's some text in a different font.") : %vwf_line_break()
		pulltable
		
		%vwf_set_font(!default_font)
		%vwf_text("And now back to the default.") : %vwf_line_break()
		%vwf_wait_for_a() : %vwf_clear()
		
		%vwf_text("How about a different song?") : %vwf_line_break()
		%vwf_play_bgm($05)
		%vwf_wait_for_a()
		%vwf_play_bgm($02)
		%vwf_clear()
		
		%vwf_text("Commands test complete!") : %vwf_line_break()
		%vwf_wait_for_a()
	
		%vwf_clear()		
		%vwf_set_text_pointer(.Start)
		
	%vwf_set_option_location(TestSelection, 1)
		%vwf_display_message(0000)
		%vwf_close()
		
	%vwf_set_option_location(TestSelection, 2)
		%vwf_close()
		
	%vwf_set_option_location(TestSelection, 3)
		%vwf_text("Where to go?") : %vwf_line_break()
		%vwf_text("(NOTE: Teleporting to midway requires active Lunar Magic hack.)") : %vwf_line_break()
	
		%vwf_display_options(TeleportDestination,
			%vwf_text("Level $0105 (Start)"),
			%vwf_text("Level $0105 (Midway)"),
			%vwf_text("Secondary Entrance $01CB"),
			%vwf_text("Secondary Entrance $01CB (Water)"),
			%vwf_text("Exit"))
		
		%vwf_set_option_location(TeleportDestination, 0)
			%vwf_setup_teleport($0105, false, false)
			%vwf_close()
			
		%vwf_set_option_location(TeleportDestination, 1)
			%vwf_setup_teleport($0105, false, true)
			%vwf_close()
			
		%vwf_set_option_location(TeleportDestination, 2)
			%vwf_setup_teleport($01CB, true, false)
			%vwf_close()
			
		%vwf_set_option_location(TeleportDestination, 3)
			%vwf_setup_teleport($01CB, true, true)
			%vwf_close()
			
		%vwf_set_option_location(TeleportDestination, 4)
			%vwf_clear()
			%vwf_set_text_pointer(.Start)
		
	%vwf_set_option_location(TestSelection, 4)
		%vwf_display_message(0010)
			
	%vwf_set_option_location(TestSelection, 5)
	%vwf_set_option_location(TestSelection, 6)
	%vwf_set_option_location(TestSelection, 7)
	%vwf_set_option_location(TestSelection, 8)
	%vwf_set_option_location(TestSelection, 9)
	%vwf_set_option_location(TestSelection, 10)
	%vwf_set_option_location(TestSelection, 11)
	
	%vwf_set_option_location(TestSelection, 12)
	%vwf_set_skip_location()
		%vwf_text("Thank you for using VWF Dialogues Patch by RPG Hacker!") : %vwf_wait_for_a()

	;%vwf_close()

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0000)	; Message 000-1

	%vwf_header(vwf_x_pos(1), vwf_y_pos(1), vwf_width(14), vwf_height(3), vwf_text_alignment(TextAlignment.Left))
	
	%vwf_text("A relatively standard text box!") : %vwf_line_break()
	%vwf_text("x: 1, y: 1, w: 14, h: 3, alignment: left")
	%vwf_wait_for_a()
	
	%vwf_display_message(0001)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0001)	; Message 000-2

	%vwf_header(vwf_x_pos(3), vwf_y_pos(10), vwf_width(12), vwf_height(5), vwf_text_alignment(TextAlignment.Centered), vwf_font($01), vwf_text_palette($06), vwf_text_color(vwf_make_color_15(0, 0, 0)), vwf_outline_color(vwf_make_color_15(31, 31, 31)))
	
	pushtable
	cleartable
	table "vwftable_font2.txt"
	%vwf_text("Here's one with font + color switched.") : %vwf_line_break()
	%vwf_text("x: 3, y: 10, w: 12, h: 5, alignment: centered, font: $01, text palette: $06, text color: black, outline color: white")
	pulltable
	%vwf_wait_for_a()
	
	%vwf_display_message(0002)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0002)	; Message 001-1

	%vwf_header(vwf_text_alignment(TextAlignment.Left), vwf_space_width(15), vwf_text_margin(0), vwf_text_speed(5), vwf_button_speedup(false), vwf_enable_skipping(false))
	
	%vwf_text("Weird spacing and slow, unskippable text. x)") : %vwf_line_break()
	%vwf_text("alignment: left, space width: 15, text margin: 0, text speed: 5, button speedup: false, enable skipping: false")
	%vwf_wait_for_a()
	
	%vwf_display_message(0003)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0003)	; Message 001-2

	%vwf_header(vwf_height(5), vwf_freeze_game(false), vwf_auto_wait(AutoWait.None))

	%vwf_text("Here's one with lots and lots of text and no auto-wait. Although you can move around in the meantime. Enjoy!") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_wait_for_a()
	
	%vwf_display_message(0004)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0004)	; Message 002-1

	%vwf_header(vwf_height(5), vwf_freeze_game(false), vwf_auto_wait(AutoWait.WaitFrames.60))

	%vwf_text("Same as last one, but with automatic wait frames.") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_text("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")
	%vwf_wait_for_a()
	
	%vwf_display_message(0005)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0005)	; Message 002-2

	%vwf_header(vwf_enable_sfx(false))

	%vwf_text("A silent text box all of a sudden. This is scaaaaaaaary!") : %vwf_line_break()
	%vwf_text("enable sfx: false")
	%vwf_wait_for_a()
	
	%vwf_display_message(0006)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0006)	; Message 003-1

	%vwf_header(vwf_letter_sound($1DFC, 03), vwf_wait_sound($1DFA, 01), vwf_cursor_sound($1DF9, 02), vwf_continue_sound($1DFC, 08))

	%vwf_text("Now this one uses all kinds of funny sound effects all of a sudden!") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("So damn funny, ahahaha! Isn't it? :'D") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_display_options(AreSoundsFunny,
		%vwf_text("Very funny, indeed!"),
		%vwf_text("Sure..."))
	
	%vwf_set_option_location(AreSoundsFunny, 0)
	%vwf_set_option_location(AreSoundsFunny, 1)	
		%vwf_text("letter sound: vine, wait sound: jump, cursor sound: spin jump contact, continue sound: springboard")
		%vwf_wait_for_a()
	
	%vwf_display_message(0007, true)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0007)	; Message 003-2

	%vwf_header(vwf_box_animation(BoxAnimation.MMZ))

	%vwf_text("This box concludes the message box test by closing the box with animation: MMZ") : %vwf_wait_for_a()
		
	%vwf_display_message(0050)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0008)	; Message 004-1

	%vwf_header()

	%vwf_text("Message box test complete!") : %vwf_wait_for_a()

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0009)	; Message 004-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000A)	; Message 005-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000B)	; Message 005-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000C)	; Message 006-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000D)	; Message 006-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000E)	; Message 007-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000F)	; Message 007-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0010)	; Message 008-1

	%vwf_header(vwf_height(5))

	%vwf_text("What to customize?")
	
	%vwf_display_options(CustomizationSelect,
		%vwf_text("Border"),
		%vwf_text("Background"),
		%vwf_text("Background color"),
		%vwf_text("Exit"))
	
	%vwf_set_option_location(CustomizationSelect, 0)
		%vwf_display_message(0011)
	
	%vwf_set_option_location(CustomizationSelect, 1)
		%vwf_display_message(0012)
		
	%vwf_set_option_location(CustomizationSelect, 2)
		%vwf_execute_subroutine(BoxColorStuff_InitializeRAM)
		%vwf_display_message(0013)
		
	%vwf_set_option_location(CustomizationSelect, 3)		
		%vwf_display_message(0050)

%vwf_message_end()

;-------------------------------------------------------

macro message_box_design_change_logic(message_no, var_address, num_designs)
	lda $16
	bit.b #%00000010
	beq .NotLeft
	
	lda <var_address>
	dec
	sta <var_address>
	
	jsr .CheckRange
	
	bra .Redraw
	
.NotLeft
	bit.b #%00000001
	beq .NotRight
	
	lda <var_address>
	inc
	sta <var_address>
	
	jsr .CheckRange
	
	bra .Redraw
	
.Redraw
	lda.b #Message<message_no>_Refresh
	ldx.b #Message<message_no>_Refresh>>8
	ldy.b #Message<message_no>_Refresh>>16
	jsl ChangeVWFTextPtr
	rtl

.NotRight
	lda $18
	bit #%10000000
	beq .NotA
	
	lda #$29
	sta $1DFC
	
	lda.b #Message<message_no>_Done
	ldx.b #Message<message_no>_Done>>8
	ldy.b #Message<message_no>_Done>>16
	jsl ChangeVWFTextPtr

.NotA
	rtl


.CheckRange:
	lda <var_address>
	cmp #$FF
	bne .NotMin
	
	lda #<num_designs>-1
	sta <var_address>
	rts
	
.NotMin
	cmp #<num_designs>
	bne .NotMax
	
	lda #$00
	sta <var_address>
	
.NotMax
	rts
endmacro

;-------------------------------------------------------

%vwf_message_start(0011)	; Message 008-2

	%vwf_header(vwf_x_pos(10), vwf_y_pos(10), vwf_width(5), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_char($93) : %vwf_char(' ') : %vwf_hex(!boxframe) : %vwf_char(' ') : %vwf_char($94) : %vwf_freeze()
	
.Refresh
	%vwf_display_message(0011, true)
	
.Done
	%vwf_display_message(0010)

%vwf_message_end()

MessageASM0011:
	%message_box_design_change_logic(0011, !boxframe, $10)

;-------------------------------------------------------

%vwf_message_start(0012)	; Message 009-1

	%vwf_header(vwf_x_pos(10), vwf_y_pos(10), vwf_width(5), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_char($93) : %vwf_char(' ') : %vwf_hex(!boxbg) : %vwf_char(' ') : %vwf_char($94) : %vwf_freeze()
	
.Refresh
	%vwf_display_message(0012, true)
	
.Done
	%vwf_display_message(0010)

%vwf_message_end()

MessageASM0012:
	%message_box_design_change_logic(0012, !boxbg, $0E)

;-------------------------------------------------------

; RPG Hacker: Yeah, whatever, we can do this here. It's just for testing, anyways.
%claim_varram(edit_color_r, 2)
%claim_varram(edit_color_g, 2)
%claim_varram(edit_color_b, 2)
%claim_varram(edit_color_id, 1)

BoxColorStuff:

.InitializeRAM:	
	lda #$00
	sta !edit_color_id
	
	rep #$20
	
	lda !boxcolor
	and.w #%00011111
	sta !edit_color_r
	
	lda !boxcolor
	lsr #5
	and.w #%00011111
	sta !edit_color_g
	
	lda !boxcolor
	lsr #10
	sta !edit_color_b
	
	sep #$20
	
	rtl
	
.Commit:	
	rep #$20
	
	lda !edit_color_b
	asl #5
	ora !edit_color_g
	asl #5
	ora !edit_color_r
	
	sta !boxcolor
	
	sep #$20

	rts
	
.ProcessInput:
	lda $16
	bit.b #%00001000
	beq .NotUp
	
	lda !edit_color_id
	dec
	cmp #$FF
	bne .NoUnderflow
	lda #$02
	
.NoUnderflow
	sta !edit_color_id
	
	asl
	tax	
	jsr (.RedrawTable,x)
	
	bra .CheckLeftRight
	
.NotUp:
	bit.b #%00000100
	beq .NotDown
	
	lda !edit_color_id
	inc
	cmp #$03
	bne .NoOverflow
	lda #$00
	
.NoOverflow
	sta !edit_color_id
	
	asl
	tax	
	jsr (.RedrawTable,x)
	
	bra .CheckLeftRight
	
.NotDown

.CheckLeftRight
	lda !edit_color_id
	asl
	tax
	
	jsr (.RoutineTable,x)
	jsr .Commit
	
	rts
	

.RoutineTable
dw .EditRed, .EditGreen, .EditBlue

.RedrawTable
dw .RedrawRed, .RedrawGreen, .RedrawBlue


.EditRed
	jsl BoxEditRed
	rts
	
.EditGreen
	jsl BoxEditGreen
	rts
	
.EditBlue
	jsl BoxEditBlue
	rts


.RedrawRed
	jsl BoxEditRed_Redraw
	rts
	
.RedrawGreen
	jsl BoxEditGreen_Redraw
	rts
	
.RedrawBlue
	jsl BoxEditBlue_Redraw
	rts
	
	
; RPG Hacker: Very stupid, wasteful code, but whatever.
; It's just for testing, anyways.

BoxEditRed:
%message_box_design_change_logic(0013, !edit_color_r, 32)

BoxEditGreen:
%message_box_design_change_logic(0014, !edit_color_g, 32)

BoxEditBlue:
%message_box_design_change_logic(0015, !edit_color_b, 32)
	
	
MessageASM0013:
MessageASM0014:
MessageASM0015:
	jsr BoxColorStuff_ProcessInput
	rtl
	
;-------------------------------------------------------

%vwf_message_start(0013)	; Message 009-2

	%vwf_header(vwf_x_pos(9), vwf_y_pos(10), vwf_width(6), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(31, 12, 12), vwf_make_color_15(0, 0, 0))

	%vwf_char($96) : %vwf_char($95) : %vwf_char(' ') : %vwf_char($93)
	%vwf_char(' ') : %vwf_set_text_palette($06) : %vwf_text("R:") : %vwf_set_text_palette(!default_text_palette) : %vwf_text(" ")
	%vwf_decimal(!edit_color_r) : %vwf_char(' ') : %vwf_char($94)
	%vwf_freeze()
	
.Refresh
	%vwf_display_message(0013, true)
	
.Done
	%vwf_display_message(0010)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0014)	; Message 00A-1

	%vwf_header(vwf_x_pos(9), vwf_y_pos(10), vwf_width(6), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(6, 31, 6), vwf_make_color_15(0, 0, 0))

	%vwf_char($96) : %vwf_char($95) : %vwf_char(' ') : %vwf_char($93)
	%vwf_char(' ') : %vwf_set_text_palette($06) : %vwf_text("G:") : %vwf_set_text_palette(!default_text_palette) : %vwf_text(" ")
	%vwf_decimal(!edit_color_g) : %vwf_char(' ') : %vwf_char($94)
	%vwf_freeze()
	
.Refresh
	%vwf_display_message(0014, true)
	
.Done
	%vwf_display_message(0010)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0015)	; Message 00A-2

	%vwf_header(vwf_x_pos(9), vwf_y_pos(10), vwf_width(6), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(15, 15, 31), vwf_make_color_15(0, 0, 0))

	%vwf_char($96) : %vwf_char($95) : %vwf_char(' ') : %vwf_char($93)
	%vwf_char(' ') : %vwf_set_text_palette($06) : %vwf_text("B:") : %vwf_set_text_palette(!default_text_palette) : %vwf_text(" ")
	%vwf_decimal(!edit_color_b) : %vwf_char(' ') : %vwf_char($94)
	%vwf_freeze()
	
.Refresh
	%vwf_display_message(0015, true)
	
.Done
	%vwf_display_message(0010)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0016)	; Message 00B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0017)	; Message 00B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0018)	; Message 00C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0019)	; Message 00C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001A)	; Message 00D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001B)	; Message 00D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001C)	; Message 00E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001D)	; Message 00E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001E)	; Message 00F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(001F)	; Message 00F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0020)	; Message 010-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0021)	; Message 010-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0022)	; Message 011-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0023)	; Message 011-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0024)	; Message 012-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0025)	; Message 012-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0026)	; Message 013-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0027)	; Message 013-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0028)	; Message 014-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0029)	; Message 014-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002A)	; Message 015-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002B)	; Message 015-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002C)	; Message 016-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002D)	; Message 016-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002E)	; Message 017-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002F)	; Message 017-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0030)	; Message 018-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0031)	; Message 018-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0032)	; Message 019-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0033)	; Message 019-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0034)	; Message 01A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0035)	; Message 01A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0036)	; Message 01B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0037)	; Message 01B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0038)	; Message 01C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0039)	; Message 01C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003A)	; Message 01D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003B)	; Message 01D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003C)	; Message 01E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003D)	; Message 01E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003E)	; Message 01F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(003F)	; Message 01F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0040)	; Message 020-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0041)	; Message 020-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0042)	; Message 021-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0043)	; Message 021-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0044)	; Message 022-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0045)	; Message 022-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0046)	; Message 023-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0047)	; Message 023-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0048)	; Message 024-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0049)	; Message 024-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004A)	; Message 101-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004B)	; Message 101-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004C)	; Message 102-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004D)	; Message 102-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004E)	; Message 103-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004F)	; Message 103-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0051)	; Message 104-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0052)	; Message 105-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0053)	; Message 105-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0054)	; Message 106-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0055)	; Message 106-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0056)	; Message 107-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0057)	; Message 107-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0058)	; Message 108-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0059)	; Message 108-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005A)	; Message 109-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005B)	; Message 109-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005C)	; Message 10A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005D)	; Message 10A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005E)	; Message 10B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(005F)	; Message 10B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0060)	; Message 10C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0061)	; Message 10C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0062)	; Message 10D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0063)	; Message 10D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0064)	; Message 10E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0065)	; Message 10E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0066)	; Message 10F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0067)	; Message 10F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0068)	; Message 110-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0069)	; Message 110-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006A)	; Message 111-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006B)	; Message 111-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006C)	; Message 112-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006D)	; Message 112-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006E)	; Message 113-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(006F)	; Message 113-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0070)	; Message 114-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0071)	; Message 114-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0072)	; Message 115-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0073)	; Message 115-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0074)	; Message 116-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0075)	; Message 116-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0076)	; Message 117-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0077)	; Message 117-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0078)	; Message 118-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0079)	; Message 118-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007A)	; Message 119-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007B)	; Message 119-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007C)	; Message 11A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007D)	; Message 11A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007E)	; Message 11B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(007F)	; Message 11B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0080)	; Message 11C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0081)	; Message 11C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0082)	; Message 11D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0083)	; Message 11D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0084)	; Message 11E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0085)	; Message 11E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0086)	; Message 11F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0087)	; Message 11F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0088)	; Message 120-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0089)	; Message 120-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008A)	; Message 121-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008B)	; Message 121-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008C)	; Message 122-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008D)	; Message 122-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008E)	; Message 123-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(008F)	; Message 123-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0090)	; Message 124-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0091)	; Message 124-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0092)	; Message 125-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0093)	; Message 125-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0094)	; Message 126-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0095)	; Message 126-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0096)	; Message 127-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0097)	; Message 127-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0098)	; Message 128-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0099)	; Message 128-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009A)	; Message 129-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009B)	; Message 129-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009C)	; Message 12A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009D)	; Message 12A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009E)	; Message 12B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(009F)	; Message 12B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A0)	; Message 12C-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A1)	; Message 12C-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A2)	; Message 12D-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A3)	; Message 12D-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A4)	; Message 12E-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A5)	; Message 12E-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A6)	; Message 12F-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A7)	; Message 12F-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A8)	; Message 130-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00A9)	; Message 130-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AA)	; Message 131-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AB)	; Message 131-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AC)	; Message 132-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AD)	; Message 132-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AE)	; Message 133-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00AF)	; Message 133-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B0)	; Message 134-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B1)	; Message 134-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B2)	; Message 135-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B3)	; Message 135-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B4)	; Message 136-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B5)	; Message 136-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B6)	; Message 137-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B7)	; Message 137-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B8)	; Message 138-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00B9)	; Message 138-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BA)	; Message 139-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BB)	; Message 139-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BC)	; Message 13A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BD)	; Message 13A-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BE)	; Message 13B-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00BF)	; Message 13B-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C0)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C1)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C2)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C3)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C4)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C5)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C6)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C7)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C8)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00C9)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CA)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CB)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CC)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CD)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CE)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00CF)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D0)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D1)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D2)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D3)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D4)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D5)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D6)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D7)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D8)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00D9)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DA)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DB)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DC)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DD)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DE)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00DF)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E0)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E1)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E2)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E3)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E4)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E5)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E6)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E7)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E8)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00E9)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EA)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EB)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EC)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00ED)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EE)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00EF)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F0)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F1)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F2)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F3)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F4)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F5)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F6)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F7)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F8)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00F9)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FA)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FB)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FC)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FD)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FE)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(00FF)

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

; DIALOG DATA END

;-------------------------------------------------------

; DIALOG DATA BEGIN

; Text macros:

%vwf_register_text_macro("Option2Text", %vwf_wrap( %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_text(" "), %vwf_set_text_palette($04), %vwf_text("Message Boxes"), %vwf_set_text_palette(!default_text_palette), %vwf_text(" Test") ))
%vwf_register_text_macro("Option3Text", %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_text(" "), %vwf_set_text_palette($05), %vwf_text("Pointers"), %vwf_set_text_palette(!default_text_palette), %vwf_text(" Test") )


%vwf_register_text_macro("Mario", %vwf_change_colors(vwf_get_color_index_2bpp($05, !vwf_text_color_id), vwf_make_color_15(31, 12, 12), vwf_make_color_15(0, 0, 0)), %vwf_set_text_palette($05), %vwf_text("Mario"), %vwf_set_text_palette(!default_text_palette) )

%vwf_register_text_macro("Luigi", %vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(6, 31, 6), vwf_make_color_15(0, 0, 0)), %vwf_set_text_palette($06), %vwf_text("Luigi"), %vwf_set_text_palette(!default_text_palette) )


%vwf_register_text_macro("SmallPowerup", %vwf_text("Small") )
%vwf_register_text_macro("SuperPowerup", %vwf_text("Super") )
%vwf_register_text_macro("CapePowerup", %vwf_text("Cape") )
%vwf_register_text_macro("FirePowerup", %vwf_text("Fire") )


%vwf_register_text_macro("SuperMario", %vwf_execute_text_macro("SuperPowerup"), %vwf_non_breaking_space(), %vwf_execute_text_macro("Mario"))


%vwf_start_text_macro_group("PlayerName")
	%vwf_add_text_macro_to_group("Mario")
	%vwf_add_text_macro_to_group("Luigi")
%vwf_end_text_macro_group()

%vwf_start_text_macro_group("PlayerPowerup")
	%vwf_add_text_macro_to_group("SmallPowerup")
	%vwf_add_text_macro_to_group("SuperPowerup")
	%vwf_add_text_macro_to_group("CapePowerup")
	%vwf_add_text_macro_to_group("FirePowerup")
%vwf_end_text_macro_group()

%vwf_register_text_macro("CurrentPlayer", %vwf_execute_text_macro_by_indexed_group("PlayerName", remap_ram($7E0DB3)))

%vwf_register_text_macro("CurrentPlayerWithPowerup", %vwf_execute_text_macro_by_indexed_group("PlayerPowerup", remap_ram($7E0019)), %vwf_non_breaking_space(), %vwf_execute_text_macro("CurrentPlayer"))


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
		%vwf_wrap( %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_set_text_palette(!default_text_palette), %vwf_text(" Routines Test") ),
		%vwf_wrap( %vwf_set_text_palette($05), %vwf_char($00AC), %vwf_set_text_palette(!default_text_palette), %vwf_text(" Error Handling Test") ),
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
		%vwf_text("Mario's current coins: ") : %vwf_decimal(remap_ram($7E0DBF), AddressSize.8Bit, true) : %vwf_line_break()
		%vwf_text("Mario's X pos: ") : %vwf_decimal(remap_ram($7E00D1), AddressSize.16Bit) : %vwf_line_break()
		%vwf_text("Current X speed (unsigned dec): ") : %vwf_decimal(remap_ram($7E007B)) : %vwf_line_break()
		%vwf_text("Current X speed (hex): $") : %vwf_hex(remap_ram($7E007B)) : %vwf_line_break()
		%vwf_text("Current text box color : $") : %vwf_hex(!boxcolor+1) : %vwf_hex(!boxcolor) : %vwf_line_break()
		%vwf_text("Current timer: ") : %vwf_char_at_address(remap_ram($7E0F31)) : %vwf_char_at_address(remap_ram($7E0F32)) : %vwf_char_at_address(remap_ram($7E0F33)) : %vwf_line_break()
		%vwf_wait_for_a() : %vwf_clear()
		
		%vwf_text("ThisLongTextDoesContain") : %vwf_non_breaking_space() : %vwf_text("ANonBreakingSpace") : %vwf_line_break()
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
		%vwf_display_message(0030)
		
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
		%vwf_display_message(0020)
			
	%vwf_set_option_location(TestSelection, 5)
		%vwf_display_message(0040)
	
	%vwf_set_option_location(TestSelection, 6)
		%vwf_display_message(0060)
	
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

macro generate_message_test_messages(first_message_id, second_message_id, show_animations, alternate_font, text, next_message, ...)

	; RPG Hacker: First message.
	%vwf_message_start(<first_message_id>)
	
		%vwf_header(vwf_x_pos(1), vwf_y_pos(1), vwf_width(14), vwf_height(12), vwf_text_alignment(TextAlignment.Left))

		%vwf_text("Next test:") : %vwf_line_break()

		!temp_i #= 0
		while !temp_i < sizeof(...)
			%vwf_non_breaking_space() : %vwf_non_breaking_space()
			%vwf_text("<!temp_i>")
			if !temp_i == sizeof(...)-1
				%vwf_wait_for_a()
			else
				%vwf_line_break()
			endif
			
			!temp_i #= !temp_i+1
		endwhile
		undef "temp_i"
		
		if <show_animations> != false
			%vwf_display_message(<second_message_id>, false, true)
		else
			%vwf_display_message(<second_message_id>)
		endif
	
	%vwf_message_end()



	; RPG Hacker: Second message.
	if <alternate_font> != false
		pushtable
		cleartable
		table "vwftable_font2.txt"
	endif
	
	%vwf_message_start(<second_message_id>)
		!temp_params = ""
	
		!temp_i #= 0
		while !temp_i < sizeof(...)
			if !temp_i == 0
				!temp_params += "<!temp_i>"
			else
				!temp_params += ", <!temp_i>"
			endif
			
			!temp_i #= !temp_i+1
		endwhile
		undef "temp_i"	
		
		%vwf_header(!temp_params)
		
		<text>
		
		%vwf_wait_for_a()
		
		if <show_animations> != false
			%vwf_display_message(<next_message>, true, false)
		else
			%vwf_display_message(<next_message>)
		endif
		
	%vwf_message_end()
	
	if <alternate_font> != false
		pulltable
	endif
endmacro

;-------------------------------------------------------

; Messages 000-1 and 000-2
%generate_message_test_messages(0000, 0001, false, false, %vwf_text("A relatively standard text box!"), 0002, vwf_x_pos(1), vwf_y_pos(1), vwf_width(14), vwf_height(3), vwf_text_alignment(TextAlignment.Left))

;-------------------------------------------------------

; Messages 001-1 and 001-2	
; RPG Hacker: The animation = instant and the show_animation = true are necessary here, because
; the background color won't get initialized otherwise. If we start this test from test selector,
; that usually won't be a problem, because palette commands in that test already override the BG
; color of palette 6. However, if we run this test by itself (which happens by seeing the special
; "Yoshi found" message), this would usually lead to a black background.
%generate_message_test_messages(0002, 0003, true, true, %vwf_text("This one is small, uses centered text and also a different font and color."), 0004, vwf_x_pos(3), vwf_y_pos(10), vwf_width(12), vwf_height(5), vwf_text_alignment(TextAlignment.Centered), vwf_font($01), vwf_text_palette($06), vwf_text_color(vwf_make_color_15(0, 0, 0)), vwf_outline_color(vwf_make_color_15(31, 31, 31)), vwf_box_animation(BoxAnimation.Instant))

;-------------------------------------------------------

; Messages 002-1 and 002-2
%generate_message_test_messages(0004, 0005, false, false, %vwf_text("Weird spacing and slow, unskippable text, lol. Wasting a tester's time is fun."), 0006, vwf_text_alignment(TextAlignment.Left), vwf_space_width(15), vwf_text_margin(0), vwf_text_speed(5), vwf_button_speedup(false), vwf_enable_skipping(false))

;-------------------------------------------------------

; Messages 003-1 and 003-2
%generate_message_test_messages(0006, 0007, false, false, %vwf_text("This text box hardly gives you enough time to read anything. Like WHAT THE FUCK, why is everything so fast? Why doesn't it stop? Why doesn't it give me any time to read anything? Like, who is supposed to read this? I mean, slow down, Satan. Slow the fuck down! I want to actually enjoy the story of this game, and not feel like I was running a marathon. Whatever, I'll just watch a playthrough of the game on YouTube and press pause so that I can read everything properly. Oh yeah, did you notice you can walk around while this text box is active?"), 0008, vwf_height(5), vwf_freeze_game(false), vwf_auto_wait(AutoWait.None))

;-------------------------------------------------------

; Messages 004-1 and 004-2
%generate_message_test_messages(0008, 0009, false, false, %vwf_text("This text box gives us a little more time to read everything, but in reality, it's actually just way too fucking fast again. Like, come on! Why even use the 'auto wait' option like that? Why not just use 'press A' and let the player read everything at their own pace? Are you deliberately torturing us? You just want us to not enjoy your game, do you? Well, I tell you something. I'll go on SMW Central right fucking now, give this hack a bad fucking rating and then complain about its text boxes being too fucking fast for me in the review. I hope this is what you wanted!"), 000A, vwf_height(5), vwf_freeze_game(false), vwf_auto_wait(AutoWait.WaitFrames.60))

;-------------------------------------------------------

; Messages 005-1 and 005-2
%generate_message_test_messages(000A, 000B, false, false, %vwf_text("This text box is completely silent. Not much else going on here. Just enjoy this little break after the previous torture!"), 000C, vwf_enable_sfx(false))

;-------------------------------------------------------

; Messages 006-1 and 006-2
%generate_message_test_messages(000C, 000D, false, false,
	%vwf_wrap( %vwf_text("This text box, on the other hand, uses some hilariously fucking funny sound effects! HAHAHA!"), %vwf_wait_for_a(), %vwf_clear(),
		%vwf_text("I mean, that was already fucking hilarious, but check out that cursor sound effect! xDDDD"), %vwf_wait_for_a(), %vwf_clear(),	
		%vwf_display_options(CheckFunnyCursorSound,
			%vwf_text("Okay, let me see..."),
			%vwf_text("HAHAHAHAHAHA!")),	
		%vwf_set_option_location(CheckFunnyCursorSound, 0),
		%vwf_set_option_location(CheckFunnyCursorSound, 1),
		%vwf_text("Literally pissing myself over here!") ),
	000E, vwf_enable_sfx(true), vwf_letter_sound($1DFC, 03), vwf_wait_sound($1DFA, 01), vwf_cursor_sound($1DF9, 02), vwf_continue_sound($1DFC, 08))

;-------------------------------------------------------

; Messages 007-1 and 007-2
%generate_message_test_messages(000E, 000F, true, false, %vwf_text("Time to test the different box animations. This one is Mega Man Zero-styled."), 0010, vwf_box_animation(BoxAnimation.MMZ))

;-------------------------------------------------------

; Messages 008-1 and 008-2
%generate_message_test_messages(0010, 0011, true, false, %vwf_text("Secret of Evermore-styled."), 0012, vwf_box_animation(BoxAnimation.SoE))

;-------------------------------------------------------

; Messages 009-1 and 009-2
%generate_message_test_messages(0012, 0013, true, false, %vwf_text("Secret of Mana-styled."), 0014, vwf_box_animation(BoxAnimation.SoM))

;-------------------------------------------------------

; Messages 00A-1 and 00A-2
%generate_message_test_messages(0014, 0015, true, false, %vwf_text("This one just appears and disappears instantly, with no animation whatsoever."), 0016, vwf_box_animation(BoxAnimation.Instant))

;-------------------------------------------------------

; Messages 00B-1 and 00B-2
%generate_message_test_messages(0016, 0017, true, false, %vwf_text("And this one doesn't even display a box at all, only text, which saves some precious cycles."), 0018, vwf_box_animation(BoxAnimation.None))

;-------------------------------------------------------

%vwf_message_start(0018)	; Message 00C-1

	%vwf_header()

	%vwf_text("Message box test complete!") : %vwf_wait_for_a()
	
	%vwf_display_message(0050)

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

	%vwf_header(vwf_height(5))

	%vwf_text("What to customize?")
	
	%vwf_display_options(CustomizationSelect,
		%vwf_text("Border"),
		%vwf_text("Background"),
		%vwf_text("Background color"),
		%vwf_text("Exit"))
	
	%vwf_set_option_location(CustomizationSelect, 0)
		%vwf_display_message(0021)
	
	%vwf_set_option_location(CustomizationSelect, 1)
		%vwf_display_message(0022)
		
	%vwf_set_option_location(CustomizationSelect, 2)
		%vwf_execute_subroutine(BoxColorStuff_InitializeRAM)
		%vwf_display_message(0023)
		
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
	jsl VWF_ChangeVWFTextPtr
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
	jsl VWF_ChangeVWFTextPtr

.NotA
	rtl


.CheckRange:
	lda <var_address>
	cmp #$FF
	bne .NotMin
	
	lda.b #<num_designs>-1
	sta <var_address>
	rts
	
.NotMin
	cmp.b #<num_designs>
	bne .NotMax
	
	lda #$00
	sta <var_address>
	
.NotMax
	rts
endmacro

;-------------------------------------------------------

%vwf_message_start(0021)	; Message 010-2

	%vwf_header(vwf_x_pos(10), vwf_y_pos(10), vwf_width(5), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_char($93) : %vwf_non_breaking_space() : %vwf_hex(!boxframe) : %vwf_non_breaking_space() : %vwf_char($94) : %vwf_freeze()
	
.Refresh
	%vwf_display_message(0021, false, true)
	
.Done
	%vwf_display_message(0020)

%vwf_message_end()

MessageASM0021:
	%message_box_design_change_logic(0021, !boxframe, !num_frames)

;-------------------------------------------------------

%vwf_message_start(0022)	; Message 011-1

	%vwf_header(vwf_x_pos(10), vwf_y_pos(10), vwf_width(5), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_char($93) : %vwf_non_breaking_space() : %vwf_hex(!boxbg) : %vwf_non_breaking_space() : %vwf_char($94) : %vwf_freeze()
	
.Refresh
	%vwf_display_message(0022, false, true)
	
.Done
	%vwf_display_message(0020)

%vwf_message_end()

MessageASM0022:
	%message_box_design_change_logic(0022, !boxbg, !num_bg_patterns)

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
%message_box_design_change_logic(0023, !edit_color_r, 32)

BoxEditGreen:
%message_box_design_change_logic(0024, !edit_color_g, 32)

BoxEditBlue:
%message_box_design_change_logic(0025, !edit_color_b, 32)
	
	
MessageASM0023:
MessageASM0024:
MessageASM0025:
	jsr BoxColorStuff_ProcessInput
	rtl
	
;-------------------------------------------------------

%vwf_message_start(0023)	; Message 011-2

	%vwf_header(vwf_x_pos(9), vwf_y_pos(10), vwf_width(6), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(31, 12, 12), vwf_make_color_15(0, 0, 0))

	%vwf_char($96) : %vwf_char($95) : %vwf_non_breaking_space() : %vwf_char($93)
	%vwf_non_breaking_space() : %vwf_set_text_palette($06) : %vwf_text("R:") : %vwf_set_text_palette(!default_text_palette) : %vwf_text(" ")
	%vwf_decimal(!edit_color_r) : %vwf_non_breaking_space() : %vwf_char($94)
	%vwf_freeze()
	
.Refresh
	%vwf_display_message(0023, false, true)
	
.Done
	%vwf_display_message(0020)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0024)	; Message 012-1

	%vwf_header(vwf_x_pos(9), vwf_y_pos(10), vwf_width(6), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(6, 31, 6), vwf_make_color_15(0, 0, 0))

	%vwf_char($96) : %vwf_char($95) : %vwf_non_breaking_space() : %vwf_char($93)
	%vwf_non_breaking_space() : %vwf_set_text_palette($06) : %vwf_text("G:") : %vwf_set_text_palette(!default_text_palette) : %vwf_text(" ")
	%vwf_decimal(!edit_color_g) : %vwf_non_breaking_space() : %vwf_char($94)
	%vwf_freeze()
	
.Refresh
	%vwf_display_message(0024, false, true)
	
.Done
	%vwf_display_message(0020)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0025)	; Message 012-2

	%vwf_header(vwf_x_pos(9), vwf_y_pos(10), vwf_width(6), vwf_height(1), vwf_text_alignment(TextAlignment.Centered), vwf_enable_sfx(false), vwf_enable_message_asm(true), vwf_box_animation(BoxAnimation.Instant))
	
	%vwf_change_colors(vwf_get_color_index_2bpp($06, !vwf_text_color_id), vwf_make_color_15(15, 15, 31), vwf_make_color_15(0, 0, 0))

	%vwf_char($96) : %vwf_char($95) : %vwf_non_breaking_space() : %vwf_char($93)
	%vwf_non_breaking_space() : %vwf_set_text_palette($06) : %vwf_text("B:") : %vwf_set_text_palette(!default_text_palette) : %vwf_text(" ")
	%vwf_decimal(!edit_color_b) : %vwf_non_breaking_space() : %vwf_char($94)
	%vwf_freeze()
	
.Refresh
	%vwf_display_message(0025, false, true)
	
.Done
	%vwf_display_message(0020)

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

	%vwf_header()
		
	%vwf_text("Text macro:") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("This is a ") : %vwf_execute_text_macro("Mario") : %vwf_text(" game! Oh yeah, ") : %vwf_execute_text_macro("Luigi") : %vwf_text(" is also here.") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_text("Nested text macro:") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("Welcome to ") : %vwf_execute_text_macro("SuperMario") : %vwf_text(" World!") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_text("Indexed text macro group:") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("Hey there, ") : %vwf_execute_text_macro_by_indexed_group("PlayerName", remap_ram($7E0DB3)) : %vwf_text(" - how are you doing?") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_text("Indexed text macro group inside a text macro:") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("Welcome back, ") : %vwf_execute_text_macro("CurrentPlayer") : %vwf_text(" - good to see you again!") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_text("Multiple indexed text macro groups inside a multi-level deep text macro:") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("If that ain't the infamous ") : %vwf_execute_text_macro("CurrentPlayerWithPowerup") : %vwf_text(" - what brought you here?") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_text("A couple of buffered macros:") : %vwf_execute_subroutine(InitializeBufferedMacros1) : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("Hey now, who do we have here? If it isn't our friends ") : %vwf_execute_buffered_text_macro(0) : %vwf_text(" and ") : %vwf_execute_buffered_text_macro(1) : %vwf_text("!") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_display_message(0034)

%vwf_message_end()

InitializeBufferedMacros1:
	jsl VWF_ResetBufferedTextMacros
	
	jsl VWF_BeginBufferedTextMacro
	%add_to_buffered_text_macro(.Str1)
	%add_to_buffered_text_macro(.Str2)
	%add_to_buffered_text_macro(.Str3)
	%add_to_buffered_text_macro(.Str4)
	jsl VWF_EndBufferedTextMacro
	
	jsl VWF_BeginBufferedTextMacro
	%add_to_buffered_text_macro(.Str1)
	%add_to_buffered_text_macro(.Str2)
	%add_to_buffered_text_macro(.Str5)
	%add_to_buffered_text_macro(.Str6)
	jsl VWF_EndBufferedTextMacro
	
	rtl
	
.Str1:
	%vwf_inline(%vwf_text("Buf"))
	
.Str2:
	%vwf_inline(%vwf_text("fered"))
	
.Str3:
	%vwf_inline(%vwf_text(" Mar"))
	
.Str4:
	%vwf_inline(%vwf_text("io"))
	
.Str5:
	%vwf_inline(%vwf_text(" Lui"))
	
.Str6:
	%vwf_inline(%vwf_text("gi"))

;-------------------------------------------------------

%vwf_message_start(0031)	; Message 018-2

	%vwf_header(vwf_enable_message_asm(true))
	
	%vwf_text("This text box uses MessageASM to animate the text color, WHOOOA!")
	%vwf_wait_for_a() : %vwf_clear()
	
	%vwf_display_message(0032)

%vwf_message_end()

MessageASM0031:
	!temp_target_address #= !palettebackupram+(vwf_get_color_index_2bpp(!default_text_palette, !vwf_text_color_id)*2)
	
	lda #$00
	xba
	lda $13
	
	rep #$30
	asl
	tax
	
	lda SillyColorAnimTable,x
	sta !temp_target_address
	sep #$30
	
	lda #$01
	sta !paletteupload
	
	undef "temp_target_address"
	
	rtl
	
SillyColorAnimTable:
	!temp_i #= 0
	while !temp_i < 256
		!temp_max_val #= 31
		!temp_min_val #= 8
		!temp_speed #= 4.0		
		 
		!temp_range_mult #= (!temp_max_val-!temp_min_val)/2
		!temp_offset #= !temp_range_mult+!temp_min_val
		
		!temp_channel_val #=          (cos((3.14159265359*2)*((!temp_i/256)*!temp_speed))*!temp_range_mult)+!temp_offset
		!temp_reverse_channel_val #=  (sin((3.14159265359*2)*((!temp_i/256)*!temp_speed))*!temp_range_mult)+!temp_offset
		
		dw vwf_make_color_15(!temp_reverse_channel_val, !temp_channel_val, 3)
		
		undef "temp_max_val"
		undef "temp_min_val"
		undef "temp_speed"
		
		undef "temp_range_mult"
		undef "temp_offset"
		
		undef "temp_channel_val"
		undef "temp_reverse_channel_val"
	
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"

;-------------------------------------------------------

%vwf_message_start(0032)	; Message 019-1

	%vwf_header(vwf_enable_message_asm(true), vwf_enable_skipping(false))	
	
	%vwf_text("This text box is completely frozen via %vwf_freeze().") : %vwf_line_break()
	%vwf_text("Hold L + R to continue.") : %vwf_freeze()

.Continue
	%vwf_display_message(0033)

%vwf_message_end()

MessageASM0032:
	lda $17
	and.b #%00110000
	cmp.b #%00110000
	bne .NotPressed

	lda #$29
	sta $1DFC
	
	lda.b #Message0032_Continue
	ldx.b #Message0032_Continue>>8
	ldy.b #Message0032_Continue>>16
	jsl VWF_ChangeVWFTextPtr
	
.NotPressed
	rtl

;-------------------------------------------------------

%vwf_message_start(0033)	; Message 019-2

	%vwf_header()

	%vwf_clear()

	%vwf_text("Pointers test complete!") : %vwf_line_break()
	%vwf_wait_for_a()
	
	%vwf_display_message(0050)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0034)	; Message 01A-1

	%vwf_header(vwf_x_pos(0), vwf_y_pos(0), vwf_width(15), vwf_height(13), vwf_text_alignment(TextAlignment.Left))
	
	%vwf_execute_subroutine(InitializePlayerName)
	
.RedrawPlayerName
	%vwf_clear() : %vwf_text("Please enter a player name!") : %vwf_line_break()
	%vwf_text("Current: ") : %vwf_execute_buffered_text_macro(0) : %vwf_line_break()
	
	%vwf_display_options(PlayerNameEntry,
		%vwf_text("SU"),
		%vwf_text("PER"),
		%vwf_text("MA"),
		%vwf_text("RI"),
		%vwf_text("O"),
		%vwf_text("LU"),
		%vwf_text("I"),
		%vwf_text("GI"),
		%vwf_text("(Space)"),
		%vwf_text("Reset"),
		%vwf_text("Done"))
	
	%vwf_set_option_location(PlayerNameEntry, 0)
		%vwf_execute_subroutine(EditPlayerName_Add0)
	
	%vwf_set_option_location(PlayerNameEntry, 1)
		%vwf_execute_subroutine(EditPlayerName_Add1)
		
	%vwf_set_option_location(PlayerNameEntry, 2)
		%vwf_execute_subroutine(EditPlayerName_Add2)
		
	%vwf_set_option_location(PlayerNameEntry, 3)
		%vwf_execute_subroutine(EditPlayerName_Add3)
		
	%vwf_set_option_location(PlayerNameEntry, 4)
		%vwf_execute_subroutine(EditPlayerName_Add4)
		
	%vwf_set_option_location(PlayerNameEntry, 5)
		%vwf_execute_subroutine(EditPlayerName_Add5)
		
	%vwf_set_option_location(PlayerNameEntry, 6)
		%vwf_execute_subroutine(EditPlayerName_Add6)
		
	%vwf_set_option_location(PlayerNameEntry, 7)
		%vwf_execute_subroutine(EditPlayerName_Add7)
		
	%vwf_set_option_location(PlayerNameEntry, 8)
		%vwf_execute_subroutine(EditPlayerName_Add8)
		
	%vwf_set_option_location(PlayerNameEntry, 9)
		%vwf_execute_subroutine(EditPlayerName_Clear)
		
	
	%vwf_set_option_location(PlayerNameEntry, 10)
		%vwf_text("Welcome, ") : %vwf_execute_buffered_text_macro(0) : %vwf_text("!") : %vwf_wait_for_a()
	
		%vwf_display_message(0031)

%vwf_message_end()


; Again... we can do this, because it's just for testing.
!player_name_max_length = 16*(1+!bitmode)
%claim_varram(player_name_length, 2)
%claim_varram(player_name, !player_name_max_length)


InitializePlayerName:
	jsl VWF_ResetBufferedTextMacros
	
	jsl VWF_BeginBufferedTextMacro
	jsl VWF_EndBufferedTextMacro
	
	lda #$00
	sta !player_name_length
	sta !player_name_length+1
	
	rtl
	
EditPlayerName:

.Add0
	pea .Str0
	bra .Commit
	
.Add1
	pea .Str1
	bra .Commit
	
.Add2
	pea .Str2
	bra .Commit
	
.Add3
	pea .Str3
	bra .Commit
	
.Add4
	pea .Str4
	bra .Commit
	
.Add5
	pea .Str5
	bra .Commit
	
.Add6
	pea .Str6
	bra .Commit
	
.Add7
	pea .Str7
	bra .Commit
	
.Add8
	pea .Str8
	bra .Commit

.Clear
	jsl InitializePlayerName
	bra .Redraw
	
.Commit
	phb
	lda.b #bank(.Str0)
	pha
	plb
	
	rep #$30
	
	ldy.w #$0000
	; Load size into A and copy it into $06 for easy access.
	lda ($02,s),y
	sta $06
	
	; Now skip past the length specifier in the address on stack.
	lda $02,s
	inc #2
	sta $02,s
	
	; Load player name length into X, so that we can append at the end.
	lda !player_name_length
	tax
	
.Copy
	; Make sure we don't overflow our maximum allowed length.
	cpx.w #!player_name_max_length
	bcs .Done

	lda ($02,s),y
	sta !player_name,x
	inx
	iny
	
	; Damn, this doesn't exist.
	cpy $06
	bcc .Copy
	
.Done
	plb

	txa
	sta !player_name_length
	
	pla
	
	sep #$30
	
	jsl VWF_ResetBufferedTextMacros
	
	jsl VWF_BeginBufferedTextMacro
	%add_to_buffered_text_macro(!player_name_length)
	jsl VWF_EndBufferedTextMacro
	
.Redraw
	lda.b #Message0034_RedrawPlayerName
	ldx.b #Message0034_RedrawPlayerName>>8
	ldy.b #Message0034_RedrawPlayerName>>16
	jsl VWF_ChangeVWFTextPtr
	rtl
	
.Str0
	%vwf_inline( %vwf_text("SU") )
	
.Str1
	%vwf_inline( %vwf_text("PER") )
	
.Str2
	%vwf_inline( %vwf_text("MA") )
	
.Str3
	%vwf_inline( %vwf_text("RI") )
	
.Str4
	%vwf_inline( %vwf_text("O") )
	
.Str5
	%vwf_inline( %vwf_text("LU") )
	
.Str6
	%vwf_inline( %vwf_text("I") )
	
.Str7
	%vwf_inline( %vwf_text("GI") )
	
.Str8
	%vwf_inline( %vwf_non_breaking_space() )

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

	%vwf_header()
	
	%vwf_text("Hey, did you know? Hold L and press either X or Y anywhere in this hack for a secret message.") : %vwf_wait_for_a() : %vwf_clear()
	%vwf_text("The L + X message even works while a message is already open. I'm serious, try it right now!") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_text("Now... Using VWF_DisplayAMessage to switch to another message in 3... 2... 1...") : %vwf_wait_for_a() : %vwf_execute_subroutine(Message0040_ChangeTextPtr)
	
	%vwf_text("Uh-oh! You should never get to see this text!") : %vwf_wait_for_a()

%vwf_message_end()

Message0040_ChangeTextPtr:
	lda.b #$43
	ldx.b #$00
	jsl VWF_DisplayAMessage

	rtl

;-------------------------------------------------------

%vwf_message_start(0041)	; Message 020-2

	%vwf_header()
	
	%vwf_text("You found the secret L + X UberASM test message! AWESOME!") : %vwf_wait_for_a()

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0042)	; Message 021-1

	%vwf_header()
	
	%vwf_text("You found the secret L + Y UberASM test message! AWESOME!") : %vwf_wait_for_a()

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0043)	; Message 021-2

	%vwf_header(vwf_height(4), vwf_enable_skipping(true), vwf_enable_message_asm(false))
	
	%vwf_text("Success! Now using VWF_ChangeVWFTextPtr to change the text pointer in 3... 2... 1...") : %vwf_wait_for_a() : %vwf_clear() : %vwf_execute_subroutine(.ChangeTextPtr_1)
	
	%vwf_text("Uh-oh! You should never get to see this text!") : %vwf_wait_for_a()
	
.Success
	%vwf_text("Success! Now using VWF_ChangeMessageASMPtr and VWF_ToggleMessageASM to animate text color in 3... 2... 1...") : %vwf_execute_subroutine(.ChangeTextPtr_2) : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_change_colors(vwf_get_color_index_2bpp($07, !vwf_text_color_id), vwf_make_color_15(31, 31, 31))
	
	%vwf_execute_subroutine(.DisableSkipping) : %vwf_text("Message skip is now disabled for this one message alone. Try it by pressing start!") : %vwf_wait_for_a() : %vwf_clear()
	
	%vwf_execute_subroutine(.EnableSkipping) : %vwf_text("Now it's enabled again, but points to a different location. Try it, press start!") : %vwf_wait_for_a() : %vwf_clear()
	
.ModifiedSkipLocation
	%vwf_execute_subroutine(.ResetSkipping) : %vwf_text("Now whether you skipped or not, you will always arrive at this text box here.") : %vwf_wait_for_a() : %vwf_clear() : %vwf_execute_subroutine(.SkipCheck)
	
.NoSkip
	%vwf_text("But only because you DIDN'T skip, you're getting to see this text box!") : %vwf_wait_for_a() : %vwf_clear() : %vwf_set_text_pointer(.Continue)

.DidSkip
	%vwf_text("However, this text box is visible only to players who DID skip!") : %vwf_wait_for_a() : %vwf_clear()

.Continue
	%vwf_text("Return to the overworld now?")

	%vwf_display_options(ReturnToOW,
		%vwf_text("Yes"),
		%vwf_text("No"))
	
	%vwf_set_option_location(ReturnToOW, 0)
		%vwf_execute_subroutine(.ReturnToOW)
		%vwf_set_text_pointer(.TheEnd)
	
	%vwf_set_option_location(ReturnToOW, 1)

.TheEnd
	%vwf_text("Routines test complete!") : %vwf_wait_for_a()

%vwf_message_end()

.ChangeTextPtr_1:
	lda.b #.Success
	ldx.b #.Success>>8
	ldy.b #.Success>>16
	jsl VWF_ChangeVWFTextPtr

	rtl
	
.ChangeTextPtr_2:
	lda.b #MessageASM0031
	ldx.b #MessageASM0031>>8
	ldy.b #MessageASM0031>>16
	jsl VWF_ChangeMessageASMPtr
	
	jsl VWF_ToggleMessageASM

	rtl
	
.DisableSkipping:	
	jsl VWF_ToggleMessageASM
	jsl VWF_ToggleMessageSkip

	rtl
	
.EnableSkipping:
	lda.b #.ModifiedSkipLocation
	ldx.b #.ModifiedSkipLocation>>8
	ldy.b #.ModifiedSkipLocation>>16
	jsl VWF_ChangeMessageSkipPtr

	jsl VWF_ToggleMessageSkip
	rtl
	
.ResetSkipping:
	lda.b #.SkipLocation
	ldx.b #.SkipLocation>>8
	ldy.b #.SkipLocation>>16
	jsl VWF_ChangeMessageSkipPtr
	
	rtl
	
.SkipCheck:
	jsl VWF_WasMessageSkipped
	beq ..NotSkipped
	
	lda.b #.DidSkip
	ldx.b #.DidSkip>>8
	ldy.b #.DidSkip>>16
	jsl VWF_ChangeVWFTextPtr

..NotSkipped
	rtl
	
.ReturnToOW
	jsl VWF_CloseMessageAndGoToOverworld
	rtl

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

	%vwf_header(vwf_x_pos(0), vwf_y_pos(0), vwf_width(15), vwf_height(13), vwf_text_alignment(TextAlignment.Centered))

	%vwf_text("What error do you want to test?") : %vwf_line_break()
	
	%vwf_display_options(ErrorCheck,
		%vwf_text("Text macro ID overflow"),
		%vwf_text("Text macro buffer overflow"),
		%vwf_text("Undefined message (defined ID)"),
		%vwf_text("Undefined message (undefined ID)"),
		%vwf_text("Exit"))
	
	%vwf_set_option_location(ErrorCheck, 0)
		%vwf_execute_subroutine(IdOverflowTest)
		%vwf_text("If you can read this text, then no error was triggered. Please adjust the test to make sure the respective error is triggered.") : %vwf_wait_for_a() : %vwf_close()
		
	%vwf_set_option_location(ErrorCheck, 1)
		%vwf_execute_subroutine(BufferOverflowTest)
		%vwf_text("If you can read this text, then no error was triggered. Please adjust the test to make sure the respective error is triggered.") : %vwf_wait_for_a() : %vwf_close()
		
	%vwf_set_option_location(ErrorCheck, 2)
		%vwf_display_message(0061)
		
	%vwf_set_option_location(ErrorCheck, 3)
		%vwf_display_message(EEEE)
		
	%vwf_set_option_location(ErrorCheck, 4)
		%vwf_display_message(0050)

%vwf_message_end()

IdOverflowTest:
	jsl VWF_ResetBufferedTextMacros
	
	; There should be at least !num_reserved_text_macros+1 calls to both macros here to trigger the error handling.
	jsl VWF_BeginBufferedTextMacro
	jsl VWF_EndBufferedTextMacro
	
	jsl VWF_BeginBufferedTextMacro
	jsl VWF_EndBufferedTextMacro
	
	jsl VWF_BeginBufferedTextMacro
	jsl VWF_EndBufferedTextMacro
	
	jsl VWF_BeginBufferedTextMacro
	jsl VWF_EndBufferedTextMacro
	
	jsl VWF_BeginBufferedTextMacro
	jsl VWF_EndBufferedTextMacro
	
	jsl VWF_BeginBufferedTextMacro
	jsl VWF_EndBufferedTextMacro
	
	rtl
	
BufferOverflowTest:
	jsl VWF_ResetBufferedTextMacros
	
	jsl VWF_BeginBufferedTextMacro
	%add_to_buffered_text_macro(.ErrorString)
	jsl VWF_EndBufferedTextMacro
	
	rtl
	
.ErrorString
	; This string should be larger than !buffered_text_macro_buffer_size to trigger the error handling.
	%vwf_inline(%vwf_text("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	%vwf_text("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	%vwf_text("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	%vwf_text("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	%vwf_text("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	%vwf_text("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "))

;-------------------------------------------------------

%vwf_message_start(0061)	; Message 10C-2

	; LEAVE THIS MESSAGE BLANK!
	; It is used in the error handling test.

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

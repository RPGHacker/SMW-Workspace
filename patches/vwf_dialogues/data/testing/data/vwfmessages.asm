;-------------------------------------------------------

; DIALOG DATA BEGIN

; Text macros:

%vwf_register_text_macro("Option2Text", %vwf_wrap( !set_pal($05), !char($00AC), !str(" "), !set_pal($04), !str("Message Boxes"), !reset_color, !str(" Test") ))
%vwf_register_text_macro("Option3Text", !set_pal($05), !char($00AC), !str(" "), !set_pal($05), !str("Pointers"), !reset_color, !str(" Test") )


%vwf_register_text_macro("Mario", !set_color(5, rgb_15(31, 12, 12)), !str("Mario"), !reset_color )

%vwf_register_text_macro("Luigi", !set_color(6, rgb_15(6, 31, 6)), !str("Luigi"), !reset_color )


%vwf_register_text_macro("SmallPowerup", !str("Small") )
%vwf_register_text_macro("SuperPowerup", !str("Super") )
%vwf_register_text_macro("CapePowerup", !str("Cape") )
%vwf_register_text_macro("FirePowerup", !str("Fire") )


%vwf_register_text_macro("SuperMario", !macro("SuperPowerup"), !nbsp, !macro("Mario"))


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

%vwf_register_text_macro("CurrentPlayer", !macro_group("PlayerName", remap_ram($7E0DB3)))

%vwf_register_text_macro("CurrentPlayerWithPowerup", !macro_group("PlayerPowerup", remap_ram($7E0019)), !nbsp, !macro("CurrentPlayer"))


%vwf_register_text_macro("No", !str("NO") )
%vwf_register_text_macro("Yes", !str("YES") )

%vwf_start_text_macro_group("NoYes")
	%vwf_add_text_macro_to_group("No")
	%vwf_add_text_macro_to_group("Yes")
%vwf_end_text_macro_group()

	
; RPG Hacker: This is just for testing purposes. Don't use %vwf_claim_varram() in your actual hacks. Use proper free RAM instead.
%vwf_claim_varram(box_anim_test_show_open_old, 1)
%vwf_claim_varram(box_anim_test_show_close_old, 1)
%vwf_claim_varram(box_anim_test_show_open, 1)
%vwf_claim_varram(box_anim_test_show_close, 1)


; Messages:

; RPG Hacker: Really, message $0050 (Yoshi's House) is the most important one for us, since it's the quickest one to get to.
;-------------------------------------------------------

%vwf_message_start(0050)	; Message 104-1

	%vwf_header(x_pos(0), y_pos(0), width(15), height(13), text_alignment(TextAlignment.Centered))
	
.Start
!opt_loc(TestSelectionPage2, 11)
	!clear

	!edit_pal(!text_color_4, rgb_15(15, 15, 31), rgb_15(0, 0, 0))
	!edit_pal(!text_color_5, rgb_15(6, 31, 6), rgb_15(0, 0, 0))
	!edit_pal(!text_color_6, rgb_15(31, 12, 12), rgb_15(0, 0, 0))
	
if !assembler_ver >= 20000
	!set_pal($05) : !str("🐾") : !space
	!reset_color : !str("👉 Pléäse sèlêct â teßt 👈") : !space
	!set_pal($05) : !str("🐾")
	!reset_color : !new_line
else
	!set_pal($05) : !char($00AC) : !space
	!reset_color : !str("Please select a test") : !space
	!set_pal($05) : !char($00AC)
	!reset_color : !new_line
endif
	
	!options(TestSelection,
		%vwf_wrap( !set_pal($05), !char($00AC), !str(" "),
			!set_pal($06), !str("Commands"),
			!reset_color, !str(" Test") ),
		!macro("Option2Text"),
		!macro("Option3Text"),
		%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Teleport Test") ),
		%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Change Appearance Test") ),
		%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Routines Test") ),
		%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Error Handling Test") ),
		%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Edge Cases") ),
		%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Message Box Anims") ),		
		%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Layer Priorities") ),
		%vwf_wrap( !char($94), !str(" Page 2") ),
		!str("Exit"))
		
	!opt_loc(TestSelection, 10)
		.Page2Start
		!clear
		!options(TestSelectionPage2,
			%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Wait for Buttons") ),
			%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Text box overrides") ),
			%vwf_wrap( !set_pal($05), !char($00AC), !reset_color, !str(" Shared headers") ),
			!str("-"),
			!str("-"),
			!str("-"),
			!str("-"),
			!str("-"),
			!str("-"),
			!str("-"),
			!str("-"),
			%vwf_wrap( !char($93), !str(" Page 1") ),
			!str("Exit"))		
		
	;!edit_pal(-1, $0000)
	;!edit_pal($100, $0000)
	;!edit_pal($1A)
	;!edit_pal($FF, $0000, $0000)
	;!edit_pal($1A, $0000)
	;!edit_pal($1A, $10000)
	;!edit_pal($1A, -1)
	
	!opt_loc(TestSelection, 0)
		!str("This is a line.") : !new_line
		!str("This is a new line.") : !new_line
		!str("Now some text...") : !wait_frames(60) : !str(" with a long pause.") : !wait_frames(30) : !new_line
		!set_speed(5) : !str("This text appears very slowly.") : !set_speed(0) : !new_line
		!press_button : !clear
		
		!str("Time for some numbers!") : !new_line
		!str("Mario's current coins: ") : !dec(remap_ram($7E0DBF), AddressSize.8Bit, true) : !new_line
		!str("Mario's X pos: ") : !dec(remap_ram($7E00D1), AddressSize.16Bit) : !new_line
		!str("Current X speed (unsigned dec): ") : !dec(remap_ram($7E007B)) : !new_line
		!str("Current X speed (hex): $") : !hex(remap_ram($7E007B)) : !new_line
		!str("Current text box color: $") : !hex(!vwf_chosen_box_color+1) : !hex(!vwf_chosen_box_color) : !new_line
		!str("Current timer: ") : !ram_char(remap_ram($7E0F31)) : !ram_char(remap_ram($7E0F32)) : !ram_char(remap_ram($7E0F33)) : !new_line
		!press_button : !clear		
		
		!str("Further number tests.") : !new_line
		!str("(Left = target, right = actual)") : !new_line
		!str("42: ") : !dec(.TestNumber00, AddressSize.8Bit, false) : !new_line
		!str("042: ") : !dec(.TestNumber00, AddressSize.8Bit, true) : !new_line
		!str("512: ") : !dec(.TestNumber06, AddressSize.16Bit, false) : !new_line
		!str("00512: ") : !dec(.TestNumber06, AddressSize.16Bit, true) : !new_line
		!str("6666: ") : !dec(.TestNumber01, AddressSize.16Bit, false) : !new_line
		!str("06666: ") : !dec(.TestNumber01, AddressSize.16Bit, true) : !new_line
		!str("255: ") : !dec(.TestNumber02) : !new_line
		!str("65535: ") : !dec(.TestNumber03, AddressSize.16Bit) : !new_line
		!str("$69: $") : !hex(.TestNumber04) : !new_line
		!str("123: ") : !ram_char(.TestNumber05) : !ram_char(.TestNumber05+2) : !ram_char(.TestNumber05+4) : !new_line
		!press_button : !clear
		
		!str("ThisLongTextDoesContain") : !nbsp : !str("ANonBreakingSpace") : !new_line
		!press_button : !clear	
		
		!str("Have some text in a ") : !set_color($06, rgb_15(31, 24, 2)) : !str("different color ") : !reset_color : !str("- hooray!") : !new_line
		!press_button : !clear
		
		!font($01)
		
		pushtable
		cleartable
		incsrc "vwftable_font2.txt"
		!str("Here's some text in a different font.") : !new_line
		pulltable
		
		!font(!vwf_default_font)
		!str("And now back to the default.") : !new_line
		!press_button : !clear
		
		!str("How about a different song?") : !new_line
		!play_bgm($05)
		!press_button
		!play_bgm($02)
		!clear		

if !assembler_ver >= 20000
		; This looks really messy, because it supports both 8-bit and 16-bit mode.
		; If we only wanted to support 16-bit mode, we wouldn't need the font calls.
		; We'd only have to set the char offset once and then write the text as normal.
		macro write_japanese_text(...)
			if sizeof(...)&$01 != 0
				error "%write_japanese_text() takes an even amount of arguments in the form: {font},{text}"
			endif
			
			!temp_i = 0
			while !temp_i < sizeof(...)
				!font(<...[!temp_i]>)
				!str(<...[!temp_i+1]>)
			
				!temp_i #= !temp_i+2
			endwhile
			undef "temp_i"
		endmacro

		!char_offset($0200)
		%write_japanese_text($02, "Ｈｏｗ　ａｂｏｕｔ　ｓｏｍｅ　Ｊａｐａｎｅｓｅ　ｔｅｘｔ？") : !new_line : !new_line
		%write_japanese_text($03, "こんにちは", $02, "、RPG", $03, "ハッカーです", $02, "！") : !new_line
		%write_japanese_text($07, "私", $03, "は", $04, "日本語", $03, "が", $04, "話", $03, "せないので", $02, "、", $03, "ここにランダムな", $05, "漢", $04, "字", $03, "を挿", $04, "入", $03, "します。") : !new_line
		%write_japanese_text($05, "兄係軽血決県研言庫湖公向幸港号根") : !press_button : !clear

		!char_offset($0000)
		!font($00)
endif
		
		!str("Commands test complete!") : !new_line
		!press_button
	
		!clear		
		!jump(.Start)
		
	.TestNumber00
		db 42
		
	.TestNumber01
		dw 6666
		
	.TestNumber02
		db 255
		
	.TestNumber03
		dw 65535
		
	.TestNumber04
		db $69
		
	.TestNumber05
		dw 1,2,3
		
	.TestNumber06
		dw 512
		
	!opt_loc(TestSelection, 1)
		!open_message(0000)
		!close
		
	!opt_loc(TestSelection, 2)
		!open_message(0030)
		
	!opt_loc(TestSelection, 3)
		!str("Where to go?") : !new_line
		!str("(NOTE: Teleporting to midway requires active Lunar Magic hack.)") : !new_line
	
		!options(TeleportDestination,
			!str("Level $0105 (Start)"),
			!str("Level $0105 (Midway)"),
			!str("Secondary Entrance $01CB"),
			!str("Secondary Entrance $01CB (Water)"),
			!str("Exit"))
		
		!opt_loc(TeleportDestination, 0)
			!teleport_to_level($0105, false)
			!close
			
		!opt_loc(TeleportDestination, 1)
			!teleport_to_level($0105, true)
			!close
			
		!opt_loc(TeleportDestination, 2)
			!teleport_to_secondary($01CB, false)
			!close
			
		!opt_loc(TeleportDestination, 3)
			!teleport_to_secondary($01CB, true)
			!close
			
		!opt_loc(TeleportDestination, 4)
			!clear
			!jump(.Start)
		
	!opt_loc(TestSelection, 4)
		!open_message(0020)
			
	!opt_loc(TestSelection, 5)
		!open_message(0040)
	
	!opt_loc(TestSelection, 6)
		!open_message(0060)
	
	!opt_loc(TestSelection, 7)
		!str("The following boxes of text should all stay the same color:") : !press_button : !clear
		!set_color($06, rgb_15(31, 0, 0))
		!str("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
		!str("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
		!str("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
		!str("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
		!str("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
		!str("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
		!reset_color
		!press_button : !clear
		
		!execute(.GiveReserveMushroom)
		!str("I just put a mushroom into your reserve item box.") : !new_line : !new_line
		!str("It should be hidden while this dialog box remains open.")
		!press_button
		
		!open_message(0045)
			
	!opt_loc(TestSelection, 8)	
		!execute(MessageBoxAnimTestInit)
		!open_message(0080, false, false)
			
	!opt_loc(TestSelection, 9)	
		!options(LayerPrioritiesTestSelection,
			!str("Level Header: 0E"),
			!str("Level Header: 1E"),
			!str("Exit"))
		
		!opt_loc(LayerPrioritiesTestSelection, 0)
			!teleport_to_level($0018, false)
			!close
		
		!opt_loc(LayerPrioritiesTestSelection, 1)
			!teleport_to_level($0017, false)
			!close
			
		!opt_loc(LayerPrioritiesTestSelection, 2)
			!clear
			!jump(.Start)
	
	!opt_loc(TestSelectionPage2, 0)
			!str("Press A") : !press_custom_button(ControllerButton.A) : !new_line
			!str("Press B") : !press_custom_button(ControllerButton.B) : !new_line
			!str("Press X") : !press_custom_button(ControllerButton.X) : !new_line
			!str("Press Y") : !press_custom_button(ControllerButton.Y) : !new_line
			!str("Press Up or Down") : !press_custom_button(ControllerButton.DpadUp|ControllerButton.DpadDown) : !new_line
			!str("Press Left or Right") : !press_custom_button(ControllerButton.DpadLeft|ControllerButton.DpadRight) : !new_line
			!str("Press Select") : !press_custom_button(ControllerButton.Select) : !new_line
			!str("Press L or R") : !press_custom_button(ControllerButton.L|ControllerButton.R)
	
			!clear
			!jump(.Page2Start)
			
	!opt_loc(TestSelectionPage2, 1)
		!display_message(0062, false, false)
	
	!opt_loc(TestSelectionPage2, 2)
		!display_message(0066, false, false)
		
	!opt_loc(TestSelectionPage2, 3)
	!opt_loc(TestSelectionPage2, 4)
	!opt_loc(TestSelectionPage2, 5)
	!opt_loc(TestSelectionPage2, 6)
	!opt_loc(TestSelectionPage2, 7)
	!opt_loc(TestSelectionPage2, 8)
	!opt_loc(TestSelectionPage2, 9)
	!opt_loc(TestSelectionPage2, 10)
	
	!opt_loc(TestSelection, 11)	
	!opt_loc(TestSelectionPage2, 12)
	!skip_loc
		!str("Thank you for using VWF Dialogues by RPG Hacker!") : !press_button

%vwf_message_end()

.GiveReserveMushroom
	lda.b #$01
	sta remap_ram($0DC2)
	rtl

;-------------------------------------------------------

macro generate_message_test_messages(first_message_id, second_message_id, show_animations, alternate_font, text, next_message, ...)

	; RPG Hacker: First message.
	%vwf_message_start(<first_message_id>)
	
		%vwf_header(x_pos(1), y_pos(1), width(14), height(12), text_alignment(TextAlignment.Left))

		!str("Next test:") : !new_line

		!temp_i #= 0
		while !temp_i < sizeof(...)
			!nbsp : !nbsp
			!str("<...[!temp_i]>")
			if !temp_i == sizeof(...)-1
				!press_button
			else
				!new_line
			endif
			
			!temp_i #= !temp_i+1
		endwhile
		undef "temp_i"
		
		if <show_animations> != false
			!open_message(<second_message_id>, false, true)
		else
			!open_message(<second_message_id>)
		endif
	
	%vwf_message_end()



	; RPG Hacker: Second message.
	if <alternate_font> != false
		pushtable
		cleartable
		incsrc "vwftable_font2.txt"
	endif
	
	%vwf_message_start(<second_message_id>)
		!temp_params = ""
	
		!temp_i #= 0
		while !temp_i < sizeof(...)
			if !temp_i == 0
				!temp_params += "<...[!temp_i]>"
			else
				!temp_params += ", <...[!temp_i]>"
			endif
			
			!temp_i #= !temp_i+1
		endwhile
		undef "temp_i"	
		
		%vwf_header(!temp_params)
		
		<text>
		
		!press_button
		
		if <show_animations> != false
			!open_message(<next_message>, true, false)
		else
			!open_message(<next_message>)
		endif
		
	%vwf_message_end()
	
	if <alternate_font> != false
		pulltable
	endif
endmacro

;-------------------------------------------------------

; Messages 000-1 and 000-2
%generate_message_test_messages(0000, 0001, false, false, !str("A relatively standard text box!"), 0002, x_pos(1), y_pos(1), width(14), height(3), text_alignment(TextAlignment.Left))

;-------------------------------------------------------

; Messages 001-1 and 001-2	
; RPG Hacker: The animation = instant and the show_animation = true are necessary here, because
; the background color won't get initialized otherwise. If we start this test from test selector,
; that usually won't be a problem, because palette commands in that test already override the BG
; color of palette 6. However, if we run this test by itself (which happens by seeing the special
; "Yoshi found" message), this would usually lead to a black background.
%generate_message_test_messages(0002, 0003, true, true, !str("This one is small, uses centered text and also a different font and color."), 0004, x_pos(3), y_pos(10), width(12), height(5), text_alignment(TextAlignment.Centered), font($01), text_palette($06), text_color(rgb_15(0, 0, 0)), outline_color(rgb_15(31, 31, 31)), box_animation(BoxAnimation.Instant))

;-------------------------------------------------------

; Messages 002-1 and 002-2
%generate_message_test_messages(0004, 0005, false, false, !str("Weird spacing and slow, unskippable text, lol. Wasting a tester's time is fun."), 0006, text_alignment(TextAlignment.Left), space_width(15), text_margin(0), text_speed(5), button_speedup(false), enable_skipping(false))

;-------------------------------------------------------

; Messages 003-1 and 003-2
%generate_message_test_messages(0006, 0007, false, false, !str("This text box hardly gives you enough time to read anything. Like WHAT THE FUCK, why is everything so fast? Why doesn't it stop? Why doesn't it give me any time to read anything? Like, who is supposed to read this? I mean, slow down, Satan. Slow the fuck down! I want to actually enjoy the story of this game, and not feel like I was running a marathon. Whatever, I'll just watch a playthrough of the game on YouTube and press pause so that I can read everything properly. Oh yeah, did you notice you can walk around while this text box is active?"), 0008, height(5), freeze_game(false), auto_wait(AutoWait.None))

;-------------------------------------------------------

; Messages 004-1 and 004-2
%generate_message_test_messages(0008, 0009, false, false, !str("This text box gives us a little more time to read everything, but in reality, it's actually just way too fucking fast again. Like, come on! Why even use the 'auto wait' option like that? Why not just use 'press A' and let the player read everything at their own pace? Are you deliberately torturing us? You just want us to not enjoy your game, do you? Well, I tell you something. I'll go on SMW Central right fucking now, give this hack a bad fucking rating and then complain about its text boxes being too fucking fast for me in the review. I hope this is what you wanted!"), 000A, height(5), freeze_game(false), auto_wait(AutoWait.WaitFrames.60))

;-------------------------------------------------------

; Messages 005-1 and 005-2
%generate_message_test_messages(000A, 000B, false, false, !str("This text box is completely silent. Not much else going on here. Just enjoy this little break after the previous torture!"), 000C, enable_sfx(false))

;-------------------------------------------------------

; Messages 006-1 and 006-2
%generate_message_test_messages(000C, 000D, false, false,
	%vwf_wrap( !str("This text box, on the other hand, uses some hilariously fucking funny sound effects! HAHAHA!"), !press_button, !clear,
		!str("I mean, that was already fucking hilarious, but check out that cursor sound effect! xDDDD"), !press_button, !clear,	
		!options(CheckFunnyCursorSound,
			!str("Okay, let me see..."),
			!str("HAHAHAHAHAHA!")),	
		!opt_loc(CheckFunnyCursorSound, 0),
		!opt_loc(CheckFunnyCursorSound, 1),
		!str("Literally pissing myself over here!") ),
	000E, enable_sfx(true), letter_sound($1DFC, 03), wait_sound($1DFA, 01), cursor_sound($1DF9, 02), continue_sound($1DFC, 08))

;-------------------------------------------------------

; Messages 007-1 and 007-2
%generate_message_test_messages(000E, 000F, true, false, !str("Time to test the different box animations. This one is Mega Man Zero-styled."), 0010, box_animation(BoxAnimation.MMZ))

;-------------------------------------------------------

; Messages 008-1 and 008-2
%generate_message_test_messages(0010, 0011, true, false, !str("Secret of Evermore-styled."), 0012, box_animation(BoxAnimation.SoE))

;-------------------------------------------------------

; Messages 009-1 and 009-2
%generate_message_test_messages(0012, 0013, true, false, !str("Secret of Mana-styled."), 0014, box_animation(BoxAnimation.SoM))

;-------------------------------------------------------

; Messages 00A-1 and 00A-2
%generate_message_test_messages(0014, 0015, true, false, !str("This one just appears and disappears instantly, with no animation whatsoever."), 0016, box_animation(BoxAnimation.Instant))

;-------------------------------------------------------

; Messages 00B-1 and 00B-2
%generate_message_test_messages(0016, 0017, true, false, !str("And this one doesn't even display a box at all, only text, which saves some precious cycles."), 0018, box_animation(BoxAnimation.None))

;-------------------------------------------------------

%vwf_message_start(0018)	; Message 00C-1

	%vwf_header()

	!str("Message box test complete!") : !press_button
	
	!open_message(0050)

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

	%vwf_header(height(5))

	!str("What to customize?")
	
	!options(CustomizationSelect,
		!str("Border"),
		!str("Background"),
		!str("Background color"),
		!str("Exit"))
	
	!opt_loc(CustomizationSelect, 0)
		!open_message(0021)
	
	!opt_loc(CustomizationSelect, 1)
		!open_message(0022)
		
	!opt_loc(CustomizationSelect, 2)
		!execute(vwf_box_colorStuff_InitializeRAM)
		!open_message(0023)
		
	!opt_loc(CustomizationSelect, 3)
		!open_message(0050)

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

	%vwf_header(x_pos(10), y_pos(10), width(5), height(1), text_alignment(TextAlignment.Centered), enable_sfx(false), enable_message_asm(true), box_animation(BoxAnimation.Instant))
	
	!char($93) : !nbsp : !hex(!vwf_chosen_box_frame) : !nbsp : !char($94) : !freeze
	
.Refresh
	!open_message(0021, false, true)
	
.Done
	!open_message(0020)

%vwf_message_end()

MessageASM0021:
	%message_box_design_change_logic(0021, !vwf_chosen_box_frame, !num_frames)

;-------------------------------------------------------

%vwf_message_start(0022)	; Message 011-1

	%vwf_header(x_pos(10), y_pos(10), width(5), height(1), text_alignment(TextAlignment.Centered), enable_sfx(false), enable_message_asm(true), box_animation(BoxAnimation.Instant))
	
	!char($93) : !nbsp : !hex(!vwf_chosen_box_bg) : !nbsp : !char($94) : !freeze
	
.Refresh
	!open_message(0022, false, true)
	
.Done
	!open_message(0020)

%vwf_message_end()

MessageASM0022:
	%message_box_design_change_logic(0022, !vwf_chosen_box_bg, !num_bg_patterns)

;-------------------------------------------------------

; RPG Hacker: This is just for testing purposes. Don't use %vwf_claim_varram() in your actual hacks. Use proper free RAM instead.
%vwf_claim_varram(edit_color_r, 2)
%vwf_claim_varram(edit_color_g, 2)
%vwf_claim_varram(edit_color_b, 2)
%vwf_claim_varram(edit_color_id, 1)

vwf_box_colorStuff:

.InitializeRAM:	
	lda #$00
	sta !vwf_edit_color_id
	
	rep #$20
	
	lda !vwf_chosen_box_color
	and.w #%00011111
	sta !vwf_edit_color_r
	
	lda !vwf_chosen_box_color
	lsr #5
	and.w #%00011111
	sta !vwf_edit_color_g
	
	lda !vwf_chosen_box_color
	lsr #10
	sta !vwf_edit_color_b
	
	sep #$20
	
	rtl
	
.Commit:	
	rep #$20
	
	lda !vwf_edit_color_b
	asl #5
	ora !vwf_edit_color_g
	asl #5
	ora !vwf_edit_color_r
	
	sta !vwf_chosen_box_color
	
	sep #$20

	rts
	
.ProcessInput:
	lda $16
	bit.b #%00001000
	beq .NotUp
	
	lda !vwf_edit_color_id
	dec
	cmp #$FF
	bne .NoUnderflow
	lda #$02
	
.NoUnderflow
	sta !vwf_edit_color_id
	
	asl
	tax	
	jsr (.RedrawTable,x)
	
	bra .CheckLeftRight
	
.NotUp:
	bit.b #%00000100
	beq .NotDown
	
	lda !vwf_edit_color_id
	inc
	cmp #$03
	bne .NoOverflow
	lda #$00
	
.NoOverflow
	sta !vwf_edit_color_id
	
	asl
	tax	
	jsr (.RedrawTable,x)
	
	bra .CheckLeftRight
	
.NotDown

.CheckLeftRight
	lda !vwf_edit_color_id
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
%message_box_design_change_logic(0023, !vwf_edit_color_r, 32)

BoxEditGreen:
%message_box_design_change_logic(0024, !vwf_edit_color_g, 32)

BoxEditBlue:
%message_box_design_change_logic(0025, !vwf_edit_color_b, 32)
	
	
MessageASM0023:
MessageASM0024:
MessageASM0025:
	jsr vwf_box_colorStuff_ProcessInput
	rtl
	
;-------------------------------------------------------

%vwf_message_start(0023)	; Message 011-2

	%vwf_header(x_pos(9), y_pos(10), width(6), height(1), text_alignment(TextAlignment.Centered), enable_sfx(false), enable_message_asm(true), box_animation(BoxAnimation.Instant))
	
	!edit_pal(!text_color_6, rgb_15(31, 12, 12), rgb_15(0, 0, 0))

	!char($96) : !char($95) : !nbsp : !char($93)
	!nbsp : !set_pal($06) : !str("R:") : !reset_color : !str(" ")
	!dec(!vwf_edit_color_r) : !nbsp : !char($94)
	!freeze
	
.Refresh
	!open_message(0023, false, true)
	
.Done
	!open_message(0020)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0024)	; Message 012-1

	%vwf_header(x_pos(9), y_pos(10), width(6), height(1), text_alignment(TextAlignment.Centered), enable_sfx(false), enable_message_asm(true), box_animation(BoxAnimation.Instant))
	
	!edit_pal(!text_color_6, rgb_15(6, 31, 6), rgb_15(0, 0, 0))

	!char($96) : !char($95) : !nbsp : !char($93)
	!nbsp : !set_pal($06) : !str("G:") : !reset_color : !str(" ")
	!dec(!vwf_edit_color_g) : !nbsp : !char($94)
	!freeze
	
.Refresh
	!open_message(0024, false, true)
	
.Done
	!open_message(0020)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0025)	; Message 012-2

	%vwf_header(x_pos(9), y_pos(10), width(6), height(1), text_alignment(TextAlignment.Centered), enable_sfx(false), enable_message_asm(true), box_animation(BoxAnimation.Instant))
	
	!edit_pal(!text_color_6, rgb_15(15, 15, 31), rgb_15(0, 0, 0))

	!char($96) : !char($95) : !nbsp : !char($93)
	!nbsp : !set_pal($06) : !str("B:") : !reset_color : !str(" ")
	!dec(!vwf_edit_color_b) : !nbsp : !char($94)
	!freeze
	
.Refresh
	!open_message(0025, false, true)
	
.Done
	!open_message(0020)

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
		
	!str("Text macro:") : !press_button : !clear
	!str("This is a ") : !macro("Mario") : !str(" game! Oh yeah, ") : !macro("Luigi") : !str(" is also here.") : !press_button : !clear
	
	!str("Nested text macro:") : !press_button : !clear
	!str("Welcome to ") : !macro("SuperMario") : !str(" World!") : !press_button : !clear
	
	!str("Indexed text macro group:") : !press_button : !clear
	!str("Hey there, ") : !macro_group("PlayerName", remap_ram($7E0DB3)) : !str(" - how are you doing?") : !press_button : !clear
	
	!str("Indexed text macro group inside a text macro:") : !press_button : !clear
	!str("Welcome back, ") : !macro("CurrentPlayer") : !str(" - good to see you again!") : !press_button : !clear
	
	!str("Multiple indexed text macro groups inside a multi-level deep text macro:") : !press_button : !clear
	!str("If that ain't the infamous ") : !macro("CurrentPlayerWithPowerup") : !str(" - what brought you here?") : !press_button : !clear
	
	!str("A couple of buffered macros:") : !execute(InitializeBufferedMacros1) : !press_button : !clear
	!str("Hey now, who do we have here? If it isn't our friends ") : !macro_buf(0) : !str(" and ") : !macro_buf(1) : !str("!") : !press_button : !clear
	
	!open_message(0034)

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
	%vwf_inline(!str("Buf"))
	
.Str2:
	%vwf_inline(!str("fered"))
	
.Str3:
	%vwf_inline(!str(" Mar"))
	
.Str4:
	%vwf_inline(!str("io"))
	
.Str5:
	%vwf_inline(!str(" Lui"))
	
.Str6:
	%vwf_inline(!str("gi"))

;-------------------------------------------------------

%vwf_message_start(0031)	; Message 018-2

	%vwf_header(enable_message_asm(true))
	
	!str("This text box uses MessageASM to animate the text color, WHOOOA!")
	!press_button : !clear
	
	!open_message(0032)

%vwf_message_end()

MessageASM0031:
	!temp_target_address #= !vwf_palette_backup_ram+(vwf_get_color_index_2bpp(!vwf_default_text_palette, ColorID.Text)*2)
	
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
	sta !vwf_palette_upload
	
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
		
		dw rgb_15(!temp_reverse_channel_val, !temp_channel_val, 3)
		
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

	%vwf_header(enable_message_asm(true), enable_skipping(false))	
	
	!str("This text box is completely frozen via %vwf_freeze().") : !new_line
	!str("Hold L + R to continue.") : !freeze

.Continue
	!open_message(0033)

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

	!clear

	!str("Pointers test complete!") : !new_line
	!press_button
	
	!open_message(0050)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0034)	; Message 01A-1

	%vwf_header(x_pos(0), y_pos(0), width(15), height(13), text_alignment(TextAlignment.Left))
	
	!execute(InitializePlayerName)
	
.RedrawPlayerName
	!clear : !str("Please enter a player name!") : !new_line
	!str("Current: ") : !macro_buf(0) : !new_line
	
	!options(PlayerNameEntry,
		!str("SU"),
		!str("PER"),
		!str("MA"),
		!str("RI"),
		!str("O"),
		!str("LU"),
		!str("I"),
		!str("GI"),
		!str("(Space)"),
		!str("Reset"),
		!str("Done"))
	
	!opt_loc(PlayerNameEntry, 0)
		!execute(EditPlayerName_Add0)
	
	!opt_loc(PlayerNameEntry, 1)
		!execute(EditPlayerName_Add1)
		
	!opt_loc(PlayerNameEntry, 2)
		!execute(EditPlayerName_Add2)
		
	!opt_loc(PlayerNameEntry, 3)
		!execute(EditPlayerName_Add3)
		
	!opt_loc(PlayerNameEntry, 4)
		!execute(EditPlayerName_Add4)
		
	!opt_loc(PlayerNameEntry, 5)
		!execute(EditPlayerName_Add5)
		
	!opt_loc(PlayerNameEntry, 6)
		!execute(EditPlayerName_Add6)
		
	!opt_loc(PlayerNameEntry, 7)
		!execute(EditPlayerName_Add7)
		
	!opt_loc(PlayerNameEntry, 8)
		!execute(EditPlayerName_Add8)
		
	!opt_loc(PlayerNameEntry, 9)
		!execute(EditPlayerName_Clear)
		
	
	!opt_loc(PlayerNameEntry, 10)
		!str("Welcome, ") : !macro_buf(0) : !str("!") : !press_button
	
		!open_message(0031)

%vwf_message_end()


; RPG Hacker: This is just for testing purposes. Don't use %vwf_claim_varram() in your actual hacks. Use proper free RAM instead.
!player_name_max_length = 16*(1+!vwf_bit_mode)
%vwf_claim_varram(player_name_length, 2)
%vwf_claim_varram(player_name, !player_name_max_length)


InitializePlayerName:
	jsl VWF_ResetBufferedTextMacros
	
	jsl VWF_BeginBufferedTextMacro
	jsl VWF_EndBufferedTextMacro
	
	lda #$00
	sta !vwf_player_name_length
	sta !vwf_player_name_length+1
	
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
	lda !vwf_player_name_length
	tax
	
.Copy
	; Make sure we don't overflow our maximum allowed length.
	cpx.w #!player_name_max_length
	bcs .Done

	lda ($02,s),y
	sta !vwf_player_name,x
	inx
	iny
	
	; Damn, this doesn't exist.
	cpy $06
	bcc .Copy
	
.Done
	plb

	txa
	sta !vwf_player_name_length
	
	pla
	
	sep #$30
	
	jsl VWF_ResetBufferedTextMacros
	
	jsl VWF_BeginBufferedTextMacro
	%add_to_buffered_text_macro(!vwf_player_name_length)
	jsl VWF_EndBufferedTextMacro
	
.Redraw
	lda.b #Message0034_RedrawPlayerName
	ldx.b #Message0034_RedrawPlayerName>>8
	ldy.b #Message0034_RedrawPlayerName>>16
	jsl VWF_ChangeVWFTextPtr
	rtl
	
.Str0
	%vwf_inline( !str("SU") )
	
.Str1
	%vwf_inline( !str("PER") )
	
.Str2
	%vwf_inline( !str("MA") )
	
.Str3
	%vwf_inline( !str("RI") )
	
.Str4
	%vwf_inline( !str("O") )
	
.Str5
	%vwf_inline( !str("LU") )
	
.Str6
	%vwf_inline( !str("I") )
	
.Str7
	%vwf_inline( !str("GI") )
	
.Str8
	%vwf_inline( !nbsp )

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
	
	!str("Hey, did you know? Hold L and press either X or Y anywhere in this hack for a secret message.") : !press_button : !clear
	!str("The L + X message even works while a message is already open. I'm serious, try it right now!") : !press_button : !clear
	
	!str("Now... Using VWF_DisplayAMessage to switch to another message in 3... 2... 1...") : !press_button : !execute(Message0040_ChangeTextPtr)
	
	!str("Uh-oh! You should never get to see this text!") : !press_button

%vwf_message_end()

Message0040_ChangeTextPtr:
	lda.b #$43
	ldx.b #$00
	jsl VWF_DisplayAMessage

	rtl

;-------------------------------------------------------

%vwf_message_start(0041)	; Message 020-2

	%vwf_header()
	
	!str("You found the secret L + X UberASM test message! AWESOME!") : !press_button

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0042)	; Message 021-1

	%vwf_header()
	
	!str("You found the secret L + Y UberASM test message! AWESOME!") : !press_button

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0043)	; Message 021-2

	%vwf_header(height(4), vwf_enable_skipping(true), enable_message_asm(false))
	
	!str("Success! Now using VWF_ChangeVWFTextPtr to change the text pointer in 3... 2... 1...") : !press_button : !clear : !execute(.ChangeTextPtr_1)
	
	!str("Uh-oh! You should never get to see this text!") : !press_button
	
.Success
	!str("Success! Now using VWF_ChangeMessageASMPtr and VWF_ToggleMessageASM to animate text color in 3... 2... 1...") : !execute(.ChangeTextPtr_2) : !press_button : !clear
	
	!edit_pal(!text_color_7, rgb_15(31, 31, 31))
	
	!execute(.DisableSkipping) : !str("Message skip is now disabled for this one message alone. Try it by pressing start!") : !press_button : !clear
	
	!execute(.EnableSkipping) : !str("Now it's enabled again, but points to a different location. Try it, press start!") : !press_button : !clear
	
.ModifiedSkipLocation
	!execute(.ResetSkipping) : !str("Now whether you skipped or not, you will always arrive at this text box here.") : !press_button : !clear : !execute(.SkipCheck)
	
.NoSkip
	!str("But only because you DIDN'T skip, you're getting to see this text box!") : !press_button : !clear : !jump(.Continue)

.DidSkip
	!str("However, this text box is visible only to players who DID skip!") : !press_button : !clear

.Continue
	!str("Teleport to Chocolate Island 2?") : !new_line
	!str("(Select ") : !char('"') : !str("No") : !char('"') : !str(" for more tests)")

	!options(ReturnToOW,
		!str("Yes"),
		!str("No"))
	
	!opt_loc(ReturnToOW, 0)		
		!execute(.EndLevelAndTeleportToChocolateIsland2)
	
	!opt_loc(ReturnToOW, 1)

.TheEnd
	!open_message(0044)

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
	
.EndLevelAndTeleportToChocolateIsland2
    lda #$00
    sta remap_ram($1F11)
    
    rep #$20
    lda #$0158
    sta remap_ram($1F17)
    lsr #4
    sta remap_ram($1F1F)

    lda #$01B8
    sta remap_ram($1F19)
    lsr #4
    sta remap_ram($1F21)
    sep #$20
	
	jsl VWF_CloseMessageAndGoToOverworld_StartPlusSelect
	rtl

;-------------------------------------------------------

%vwf_message_start(0044)	; Message 022-1

	%vwf_header(enable_message_asm(true))
	
	!str("This uses \\\\\\\!vwf_at_start_of_text to play a 1-UP sound at every clear.") : !press_button : !clear

	!str("Routines test complete!") : !press_button
	!open_message(0050)

%vwf_message_end()

MessageASM0044:
	lda !vwf_at_start_of_text
	beq .NotAtStart
	
	lda #$05
	sta remap_ram($1DFC)
	
.NotAtStart
	rtl

;-------------------------------------------------------

; Macros that reproduce some bugs simoncaio ran into.
%vwf_register_text_macro("AlignmentBug1",\
    !str("6"), !text(" cueres ")\
)

%vwf_register_text_macro("AlignmentBug2",\
    !str("6"), !text(" cueres")\
)

%vwf_message_start(0045)	; Message 022-2

	%vwf_header(x_pos(8), height(4), width(8), text_alignment(TextAlignment.Centered))

	!str("Centered") : !new_line
	!macro("AlignmentBug1") : !new_line
	!str("Centered") : !new_line
	!press_button : !clear

	!str("Centered")
	!macro("AlignmentBug2") : !new_line
	!str("Centered") : !new_line
	!press_button : !clear

	!open_message(0046)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0046)	; Message 023-1

	%vwf_header(freeze_game(false), vwf_enable_skipping(false))
	
	!str("Exit level via Start + Select?")
		
	!options(ExitViaStartSelect,
		!str("Yes"),
		!str("No"))
	
	!opt_loc(ExitViaStartSelect, 0)
		!execute(.ExitViaStartSelect)		
		!clear
		
		!str("Exiting level...")
		!freeze
	
	!opt_loc(ExitViaStartSelect, 1)
		!close

%vwf_message_end()

.ExitViaStartSelect
    phk
	pea.w .Return-1
    pea.w $0084CF-1
    jml remap_rom($00A269)
	
.Return
	rtl

;-------------------------------------------------------

%vwf_message_start(0047)	; Message 023-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0048)	; Message 024-1

	; Message header & text go here

%vwf_message_end()
	rtl

;-------------------------------------------------------

%vwf_message_start(0049)	; Message 024-2

	; Chocolate Island 2 message box
	; We use this level because it has a normal exit & secret exit and also a text box right at the start of the level

	%vwf_header(height(6))
	
	!str("Return to the overworld now?")
		
	!options(ReturnToOWExitSelect,
		!str("Normal Exit"),
		!str("Secret Exit"),
		!str("Start + Select"),
		!str("Return to Yoshi's House"),
		!str("Cancel"))
	
	!opt_loc(ReturnToOWExitSelect, 0)
		!exit_to_ow(ExitToOwMode.PrimaryExit)
		!close
	
	!opt_loc(ReturnToOWExitSelect, 1)
		!exit_to_ow(ExitToOwMode.SecondaryExit)
		!close
	
	!opt_loc(ReturnToOWExitSelect, 2)
		!exit_to_ow(ExitToOwMode.NoExit)
		!close
		
	!opt_loc(ReturnToOWExitSelect, 3)
		!execute(.EndLevelAndTeleportToYoshisHouse)
		!close
		
	!opt_loc(ReturnToOWExitSelect, 4)

%vwf_message_end()
	
.EndLevelAndTeleportToYoshisHouse
    lda #$01
    sta remap_ram($1F11)
    
    rep #$20
    lda #$0068
    sta remap_ram($1F17)
    lsr #4
    sta remap_ram($1F1F)

    lda #$0078
    sta remap_ram($1F19)
    lsr #4
    sta remap_ram($1F21)
    sep #$20
	
	jsl VWF_CloseMessageAndGoToOverworld_StartPlusSelect
	rtl

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

	%vwf_header()
	
	!str("This block uses touch_mXX.asm and vwfsharedroutines.asm to display a message once.") : !press_button : !clear
	!str("Depending on the \\\\\\\!free_ram used, re-entering the level might display this message again.") : !press_button : !clear

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

	%vwf_header(x_pos(0), y_pos(0), width(15), height(13), text_alignment(TextAlignment.Centered))

	!str("What error do you want to test?") : !new_line
	
	!options(ErrorCheck,
		!str("Text macro ID overflow"),
		!str("Text macro buffer overflow"),
		!str("Undefined message (defined ID)"),
		!str("Undefined message (undefined ID)"),
		!str("Udf msg. (vwfmessages2.asm, 1)"),
		!str("Udf msg. (vwfmessages2.asm, 2)"),
		!str("Exit"))
	
	!opt_loc(ErrorCheck, 0)
		!execute(IdOverflowTest)
		!str("If you can read this text, then no error was triggered. Please adjust the test to make sure the respective error is triggered.") : !press_button : !close
		
	!opt_loc(ErrorCheck, 1)
		!execute(BufferOverflowTest)
		!str("If you can read this text, then no error was triggered. Please adjust the test to make sure the respective error is triggered.") : !press_button : !close
		
	!opt_loc(ErrorCheck, 2)
		!open_message(0061)
		
	!opt_loc(ErrorCheck, 3)
		!open_message(EEEE)
		
	!opt_loc(ErrorCheck, 4)
		!open_message(0100)
		
	!opt_loc(ErrorCheck, 5)
		!open_message(0102)
		
	!opt_loc(ErrorCheck, 6)
		!open_message(0050)

%vwf_message_end()

IdOverflowTest:
	jsl VWF_ResetBufferedTextMacros
	
	; There should be at least !vwf_num_reserved_text_macros+1 calls to both macros here to trigger the error handling.
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
	; This string should be larger than !vwf_buffered_text_macro_buffer_size to trigger the error handling.
	%vwf_inline(!str("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	!str("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	!str("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	!str("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	!str("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "),
	!str("wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww wwwwwwww "))

;-------------------------------------------------------

%vwf_message_start(0061)	; Message 10C-2

	; LEAVE THIS MESSAGE BLANK!
	; It is used in the error handling test.

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0062)	; Message 10D-1

	%vwf_header(text_box_bg_pattern($07))
	
	!str("This text box overrides the text box background.") : !press_button
	!display_message(0063)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0063)	; Message 10D-2

	%vwf_header(text_box_bg_color(rgb_15_from_24(128, 0, 0)))
	
	!str("This text box overrides the text box color.") : !press_button
	!display_message(0064)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0064)	; Message 10E-1

	%vwf_header(text_box_frame($01))
	
	!str("This text box overrides the text box frame.") : !press_button
	!display_message(0065)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0065)	; Message 10E-2

	%vwf_header(text_box_bg_pattern($05), text_box_bg_color(rgb_15_from_f(0.0, 0.5, 0.0)), text_box_frame($02))
	
	!str("This text box overrides all three text box properties.") : !press_button
	!display_message(0050)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0066)	; Message 10F-1

	%vwf_shared_header(0062)
	
	!str("Copying text box background pattern setting from message 0062 header.") : !press_button
	!display_message(0067)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0067)	; Message 10F-2

	%vwf_shared_header(0063)
	
	!str("Copying text box background color setting from message 0063 header.") : !press_button
	!display_message(0068)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0068)	; Message 110-1

	%vwf_shared_header(0064)
	
	!str("Copying text box frame setting from message 0064 header.") : !press_button
	!display_message(0069)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0069)	; Message 110-2

	%vwf_shared_header(0065)
	
	!str("Copying multiple text box property settings from message 0065 header.") : !press_button
	!display_message(0050)

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

	%vwf_header(x_pos(0), y_pos(0), width(15), height(13), text_alignment(TextAlignment.Centered), box_animation(BoxAnimation.Instant))
		
.Start
	!clear

	!options(MessageBoxAnimSelection,
		%vwf_wrap( !str("Show Open (current): "), !macro_group("NoYes", !vwf_box_anim_test_show_open_old)),
		%vwf_wrap( !str("Show Close (current): "), !macro_group("NoYes", !vwf_box_anim_test_show_close_old)),
		%vwf_wrap( !str("Show Open (next): "), !macro_group("NoYes", !vwf_box_anim_test_show_open)),
		%vwf_wrap( !str("Show Close (next): "), !macro_group("NoYes", !vwf_box_anim_test_show_close)),
		!str(""),
		!str("None"),
		!str("SoE"),
		!str("SoM"),
		!str("MMZ"),
		!str("Instant"),
		!str(""),
		!str("Exit"))
	
	!opt_loc(MessageBoxAnimSelection, 0)
		!execute(.ToggleShowOpenOld)
		!jump(.Start)
	
	!opt_loc(MessageBoxAnimSelection, 1)
		!execute(.ToggleShowCloseOld)
		!jump(.Start)
		
	!opt_loc(MessageBoxAnimSelection, 2)
		!execute(.ToggleShowOpen)
		!jump(.Start)
	
	!opt_loc(MessageBoxAnimSelection, 3)
		!execute(.ToggleShowClose)
		!jump(.Start)
		
	!opt_loc(MessageBoxAnimSelection, 4)
		!jump(.Start)
		
	!opt_loc(MessageBoxAnimSelection, 5)
		!execute(.SetupMessageBoxAnimTest_None)
		!clear
		!macro_buf(0)
	!opt_loc(MessageBoxAnimSelection, 6)
		!execute(.SetupMessageBoxAnimTest_SoE)
		!clear
		!macro_buf(0)
	!opt_loc(MessageBoxAnimSelection, 7)
		!execute(.SetupMessageBoxAnimTest_SoM)
		!clear
		!macro_buf(0)
	!opt_loc(MessageBoxAnimSelection, 8)
		!execute(.SetupMessageBoxAnimTest_MMZ)
		!clear
		!macro_buf(0)
	!opt_loc(MessageBoxAnimSelection, 9)
		!execute(.SetupMessageBoxAnimTest_Instant)
		!clear
		!macro_buf(0)		
	
	!opt_loc(MessageBoxAnimSelection, 10)
		!jump(.Start)
		
	!opt_loc(MessageBoxAnimSelection, 11)
		!open_message(0050)

%vwf_message_end()

.ToggleShowOpenOld:
	lda !vwf_box_anim_test_show_open_old
	eor.b #$01
	sta !vwf_box_anim_test_show_open_old
	rtl

.ToggleShowCloseOld:
	lda !vwf_box_anim_test_show_close_old
	eor.b #$01
	sta !vwf_box_anim_test_show_close_old
	rtl

.ToggleShowOpen:
	lda !vwf_box_anim_test_show_open
	eor.b #$01
	sta !vwf_box_anim_test_show_open
	rtl

.ToggleShowClose:
	lda !vwf_box_anim_test_show_close
	eor.b #$01
	sta !vwf_box_anim_test_show_close
	rtl
	
.SetupMessageBoxAnimTest
	!vwf_test_message_id_base = $0081

..None
	lda.b #!vwf_test_message_id_base+$00
	pha
	bra ..CreateMacro
	
..SoE
	lda.b #!vwf_test_message_id_base+$01
	pha
	bra ..CreateMacro
	
..SoM
	lda.b #!vwf_test_message_id_base+$02
	pha
	bra ..CreateMacro
	
..MMZ
	lda.b #!vwf_test_message_id_base+$03
	pha
	bra ..CreateMacro
	
..Instant
	lda.b #!vwf_test_message_id_base+$04
	pha
	
..CreateMacro
	jsl VWF_ResetBufferedTextMacros
	
	
	jsl VWF_BeginBufferedTextMacro
	%add_to_buffered_text_macro(..RawCommand1)
	jsl VWF_EndBufferedTextMacro
	
	; This modifies the arguments of the buffered !open_message() command.
	lda !vwf_tm_buffers_text_index
	dec #4
	tax
	pla
	sta !vwf_tm_buffers_text_buffer,x
	inx #2
	
	lda !vwf_box_anim_test_show_close_old
	asl
	ora !vwf_box_anim_test_show_open
	sta !vwf_tm_buffers_text_buffer,x
	
	
	jsl VWF_BeginBufferedTextMacro
	%add_to_buffered_text_macro(..RawCommand2)
	jsl VWF_EndBufferedTextMacro
	
	; Same as above
	lda !vwf_tm_buffers_text_index
	dec #2
	tax
	
	lda !vwf_box_anim_test_show_close
	asl
	ora !vwf_box_anim_test_show_open_old
	sta !vwf_tm_buffers_text_buffer,x
	
	rtl
	
..RawCommand1:
	%vwf_inline(!open_message(0000, true, true))
	
..RawCommand2:
	%vwf_inline(!open_message(0080, true, true))
	
MessageBoxAnimTestInit:
	lda.b #$00
	sta !vwf_box_anim_test_show_open_old
	sta !vwf_box_anim_test_show_close_old
	sta !vwf_box_anim_test_show_open
	sta !vwf_box_anim_test_show_close
	rtl

;-------------------------------------------------------

%vwf_message_start(0081)	; Message 11C-2

	%vwf_header(box_animation(BoxAnimation.None))
	
	!str("Test") : !press_button
	!macro_buf(1)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0082)	; Message 11D-1

	%vwf_header(box_animation(BoxAnimation.SoE))
	
	!str("Test") : !press_button
	!macro_buf(1)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0083)	; Message 11D-2

	%vwf_header(box_animation(BoxAnimation.SoM))
	
	!str("Test") : !press_button
	!macro_buf(1)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0084)	; Message 11E-1

	%vwf_header(box_animation(BoxAnimation.MMZ))
	
	!str("Test") : !press_button
	!macro_buf(1)

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0085)	; Message 11E-2

	%vwf_header(box_animation(BoxAnimation.Instant))
	
	!str("Test") : !press_button
	!macro_buf(1)

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
	%vwf_header()
	
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	%vwf_text("aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaaa")
	

%vwf_message_end()

;-------------------------------------------------------

; DIALOG DATA END

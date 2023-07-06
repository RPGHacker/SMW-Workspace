; Text macro for Switch Palace message.
; They're all completely identical aside from different colors.
%vwf_register_text_macro("SwitchPalace",\
	!new_line, !text("- SWITCH PALACE -"), !new_line, !new_line,\
	\
	!text("The power of the switch you have pushed will turn"), !new_line,\
	!set_pal($06), !chr($AD), !set_pal($07), !text(" into "), !set_pal($06), !chr($AE), !set_pal($07), !text(" ."), !new_line,\
	!new_line, !text("Your progress will also be saved."), !new_line, !new_line\
)

; Text macro for re-occurring "Point of Advice" text.
%vwf_register_text_macro("PointOfAdvice",\
	!new_line, !text("-POINT OF ADVICE-"), !press_a, !clear\
)

;-------------------------------------------------------

; Intro level message.
%vwf_message_start(0000)	; Message 000-1

	%vwf_header(auto_wait(AutoWait.WaitFrames.161), text_alignment(TextAlignment.Centered))

	!new_line : !text("Welcome! This is Dinosaur Land.") : !new_line : !new_line
	!text("In this strange land we find that Princess Toadstool is missing again!") : !new_line
	!new_line : !text("Looks like Bowser is at it again!") : !new_line : !new_line


%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0001)	; Message 000-2

	%vwf_header()

	!text("Hooray! Thank you for rescuing me. My name is Yoshi. On my way to rescue my friends, Bowser trapped me in that egg.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0002)	; Message 001-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0003)	; Message 001-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0004)	; Message 002-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0005)	; Message 002-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0006)	; Message 003-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0007)	; Message 003-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0008)	; Message 004-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0009)	; Message 004-2

	%vwf_header()

	!text("This is a Ghost House. Can you find the exit? Hee, hee, hee... Don't get lost!") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(000A)	; Message 005-1

	%vwf_header()

	!text("You can slide the screen left or right by pressing the L or R Buttons on top of the controller.") : !press_a : !clear
	!text("You may be able to see further ahead.") : !press_a

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

	%vwf_header(auto_wait(AutoWait.WaitFrames.161), text_alignment(TextAlignment.Centered))

	!edit_pal(!text_color_6, rgb_15(0, 23, 0), rgb_15(0, 0, 0))
	!macro("SwitchPalace")

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0011)	; Message 008-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0012)	; Message 009-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0013)	; Message 009-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0014)	; Message 00A-1

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0015)	; Message 00A-2

	; Message header & text go here

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

	%vwf_header()

	!text("There are five entrances to the Star World in Dinosaur Land.") : !press_a : !clear
	!text("Find them all and you can travel between many different places.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0027)	; Message 013-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0028)	; Message 014-1

	%vwf_header(auto_wait(AutoWait.WaitFrames.161), text_alignment(TextAlignment.Centered))

	!edit_pal(!text_color_6, rgb_15(31, 25, 11), rgb_15(0, 0, 0))
	!macro("SwitchPalace")

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0029)	; Message 014-2

	; Message header & text go here

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002A)	; Message 015-1

	%vwf_header()

	!text("The red dot areas on the map have two different exits.") : !press_a : !clear
	!text("If you have the time and skill, be sure to look for them.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(002B)	; Message 015-2

	%vwf_header()

	!text("Use Mario's cape to soar through the air! Run fast, jump, and hold the Y Button.") : !press_a : !clear
	!text("To keep balance, use left and right on the Control Pad.") : !press_a

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

	%vwf_header()

	!text("Here, the coins you collect or the time remaining can change your progress.") : !press_a : !clear
	!text("Can you find the special goal?") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004A)	; Message 101-1

	%vwf_header()

	!text("Press Up on the Control Pad while jumping and you can cling to the fence.") : !press_a : !clear
	!text("To go in the door at the end of this area, use Up also.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004B)	; Message 101-2

	%vwf_header(text_alignment(TextAlignment.Centered))

	!macro("PointOfAdvice")
	!text("One of Yoshi's friends is trapped in the castle by Iggy Koopa.") : !press_a : !clear
	!text("To defeat him, push him into the lava pool.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004C)	; Message 102-1

	%vwf_header()

	!text("You get Bonus Stars if you cut the tape at the end of each area.") : !press_a : !clear
	!text("If you collect 100 Bonus Stars you can play a fun bonus game.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004D)	; Message 102-2

	%vwf_header()

	!text("If you are in an area that you have already cleared, you can return to the map screen by pressing START, then SELECT.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004E)	; Message 103-1

	%vwf_header()

	!text("When you stomp on an enemy, you can jump high if you hold the jump button.") : !press_a : !clear
	!text("Use Up on the Control Pad to jump high in the shallow water.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(004F)	; Message 103-2

	%vwf_header(text_alignment(TextAlignment.Centered))

	!macro("PointOfAdvice")
	!text("The big coins are Dragon Coins. If you pick up five of these in one area, you get an extra Mario.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

; Yoshi's House (while not riding on Yoshi)
%vwf_message_start(0050)	; Message 104-1

	%vwf_header(text_alignment(TextAlignment.Centered))

	!edit_pal(!text_color_6, rgb_15(0, 31, 0), rgb_15(0, 0, 0))
	
	!text("Hello! Sorry I'm not home, but I have gone to rescue my friends who were captured by Bowser.") : !press_a : !clear
	!new_line : !set_pal($06) : !text("- Yoshi ") : !chr($AC) : !press_a

%vwf_message_end()

;-------------------------------------------------------

; Yoshi's House (while riding Yoshi)
%vwf_message_start(0051)	; Message 104-2

	%vwf_header()

	!text("It is possible to fill in the dotted line blocks.") : !press_a : !clear
	!text("To fill in the yellow ones, just go west then north to the top of the mountain.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0052)	; Message 105-1

	%vwf_header(text_alignment(TextAlignment.Centered))

	!macro("PointOfAdvice")
	!text("You can hold an extra item in the box at the top of the screen.") : !press_a : !clear
	!text("To use it, press the SELECT Button.") : !press_a


%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0053)	; Message 105-2

	%vwf_header(text_alignment(TextAlignment.Centered))

	!macro("PointOfAdvice")
	!text("To pick up a shell, use the X or Y Button.") : !press_a : !clear
	!text("To throw a shell upwards, look up and let go of the button.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0054)	; Message 106-1

	%vwf_header()

	!text("To do a spin jump, press the A Button.") : !press_a : !clear
	!text("A Super Mario spin jump can break some of the blocks and defeat some of the tougher enemies.") : !press_a

%vwf_message_end()

;-------------------------------------------------------

%vwf_message_start(0055)	; Message 106-2

	%vwf_header(text_alignment(TextAlignment.Centered))

	!macro("PointOfAdvice")
	!text("This gate marks the middle of this area.") : !press_a : !clear
	!text("By cutting the tape here, you can continue from close to this point.") : !press_a

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

	%vwf_header(auto_wait(AutoWait.WaitFrames.161), text_alignment(TextAlignment.Centered))

	!edit_pal(!text_color_6, rgb_15(17, 0, 0), rgb_15(0, 0, 0))
	!macro("SwitchPalace")

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

	%vwf_header(auto_wait(AutoWait.WaitFrames.161), text_alignment(TextAlignment.Centered))
	
	!edit_pal(!text_color_6, rgb_15(13, 13, 27), rgb_15(0, 0, 0))
	!macro("SwitchPalace")

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

	%vwf_header()

	!text("Amazing! Few have made it this far. Beyond lies the Special Zone.") : !press_a : !clear
	!text("Complete it and you can explore a strange new world. GOOD LUCK!") : !press_a

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


macro vwf_write_stripe_image_header(x_pos, y_pos, data_size, is_rle)
	if <is_rle> != false
		!temp_rle = %01000000
		!temp_length = (-(<data_size>))
	else
		!temp_rle = %00000000
		!temp_length = ((<data_size>)-1)
	endif
	
	db %01010000|(((<y_pos>)&%100000)>>2)|(((<x_pos>)&%100000)>>3)|(((<y_pos>)&%011000)>>3)
	db (((<y_pos>)&%000111)<<5)|((<x_pos>)&%011111)
	db !temp_rle|((!temp_length&%11111100000000)>>8)
	db !temp_length&%00000011111111
	
	undef "temp_rle"
	undef "temp_length"
endmacro

macro vwf_define_stripe_image_raw_line(x_pos, y_pos, ...)	
	!magic_token ?= .X
	!magic_token += X
	
!magic_token:
	%vwf_write_stripe_image_header(<x_pos>, <y_pos>, ..End-..Start, false)
	
..Start:
	for i = 0..sizeof(...)
		db <...[!i]>
		db $39
	endfor
..End:
endmacro

macro vwf_define_stripe_image_raw_line_rle(x_pos, y_pos, tile_id, count)
	!magic_token ?= .X
	!magic_token += X
	
!magic_token:
	%vwf_write_stripe_image_header(<x_pos>, <y_pos>, -(<count>)*2, true)
	
	db <tile_id>
	db $39
endmacro

macro vwf_define_stripe_image_text_line(x_pos, y_pos, text)
	pushtable
	
	!temp_property_byte #= %00111001<<8
	!temp_property_byte_page_1 #= %00111000<<8
	
	'A' = !temp_property_byte|$00
	'B' = !temp_property_byte|$01
	'C' = !temp_property_byte|$02
	'D' = !temp_property_byte|$03
	'E' = !temp_property_byte|$04
	'F' = !temp_property_byte|$05
	'G' = !temp_property_byte|$06
	'H' = !temp_property_byte|$07
	'I' = !temp_property_byte|$08
	'J' = !temp_property_byte|$09
	'K' = !temp_property_byte|$0A
	'L' = !temp_property_byte|$0B
	'M' = !temp_property_byte|$0C
	'N' = !temp_property_byte|$0D
	'O' = !temp_property_byte|$0E
	'P' = !temp_property_byte|$0F
	
	'Q' = !temp_property_byte|$10
	'R' = !temp_property_byte|$11
	'S' = !temp_property_byte|$12
	'T' = !temp_property_byte|$13
	'U' = !temp_property_byte|$14
	'V' = !temp_property_byte|$15
	'W' = !temp_property_byte|$16
	'X' = !temp_property_byte|$17
	'Y' = !temp_property_byte|$18
	'Z' = !temp_property_byte|$19
	'!' = !temp_property_byte|$1A
	'.' = !temp_property_byte|$1B
	'-' = !temp_property_byte|$1C
	',' = !temp_property_byte|$1D
	'?' = !temp_property_byte|$1E
	' ' = !temp_property_byte|$1F
	
	'a' = !temp_property_byte|$40
	'b' = !temp_property_byte|$41
	'c' = !temp_property_byte|$42
	'd' = !temp_property_byte|$43
	'e' = !temp_property_byte|$44
	'f' = !temp_property_byte|$45
	'g' = !temp_property_byte|$46
	'h' = !temp_property_byte|$47
	'i' = !temp_property_byte|$48
	'j' = !temp_property_byte|$49
	'k' = !temp_property_byte|$4A
	'l' = !temp_property_byte|$4B
	'm' = !temp_property_byte|$4C
	'n' = !temp_property_byte|$4D
	'o' = !temp_property_byte|$4E
	'p' = !temp_property_byte|$4F
	
	'q' = !temp_property_byte|$50
	'r' = !temp_property_byte|$51
	's' = !temp_property_byte|$52
	't' = !temp_property_byte|$53
	'u' = !temp_property_byte|$54
	'v' = !temp_property_byte|$55
	'w' = !temp_property_byte|$56
	'x' = !temp_property_byte|$57
	'y' = !temp_property_byte|$58
	'z' = !temp_property_byte|$59
	'#' = !temp_property_byte|$5A
	'(' = !temp_property_byte|$5B
	')' = !temp_property_byte|$5C
	''' = !temp_property_byte|$5D : ''' = !temp_property_byte|$5D
	'/' = !temp_property_byte|$3F
	
	'0' = !temp_property_byte_page_1|$00
	'1' = !temp_property_byte_page_1|$01
	'2' = !temp_property_byte_page_1|$02
	'3' = !temp_property_byte_page_1|$03
	'4' = !temp_property_byte_page_1|$04
	'5' = !temp_property_byte_page_1|$05
	'6' = !temp_property_byte_page_1|$06
	'7' = !temp_property_byte_page_1|$07
	'8' = !temp_property_byte_page_1|$08
	'9' = !temp_property_byte_page_1|$09
	
	; Used as cursor character
	'>' = !temp_property_byte|$5E
	
	undef "temp_property_byte"
	undef "temp_property_byte_page_1"
	
	!magic_token ?= .X
	!magic_token += X
	
!magic_token:
	%vwf_write_stripe_image_header(<x_pos>, <y_pos>, ..End-..Start, false)
	
..Start:
	dw "<text>"
..End:
	
	pulltable
endmacro

macro vwf_stripe_image_end()
	db $FF
endmacro

macro vwf_append_stripe_image(address, size)
	rep #$30
	
	ldx.w #(<address>)
	
	lda $7F837B
	clc
	adc.w #$7F837D
	tay
	
	lda.w #(<size>)
	pha
	dec
	clc
	adc $7F837B
	sta $7F837B
	pla
	
	phb
	mvn bank($7F837D), bank(<address>)
	plb
	
	sep #$30
endmacro


TestSuiteNMI:
	lda remap_ram($0D9D)
	ora.b #%00000100
	sta $212C
	lda remap_ram($0D9E)
	and.b #%11111011
	sta $212D
	
	lda $3E
	ora.b #%00001000
	sta $2105
	lda $40
	and.b #%11111011
	sta $2131

	stz $11
	stz $2111	; Set layer 3 X scroll to $0000
	stz $2111
	lda.b #$1F	; Set layer 3 Y scroll to $011F
	sta $2112
	lda.b #$01
	sta $2112
	
	lda.b #$22
	sta $2123
	lda.b #$00
	sta $2124
	lda.b #$22
	sta $2125
	lda.b #$22
	sta $2130
	
	lda remap_ram($0D9F)
	ora.b #$80
	sta $420C
	
	rts


ProcessTestSuiteInput:
	lda !vwf_current_test_suite_page
	beq .NotOpenYet
	
.AlreadyOpen
	lda.b #%10000000
	trb $18
	beq .DontConfirm
	
	lda.b #$29
	sta $1DFC
	
	jsr StartMessage
	
	jsr CloseTestSuite
	rts
	
.DontConfirm
	lda.b #%00010000
	trb $16
	beq .DontClose
	
	lda.b #$12
	sta $1DF9
	
	jsr CloseTestSuite
	rts
	
.DontClose
	lda.b #%00001000
	trb $16
	beq .UpNotPressed
	
	jsr CursorUp
	
.UpNotPressed
	lda.b #%00000100
	trb $16
	beq .DownNotPressed
	
	jsr CursorDown
	
.DownNotPressed
	lda.b #%00000010
	trb $16
	beq .LeftNotPressed
	
	jsr PageLeft
	
.LeftNotPressed
	lda.b #%00000001
	trb $16
	beq .RightNotPressed
	
	jsr PageRight
	
.RightNotPressed
	rts
	
.NotOpenYet
	lda.b #%00010000
	trb $16
	beq .Return
	
	lda.b #$12
	sta $1DF9
	
	jsr OpenTestSuite

.Return
	rts
	
	
CursorUp:
	lda.b #$23
	sta $1DFC
	
	jsr ClearCursor	
	jsr GetNumTestsOnPage
	
	lda !vwf_current_test_suite_row
	dec
	bpl .NoWrapAround
	lda $00
	dec
	
.NoWrapAround
	sta !vwf_current_test_suite_row
	
	jsr DrawCursor
	
	rts
	
CursorDown:
	lda.b #$23
	sta $1DFC
	
	jsr ClearCursor	
	jsr GetNumTestsOnPage
	
	lda !vwf_current_test_suite_row
	inc
	cmp $00
	bcc .NoWrapAround
	lda.b #$00
	
.NoWrapAround
	sta !vwf_current_test_suite_row
	
	jsr DrawCursor
	
	rts
	
PageLeft:
	lda.b #$23
	sta $1DFC
	
	lda !vwf_current_test_suite_page
	dec
	bne .NoWrapAround
	lda TestSuiteNumPages
	
.NoWrapAround
	sta !vwf_current_test_suite_page
	
	jsr ClampCursor	
	jsr DrawCurrentTestSuitePage	
	jsr DrawCursor
	
	rts
	
PageRight:
	lda.b #$23
	sta $1DFC
	
	lda !vwf_current_test_suite_page
	cmp TestSuiteNumPages
	bcc .NoWrapAround
	lda.b #$00
	
.NoWrapAround
	inc
	sta !vwf_current_test_suite_page
	
	jsr ClampCursor	
	jsr DrawCurrentTestSuitePage	
	jsr DrawCursor
	rts
	
	
GetNumTestsOnPage:
	rep #$30
	jsr GetPageTableOffset
	sep #$20
	lda TestSuitePageInfos+8,x
	sep #$10
	sta $00
	
	rts
	
ClampCursor:
	jsr GetNumTestsOnPage
	
	lda !vwf_current_test_suite_row
	cmp $00
	bcc .NoClamp
	lda $00
	dec
	sta !vwf_current_test_suite_row
	
.NoClamp
	rts
	
	
StartMessage:	
	rep #$30
	jsr GetPageTableOffset
	
	lda TestSuitePageInfos+5,x
	sta $00
	lda TestSuitePageInfos+6,x
	sta $01
	
	lda !vwf_current_test_suite_row
	and.w #$00FF
	asl
	tay
	
	lda [$00],y
	xba
	tax
	xba
	sep #$30
	
	jsl VWF_DisplayAMessage
	
	rts
	

!vwf_test_suite_scanline_start #= 8
!vwf_test_suite_scanline_stop #= 224-8

assert !vwf_test_suite_scanline_stop > !vwf_test_suite_scanline_start
	
OpenTestSuite:
	lda.b #$01
	sta !vwf_current_test_suite_page
	lda.b #$00
	sta !vwf_current_test_suite_row
	
	; Set up background window
	rep #$30
	ldx.w #(!vwf_test_suite_scanline_start*2)
	lda.w #$F808
.SetUpWindow
	sta remap_ram($04A0),x
	inx #2
	cpx.w #(!vwf_test_suite_scanline_stop*2)
	bne .SetUpWindow
	sep #$30
	
	jsr DrawCurrentTestSuitePage
	
	jsr DrawCursor
	
	rts
	
CloseTestSuite:
	lda.b #$00
	sta !vwf_current_test_suite_page
	
	jsr ClearTestSuiteScreen
	
	rts
	
DrawCurrentTestSuitePage:
	jsr DrawTestSuiteBackground
	
	rep #$30
	
	jsr GetPageTableOffset
	
	; Build MVN as RAM routine
	lda.w #$7F54	; $54 = MVN opcode, 7F = bank byte of $7F837B
	sta $00	
	lda TestSuitePageInfos+2,x	; Get source bank byte from TestSuitePageInfos
	and.w #$00FF
	ora.w #$6B00	; $6B = RTL opcode
	sta $02

		
	lda $7F837B
	clc
	adc.w #$7F837D
	tay
	
	lda TestSuitePageInfos+3,x
	pha
	pha
	
	lda TestSuitePageInfos,x
	tax
	
	pla
	dec	; $7F837B does not count the terminating $FF.
	clc
	adc $7F837B
	sta $7F837B
	pla
	
	jsl $7E0000
	
	sep #$30
	rts
	
GetPageTableOffset:
	lda !vwf_current_test_suite_page
	and.w #$00FF
	dec
	asl #4	; Multiply by 16
	tax
	
	rts
	
DrawTestSuiteBackground:
	%vwf_append_stripe_image(.BackgroundImage_Start, .BackgroundImage_End-.BackgroundImage_Start)
	rts
	
!vwf_test_suite_left = 1
!vwf_test_suite_top = 37
!vwf_test_suite_width = 29
!vwf_test_suite_height = 26
!vwf_test_suite_right #= !vwf_test_suite_left+!vwf_test_suite_width
!vwf_test_suite_bottom #= !vwf_test_suite_top+!vwf_test_suite_height

.BackgroundImage_Start
	for temp_current_y = !vwf_test_suite_top..!vwf_test_suite_bottom
		%vwf_define_stripe_image_raw_line_rle(!vwf_test_suite_left, !temp_current_y, $1F, !vwf_test_suite_width)
	endfor
	%vwf_define_stripe_image_text_line(!vwf_test_suite_left+10, !vwf_test_suite_top+1, "Test Suite")
	%vwf_define_stripe_image_raw_line_rle(!vwf_test_suite_left, !vwf_test_suite_top+2, $1C, !vwf_test_suite_width)
	%vwf_stripe_image_end()
.BackgroundImage_End
	
ClearTestSuiteScreen:
	%vwf_append_stripe_image(.ClearScreen_Start, .ClearScreen_End-.ClearScreen_Start)
	rts

.ClearScreen_Start
	for temp_current_y = !vwf_test_suite_top..!vwf_test_suite_bottom
		%vwf_define_stripe_image_raw_line_rle(!vwf_test_suite_left, !temp_current_y, $79, !vwf_test_suite_width)
	endfor
	%vwf_stripe_image_end()
.ClearScreen_End

!vwf_test_suite_cursor_x_pos #= !vwf_test_suite_left+1
!vwf_test_suite_cursor_y_pos_start #= !vwf_test_suite_top+6
!vwf_test_suite_cursor_tile_value #= (%00101101<<8)|$2E
!vwf_test_suite_empty_tile_value #= (%00111001<<8)|$1F
	
DrawCursor:
	rep #$30
	lda.w #!vwf_test_suite_cursor_tile_value
	sta $02
	jsr DrawTileAtCursorPos
	rts
	
ClearCursor:
	rep #$30
	lda.w #!vwf_test_suite_empty_tile_value
	sta $02
	jsr DrawTileAtCursorPos
	rts

DrawTileAtCursorPos:
	;rep #$30
	lda $7F837B
	tax
	
	lda !vwf_current_test_suite_row
	and.w #$00FF
	clc
	adc.w #!vwf_test_suite_cursor_y_pos_start
	and.w #%011111
	asl #5
	sta $00
	
	lda !vwf_current_test_suite_row
	and.w #$00FF
	clc
	adc.w #!vwf_test_suite_cursor_y_pos_start
	and.w #%100000
	asl #6
	ora $00
	xba
	sta $00
	
	ora.w #%01010000|((!vwf_test_suite_cursor_x_pos&%100000)>>3)|((!vwf_test_suite_cursor_x_pos&%011111)<<8)
		
	sta $7F837D,x
	inx #2
	
	lda.w #$0100
	sta $7F837D,x
	inx #2
	
	lda $02
	sta $7F837D,x
	inx #2
	
	lda $7F837B
	clc
	adc.w #6
	sta $7F837B
	
	sep #$20
	lda.b #$FF
	sta $7F837D,x
	
	sep #$10
	
	rts


!vwf_test_suite_max_num_tests_per_page #= (!vwf_test_suite_height-7)
!vwf_test_suite_num_categories #= 0
!vwf_test_suite_page_start_offset_x #= !vwf_test_suite_left+1
!vwf_test_suite_page_start_offset_y #= !vwf_test_suite_top+4

macro vwf_register_test_suite_category(internal_name, display_name)
	if defined("vwf_test_suite_category_<internal_name>_id")
		error "Test suite category ""<internal_name>"" was already defined."
	endif
	
	!{vwf_test_suite_category_!{vwf_test_suite_num_categories}_internal_name} := <internal_name>
	!{vwf_test_suite_category_<internal_name>_id} #= !vwf_test_suite_num_categories
	!{vwf_test_suite_category_!{vwf_test_suite_num_categories}_display_name} := "<display_name>"
	!{vwf_test_suite_category_!{vwf_test_suite_num_categories}_num_tests} #= 0
	
	!vwf_test_suite_num_categories #= !vwf_test_suite_num_categories+1
endmacro

macro vwf_register_test(category_internal_name, test_name, message_number)
	if not(defined("vwf_test_suite_category_<category_internal_name>_id"))
		error "Test suite category ""<category_internal_name>"" wasn't defined yet."
	else
		!temp_category_id #= !vwf_test_suite_category_<category_internal_name>_id
		!temp_test_id #= !{vwf_test_suite_category_!{temp_category_id}_num_tests}
		
		!{vwf_test_suite_test_!{temp_category_id}_!{temp_test_id}_display_name} := "<test_name>"
		!{vwf_test_suite_test_!{temp_category_id}_!{temp_test_id}_message_number} #= <message_number>
		
		!{vwf_test_suite_category_!{temp_category_id}_num_tests} #= !{vwf_test_suite_category_!{temp_category_id}_num_tests}+1
		undef "temp_category_id"
		undef "temp_test_id"
	endif
endmacro

macro vwf_generate_test_suite_tables()
	TestSuitePageInfos:
	
	!temp_num_pages = 0

	for temp_category_idx = 0..!vwf_test_suite_num_categories
		!temp_num_tests_in_category #= !{vwf_test_suite_category_!{temp_category_idx}_num_tests}
		!temp_num_pages_for_category #= ceil(!temp_num_tests_in_category/!vwf_test_suite_max_num_tests_per_page)
		
		for temp_page_idx = 0..!temp_num_pages_for_category			
			dl TestSuitePageImages!{temp_num_pages}
			dw TestSuitePageImages!{temp_num_pages}End-TestSuitePageImages!{temp_num_pages}
			dl TestSuiteTestPropertiesStart!{temp_num_pages}
			db min(!temp_num_tests_in_category-(!temp_page_idx*!vwf_test_suite_max_num_tests_per_page),!vwf_test_suite_max_num_tests_per_page)
			; Padding
			db $FF
			db $FF
			db $FF
			db $FF
			db $FF
			db $FF
			db $FF
			
			!temp_num_pages #= !temp_num_pages+1
		endfor
		
		undef "temp_num_tests_in_category"
		undef "temp_num_pages_for_category"
	endfor
	
	TestSuiteNumPages:
		dw !temp_num_pages
	
	!temp_num_pages = 0

	for temp_category_idx = 0..!vwf_test_suite_num_categories
		!temp_num_tests_in_category #= !{vwf_test_suite_category_!{temp_category_idx}_num_tests}
		!temp_num_pages_for_category #= ceil(!temp_num_tests_in_category/!vwf_test_suite_max_num_tests_per_page)
		
		for temp_page_idx = 0..!temp_num_pages_for_category
			!temp_test_start_idx #= !temp_page_idx*!vwf_test_suite_max_num_tests_per_page	
			
			TestSuiteTestPropertiesStart!{temp_num_pages}:			
				for temp_test_idx = 0..!vwf_test_suite_max_num_tests_per_page
					!temp_test_id #= !temp_test_start_idx+!temp_test_idx
					if !temp_test_idx >= !temp_num_tests_in_category-(!temp_page_idx*!vwf_test_suite_max_num_tests_per_page)
						dw $FFFF
					else
						dw !{vwf_test_suite_test_!{temp_category_idx}_!{temp_test_id}_message_number}
					endif
					undef "temp_test_id"
				endfor
			
			!temp_num_pages #= !temp_num_pages+1
			undef "temp_test_start_idx"
		endfor	
		
		undef "temp_num_tests_in_category"
		undef "temp_num_pages_for_category"
	endfor
	
	undef "temp_num_pages"
endmacro

macro vwf_generate_test_suite_stripe_images()
	!temp_num_pages = 0

	for temp_category_idx = 0..!vwf_test_suite_num_categories
		!temp_category_name := !{vwf_test_suite_category_!{temp_category_idx}_display_name}
		!temp_num_tests_in_category #= !{vwf_test_suite_category_!{temp_category_idx}_num_tests}
		!temp_num_pages_for_category #= ceil(!temp_num_tests_in_category/!vwf_test_suite_max_num_tests_per_page)
		
		for temp_page_idx = 0..!temp_num_pages_for_category
			TestSuitePageImages!{temp_num_pages}:
				!temp_test_start_idx #= !temp_page_idx*!vwf_test_suite_max_num_tests_per_page
				!temp_page_idx_display #= !temp_page_idx+1
				
				%vwf_define_stripe_image_text_line(!vwf_test_suite_page_start_offset_x, !vwf_test_suite_page_start_offset_y, "!temp_category_name (!temp_page_idx_display of !temp_num_pages_for_category)")
				
				for temp_test_idx = 0..min(!temp_num_tests_in_category-(!temp_page_idx*!vwf_test_suite_max_num_tests_per_page),!vwf_test_suite_max_num_tests_per_page)
					!temp_test_id #= !temp_test_start_idx+!temp_test_idx
					!temp_test_name := !{vwf_test_suite_test_!{temp_category_idx}_!{temp_test_id}_display_name}
					%vwf_define_stripe_image_text_line(!vwf_test_suite_page_start_offset_x+2, !vwf_test_suite_page_start_offset_y+2+!temp_test_idx, "!temp_test_name")
					undef "temp_test_id"
					undef "temp_test_name"
				endfor
				
				%vwf_stripe_image_end()
			TestSuitePageImages!{temp_num_pages}End:
			
			!temp_num_pages #= !temp_num_pages+1
			undef "temp_test_start_idx"
			undef "temp_page_idx_display"
		endfor
		
		undef "temp_category_name"
		undef "temp_num_tests_in_category"
		undef "temp_num_pages_for_category"
	endfor
	
	undef "temp_num_pages"
endmacro

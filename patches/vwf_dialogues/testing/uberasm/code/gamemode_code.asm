incsrc "vwfsharedroutines.asm"
incsrc "vwfsharedroutines.asm"

macro write_stripe_image_header(x_pos, y_pos, data_size)	
	!temp_length = ((<data_size>)-1)
	
	db %01010000|((<y_pos>&%100000)>>2)|((<x_pos>&%100000)>>3)|((<y_pos>&%011000)>>3)
	db ((<y_pos>&%000111)<<5)|(<x_pos>&%011111)
	db %00000000|((!temp_length&%11111100000000)>>8)
	db !temp_length&%00000011111111
	
	undef "temp_length"
endmacro

macro define_stripe_image_raw_line(x_pos, y_pos, ...)	
	!magic_token ?= .X
	!magic_token += X
	
!magic_token:
	%write_stripe_image_header(<x_pos>, <y_pos>, ..End-..Start)
	
..Start:
	for i = 0..sizeof(...)
		db <...[!i]>
		db $39
	endfor
..End:
endmacro

macro define_stripe_image_text_line(x_pos, y_pos, text)
	pushtable
	
	;!temp_property_byte #= %00111001	
	!temp_property_byte = 39
	
	'A' = $!{temp_property_byte}00
	'B' = $!{temp_property_byte}01
	'C' = $!{temp_property_byte}02
	'D' = $!{temp_property_byte}03
	'E' = $!{temp_property_byte}04
	'F' = $!{temp_property_byte}05
	'G' = $!{temp_property_byte}06
	'H' = $!{temp_property_byte}07
	'I' = $!{temp_property_byte}08
	'J' = $!{temp_property_byte}09
	'K' = $!{temp_property_byte}0A
	'L' = $!{temp_property_byte}0B
	'M' = $!{temp_property_byte}0C
	'N' = $!{temp_property_byte}0D
	'O' = $!{temp_property_byte}0E
	'P' = $!{temp_property_byte}0F
	
	'Q' = $!{temp_property_byte}10
	'R' = $!{temp_property_byte}11
	'S' = $!{temp_property_byte}12
	'T' = $!{temp_property_byte}13
	'U' = $!{temp_property_byte}14
	'V' = $!{temp_property_byte}15
	'W' = $!{temp_property_byte}16
	'X' = $!{temp_property_byte}17
	'Y' = $!{temp_property_byte}18
	'Z' = $!{temp_property_byte}19
	'!' = $!{temp_property_byte}1A
	'.' = $!{temp_property_byte}1B
	'-' = $!{temp_property_byte}1C
	',' = $!{temp_property_byte}1D
	'?' = $!{temp_property_byte}1E
	' ' = $!{temp_property_byte}1F
	
	'a' = $!{temp_property_byte}40
	'b' = $!{temp_property_byte}41
	'c' = $!{temp_property_byte}42
	'd' = $!{temp_property_byte}43
	'e' = $!{temp_property_byte}44
	'f' = $!{temp_property_byte}45
	'g' = $!{temp_property_byte}46
	'h' = $!{temp_property_byte}47
	'i' = $!{temp_property_byte}48
	'j' = $!{temp_property_byte}49
	'k' = $!{temp_property_byte}4A
	'l' = $!{temp_property_byte}4B
	'm' = $!{temp_property_byte}4C
	'n' = $!{temp_property_byte}4D
	'o' = $!{temp_property_byte}4E
	'p' = $!{temp_property_byte}4F
	
	'q' = $!{temp_property_byte}50
	'r' = $!{temp_property_byte}51
	's' = $!{temp_property_byte}52
	't' = $!{temp_property_byte}53
	'u' = $!{temp_property_byte}54
	'v' = $!{temp_property_byte}55
	'w' = $!{temp_property_byte}56
	'x' = $!{temp_property_byte}57
	'y' = $!{temp_property_byte}58
	'z' = $!{temp_property_byte}59
	'#' = $!{temp_property_byte}5A
	'(' = $!{temp_property_byte}5B
	')' = $!{temp_property_byte}5C
	''' = $!{temp_property_byte}5D : ''' = $!{temp_property_byte}5D
	
	; Used as cursor character
	'>' = $!{temp_property_byte}5E
	
	undef "temp_property_byte"
	
	!magic_token ?= .X
	!magic_token += X
	
!magic_token:
	%write_stripe_image_header(<x_pos>, <y_pos>, ..End-..Start)
	
..Start:
	dw "<text>"
..End:
	
	pulltable
endmacro

macro stripe_image_end()
	db $FF
endmacro

macro transfer_stripe_image(address, size)	
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

gamemode_0:
	RTS
gamemode_1:
	RTS
gamemode_2:
	RTS
gamemode_3:
	RTS
gamemode_4:
	RTS
gamemode_5:
	RTS
gamemode_6:
	RTS
gamemode_7:
	RTS
gamemode_8:
	RTS
gamemode_9:
	RTS
gamemode_A:
	RTS
gamemode_B:
	RTS
gamemode_C:
	RTS
gamemode_D:
	RTS
gamemode_E:
	RTS
gamemode_F:
	RTS
gamemode_10:
	RTS
gamemode_11:
	RTS
gamemode_12:
	RTS
gamemode_13:
	RTS
gamemode_14:
	; Yoshi's House. Run our VWF test code.
	if defined("vwf_shared_routine_VWF_DisplayAMessage_exists")
		lda $17
		and.b #%00100000
		beq .LNotPressed
		
		lda $18
		and.b #%01000000
		bne .XPressed
		
		lda $16
		and.b #%01000000
		beq .YNotPressed
		
		jsl VWF_IsMessageActive
		bne .AMessageIsAlreadyOpen
		
		!y_test_message_no = $0042
		lda.b #!y_test_message_no
		ldx.b #!y_test_message_no>>8
		jsl VWF_DisplayAMessage
		rts
	
	.XPressed
		!x_test_message_no = $0041
		lda.b #!x_test_message_no
		ldx.b #!x_test_message_no>>8
		jsl VWF_DisplayAMessage
		rts
		
	.LNotPressed
	.YNotPressed
	.AMessageIsAlreadyOpen
	else
		error "Whoops, VWF_DisplayAMessage routine not found. Did you patch UberASM before VWF Dialogues Patch?"
	endif
	
	
	lda.b #%00001000
	tsb $3E
	lda.b #%00000100
	trb $40
	
	%transfer_stripe_image(.TestImage, .TestImageEnd-.TestImage)
	
	RTS

.TestImage
%define_stripe_image_raw_line(1, 32, $1F, $1F, $1F, $1F, $1F, $1F, $1F)
%define_stripe_image_text_line(2, 32, "Test")
%stripe_image_end()
.TestImageEnd

gamemode_15:
	RTS
gamemode_16:
	RTS
gamemode_17:
	RTS
gamemode_18:
	RTS
gamemode_19:
	RTS
gamemode_1A:
	RTS
gamemode_1B:
	RTS
gamemode_1C:
	RTS
gamemode_1D:
	RTS
gamemode_1E:
	RTS
gamemode_1F:
	RTS
gamemode_20:
	RTS
gamemode_21:
	RTS
gamemode_22:
	RTS
gamemode_23:
	RTS
gamemode_24:
	RTS
gamemode_25:
	RTS
gamemode_26:
	RTS
gamemode_27:
	RTS
gamemode_28:
	RTS
gamemode_29:
	RTS
gamemode_2A:
	RTS
gamemode_2B:
	RTS
gamemode_2C:
	RTS
gamemode_2D:
	RTS
gamemode_2E:
	RTS
gamemode_2F:
	RTS
gamemode_30:
	RTS
gamemode_31:
	RTS
gamemode_32:
	RTS
gamemode_33:
	RTS
gamemode_34:
	RTS
gamemode_35:
	RTS
gamemode_36:
	RTS
gamemode_37:
	RTS
gamemode_38:
	RTS
gamemode_39:
	RTS
gamemode_3A:
	RTS
gamemode_3B:
	RTS
gamemode_3C:
	RTS
gamemode_3D:
	RTS
gamemode_3E:
	RTS
gamemode_3F:
	RTS
gamemode_40:
	RTS
gamemode_41:
	RTS
gamemode_42:
	RTS
gamemode_43:
	RTS
gamemode_44:
	RTS
gamemode_45:
	RTS
gamemode_46:
	RTS
gamemode_47:
	RTS
gamemode_48:
	RTS
gamemode_49:
	RTS
gamemode_4A:
	RTS
gamemode_4B:
	RTS
gamemode_4C:
	RTS
gamemode_4D:
	RTS
gamemode_4E:
	RTS
gamemode_4F:
	RTS
gamemode_50:
	RTS
gamemode_51:
	RTS
gamemode_52:
	RTS
gamemode_53:
	RTS
gamemode_54:
	RTS
gamemode_55:
	RTS
gamemode_56:
	RTS
gamemode_57:
	RTS
gamemode_58:
	RTS
gamemode_59:
	RTS
gamemode_5A:
	RTS
gamemode_5B:
	RTS
gamemode_5C:
	RTS
gamemode_5D:
	RTS
gamemode_5E:
	RTS
gamemode_5F:
	RTS
gamemode_60:
	RTS
gamemode_61:
	RTS
gamemode_62:
	RTS
gamemode_63:
	RTS
gamemode_64:
	RTS
gamemode_65:
	RTS
gamemode_66:
	RTS
gamemode_67:
	RTS
gamemode_68:
	RTS
gamemode_69:
	RTS
gamemode_6A:
	RTS
gamemode_6B:
	RTS
gamemode_6C:
	RTS
gamemode_6D:
	RTS
gamemode_6E:
	RTS
gamemode_6F:
	RTS
gamemode_70:
	RTS
gamemode_71:
	RTS
gamemode_72:
	RTS
gamemode_73:
	RTS
gamemode_74:
	RTS
gamemode_75:
	RTS
gamemode_76:
	RTS
gamemode_77:
	RTS
gamemode_78:
	RTS
gamemode_79:
	RTS
gamemode_7A:
	RTS
gamemode_7B:
	RTS
gamemode_7C:
	RTS
gamemode_7D:
	RTS
gamemode_7E:
	RTS
gamemode_7F:
	RTS
gamemode_80:
	RTS
gamemode_81:
	RTS
gamemode_82:
	RTS
gamemode_83:
	RTS
gamemode_84:
	RTS
gamemode_85:
	RTS
gamemode_86:
	RTS
gamemode_87:
	RTS
gamemode_88:
	RTS
gamemode_89:
	RTS
gamemode_8A:
	RTS
gamemode_8B:
	RTS
gamemode_8C:
	RTS
gamemode_8D:
	RTS
gamemode_8E:
	RTS
gamemode_8F:
	RTS
gamemode_90:
	RTS
gamemode_91:
	RTS
gamemode_92:
	RTS
gamemode_93:
	RTS
gamemode_94:
	RTS
gamemode_95:
	RTS
gamemode_96:
	RTS
gamemode_97:
	RTS
gamemode_98:
	RTS
gamemode_99:
	RTS
gamemode_9A:
	RTS
gamemode_9B:
	RTS
gamemode_9C:
	RTS
gamemode_9D:
	RTS
gamemode_9E:
	RTS
gamemode_9F:
	RTS
gamemode_A0:
	RTS
gamemode_A1:
	RTS
gamemode_A2:
	RTS
gamemode_A3:
	RTS
gamemode_A4:
	RTS
gamemode_A5:
	RTS
gamemode_A6:
	RTS
gamemode_A7:
	RTS
gamemode_A8:
	RTS
gamemode_A9:
	RTS
gamemode_AA:
	RTS
gamemode_AB:
	RTS
gamemode_AC:
	RTS
gamemode_AD:
	RTS
gamemode_AE:
	RTS
gamemode_AF:
	RTS
gamemode_B0:
	RTS
gamemode_B1:
	RTS
gamemode_B2:
	RTS
gamemode_B3:
	RTS
gamemode_B4:
	RTS
gamemode_B5:
	RTS
gamemode_B6:
	RTS
gamemode_B7:
	RTS
gamemode_B8:
	RTS
gamemode_B9:
	RTS
gamemode_BA:
	RTS
gamemode_BB:
	RTS
gamemode_BC:
	RTS
gamemode_BD:
	RTS
gamemode_BE:
	RTS
gamemode_BF:
	RTS
gamemode_C0:
	RTS
gamemode_C1:
	RTS
gamemode_C2:
	RTS
gamemode_C3:
	RTS
gamemode_C4:
	RTS
gamemode_C5:
	RTS
gamemode_C6:
	RTS
gamemode_C7:
	RTS
gamemode_C8:
	RTS
gamemode_C9:
	RTS
gamemode_CA:
	RTS
gamemode_CB:
	RTS
gamemode_CC:
	RTS
gamemode_CD:
	RTS
gamemode_CE:
	RTS
gamemode_CF:
	RTS
gamemode_D0:
	RTS
gamemode_D1:
	RTS
gamemode_D2:
	RTS
gamemode_D3:
	RTS
gamemode_D4:
	RTS
gamemode_D5:
	RTS
gamemode_D6:
	RTS
gamemode_D7:
	RTS
gamemode_D8:
	RTS
gamemode_D9:
	RTS
gamemode_DA:
	RTS
gamemode_DB:
	RTS
gamemode_DC:
	RTS
gamemode_DD:
	RTS
gamemode_DE:
	RTS
gamemode_DF:
	RTS
gamemode_E0:
	RTS
gamemode_E1:
	RTS
gamemode_E2:
	RTS
gamemode_E3:
	RTS
gamemode_E4:
	RTS
gamemode_E5:
	RTS
gamemode_E6:
	RTS
gamemode_E7:
	RTS
gamemode_E8:
	RTS
gamemode_E9:
	RTS
gamemode_EA:
	RTS
gamemode_EB:
	RTS
gamemode_EC:
	RTS
gamemode_ED:
	RTS
gamemode_EE:
	RTS
gamemode_EF:
	RTS
gamemode_F0:
	RTS
gamemode_F1:
	RTS
gamemode_F2:
	RTS
gamemode_F3:
	RTS
gamemode_F4:
	RTS
gamemode_F5:
	RTS
gamemode_F6:
	RTS
gamemode_F7:
	RTS
gamemode_F8:
	RTS
gamemode_F9:
	RTS
gamemode_FA:
	RTS
gamemode_FB:
	RTS
gamemode_FC:
	RTS
gamemode_FD:
	RTS
gamemode_FE:
	RTS
gamemode_FF:
	RTS




; General macros

macro vwf_define_enum(name, ...)	
	if sizeof(...) > 0
		!vwf_enum_<name>_first = <name>.<0>
		!vwf_enum_<name>_last = <name>.<sizeof(...)-1>
	
		struct <name> $000000
			.First:
			
			!temp_i #= 0
			while !temp_i < sizeof(...)
				if !temp_i == sizeof(...)-1
					.Last:
				endif
				
				.<!temp_i>: skip 1
				
				!temp_i #= !temp_i+1
			endwhile
			undef "temp_i"
			
			.Count:
		endstruct
	else
		error "Enums must have at least a single value."
	endif
endmacro


%vwf_define_enum(BitMode, 8Bit, 16Bit)


function vwf_make_color_15(red, green, blue) = (red&%11111)|((green&%11111)<<5)|((blue&%11111)<<10)



; Resource management macros

macro vwf_first_bank()
	freedata
	!vwf_prev_freespace:
endmacro

macro vwf_next_bank()
	freedata : prot !vwf_prev_freespace
	!vwf_prev_freespace += a
	!vwf_prev_freespace:
endmacro

macro vwf_add_font(gfx_file, width_table_file)
	%vwf_next_bank()

	Font!vwf_num_fonts:
	incbin <gfx_file>
	.Width
	incsrc <width_table_file>

	; RPG Hacker: Hack: If we define another font, increase the maximum for our setter.
	!vwf_header_argument_0_maximum #= !vwf_num_fonts
	
	!vwf_num_fonts #= !vwf_num_fonts+1
endmacro

macro vwf_add_messages(messages_file, table_file)
	%vwf_text_start(<table_file>)
	
	incsrc <messages_file>
	
	%vwf_text_end()
endmacro

macro vwf_generate_pointers()
Fonttable:
	!temp_i #= 0
	while !temp_i < !vwf_num_fonts		
		dl Font!{temp_i},Font!{temp_i}_Width
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"

Pointers:
	!temp_i #= 0
	!temp_num_gaps #= 0
	while !temp_i < !vwf_highest_message_id
		if defined("vwf_message_!{temp_i}_defined")
			if !{vwf_message_!{temp_i}_has_header}
				dl !{vwf_message_!{temp_i}_label}
			else
				!vwf_last_fallback_label := !{vwf_message_!{temp_i}_fallback_label}
				dl !vwf_last_fallback_label
			endif
		else
			; RPG Hacker: If it's a gap, use whatever was the last fallback label we found.
			; If there is none, just pad with magic hex. It will likely lead to a crash if
			; someone attempts to open the message, but at least we should be able to find
			; it in the ROM and know what's going on.
			if defined("vwf_last_fallback_label")
				dl !vwf_last_fallback_label
			else
				dl $000BAD
			endif
			!temp_num_gaps #= !temp_num_gaps+1
		endif
	
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"
	
	if !temp_num_gaps >= 50
		warn "Found !temp_num_gaps gaps in message IDs. Gaps in message IDs waste freespace, so it's recommended to avoid excessive usage of them."
	endif
	undef "temp_num_gaps"

TextMacroPointers:
	; RPG Hacker: Some text macros are reserved for buffered text, so pad with magic hex.
	rep !num_reserved_text_macros : dl $00DEAD
	
	!temp_i #= 0
	while !temp_i < !vwf_num_text_macros
		dl TextMacro!temp_i
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"
endmacro



; Text file macros

macro vwf_text_start(table_file)
	%vwf_next_bank()	
	
	pushtable
	cleartable
	table "<table_file>"
	
	!vwf_current_message_name = ""
	!vwf_current_message_id = $FFFF
	!vwf_header_present = false
	!vwf_current_text_file_id #= !vwf_num_text_files
	
	assert !vwf_num_fonts > 0, "Must add at least a single font before starting a text file."
	
	%vwf_define_invalid_message_handlers()
	
	TextFile!vwf_num_text_files:
	!vwf_num_text_files #= !vwf_num_text_files+1
endmacro

macro vwf_text_end()
	if !vwf_current_message_id != $FFFF
		error "A %vwf_message_start() (message !vwf_current_message_id) seems to be missing a %vwf_message_end()."
	else		
		!vwf_current_message_name = ""
		!vwf_current_message_id = $FFFF
		!vwf_header_present = false
		!vwf_current_text_file_id = -1
		
		pulltable
	endif
endmacro

macro vwf_define_invalid_message_handlers()
	
HandleUndefinedMessage!vwf_num_text_files:
	!8bit_mode_only db $00
	db %00001000,%01111000,%11010001,%11000000,$01,%00100000
	dw $7FFF,$0000
	db %11110100
	db %00001111,$13,$13,$23,$29
	db %00000000
	;dl MessageASMLoc
	;dl .MessageSkipLoc	
	
.Text
	if !bitmode	== BitMode.8Bit
		db "Message "
		db $F6
		dl !message+1
		db $F6
		dl !message
		db " isn't defined. Please contact the hack author to report this oversight."
		db $FA
		db $FF
	else	
		dw "Message "
		dw $FFF6
		dl !message+1
		dw $FFF6
		dl !message
		dw " isn't defined. Please contact the hack author to report this oversight."
		dw $FFFA
		dw $FFFF
	endif
	
endmacro



; Message header macros

macro vwf_message_start(id)
	if !vwf_current_message_id != $FFFF
		error "A %vwf_message_start() (message !vwf_current_message_id) seems to be missing a %vwf_message_end()."
	elseif defined("vwf_message_<id>_defined")
		error "Message ID <id> used multiple times. Please make sure every message ID is unique."
	else
		!vwf_current_message_name = "Message<id>"
		!vwf_current_message_id = $<id>
		!vwf_header_present = false
		
		!vwf_num_messages #= !vwf_num_messages+1
		
		!temp_id_num #= !vwf_current_message_id
		!temp_text_id_num #= !vwf_num_text_files-1
		!{vwf_message_!{temp_id_num}_defined} = true
		!{vwf_message_!{temp_id_num}_label} := !vwf_current_message_name
		!{vwf_message_!{temp_id_num}_fallback_label} := HandleUndefinedMessage!temp_text_id_num
		!{vwf_message_!{temp_id_num}_has_header} = false
		
		!vwf_last_fallback_label := !{vwf_message_!{temp_id_num}_fallback_label}
		undef "temp_id_num"
		undef "temp_text_id_num"
		
		if $<id> > !vwf_highest_message_id
			!vwf_highest_message_id #= $<id>
		endif
	endif
endmacro

macro vwf_message_end()
	if !vwf_current_message_id == $FFFF
		error "You must call %vwf_message_start() before calling %vwf_message_end()."
	else
		if !vwf_header_present != false
			; RPG Hacker: Add fallback in case someone forgets to terminate a message correctly.
			%vwf_close()
		else
			; RPG Hacker: If we don't have at least a header, don't add this fallback. This is likely an empty message,
			; and we don't want to waste a few bytes of freespace for every empty message. This should hopefully just
			; fall through to whatever %vwf_header() or %vwf_text_start() is being called next.
			!vwf_current_message_name:
		endif
			
		!vwf_current_message_name = ""
		!vwf_current_message_id = $FFFF	
		!vwf_header_present = false
	endif
endmacro

macro vwf_register_text_macro(name, ...)
	if defined("vwf_text_macro_<name>_defined")
		error "Text macro redefinition: <name>"
	endif

TextMacro!vwf_num_text_macros:
	!temp_i #= 0
	while !temp_i < sizeof(...)
		<!temp_i>
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"

	!8bit_mode_only db $E7
	!16bit_mode_only db $FFE7
	
	!vwf_text_macro_<name>_defined = true
	; RPG Hacker: +!num_reserved_text_macros, because we are skipping the reserved macros in the table.
	!vwf_text_macro_<name>_sequence := "$E8 : dw !vwf_num_text_macros+!num_reserved_text_macros"
	
	!vwf_num_text_macros #= !vwf_num_text_macros+1
endmacro


; RPG Hacker: A lot of macro wizardry following below. I know this is all quite nasty, unintuitive
; and hard to read. The TL;DR about what I'm doing here is that I'm abusing macros to define a few
; helper functions that simulate dictionaries from traditional programming languages. I'm then using
; these "dictionaries" to implement the logic for the parsing of my generic headers.
!vwf_header_num_setters = 0

macro vwf_set_header_arg_property(arg_id, property_name, value)
	!vwf_header_argument_<arg_id>_<property_name> := <value>
endmacro

macro vwf_define_header_setter_generic(name, is_hex, minimum, maximum)
	%vwf_set_header_arg_property(!vwf_header_num_setters, "name", <name>)	
	
	%vwf_set_header_arg_property(!vwf_header_num_setters, "index", !vwf_header_num_setters)
	%vwf_set_header_arg_property(!vwf_header_num_setters, "type", 0)
	%vwf_set_header_arg_property(!vwf_header_num_setters, "is_hex", <is_hex>)
	%vwf_set_header_arg_property(!vwf_header_num_setters, "minimum", <minimum>)
	%vwf_set_header_arg_property(!vwf_header_num_setters, "maximum", <maximum>)
	
	function vwf_<name>(value) = (!vwf_header_num_setters<<24)|value
	
	!vwf_header_num_setters #= !vwf_header_num_setters+1
endmacro

macro vwf_define_header_setter_sound(name)
	%vwf_set_header_arg_property(!vwf_header_num_setters, "name", <name>)
	
	%vwf_set_header_arg_property(!vwf_header_num_setters, "index", !vwf_header_num_setters)
	%vwf_set_header_arg_property(!vwf_header_num_setters, "type", 1)
	
	function vwf_<name>(sound_id, sound_bank) = (!vwf_header_num_setters<<24)|((sound_id&$FF)<<16)|(sound_bank&$FFFF)
	
	!vwf_header_num_setters #= !vwf_header_num_setters+1
endmacro


macro vwf_get_header_arg_name(out_var, arg_id)
	!<out_var> := !vwf_header_argument_<arg_id>_name
endmacro

macro vwf_reset_header_arg_to_default(arg_id, name)
	if !vwf_header_argument_<arg_id>_type == 0
		; Generic value
		!vwf_header_argument_<name>_value #= !default_<name>
	elseif !vwf_header_argument_<arg_id>_type == 1
		; Sound ID + Bank
		!vwf_header_argument_<name>_id #= !default_<name>_id
		!vwf_header_argument_<name>_bank #= !default_<name>_bank
	else
		error "Header function ""vwf_<name>()"" has an unknown type, indicating a bug in the patch."
	endif
endmacro

macro vwf_clear_header_argument(arg_id)
	%vwf_get_header_arg_name("temp_name", <arg_id>)
	
	%vwf_reset_header_arg_to_default(<arg_id>, !temp_name)
	undef "temp_name"
	
	!vwf_header_argument_<arg_id>_set #= false
endmacro

macro vwf_clear_header_arguments()
	!temp_i #= 0
	while !temp_i < !vwf_header_num_setters		
		%vwf_clear_header_argument(!temp_i)
		
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"
endmacro


macro vwf_verify_header_argument_value(arg_id, name, value, display_name)
	if !vwf_header_argument_<arg_id>_type == 0
		; Generic value
		if !vwf_header_argument_<arg_id>_is_hex == false
			!vwf_set_generic_extra_char = ""
			!vwf_set_generic_value_output = dec(<value>)
		else
			!vwf_set_generic_extra_char = "$"
			!vwf_set_generic_value_output = hex(<value>)
		endif
	
		if <value> < !vwf_header_argument_<arg_id>_minimum || <value> > !vwf_header_argument_<arg_id>_maximum
			error "<display_name>: Invalid value: !vwf_set_generic_extra_char",!vwf_set_generic_value_output,", should be between !vwf_header_argument_<arg_id>_minimum and !vwf_header_argument_<arg_id>_maximum."
		else
			!vwf_header_argument_<name>_value #= <value>
		endif	
	elseif !vwf_header_argument_<arg_id>_type == 1
		; Sound ID + Bank
		!temp_sound_id #= (<value>>>16)%$FF
		!temp_bank #= <value>&$FFFF
		
		if !temp_bank < $1DF9 || !temp_bank > $1DFC
			error "<display_name>: Invalid sound bank address: $",hex(!temp_bank),", should be between $1DF9 and $1DFC."
		else
			; RPG Hacker: Should consider promoting this to an error, because I honestly can't think of ANY
			; scenario where allowing $1DFB could actually work. However, the original manual only mentioned
			; that using this value was "not recommended", so for the sake of backwards-compatibility, I will
			; keep it like this for the time being.
			if !temp_bank == $1DFB
				warn "<display_name>: Using $1DFB as a sound bank. This might produce some undesired effects."
			endif
			
			; RPG Hacker: We could also check if the respective sound ID is in-bound here. However, Addmusic
			; does technically allow us to define custom sound effects, so I decided against it (even though
			; nearly no hacks actually make use of this).
	
			!vwf_header_argument_<name>_id #= !temp_sound_id
			!vwf_header_argument_<name>_bank #= !temp_bank
		endif
		undef "temp_sound_id"
		undef "temp_bank"
	else
		error "Header property <arg_id> (set via ""<display_name>"") has an unknown type, indicating a bug in the patch."
	endif
endmacro

macro vwf_verify_header_argument(arg_id, name, value)
	if !vwf_header_argument_<arg_id>_set != false
		error "vwf_<name>() set multiple times in one header."
	endif
	
	%vwf_verify_header_argument_value(<arg_id>, <name>, <value>, "vwf_<name>()")
	
	!vwf_header_argument_<arg_id>_set #= true
endmacro

macro vwf_extract_header_agrument(packed_value)
	; RPG Hacker: This initialization is here so that if the #= below fails (which will happen,
	; for example, on passing an undefined function), we run into the if below and print an error
	; that's actually meaningful to the average user, rather than a bunch of nonsense.
	!temp_function_value = $FFFFFFFF

	; RPG Hacker: Really, the only reason I pre-process this arg into a define is because Asar
	; produces pretty weird error messages otherwise for functions that aren't found. Honestly,
	; that might just be another bug in Asar itself, though.
	!temp_function_value #= <packed_value>
	
	!temp_id #= (!temp_function_value>>24)&$FF
	!temp_value #= !temp_function_value&$FFFFFF
	undef "temp_function_value"
	
	if !temp_id < 0 || !temp_id > !vwf_header_num_setters
		error "Failed to parse header option type from value: <packed_value>"
	else
		%vwf_get_header_arg_name("temp_name", !temp_id)
		
		%vwf_verify_header_argument(!temp_id, !temp_name, !temp_value)
	endif
	undef "temp_id"
	undef "temp_value"
endmacro


macro vwf_verfiy_default_arguments()
	!temp_i #= 0
	while !temp_i < !vwf_header_num_setters
		%vwf_get_header_arg_name("temp_name", !temp_i)
		
		!temp_arg_type #= !{vwf_header_argument_!{temp_i}_type}
		if !temp_arg_type == 0
			!temp_define_name := default_!{temp_name}
			
			!temp_value #= !{!{temp_define_name}}
			
			!temp_packed_value #= vwf_!temp_name(!temp_value)&$FFFFFF
			
			undef "temp_value"
		elseif !temp_arg_type == 1			
			!temp_id_define_name := default_!{temp_name}_id
			!temp_bank_define_name := default_!{temp_name}_bank
			
			; RPG Hacker: Uses name of the _bank define, because that's currently the only thing that
			; can actually have an invalid value - so it makes sense if we use it for printing errors.
			!temp_define_name := !temp_bank_define_name
			
			!temp_id_value #= !{!{temp_id_define_name}}
			!temp_bank_value #= !{!{temp_bank_define_name}}
			
			!temp_packed_value #= vwf_!temp_name(!temp_id_value, !temp_bank_value)&$FFFFFF
			
			undef "temp_id_value"
			undef "temp_bank_value"
		else
			error "Header property !temp_i (set while parsing defaults) has an unknown type, indicating a bug in the patch."
		endif
		
		; RPG Hacker: I know this looks silly af, but the triple backslashes are actually necessary.
		; Using only one backslash here makes Asar try to resolve the define once inside the macro...
		!temp_printable_name = "\\\!!{temp_define_name}"
		%vwf_verify_header_argument_value(!temp_i, !temp_name, !temp_packed_value, !temp_printable_name)
		undef "temp_define_name"
		undef "temp_packed_value"
		
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"
endmacro



%vwf_define_enum(BoxAnimation, None, SoE, SoM, MMZ, Instant)
; RPG Hacker: Seems I never implemented right-aligned text for some reason, and we can't easily
; implement it into VWF Patch 1.3 without breaking header binary compatibility, because only a
; single bit is reserved for this setting. However, once 1.3 has been out for a while and everyone
; has switched to using the macro system, binary compatibility no longer matters as much, so we can
; decide to add right-aligned text to version 1.4 or later if we desire.
%vwf_define_enum(TextAlignment, Left, Centered)
%vwf_define_enum(AutoWait, None, WaitForA)

struct WaitFrames extends AutoWait
	!temp_i #= 1
	while !temp_i < $FF
		.!temp_i: skip 1
	
		!temp_i #= !temp_i+1
	endwhile
	undef "temp_i"
endstruct


; RPG Hacker: This currently needs to be the first setter defined,
; due to a hack in %vwf_add_font().
%vwf_define_header_setter_generic("font", false, 0, !vwf_num_fonts-1)

%vwf_define_header_setter_generic("x_pos", false, 0, 28)
%vwf_define_header_setter_generic("y_pos", false, 0, 24)
%vwf_define_header_setter_generic("width", false, 1, 15)
%vwf_define_header_setter_generic("height", false, 1, 13)

%vwf_define_header_setter_generic("box_animation", false, !vwf_enum_BoxAnimation_first, !vwf_enum_BoxAnimation_last)
%vwf_define_header_setter_generic("palette", true, $00, $07)
%vwf_define_header_setter_generic("text_color", true, vwf_make_color_15(0,0,0), vwf_make_color_15(31,31,31))
%vwf_define_header_setter_generic("bg_color", true, vwf_make_color_15(0,0,0), vwf_make_color_15(31,31,31))

%vwf_define_header_setter_generic("space_width", false, 0, 16)
%vwf_define_header_setter_generic("text_margin", false, 0, 7)
%vwf_define_header_setter_generic("text_alignment", false, !vwf_enum_TextAlignment_first, !vwf_enum_TextAlignment_last)

%vwf_define_header_setter_generic("freeze_game", false, false, true)
%vwf_define_header_setter_generic("text_speed", false, 0, 63)
%vwf_define_header_setter_generic("auto_wait", false, !vwf_enum_AutoWait_first, AutoWait.WaitFrames.254)
%vwf_define_header_setter_generic("button_speedup", false, false, true)
%vwf_define_header_setter_generic("skip_enable", false, false, true)

%vwf_define_header_setter_generic("disable_sounds", false, false, true)
%vwf_define_header_setter_sound("letter_sound")
%vwf_define_header_setter_sound("wait_sound")
%vwf_define_header_setter_sound("cursor_sound")
%vwf_define_header_setter_sound("continue_sound")

%vwf_define_header_setter_generic("message_asm_enable", false, false, true)


macro vwf_header(...)	
	if !vwf_current_message_id == $FFFF
		error "You must call %vwf_message_start() before calling %vwf_header()."
	else		
		!temp_id_num #= !vwf_current_message_id
		!{vwf_message_!{temp_id_num}_has_header} = true
		undef "temp_id_num"
	
	!vwf_current_message_name:
	
		%vwf_clear_header_arguments()
		
		!temp_i #= 0
		while !temp_i < sizeof(...)
			%vwf_extract_header_agrument(<!temp_i>)
			!temp_i #= !temp_i+1
		endwhile
		undef "temp_i"
			
		!vwf_header_present = true
	endif
endmacro



; Message command macros

macro vwf_close()
	!8bit_mode_only db $FF
	!16bit_mode_only dw $FFFF
endmacro



; Macros solely for backwards compatibility.
; All of these are really no longer needed and should disappear at some point.
macro nextbank(freespace)
	warn "%nextbank() macro is deprecated and will disappear in a future version. Please use %vwf_add_font() or %vwf_add_messages() instead."
	%vwf_next_bank()
endmacro


macro binary(identifier, data)
	warn "%binary() macro is deprecated and will disappear in a future version. Please use %vwf_add_font() or %vwf_add_messages() instead."
	<identifier>:
	incbin <data>
endmacro


macro source(identifier, data)
	warn "%source() macro is deprecated and will disappear in a future version. Please use %vwf_add_font() or %vwf_add_messages() instead."
	<identifier>:
	incsrc <data>
endmacro

macro textstart()
	warn "%textstart() macro is deprecated and will disappear in a future version. Please use %vwf_add_messages() instead."
	%vwf_text_start("vwftable.txt")
endmacro

macro textend()
	warn "%textend() macro is deprecated and will disappear in a future version. Please use %vwf_add_messages() instead."
	%vwf_text_end()
endmacro

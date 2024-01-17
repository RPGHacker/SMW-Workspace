@asar 1.81

; RPG Hacker: Note: We can't use includeonce here, because this file is meant to be copied alongside multiple resources
; and could be included multiple times from different locations.
if not(defined("vwf_shared_routines_parsed"))	
	macro vwf_add_char_to_label_name(define_name, char_value)
		; RPG Hacker: Yeah, this code stinks a lot. Like, a lot a lot.
		; AFAIK, there's currently no elegant method of doing this.
		; Nothing that returns an ASCII character from its ordinal value.
		if <char_value> == $30
			!<define_name> += "0"
		elseif <char_value> == $31
			!<define_name> += "1"
		elseif <char_value> == $32
			!<define_name> += "2"
		elseif <char_value> == $33
			!<define_name> += "3"
		elseif <char_value> == $34
			!<define_name> += "4"
		elseif <char_value> == $35
			!<define_name> += "5"
		elseif <char_value> == $36
			!<define_name> += "6"
		elseif <char_value> == $37
			!<define_name> += "7"
		elseif <char_value> == $38
			!<define_name> += "8"
		elseif <char_value> == $39
			!<define_name> += "9"
	
		elseif <char_value> == $41
			!<define_name> += "A"
		elseif <char_value> == $42
			!<define_name> += "B"
		elseif <char_value> == $43
			!<define_name> += "C"
		elseif <char_value> == $44
			!<define_name> += "D"
		elseif <char_value> == $45
			!<define_name> += "E"
		elseif <char_value> == $46
			!<define_name> += "F"
		elseif <char_value> == $47
			!<define_name> += "G"
		elseif <char_value> == $48
			!<define_name> += "H"
		elseif <char_value> == $49
			!<define_name> += "I"
		elseif <char_value> == $4A
			!<define_name> += "J"
		elseif <char_value> == $4B
			!<define_name> += "K"
		elseif <char_value> == $4C
			!<define_name> += "L"
		elseif <char_value> == $4D
			!<define_name> += "M"
		elseif <char_value> == $4E
			!<define_name> += "N"
		elseif <char_value> == $4F
			!<define_name> += "O"
		elseif <char_value> == $50
			!<define_name> += "P"
		elseif <char_value> == $51
			!<define_name> += "Q"
		elseif <char_value> == $52
			!<define_name> += "R"
		elseif <char_value> == $53
			!<define_name> += "S"
		elseif <char_value> == $54
			!<define_name> += "T"
		elseif <char_value> == $55
			!<define_name> += "U"
		elseif <char_value> == $56
			!<define_name> += "V"
		elseif <char_value> == $57
			!<define_name> += "W"
		elseif <char_value> == $58
			!<define_name> += "X"
		elseif <char_value> == $59
			!<define_name> += "Y"
		elseif <char_value> == $5A
			!<define_name> += "Z"
	
		elseif <char_value> == $5F
			!<define_name> += "_"
	
		elseif <char_value> == $61
			!<define_name> += "a"
		elseif <char_value> == $62
			!<define_name> += "b"
		elseif <char_value> == $63
			!<define_name> += "c"
		elseif <char_value> == $64
			!<define_name> += "d"
		elseif <char_value> == $65
			!<define_name> += "e"
		elseif <char_value> == $66
			!<define_name> += "f"
		elseif <char_value> == $67
			!<define_name> += "g"
		elseif <char_value> == $68
			!<define_name> += "h"
		elseif <char_value> == $69
			!<define_name> += "i"
		elseif <char_value> == $6A
			!<define_name> += "j"
		elseif <char_value> == $6B
			!<define_name> += "k"
		elseif <char_value> == $6C
			!<define_name> += "l"
		elseif <char_value> == $6D
			!<define_name> += "m"
		elseif <char_value> == $6E
			!<define_name> += "n"
		elseif <char_value> == $6F
			!<define_name> += "o"
		elseif <char_value> == $70
			!<define_name> += "p"
		elseif <char_value> == $71
			!<define_name> += "q"
		elseif <char_value> == $72
			!<define_name> += "r"
		elseif <char_value> == $73
			!<define_name> += "s"
		elseif <char_value> == $74
			!<define_name> += "t"
		elseif <char_value> == $75
			!<define_name> += "u"
		elseif <char_value> == $76
			!<define_name> += "v"
		elseif <char_value> == $77
			!<define_name> += "w"
		elseif <char_value> == $78
			!<define_name> += "x"
		elseif <char_value> == $79
			!<define_name> += "y"
		elseif <char_value> == $7A
			!<define_name> += "z"
		endif
	endmacro
	
	
	macro vwf_define_shared_routine_label(name, value)
		<name> = <value>
		print "    Found '<name>' at $",hex(<name>),"."
	endmacro
	
	
	macro vwf_parse_shared_routines()
		; This is the location of the message box hijack. We use it to find the VWF patch's freecode location.
		; I picked this hijack, because it's unlikely to be used by anything other than the VWF patch, so we
		; can assume that it won't suddenly move to somewhere else in a future version of the patch.
		!vwf_hijack_location = $00A1DA
		
		; First sanity check: Is there a JML at the hijack location?
		; If not, VWF Dialogues Patch can't be installed, so nothing else to do here.
		; Generate a note, just in case.
		if read1(!vwf_hijack_location) == $5C
			; Now get the free code location from the hijack.
			!vwf_freecode_location #= read3(!vwf_hijack_location+1)
			
			print "Detected VWF Dialogues Patch message box hijack at $",hex(!vwf_freecode_location),". Searching for shared routines table."		
		
					
			; Second sanity check. The pointer to the shared routines table is marked with a "VWFR". Check if it's present.
			!vwf_shared_routines_fourcc #= read4(!vwf_freecode_location-7)
			; RPG Hacker: This magic hex is actually a FourCC, "VWFR", spelled backwards due to being little endian.
			; Including it as a magic hex value so that I don't have to initialize a table with ASCII mappings.
			!vwf_shared_routines_expected_fourcc  = $52465756
			
			if !vwf_shared_routines_fourcc == !vwf_shared_routines_expected_fourcc
				print "Detected FourCC at $",hex(!vwf_freecode_location-7),". Parsing shared routines."
				
				!vwf_shared_routines_table_location #= read3(!vwf_freecode_location-3)
				
				!vwf_num_shared_routines #= read2(!vwf_shared_routines_table_location)
				
				!temp_routine_no #= 0
				!temp_table_offset #= 2
				while !temp_routine_no < !vwf_num_shared_routines
					!temp_routine_name = ""
					
					while read1(!vwf_shared_routines_table_location+!temp_table_offset) != 0
						%vwf_add_char_to_label_name("temp_routine_name", read1(!vwf_shared_routines_table_location+!temp_table_offset))
					
						!temp_table_offset #= !temp_table_offset+1
					endif
					
					%vwf_define_shared_routine_label(!temp_routine_name, read3(!vwf_shared_routines_table_location+!temp_table_offset+1))
					!{vwf_shared_routine_!{temp_routine_name}_exists} = 1
					
					undef "temp_routine_name"
				
					!temp_table_offset #= !temp_table_offset+4
					!temp_routine_no #= !temp_routine_no+1
				endif
				undef "temp_routine_no"
				undef "temp_table_offset"
			else
				print "No FourCC detected at $",hex(!vwf_freecode_location-7),". Must either be a different patch, or an unknown version of VWF Dialogues."
			endif
		else
			print "No JML found at address $00A1DA. VWF Dialogues Patch is either not patched to this ROM, or is a version prior to v1.3."
		endif
	endmacro
	
	%vwf_parse_shared_routines()
	
	!vwf_shared_routines_parsed = 1
endif

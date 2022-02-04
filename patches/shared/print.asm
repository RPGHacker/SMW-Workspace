@asar 1.90

includeonce

incsrc "shared.asm"


; This file adds a print macro to Asar which can take macros as its arguments, which Asar's regular print command can't do.
; That way, you can use your own format specifiers in print commands.	


; Private section

{		
	; Called by %print_next() to chain arguments
	; For internal use only
	
	macro rs_print_next_internal(arg, arg_num)
		!rs_print_arg<arg_num> = ""
		<arg>
		!rs_print_all_args := "!rs_print_all_args!rs_print_arg<arg_num>"
	endmacro
	
	
	; Adds another argument to the argument list of %print()
	; For internal use only, use the !a define instead as described below
	
	macro rs_print_next(arg)
		%rs_print_next_internal(<arg>, !rs_print_arg_count)
		!rs_print_arg_count #= !rs_print_arg_count+1
	endmacro
	
	
	; Flushes a %print() command
	; For internal use only, use the !e define instead as described below
	
	macro rs_print_end()
		print !rs_print_all_args""
	endmacro
	
	
	
	; Called by %str() to chain arguments
	; For internal use only
	
	macro rs_str_internal(string_value, arg_num)
		!rs_print_arg<arg_num> = """<string_value>"","
	endmacro
	
	
	
	; Called by %int() to chain arguments
	; For internal use only
	
	macro rs_int_internal(int_value, arg_num)
		!rs_print_arg<arg_num> = "dec(<int_value>),"
	endmacro
	
	
	
	; Called by %hex() to chain arguments
	; For internal use only
	
	macro rs_hex_internal(hex_value, arg_num)
		!rs_print_arg<arg_num> = "hex(<hex_value>),"
	endmacro
	
	

	; Called by functions working with decimal numbers to get the fractional part
	; For internal use only
	
	macro rs_get_fractional_part_internal_recursive(decimal_number, decimal_places_start, decimal_places, out_var)
		!get_remaining_fractional_part = frac(<decimal_number>)*10
		!get_fractional_part_next_digit #= trunc(!get_remaining_fractional_part)
		
		if <decimal_places> > 0 && equal(!get_remaining_fractional_part, 0) == 0
			; We're not done yet and can add more decimal places
			!<out_var> := !<out_var>!get_fractional_part_next_digit
			%rs_get_fractional_part_internal_recursive(frac(<decimal_number>)*10, <decimal_places_start>, <decimal_places>-1, "<out_var>")
		else
			if <decimal_places> = 0 && equal(!get_remaining_fractional_part, 0) == 0
				; We're not done yet, but can't add more decimal places, so add "..."
				!<out_var> := "!<out_var>..."
			else
				; We're done and have no more decimal places to add
				if <decimal_places_start> == <decimal_places>
					; If we didn't add any decimal places at all, add a 0
					; Or rather just replace with 0, because it doesn't really make a difference and putting "!<out_var>0" here will just confuse Asar
					!<out_var> := "0"
				endif
			endif
		endif
	endmacro
	

	; Called by functions working with decimal numbers to get the fractional part
	; For internal use only
	
	macro rs_get_fractional_part_internal(decimal_number, decimal_places, out_var)
		%rs_get_fractional_part_internal_recursive(frac(<decimal_number>), <decimal_places>, <decimal_places>, <out_var>)
	endmacro
	
	
	; Called by %dec() and %f16() to chain arguments
	; For internal use only

	macro rs_dec_internal(decimal_number, decimal_places, arg_num)
		!rs_dec_internal_val = floor(abs(<decimal_number>))
		!rs_dec_internal_sign = ""
		
		if less(<decimal_number>, 0) == 1
			; Negative numbers
			!rs_dec_internal_sign = "-"
		endif
		
		!rs_dec_fractional_part = ""
		
		%rs_get_fractional_part_internal(abs(<decimal_number>), <decimal_places>, "rs_dec_fractional_part")
		
		!rs_print_arg<arg_num> = """!rs_dec_internal_sign"",dec(!rs_dec_internal_val),""."",""!rs_dec_fractional_part"","
	endmacro
}



; Public section

; Can be passed to %print() to add a string literal to the argument list

macro str(string_value)
	%rs_str_internal("<string_value>", !rs_print_arg_count)
endmacro



; Can be passed to %print() to add a decimal number cast to an integer to the argument list

macro int(int_value)
	%rs_int_internal(<int_value>, !rs_print_arg_count)
endmacro



; Can be passed to %print() to add a hexadecimal number to the argument list

macro hex(hex_value)
	%rs_hex_internal(<hex_value>, !rs_print_arg_count)
endmacro



; Can be passed to %print() to add a decimal number to the argument list
; Pass the maximum number of decimal places to print to decimal_places

macro dec(decimal_number, decimal_places)
	%rs_dec_internal(<decimal_number>, <decimal_places>, !rs_print_arg_count)
endmacro



; Can be passed to %print() to add a fixed point number to the argument list
; Pass the maximum number of decimal places to print to decimal_places

macro f16(fixed_representation, decimal_places)
	%rs_dec_internal(fixed_16_to_decimal(<fixed_representation>), <decimal_places>, !rs_print_arg_count)
endmacro



; Prints some text to the console using Asar's print command (which it's meant to replace)
; Unlike Asar's stand-alone print command, this version can also take macros as arguments
; As a trade-off, string literals and functions like dec() or hex() can't be passed to this function directly
; anymore and have to be wrapped in macros

; Usage:
; %print(%str("String literal") !e)

; Like with Asar's regular print command, you can also chain multiple arguments, using the following method:
; %print(%str("You walked ") !a %f16($1C0) !a %str(" miles!") !e)

macro print(arg)
	!rs_print_arg_count = 0
	!rs_print_all_args = ""
	
	%rs_print_next(<arg>)
endmacro



; A label used to add another argument to %print()

!a = ") : %rs_print_next("



; A label used to end the argument list passed to %print()

!e = ") : %rs_print_end("

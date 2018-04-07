@asar 1.50
@includefrom "../shared.asm"

; This file is included by shared.asm and should not be included directly

!shared_asm_included ?= 0

if !shared_asm_included == 0

	error "Trying to include 'print_implementation.asm' directly, which is meant to be included from 'shared.asm' only."
	
else

	; This file adds a print macro to Asar which can take macros as its arguments, which Asar's regular print command can't do
	; That way, you can use your own format specifiers in print commands

	!print_implementation_asm_included ?= 0

	if !print_implementation_asm_included == 0

		!print_implementation_asm_included = 1
		
	

		; Private section
		
		{		
			; Called by %print_next() to chain arguments
			; For internal use only
			
			macro print_next_internal(arg, arg_num)
				!print_arg<arg_num> = ""
				<arg>
				!print_all_args := "!print_all_args!print_arg<arg_num>"
			endmacro
			
			
			; Adds another argument to the argument list of %print()
			; For internal use only, use the !a define instead as described below
			
			macro print_next(arg)
				%print_next_internal(<arg>, !print_arg_count)
				!print_arg_count #= !print_arg_count+1
			endmacro
			
			
			; Flushes a %print() command
			; For internal use only, use the !e define instead as described below
			
			macro print_end()
				print !print_all_args""
			endmacro
			
			
			
			; Called by %str() to chain arguments
			; For internal use only
			
			macro str_internal(string_value, arg_num)
				!print_arg<arg_num> = """<string_value>"","
			endmacro
			
			
			
			; Called by %int() to chain arguments
			; For internal use only
			
			macro int_internal(int_value, arg_num)
				!print_arg<arg_num> = "dec(<int_value>),"
			endmacro
			
			
			
			; Called by %hex() to chain arguments
			; For internal use only
			
			macro hex_internal(hex_value, arg_num)
				!print_arg<arg_num> = "hex(<hex_value>),"
			endmacro
			
			
		
			; Called by functions working with decimal numbers to get the fractional part
			; For internal use only
			
			macro get_fractional_part_internal_recursive(decimal_number, decimal_places_start, decimal_places, out_var)
				!get_remaining_fractional_part = frac(<decimal_number>)*10
				!get_fractional_part_next_digit #= trunc(!get_remaining_fractional_part)
				
				if <decimal_places> > 0 && equal(!get_remaining_fractional_part, 0) == 0
					; We're not done yet and can add more decimal places
					!<out_var> := !<out_var>!get_fractional_part_next_digit
					%get_fractional_part_internal_recursive(frac(<decimal_number>)*10, <decimal_places_start>, <decimal_places>-1, "<out_var>")
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
			
			macro get_fractional_part_internal(decimal_number, decimal_places, out_var)
				%get_fractional_part_internal_recursive(frac(<decimal_number>), <decimal_places>, <decimal_places>, <out_var>)
			endmacro
			
			
			; Called by %dec() and %f16() to chain arguments
			; For internal use only
		
			macro dec_internal(decimal_number, decimal_places, arg_num)
				!dec_internal_val = floor(abs(<decimal_number>))
				!dec_internal_sign = ""
				
				if less(<decimal_number>, 0) == 1
					; Negative numbers
					!dec_internal_sign = "-"
				endif
				
				!dec_fractional_part = ""
				
				%get_fractional_part_internal(abs(<decimal_number>), <decimal_places>, "dec_fractional_part")
				
				!print_arg<arg_num> = """!dec_internal_sign"",dec(!dec_internal_val),""."",""!dec_fractional_part"","
			endmacro
		}
		
		
		
		; Public section
		
		; Can be passed to %print() to add a string literal to the argument list
		
		macro str(string_value)
			%str_internal("<string_value>", !print_arg_count)
		endmacro
		
		
		
		; Can be passed to %print() to add a decimal number cast to an integer to the argument list
		
		macro int(int_value)
			%int_internal(<int_value>, !print_arg_count)
		endmacro
		
		
		
		; Can be passed to %print() to add a hexadecimal number to the argument list
		
		macro hex(hex_value)
			%hex_internal(<hex_value>, !print_arg_count)
		endmacro
	

		
		; Can be passed to %print() to add a decimal number to the argument list
		; Pass the maximum number of decimal places to print to decimal_places
		
		macro dec(decimal_number, decimal_places)
			%dec_internal(<decimal_number>, <decimal_places>, !print_arg_count)
		endmacro
	

		
		; Can be passed to %print() to add a fixed point number to the argument list
		; Pass the maximum number of decimal places to print to decimal_places
		
		macro f16(fixed_representation, decimal_places)
			%dec_internal(fixed_16_to_decimal(<fixed_representation>), <decimal_places>, !print_arg_count)
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
			!print_arg_count = 0
			!print_all_args = ""
			
			%print_next(<arg>)
		endmacro
		
		
		
		; A label used to add another argument to %print()
		
		!a = ") : %print_next("
		
		
		
		; A label used to end the argument list passed to %print()
		
		!e = ") : %print_end("
	
	endif
	
endif

@asar 1.90

includeonce

; !shared_asm_included is the old include guard, but I'm keeping it here because
; included files also check for its existence to generate errors.
	
; This file contains a bunch of useful helper functions for Asar.

!shared_asm_included ?= 0

if !shared_asm_included == 0

	!shared_asm_included = 1
	


	; Private section
		
	{	
		; Check if we're in a SuperFX or SA-1 ROM.
		; If so, enable the respective mapping.
	
		!use_sa1_mapping = 0
		!use_sfx_mapping = 0
		!disable_fastrom_remap ?= 0			; Using ?= here so that someone can disable it from the outside if they desire so.
		
		!num_sprite_table_slots = 12		; The number of sprite slots available (12 in regular or SuperFX ROM, 22 in SA-1 ROM).
		
		if read1($00FFD5) == $23
			!use_sa1_mapping = 1
			
			!num_sprite_table_slots = 22
			
			sa1rom
		elseif read1($00FFD6) > $02 && read1($00FFD6)&$F0 == $10
			!use_sfx_mapping = 1
			
			sfxrom
		endif
		
		!disable_fastrom_remap #= or(!disable_fastrom_remap,or(!use_sa1_mapping,!use_sfx_mapping))
	}
	
	
	
	; Public section	
	
	
	; Returns the absolute value of value.
	
	function abs(value) = select(less(value, 0), value*-1, value)
	
	
	; Returns 1 if value > 0, -1 if value < 0 and 0 otherwise.
	
	function sign(value) = value/abs(select(value, value, 1))
	
	
	
	; Private section
	
	{	
		; Remaps address to new_base if range_start <= address <= range_end.
		; For internal use only.
		
		function remap_range(address, range_start, range_end, new_base) = select(greaterequal(address, range_start), select(lessequal(address, range_end), address-range_start+new_base, address), address)
	}
	
	
	; Private section
	
	{
		; Defines a sprite table remap. To be passed to %define_remapping_functions().
		; For internal use only.
		
		macro define_sprite_table_remap(old_address, new_address)			
			; Also add a 16-bit remap where applicaple.
			if <old_address> > $FFFF && <new_address> <= $FFFF
				!temp_sprite_remap_function_term := "remap_range(!temp_sprite_remap_function_term, <old_address>&$FFFF, (<old_address>+11)&$FFFF, <new_address>)"
				!temp_remap_function_term := "remap_range(!temp_remap_function_term, <old_address>&$FFFF, (<old_address>+11)&$FFFF, <new_address>)"
			endif
			
			!temp_sprite_remap_function_term := "remap_range(!temp_sprite_remap_function_term, <old_address>, <old_address>+11, <new_address>)"
			!temp_remap_function_term := "remap_range(!temp_remap_function_term, <old_address>, <old_address>+11, <new_address>)"
		endmacro
		
		
		; Defines a general RAM remap. To be passed to %define_remapping_functions().
		; For internal use only.
		
		macro define_ram_remap_range(old_start_address, old_end_address, new_address)			
			; Also add a 16-bit remap where applicaple.
			if <old_start_address> > $FFFF && <new_address> <= $FFFF
				!temp_remap_function_term := "remap_range(!temp_remap_function_term, <old_start_address>&$FFFF, <old_end_address>&$FFFF, <new_address>)"
			endif
			
			!temp_remap_function_term := "remap_range(!temp_remap_function_term, <old_start_address>, <old_end_address>, <new_address>)"
		endmacro
		
		
		; Defines RAM the functions remap_ram() and remap_sprite_table_ram(). Pass in the macros above
		; to define which addresses get remapped.
		; For internal use only.
		
		macro define_remapping_functions(...)
			!temp_sprite_remap_function_term = "address"
			!temp_remap_function_term = "address"
			
			!temp_i = 0
			while !temp_i < sizeof(...)
				<!temp_i>				
				!temp_i #= !temp_i+1
			endwhile
			undef "temp_i"
			
			function remap_sprite_table_ram(address) = !temp_sprite_remap_function_term
			function remap_ram(address) = !temp_remap_function_term
			
			undef "temp_sprite_remap_function_term"
			undef "temp_remap_function_term"
		endmacro
		
		
		
		if !use_sa1_mapping
			%define_remapping_functions(\
				%define_sprite_table_remap($7E009E, $3200),\	; Sprite table remaps need to be defined first, because they have some overlaps with the default ranges below.
				%define_sprite_table_remap($7E00AA, $309E),\
				%define_sprite_table_remap($7E00B6, $30B6),\
				%define_sprite_table_remap($7E00C2, $30D8),\
				%define_sprite_table_remap($7E00D8, $3216),\
				%define_sprite_table_remap($7E00E4, $322C),\
				%define_sprite_table_remap($7E14C8, $3242),\
				%define_sprite_table_remap($7E14D4, $3258),\
				%define_sprite_table_remap($7E14E0, $326E),\
				%define_sprite_table_remap($7E14EC, $74C8),\
				%define_sprite_table_remap($7E14F8, $74DE),\
				%define_sprite_table_remap($7E1504, $74F4),\
				%define_sprite_table_remap($7E1510, $750A),\
				%define_sprite_table_remap($7E151C, $3284),\
				%define_sprite_table_remap($7E1528, $329A),\
				%define_sprite_table_remap($7E1534, $32B0),\
				%define_sprite_table_remap($7E1540, $32C6),\
				%define_sprite_table_remap($7E154C, $32DC),\
				%define_sprite_table_remap($7E1558, $32F2),\
				%define_sprite_table_remap($7E1564, $3308),\
				%define_sprite_table_remap($7E1570, $331E),\
				%define_sprite_table_remap($7E157C, $3334),\
				%define_sprite_table_remap($7E1588, $334A),\
				%define_sprite_table_remap($7E1594, $3360),\
				%define_sprite_table_remap($7E15A0, $3376),\
				%define_sprite_table_remap($7E15AC, $338C),\
				%define_sprite_table_remap($7E15B8, $7520),\
				%define_sprite_table_remap($7E15C4, $7536),\
				%define_sprite_table_remap($7E15D0, $754C),\
				%define_sprite_table_remap($7E15DC, $7562),\
				%define_sprite_table_remap($7E15EA, $33A2),\
				%define_sprite_table_remap($7E15F6, $33B8),\
				%define_sprite_table_remap($7E1602, $33CE),\
				%define_sprite_table_remap($7E160E, $33E4),\
				%define_sprite_table_remap($7E161A, $7578),\
				%define_sprite_table_remap($7E1626, $758E),\
				%define_sprite_table_remap($7E1632, $75A4),\
				%define_sprite_table_remap($7E163E, $33FA),\
				%define_sprite_table_remap($7E187B, $3410),\
				%define_sprite_table_remap($7E190F, $7658),\
				%define_sprite_table_remap($7E1FD6, $766E),\
				%define_sprite_table_remap($7E1FE2, $7FD6),\
				%define_sprite_table_remap($7E164A, $75BA),\
				%define_sprite_table_remap($7E1656, $75D0),\
				%define_sprite_table_remap($7E1662, $75EA),\
				%define_sprite_table_remap($7E166E, $7600),\
				%define_sprite_table_remap($7E167A, $7616),\
				%define_sprite_table_remap($7E1686, $762C),\
				%define_sprite_table_remap($7E186C, $7642),\
				%define_sprite_table_remap($7FAB10, $6040),\
				%define_sprite_table_remap($7FAB1C, $6056),\
				%define_sprite_table_remap($7FAB28, $6057),\
				%define_sprite_table_remap($7FAB34, $606D),\
				%define_sprite_table_remap($7FAB9E, $6083),\
				%define_ram_remap_range($700000, $7007FF, $41C000),\
				%define_ram_remap_range($700800, $7027FF, $41A000),\
				%define_ram_remap_range($7E0000, $7E00FF,   $3000),\
				%define_ram_remap_range(  $0100,   $1FFF,   $6100),\	; NOTE: Different remaps for 16-bit and 24-bit addressing.
				%define_ram_remap_range($7E0100, $7E1FFF, $400100),\
				%define_ram_remap_range($7E1938, $7E19B7, $418A00),\
				%define_ram_remap_range($7EC800, $7EFFFF, $40C800),\
				%define_ram_remap_range($7F9A7B, $7F9C7A, $418800),\
				%define_ram_remap_range($7FC800, $7FFFFF, $41C800),\
			)			
		elseif !use_sfx_mapping
			; Are these SuperFX remaps still correct?
			; Does a functioning SuperFX kit even still exist at this time?
			%define_remapping_functions(\
				%define_ram_remap_range(  $0000,   $1FFF,   $6000),\
				%define_ram_remap_range($7EC800, $7EFFFF, $70C800),\
				%define_ram_remap_range($7FC800, $7FFFFF, $71C800),\
			)
		else
			%define_remapping_functions()
		endif
	}
	
	
	
	; Public section
	
	; Maps a RAM address correctly, depending on whether we need SA-1/SuperFX mapping or not.
	; NOTE: Actual function is defined by macros above.
	
	; function remap_ram(address) = address
	
	
	; Same as above, but only remaps sprite table RAM.
	; NOTE: Actual function is defined by macros above.
	
	; function remap_sprite_table_ram(address) = address
	
	
	
	; Maps a ROM address correctly, depending on whether we need SA-1/SuperFX mapping or not.
	; NOTE: This doesn't work in conjunction with autoclean, because autoclean is lazy and just treats the function as a label instead of resolving it.
	
	function remap_rom(address) = address|select(!disable_fastrom_remap, $000000, $800000)
	
	
	
	; Maps a ROM bank correctly, depending on whether we need SA-1/SuperFX mapping or not.
	
	function remap_rom_bank(bankbyte) = bankbyte|select(!disable_fastrom_remap, $00, $80)
	
	
	
	
	
	; Returns the truncated value of a decimal number.
	; Note that pure unsigned int conversion acts weirdly on most negative numbers here, which is why we actually need the select().
	
	function trunc(decimal_number) = select(less(decimal_number, 0), -(abs(decimal_number)|0), decimal_number|0)
	
	
	; Returns the fractional part of a decimal number.
	; This originally used (decimal_number%1) internally, but that ended up being ridiculously inaccurate in some cases.
	; This version actually seems to work better in those cases, so I hope it's also the overall better solution.
	
	function frac(decimal_number) = decimal_number-trunc(decimal_number)
	
	
	
	; Now some helper functions for working with fixed point values (as used by mode 7, for example).
	
	; Private section
	
	{
		; Converts a positive 16-bit fixed point representation to a decimal number.
		; For internal use only.
		
		function fixed_16_to_decimal_positive(fixed_representation) = ((fixed_representation&$FF00)>>8)+((fixed_representation&$FF)/$100)
	}
	
	
	
	; Public section	
	
	; Converts a decimal number to a 16-bit signed fixed point representation (such as used by mode 7).
	
	function decimal_to_fixed_16(decimal_number) = (min(round((clamp(decimal_number, -128, 128)+128)*$100, 0)|0, $FFFF)+$8000)&$FFFF
	
	
	; Converts a 16-bit fixed point representation to a decimal number.
	
	function fixed_16_to_decimal(fixed_representation) = fixed_16_to_decimal_positive(select(less(fixed_representation, $8000), fixed_representation, (fixed_representation-1)^$FFFF))*select(less(fixed_representation, $8000), 1, -1)
	
	
	; Converts a decimal number to a 13-bit signed int (such as used by mode 7).
	
	function decimal_to_int_13(decimal_number) = (((clamp(decimal_number, -4096, 4095)&$80000000)>>19)&$1000)|(clamp(decimal_number, -4096, 4095)&$0FFF)
	
	
	
	
	
	; Some accurate PI representation, always useful.
	
	!math_pi = 3.14159265358979323846264338327950288419716939937510582
	
	
	
	; Converts degrees to radians.
	
	function deg_to_rad(angle_in_degress) = (angle_in_degress*!math_pi)/180
	
	
	; Converts radians to degrees.
	
	function rad_to_deg(angle_in_radians) = (angle_in_radians*180)/!math_pi
	
	
	
	; Resolves to "stz address" if address lies in an address range supported by stz and otherwise to "lda #$00 : sta address".
	
	macro sta_zero_or_stz(address)
		if less(<address>, $010000)
			stz <address>		
		else
			lda #$00
			sta <address>
		endif
	endmacro
	
	
	; Resolves to "inc address" if address lies in an address range supported by inc and otherwise to "lda #$01 : sta address".
	
	macro sta_one_or_inc(address)
		if less(<address>, $010000)
			inc <address>		
		else
			lda #$01
			sta <address>
		endif
	endmacro
	
	
	
	; Includes
	
	incsrc includes/print_implementation.asm
	incsrc includes/ram_getters.asm
		
endif

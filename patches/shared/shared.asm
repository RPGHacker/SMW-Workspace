asar 1.90

includeonce

	
; This file contains a bunch of useful helper functions for Asar.
	
	
; Public section

; Potentially dangerous label definitions.
; Could cause "label redefinition" errors if any patch including this also defines these.
false  = 0
true   = 1


!use_sa1_mapping = false
!use_sfx_mapping = false
!disable_fastrom_remap ?= false  ; Using ?= here so that someone can disable it from the outside if they desire so.



; Private section
	
{	
	; Check if we're in a SuperFX or SA-1 ROM.
	; If so, enable the respective mapping.
	
	!num_sprite_table_slots = 12     ; The number of sprite slots available (12 in regular or SuperFX ROM, 22 in SA-1 ROM).
	
	if read1($00FFD5) == $23
		!use_sa1_mapping = true
		
		!num_sprite_table_slots = 22
		
		sa1rom
	elseif read1($00FFD6) > $02 && read1($00FFD6)&$F0 == $10
		!use_sfx_mapping = true
		
		sfxrom
	endif
	
	!disable_fastrom_remap #= or(!disable_fastrom_remap,or(!use_sa1_mapping,!use_sfx_mapping))
}



; Public section

; A macro that abuses structs to define enums.

macro define_enum(name, ...)
	if sizeof(...) > 0
		!enum_<name>_first = <name>.<...[0]>
		!enum_<name>_last = <name>.<...[sizeof(...)-1]>
	
		struct <name> $000000
			.First:
			
			!temp_i #= 0
			while !temp_i < sizeof(...)
				if !temp_i == sizeof(...)-1
					.Last:
				endif
				
				.<...[!temp_i]>: skip 1
				
				!temp_i #= !temp_i+1
			endwhile
			undef "temp_i"
			
			.Count:
		endstruct
	else
		error "Enums must have at least a single value."
	endif
endmacro



; Same as above, but every second argument is a value to map to the previous enum key.
; Example: %define_enum_with_values(Number, One, 1, Two, 2, Three, 3)

macro define_enum_with_values(name, ...)
	if sizeof(...) > 0 && sizeof(...)&$01 == 0
		!enum_<name>_first = <name>.<...[0]>
		!enum_<name>_last = <name>.<...[sizeof(...)-2]>
	
		struct <name> $000000
			.First:
			
			!temp_i #= 0
			!temp_prev #= 0
			while !temp_i < sizeof(...)
				if <...[!temp_i+1]> < 0
					error "Enums currently don't support negative values."
				endif
			
				; This code here mainly serves the purpose of avoiding negative or zero skips.
				; Although they might not be a problem per se, but I don't want to rely on
				; Asar always supporting them.
				if <...[!temp_i+1]> < !temp_prev
					error "Enum values must be ordered sequentially.".
				endif
				
				if <...[!temp_i+1]> != !temp_prev
					skip <...[!temp_i+1]>-!temp_prev
					!temp_prev #= <...[!temp_i+1]>
				endif
				
				if !temp_i == sizeof(...)-2
					.Last:
				endif
				
				.<...[!temp_i]>:
				
				!temp_i #= !temp_i+2
			endwhile
			undef "temp_i"
			undef "temp_prev"
			
			.Count:
		endstruct
	else
		; Once again, nested if, because elseif is broken.
		if sizeof(...)&$01 != 0
			error "Number of variadic arguments must be divisble by 2."
		else
			error "Enums must have at least a single value."
		endif
	endif
endmacro




; A bunch of general helpers for doing DMA transfers below.

; DMA registers

struct DMA_Regs $4300
    .Control: skip 1		; $43x0
    .Destination: skip 1	; $43x1
    .Source_Address:		; $43x2 - $43x4
		.Source_Address_Word:
			.Source_Address_Low: skip 1
			.Source_Address_High: skip 1
		.Source_Address_Bank: skip 1
    .Size:					; $43x5 - $43x7
		.Size_Word:
			.Size_Low: skip 1
			.Size_High: skip 1
		skip 1	; $43x7 used by HDMA only
endstruct align $10


; Defines possible values to pass to %dma_transfer() as dma_settings.

%define_enum_with_values(DmaMode, WriteOnce, %00000001, WriteTwice, %00000010, ReadOnce, %10000001, ReadTwice, %10000010)


; Defines possible values to pass to %configure_vram_access() as access_mode.

%define_enum(VRamAccessMode, Read, Write)


; Defines possible values to pass to %configure_vram_access() as increment_mode.
; OnLowByte: Increment VRAM address after accessing low byte.
; OnHighByte: Increment VRAM address after acessing high byte.

%define_enum_with_values(VRamIncrementMode, OnLowByte, %00000000, OnHighByte, %10000000)


; Defines possible values to pass to %configure_vram_access() as increment_size.

%define_enum_with_values(VRamIncrementSize, 1Byte, %00000000, 32Bytes, %00000001, 128Bytes, %00000010)


; Defines possible values to pass to %configure_vram_access() as address_remap.
; Currently only a single value, because I don't use this for anything yet and have no idea
; what to name the remaining values.

%define_enum_with_values(VRamAddressRemap, None, %00000000)


; Helper function for %dma_transfer() to signify that the source address is an indirect one
; (i.e., is pointing to the actual source address to use).

function dma_source_indirect(address) = $01000000|(address&$FFFFFF)


; Same as dma_source_indirect(), but where source address only points to a 16-bit address and
; we want to use a hard-coded bank byte.

function dma_source_indirect_word(address, bank) = ((bank&$FF)<<24)|(address&$FFFFFF)


; Helper function for %dma_transfer() to signify that the num_bytes passed in is actually
; a RAM address that contains the number of bytes.

function dma_size_indirect(address) = $01000000|(address&$FFFFFF)


; A simple macro for preparing access to VRAM.

macro configure_vram_access(access_mode, increment_mode, increment_size, address_remap, vram_address)
	lda.b #<increment_mode>|<increment_size>|<address_remap>
	sta $2115
	
	rep #$20
	lda <vram_address>
	sta $2116
	
	if <access_mode> == VRamAccessMode.Read && <increment_mode> == VRamIncrementMode.OnHighByte
		lda $2139
	endif
	
	sep #$20
	
	if <access_mode> == VRamAccessMode.Read && <increment_mode> == VRamIncrementMode.OnLowByte
		lda $2139
		lda $213A
	endif
endmacro


; A simple helper macro that will cover most cases of DMA transfers.
; Either pass in the source address directly, or use the helper functions above to pass an indirect source address.

macro dma_transfer(channel, dma_settings, destination, source, num_bytes)
	assert <channel> >= 0 && <channel> <= 7,"%dma_transfer() channel parameter must be a value between 0 and 7. Current: <channel>"
	
	assert <destination> >= $2100 && <destination> <= $21FF, "Invalid destination passed to %dma_transfer(): <destination>. Must be a PPU register between $2100 and $21FF."
	
	!temp_source_resolved #= <source>
	!temp_dma_source_address_mode #= ((!temp_source_resolved>>24)&$FF)
	
	!temp_source_without_header #= !temp_source_resolved&$FFFFFF
	
	if !temp_dma_source_address_mode == 0
		!temp_dma_source_low = "lda.b #!temp_source_without_header"
		!temp_dma_source_high = "lda.b #!temp_source_without_header>>8"
		!temp_dma_source_bank = "lda.b #!temp_source_without_header>>16"
	elseif !temp_dma_source_address_mode == 1
		!temp_dma_source_low = "lda !temp_source_without_header"
		!temp_dma_source_high = "lda !temp_source_without_header+1"
		!temp_dma_source_bank = "lda !temp_source_without_header+2"
	else
		!temp_dma_source_low = "lda !temp_source_without_header"
		!temp_dma_source_high = "lda !temp_source_without_header+1"
		!temp_dma_source_bank = "lda.b #!temp_dma_source_address_mode"
	endif
	
	!temp_num_bytes_resolved #= <num_bytes>
	!temp_dma_num_bytes_mode #= ((!temp_num_bytes_resolved>>24)&$FF)
	
	assert !temp_dma_num_bytes_mode <= 1, "Invalid argument passed to num_bytes of %dma_transfer()."
	
	if !temp_dma_num_bytes_mode == 0	
		!temp_dma_num_bytes = "lda.w #<num_bytes>"
	elseif !temp_dma_num_bytes_mode == 1
		!temp_dma_num_bytes = "lda <num_bytes>"
	endif

	lda.b #<dma_settings>
	sta.w DMA_Regs[<channel>].Control
	lda.b #<destination>
	sta.w DMA_Regs[<channel>].Destination
	!temp_dma_source_low
	sta.w DMA_Regs[<channel>].Source_Address_Low
	!temp_dma_source_high
	sta.w DMA_Regs[<channel>].Source_Address_High
	!temp_dma_source_bank
	sta.w DMA_Regs[<channel>].Source_Address_Bank
	rep #$20
	!temp_dma_num_bytes
	sta.w DMA_Regs[<channel>].Size_Word
	sep #$20
	lda.b #(1<<<channel>)
	sta $420B
	
	undef "temp_source_resolved"
	undef "temp_dma_source_address_mode"
	undef "temp_source_without_header"
	undef "temp_dma_source_low"
	undef "temp_dma_source_high"
	undef "temp_dma_source_bank"
	undef "temp_num_bytes_resolved"
	undef "temp_dma_num_bytes_mode"
	undef "temp_dma_num_bytes"
endmacro



; Returns the absolute value of value.

function abs(value) = select(less(value, 0), value*-1, value)


; Returns 1 if value > 0, -1 if value < 0 and 0 otherwise.

function sign(value) = value/abs(select(value, value, 1))



; Private section

{	
	; Remaps address to new_base if range_start <= address <= range_end.
	; For internal use only.
	
	function rs_remap_range(address, range_start, range_end, new_base) = select(greaterequal(address, range_start), select(lessequal(address, range_end), address-range_start+new_base, address), address)
}


; Private section

{
	; Defines a sprite table remap. To be passed to %rs_define_remapping_functions().
	; For internal use only.
	
	macro rs_define_sprite_table_remap(old_address, new_address)			
		; Also add a 16-bit remap where applicaple.
		if <old_address> > $FFFF && <new_address> <= $FFFF
			!temp_sprite_remap_function_term := "rs_remap_range(!temp_sprite_remap_function_term, <old_address>&$FFFF, (<old_address>+11)&$FFFF, <new_address>)"
			!temp_remap_function_term := "rs_remap_range(!temp_remap_function_term, <old_address>&$FFFF, (<old_address>+11)&$FFFF, <new_address>)"
		endif
		
		!temp_sprite_remap_function_term := "rs_remap_range(!temp_sprite_remap_function_term, <old_address>, <old_address>+11, <new_address>)"
		!temp_remap_function_term := "rs_remap_range(!temp_remap_function_term, <old_address>, <old_address>+11, <new_address>)"
	endmacro
	
	
	; Defines a general RAM remap. To be passed to %rs_define_remapping_functions().
	; For internal use only.
	
	macro rs_define_ram_rs_remap_range(old_start_address, old_end_address, new_address)			
		; Also add a 16-bit remap where applicaple.
		if <old_start_address> > $FFFF && <new_address> <= $FFFF
			!temp_remap_function_term := "rs_remap_range(!temp_remap_function_term, <old_start_address>&$FFFF, <old_end_address>&$FFFF, <new_address>)"
		endif
		
		!temp_remap_function_term := "rs_remap_range(!temp_remap_function_term, <old_start_address>, <old_end_address>, <new_address>)"
	endmacro
	
	
	; Defines RAM the functions remap_ram() and remap_sprite_table_ram(). Pass in the macros above
	; to define which addresses get remapped.
	; For internal use only.
	
	macro rs_define_remapping_functions(...)
		!temp_sprite_remap_function_term = "address"
		!temp_remap_function_term = "address"
		
		!temp_i = 0
		while !temp_i < sizeof(...)
			<...[!temp_i]>				
			!temp_i #= !temp_i+1
		endwhile
		undef "temp_i"
		
		function remap_sprite_table_ram(address) = !temp_sprite_remap_function_term
		function remap_ram(address) = !temp_remap_function_term
		
		undef "temp_sprite_remap_function_term"
		undef "temp_remap_function_term"
	endmacro
	
	
	
	if !use_sa1_mapping
		%rs_define_remapping_functions(\
			%rs_define_sprite_table_remap($7E009E, $3200),\	; Sprite table remaps need to be defined first, because they have some overlaps with the default ranges below.
			%rs_define_sprite_table_remap($7E00AA, $309E),\
			%rs_define_sprite_table_remap($7E00B6, $30B6),\
			%rs_define_sprite_table_remap($7E00C2, $30D8),\
			%rs_define_sprite_table_remap($7E00D8, $3216),\
			%rs_define_sprite_table_remap($7E00E4, $322C),\
			%rs_define_sprite_table_remap($7E14C8, $3242),\
			%rs_define_sprite_table_remap($7E14D4, $3258),\
			%rs_define_sprite_table_remap($7E14E0, $326E),\
			%rs_define_sprite_table_remap($7E14EC, $74C8),\
			%rs_define_sprite_table_remap($7E14F8, $74DE),\
			%rs_define_sprite_table_remap($7E1504, $74F4),\
			%rs_define_sprite_table_remap($7E1510, $750A),\
			%rs_define_sprite_table_remap($7E151C, $3284),\
			%rs_define_sprite_table_remap($7E1528, $329A),\
			%rs_define_sprite_table_remap($7E1534, $32B0),\
			%rs_define_sprite_table_remap($7E1540, $32C6),\
			%rs_define_sprite_table_remap($7E154C, $32DC),\
			%rs_define_sprite_table_remap($7E1558, $32F2),\
			%rs_define_sprite_table_remap($7E1564, $3308),\
			%rs_define_sprite_table_remap($7E1570, $331E),\
			%rs_define_sprite_table_remap($7E157C, $3334),\
			%rs_define_sprite_table_remap($7E1588, $334A),\
			%rs_define_sprite_table_remap($7E1594, $3360),\
			%rs_define_sprite_table_remap($7E15A0, $3376),\
			%rs_define_sprite_table_remap($7E15AC, $338C),\
			%rs_define_sprite_table_remap($7E15B8, $7520),\
			%rs_define_sprite_table_remap($7E15C4, $7536),\
			%rs_define_sprite_table_remap($7E15D0, $754C),\
			%rs_define_sprite_table_remap($7E15DC, $7562),\
			%rs_define_sprite_table_remap($7E15EA, $33A2),\
			%rs_define_sprite_table_remap($7E15F6, $33B8),\
			%rs_define_sprite_table_remap($7E1602, $33CE),\
			%rs_define_sprite_table_remap($7E160E, $33E4),\
			%rs_define_sprite_table_remap($7E161A, $7578),\
			%rs_define_sprite_table_remap($7E1626, $758E),\
			%rs_define_sprite_table_remap($7E1632, $75A4),\
			%rs_define_sprite_table_remap($7E163E, $33FA),\
			%rs_define_sprite_table_remap($7E187B, $3410),\
			%rs_define_sprite_table_remap($7E190F, $7658),\
			%rs_define_sprite_table_remap($7E1FD6, $766E),\
			%rs_define_sprite_table_remap($7E1FE2, $7FD6),\
			%rs_define_sprite_table_remap($7E164A, $75BA),\
			%rs_define_sprite_table_remap($7E1656, $75D0),\
			%rs_define_sprite_table_remap($7E1662, $75EA),\
			%rs_define_sprite_table_remap($7E166E, $7600),\
			%rs_define_sprite_table_remap($7E167A, $7616),\
			%rs_define_sprite_table_remap($7E1686, $762C),\
			%rs_define_sprite_table_remap($7E186C, $7642),\
			%rs_define_sprite_table_remap($7FAB10, $6040),\
			%rs_define_sprite_table_remap($7FAB1C, $6056),\
			%rs_define_sprite_table_remap($7FAB28, $6057),\
			%rs_define_sprite_table_remap($7FAB34, $606D),\
			%rs_define_sprite_table_remap($7FAB9E, $6083),\
			%rs_define_ram_rs_remap_range($700000, $7007FF, $41C000),\
			%rs_define_ram_rs_remap_range($700800, $7027FF, $41A000),\
			%rs_define_ram_rs_remap_range($7E0000, $7E00FF,   $3000),\
			%rs_define_ram_rs_remap_range(  $0100,   $1FFF,   $6100),\	; NOTE: Different remaps for 16-bit and 24-bit addressing.
			%rs_define_ram_rs_remap_range($7E0100, $7E1FFF, $400100),\
			%rs_define_ram_rs_remap_range($7E1938, $7E19B7, $418A00),\
			%rs_define_ram_rs_remap_range($7EC800, $7EFFFF, $40C800),\
			%rs_define_ram_rs_remap_range($7F9A7B, $7F9C7A, $418800),\
			%rs_define_ram_rs_remap_range($7FC800, $7FFFFF, $41C800),\
		)			
	elseif !use_sfx_mapping
		; Are these SuperFX remaps still correct?
		; Does a functioning SuperFX kit even still exist at this time?
		%rs_define_remapping_functions(\
			%rs_define_ram_rs_remap_range(  $0000,   $1FFF,   $6000),\
			%rs_define_ram_rs_remap_range($7EC800, $7EFFFF, $70C800),\
			%rs_define_ram_rs_remap_range($7FC800, $7FFFFF, $71C800),\
		)
	else
		%rs_define_remapping_functions()
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
; RPG Hacker: This implementation is old. There's probably a better way to do this in current Asar versins usings round().

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
	
	function rs_fixed_16_to_decimal_positive(fixed_representation) = ((fixed_representation&$FF00)>>8)+((fixed_representation&$FF)/$100)
}



; Public section	

; Converts a decimal number to a 16-bit signed fixed point representation (such as used by mode 7).

function decimal_to_fixed_16(decimal_number) = (min(round((clamp(decimal_number, -128, 128)+128)*$100, 0)|0, $FFFF)+$8000)&$FFFF


; Converts a 16-bit fixed point representation to a decimal number.

function fixed_16_to_decimal(fixed_representation) = rs_fixed_16_to_decimal_positive(select(less(fixed_representation, $8000), fixed_representation, (fixed_representation-1)^$FFFF))*select(less(fixed_representation, $8000), 1, -1)


; Converts a decimal number to a 13-bit signed int (such as used by mode 7).

function decimal_to_int_13(decimal_number) = (((clamp(decimal_number, -4096, 4095)&$80000000)>>19)&$1000)|(clamp(decimal_number, -4096, 4095)&$0FFF)





; Some accurate PI representation, always useful.

!math_pi = 3.14159265358979323846264338327950288419716939937510582



; Converts degrees to radians.

function deg_to_rad(angle_in_degress) = (angle_in_degress*!math_pi)/180


; Converts radians to degrees.

function rad_to_deg(angle_in_radians) = (angle_in_radians*180)/!math_pi



; Resolves to "stz address" if address lies in an address range supported by stz and otherwise to "lda #$00 : sta address".
; NOTE: Not a perfect solution, because it can't take label optimizations into account.

macro sta_zero_or_stz(address)
	if less(<address>, $010000)
		stz <address>		
	else
		lda #$00
		sta <address>
	endif
endmacro


; Resolves to "inc address" if address lies in an address range supported by inc and otherwise to "lda #$01 : sta address".
; NOTE: Not a perfect solution, because it can't take label optimizations into account.

macro sta_one_or_inc(address)
	if less(<address>, $010000)
		inc <address>		
	else
		lda #$01
		sta <address>
	endif
endmacro



; Misc color functions


; Creates an RGB15 16-bit value from the three different colors channels. Each channel value can be in the range of 0 to 31.

function rgb_15(red, green, blue) = (red&%11111)|((green&%11111)<<5)|((blue&%11111)<<10)

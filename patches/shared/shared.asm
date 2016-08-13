@asar 1.37

; Using !shared_asm_included as an include guard here so that this file can be
; included from multiple source files at once without causing redefinitions

!shared_asm_included ?= 0

if !shared_asm_included == 0

	; Check if we're in an SA-1 ROM
	; If so, enable SA-1 mapping

	!use_sa1_mapping = 0
	
	if read1($00FFD5) == $23
		!use_sa1_mapping = 1
		
		sa1rom
	endif
	
	
	
	
	; Helper functions
	; Big thanks to Alcaro for helping with some these
	

	
	; Returns 1 if value >= 0 and 0 otherwise
	
	function gr_equ_zero(value) = 1-(value>>31)
	
	
	
	; Returns false if statement == 0 and true otherwise
	
	function select(statement, true, false) = false+((true-false)*gr_equ_zero(statement-1))
	

	
	; Returns 1 if value == 0 and 0 otherwise
	
	function not(value) = cos(value)|0
	
	
	; Returns 1 if val_a == val_b and 0 otherwise
	
	function equal(val_a, val_b) = not(val_a-val_b)
	
	
	
	; Returns 1 if val_a < val_b and 0 otherwise
	
	function less(val_a, val_b) = 1-gr_equ_zero(val_a-val_b)
	
	
	; Returns 1 if val_a > val_b and 0 otherwise
	
	function greater(val_a, val_b) = 1-gr_equ_zero(val_b-val_a)
	
	
	; Returns 1 if val_a <= val_b and 0 otherwise
	
	function less_equal(val_a, val_b) = 1-gr_equ_zero(val_a-val_b-1)
	
	
	; Returns 1 if val_a >= val_b and 0 otherwise
	
	function greater_equal(val_a, val_b) = 1-gr_equ_zero(val_b-val_a-1)
	
	
	
	; Remaps address to new_base if range_start <= address <= range_end
	
	function remap_range(address, range_start, range_end, new_base) = select(greater_equal(address, range_start), select(less_equal(address, range_end), address-range_start+new_base, address), address)
	
	
	; Remaps address to new_base if address == comparand
	
	function remap_address(address, comparand, new_base) = remap_range(address, comparand, comparand, new_base)
	
	
	
	; Maps a RAM address correctly, depending on whether we need SA-1 mapping or not
	
	function remap_ram(address) = select(!use_sa1_mapping, remap_address(remap_address(remap_address(remap_address(remap_address(remap_range(remap_range(remap_range(remap_range(remap_range(remap_range(remap_range(address, $0000, $00FF, $3000), $0100, $1FFF, $6100), $7EC800, $7EFFFF, $40C800), $7FC800, $7FFFFF, $41C800), $7F9A7B, $7F9C7A, $418800), $700000, $7007FF, $41C000), $700800, $7027FF, $41A000), $7FAB10, $6040), $7FAB1C, $6056), $7FAB28, $6057), $7FAB34, $606D), $7FAB9E, $6083), address)
	
	
	
	; Maps a ROM address correctly, depending on whether we need SA-1 mapping or not
	; NOTE: This doesn't work in conjunction with autoclean, because autoclean is lazy and just treats the function as a label instead of resolving it
	
	function remap_rom(address) = address|select(!use_sa1_mapping, $000000, $800000)
	
	
	
	; Maps a bank correctly, depending on whether we need SA-1 mapping or not
	
	function remap_bank(bankbyte) = bankbyte|select(!use_sa1_mapping, $00, $80)
	
	
	
	
	; Resolves to "stz address" if address lies in an address range supported by stz and otherwise to "lda #$00 : sta address"
	
	macro sta_zero_or_stz(address)
		if less(<address>, $10000)
			stz <address>		
		else
			lda #$00
			sta <address>
		endif
	endmacro
	
	
	; Resolves to "inc address" if address lies in an address range supported by inc and otherwise to "lda #$01 : sta address"
	
	macro sta_one_or_inc(address)
		if less(<address>, $10000)
			inc <address>		
		else
			lda #$01
			sta <address>
		endif
	endmacro
	
	
	
	!shared_asm_included = 1
	
endif

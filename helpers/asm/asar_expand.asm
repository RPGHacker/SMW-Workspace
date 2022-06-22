; This patch expands your ROM to a specific size in bytes and does nothing else.
; If any other modifications are needed along with the expansion, this patch won't provide those.
; For example, you'll still probably need to patch SA-1 pack's 6mb.asm or 8mb.asm if you plan to expand your ROM to those sizes.
; The actual size in bytes to expand to is passed in as command line define: !cmdl_arg_rom_size

if defined("cmdl_arg_rom_size") == 0
	error "No desired ROM size specified. Please define a size by passing the following argument to Asar via the command line: ""-Dcmdl_arg_rom_size={size_in_bytes}"""
endif

; Would be great if Asar updated this size automatically, but currently, it doesn't.
; At least not without using freespace.
org $00FFD7
	db max(read1($00FFD7), ceil(log2(!cmdl_arg_rom_size/1024)))

!end_pos #= ((!cmdl_arg_rom_size-1)/$8000)<<16|($8000+((!cmdl_arg_rom_size-1)%$8000))|$800000
org !end_pos 

End:
	db read1(End, 0)

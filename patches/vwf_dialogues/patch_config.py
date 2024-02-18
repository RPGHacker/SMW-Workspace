import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../../helpers/python'))
import patching_utility
from typing import cast


patcher = patching_utility.PatchingUtility()

patcher.add_option('--messages_file', values=['testing', 'smw'], default_index=0)
patcher.add_option('--bit_mode', values=['8-bit', '16-bit'], default_index=0)
patcher.add_option('--message_box_hijack', values=['enable', 'disable'], default_index=0)
patcher.add_option('--debug_vblank', values=['false', 'true'], default_index=0)
patcher.add_option('--compatibility_test', values=['none', 'super', 'sprite', 'smb3', 'minimalist', 'dkcr', 'nuke'], default_index=0)

	
patch_config = patching_utility.PatchConfig( os.path.dirname(__file__),
	
	actions = [
		patching_utility.Patch(
			os.path.join(os.path.dirname(__file__), 'vwf_dialogues.asm'),
			include_paths = [
				os.path.join(os.path.dirname(__file__), 'data/testing'),
				os.path.join(os.path.dirname(__file__), '..'),
			],
			defines = [],
		),
		patching_utility.Patch(
			os.path.join(os.path.dirname(__file__), 'testing/uberasm/asar_patch.asm'),
			include_paths = [
				os.path.join(os.path.dirname(__file__), 'code/external'),
			],
			defines = [],
		),
		patching_utility.InsertBlocks(
			blocks = [
				patching_utility.BlockData(os.path.join(os.path.dirname(__file__), 'code/blocks/display_once_on_touch/touch_mXX.asm'), 0x200, acts_like=0x2B),
			],
			routine_files = [],
			include_files = [
				os.path.join(os.path.dirname(__file__), 'code/external/vwfsharedroutines.asm'),
			],
		),
		patching_utility.InsertMap16(os.path.join(os.path.dirname(__file__), 'testing/display_once_block.map16'), 104),
		patching_utility.InsertLevel(os.path.join(os.path.dirname(__file__), 'testing/level_104.mwl'), 104),
		patching_utility.InsertLevel(os.path.join(os.path.dirname(__file__), 'testing/level_018.mwl'), 18),
		patching_utility.InsertLevel(os.path.join(os.path.dirname(__file__), 'testing/level_017.mwl'), 17),
	]
	
)


def main() -> None:
	options = patcher.parse_options()
	
	vwf_dialogues_asm = cast(patching_utility.Patch, patch_config.actions[0])
	
	if options.messages_file == 'smw':
		vwf_dialogues_asm.include_paths[0] = os.path.join(os.path.dirname(__file__), 'data/smw')
	
	if options.bit_mode == '16-bit':
		vwf_dialogues_asm.defines.append('vwf_bit_mode=VWF_BitMode.16Bit')
		
	if options.message_box_hijack == 'disable':
		vwf_dialogues_asm.defines.append('hijackbox=false')
		
	if options.debug_vblank == 'true':
		vwf_dialogues_asm.defines.append('vwf_debug_vblank_time=true')
		
	compatibility_test: str = options.compatibility_test
	
	if compatibility_test == 'super':
		patch_config.actions.append(patching_utility.Patch(os.path.join(os.path.dirname(__file__), 'testing/compatibility/SuperStatusBar_2_2/SuperStatusBar_Advancedv2.asm')))
	elif compatibility_test == 'sprite':
		patch_config.actions.append(patching_utility.Patch(os.path.join(os.path.dirname(__file__), 'testing/compatibility/SSB111/ssb.asm')))
		patch_config.actions.append(patching_utility.InsertCustomPalette(os.path.join(os.path.dirname(__file__), 'testing/compatibility/SSB111/ssb_0F.pal'), 104))
		patch_config.actions.append(patching_utility.InsertCustomPalette(os.path.join(os.path.dirname(__file__), 'testing/compatibility/SSB111/ssb_0F.pal'), 105))
		patch_config.actions.append(patching_utility.InsertCustomPalette(os.path.join(os.path.dirname(__file__), 'testing/compatibility/SSB111/ssb_0F.pal'), 106))
	elif compatibility_test == 'smb3':
		patch_config.actions.append(patching_utility.Patch(os.path.join(os.path.dirname(__file__), 'testing/compatibility/smb3_statusbar_v1.53.1/smb3_status.asm')))
	elif compatibility_test == 'minimalist':
		patch_config.actions.append(patching_utility.Patch(os.path.join(os.path.dirname(__file__), 'testing/compatibility/minimalist/status_double.asm')))
	elif compatibility_test == 'dkcr':
		patch_config.actions.append(patching_utility.Patch(os.path.join(os.path.dirname(__file__), 'testing/compatibility/dkcr_sprite_status_bar/status_bar.asm')))
		patch_config.actions.append(patching_utility.InsertGfx(os.path.join(os.path.dirname(__file__), 'testing/compatibility/dkcr_sprite_status_bar/GFX00.bin'), 0x00))
		# Currently breaks... the included palette doesn't seem to be shared.
		#patch_config.actions.append(patching_utility.InsertSharedPalette(os.path.join(os.path.dirname(__file__), 'testing/compatibility/dkcr_sprite_status_bar/paletteF.pal')))
		patch_config.actions.append(patching_utility.InsertCustomPalette(os.path.join(os.path.dirname(__file__), 'testing/compatibility/dkcr_sprite_status_bar/paletteF.pal'), 104))
		patch_config.actions.append(patching_utility.InsertCustomPalette(os.path.join(os.path.dirname(__file__), 'testing/compatibility/dkcr_sprite_status_bar/paletteF.pal'), 105))
		patch_config.actions.append(patching_utility.InsertCustomPalette(os.path.join(os.path.dirname(__file__), 'testing/compatibility/dkcr_sprite_status_bar/paletteF.pal'), 106))
	elif compatibility_test == 'nuke':
		patch_config.actions.insert(0, patching_utility.Patch(os.path.join(os.path.dirname(__file__), 'testing/compatibility/nuke_statusbar/nuke_statusbar.asm')))
		
	patcher.create_rom(patch_config, options)
	

if __name__ == '__main__':
	main()
	
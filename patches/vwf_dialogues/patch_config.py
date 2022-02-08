import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../../helpers/python'))
import patching_utility
from typing import cast


patcher = patching_utility.PatchingUtility()

patcher.add_option('--messages_file', values=['testing', 'smw'], default_index=0)
patcher.add_option('--bit_mode', values=['8-bit', '16-bit'], default_index=0)
patcher.add_option('--message_box_hijack', values=['enable', 'disable'], default_index=0)

	
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
	]
	
)


def main() -> None:
	options = patcher.parse_options()
	
	vwf_dialogues_asm = cast(patching_utility.Patch, patch_config.actions[0])
	
	if options.messages_file == 'smw':
		vwf_dialogues_asm.include_paths[0] = os.path.join(os.path.dirname(__file__), 'data/smw')
	
	if options.bit_mode == '16-bit':
		vwf_dialogues_asm.defines.append('vwf_bitmode=VWF_BitMode.16Bit')
		
	if options.message_box_hijack == 'disable':
		vwf_dialogues_asm.defines.append('hijackbox=false')
		
	patcher.create_rom(patch_config, options)
	

if __name__ == '__main__':
	main()
	
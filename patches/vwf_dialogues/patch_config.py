import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../../helpers/python'))
import patching_utility


patcher = patching_utility.PatchingUtility()

patcher.add_option('--bit_mode', values=['8-bit', '16-bit'], default_index=0)

	
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



if __name__ == '__main__':	
	options = patcher.parse_options()
	
	if options.bit_mode == '16-bit':
		patch_config.actions[0].defines.append('bitmode=BitMode.16Bit')
		
	patcher.apply_patches(patch_config, options)
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../../helpers/python'))
import patching_utility


patcher = patching_utility.PatchingUtility()

	
patch_config = patching_utility.PatchConfig( os.path.dirname(__file__),
	
	actions = [
		patching_utility.Patch(
			os.path.join(os.path.dirname(__file__), 'unit_tests/test_remap_ram.asm'),
			include_paths = [
				os.path.join(os.path.dirname(__file__), '..'),
			],
			defines = [],
		),
	]
	
)



if __name__ == '__main__':	
	options = patcher.parse_options()
		
	patcher.apply_patches(patch_config, options)
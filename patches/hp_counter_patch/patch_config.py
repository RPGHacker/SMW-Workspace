import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '../../helpers/python'))
import patching_utility


patcher = patching_utility.PatchingUtility()

	
patch_config = patching_utility.PatchConfig( os.path.dirname(__file__),
	
	actions = [
		patching_utility.Patch(
			os.path.join(os.path.dirname(__file__), 'hp_counter_patch.asm'),
			include_paths = [
				os.path.join(os.path.dirname(__file__), '..'),
			],
			defines = [],
		),
	]
	
)


def main() -> None:
	options = patcher.parse_options()
		
	patcher.create_rom(patch_config, options)
	

if __name__ == '__main__':
	main()
	
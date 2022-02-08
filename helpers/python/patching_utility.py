import argparse
import os
import shutil
import subprocess
import re
import pathlib
import dataclasses
from dataclasses import dataclass
from typing import List, Dict, Optional, cast, Match, Pattern


_asar_paths: Dict[str, str] = {
	'1.81': os.path.join(os.path.dirname(__file__), '../../tools/asar181/asar.exe'),
	'1.9': os.path.join(os.path.dirname(__file__), '../../tools/asar19/asar.exe'),
	'2.0': os.path.join(os.path.dirname(__file__), '../../tools/asar20/asar.exe'),
}

_lm_path: str = os.path.join(os.path.dirname(__file__), '../../tools/lm331/Lunar Magic.exe')

_flips_path: str = os.path.join(os.path.dirname(__file__), '../../tools/floating/flips.exe')


_clean_rom_path: str = os.path.join(os.path.dirname(__file__), '../../baserom/smw.smc')

_expand_patch_path: str = os.path.join(os.path.dirname(__file__), '../asm/asar_expand.asm')

_lm_base_patch_path: str = os.path.join(os.path.dirname(__file__), '../asm/lunar_magic_base.asm')

_level_105_path: str = os.path.join(os.path.dirname(__file__), '../smw/level_105.mwl')

_sa1_pack_base_dir: str = os.path.join(os.path.dirname(__file__), '../asm/patches/SA1-Pack-140')


_rom_types: List[str] = [ 'normal', 'sa-1' ]

_rom_size_mappings: Dict[str, int] = {
	'1mb': 1 * 1024 * 1024,
	'2mb': 2 * 1024 * 1024,
	'3mb': 3 * 1024 * 1024,
	'4mb': 4 * 1024 * 1024,
	'6mb': 6 * 1024 * 1024,
	'8mb': 8 * 1024 * 1024,
}

_unsupported_rom_sizes: Dict[str, List[str]] = {
	'normal': ['6mb', '8mb'],
	'sa-1': ['1mb'],
}


rom_extension: str = '.smc'


def format_command_line(command_line_args: List[str]) -> str:
	"""Formats a command line array in a way that is easy to read, yet can
	also be copied directly into cmd.exe to run the respective command line."""
	return '{command_line}'.format(command_line=' '.join(f'"{arg}"' if ' ' in arg else f'{arg}' for arg in command_line_args))


@dataclass
class ActionOutput:
	"""Defines all outputs of a patching_utility.Action that the patcher
	requires for further processing."""
	output_symbols_path: Optional[str] = None
	
	
@dataclass
class Action:
	"""The base class for actions the patcher can perform."""
	def run(self, patch_config: 'PatchConfig', options: argparse.Namespace, output_rom_path: str) -> ActionOutput:
		raise NotImplementedError()
	
	
@dataclass
class PatchConfig:
	"""Defines the setup that is required to get from a clean SMW ROM to a test ROM
	for	a specific patch. Certain shared aspects (like basic Lunar Magic
	hacks, ROM size and SA-1 Pack) are handled automatically under the hood. Add
	further Actions to define patches and resources needed for testing the patch.
	Pass in the path to your patch_config.py to automatically initialize the
	output directory and ROM name."""
	module_path: dataclasses.InitVar[str]
	output_dir: str = ''
	rom_base_name: str = ''
	actions: List[Action] = dataclasses.field(default_factory=lambda: [])
	
	# Pass in the directory of the calling patch_config.py module here.
	# This is only used to initialize some variables with reasonable defaults.
	def __post_init__(self, module_path: str) -> None:
		self.output_dir = os.path.join(module_path, 'builds')	
		self.rom_base_name = os.path.basename(os.path.abspath(module_path))
		

@dataclass
class Patch(Action):
	"""Defines a patch to apply with Asar."""
	path: str
	include_paths: List[str] = dataclasses.field(default_factory=lambda: [])
	defines: List[str] = dataclasses.field(default_factory=lambda: [])
	
	def run(self, patch_config: PatchConfig, options: argparse.Namespace, output_rom_path: str) -> ActionOutput:
		output = ActionOutput()
		
		patch_symbols_path: str = os.path.join(patch_config.output_dir, os.path.basename(self.path) + '.cpu.sym')
		
		command_line: List[str] = [os.path.normpath(_asar_paths[options.asar_ver])]
		
		for include_path in self.include_paths:
			command_line.append('-I{path}'.format(path=os.path.normpath(include_path)))
			
		for define in self.defines:
			command_line.append('-D{define}'.format(define=define))
			
		command_line.append('--symbols=wla')
			
		command_line.append('--symbols-path={path}'.format(path=os.path.normpath(patch_symbols_path)))
			
		command_line.append(os.path.normpath(self.path))
		
		command_line.append(os.path.normpath(output_rom_path))
		
		print('')
		print('Patching (Asar): \n{command_line}'.format(command_line=format_command_line(command_line)))
				
		print('')
		print('Output:')
		
		ret_val = subprocess.run(command_line)
		
		print('')
		
		if ret_val.returncode != 0:
			raise RuntimeError("Patching failed! Please check Asar's error output above.")
			
		output.output_symbols_path = patch_symbols_path
		
		return output
		

# There's probably no good reason to make this class public in its current form.
@dataclass
class _CopyCleanRom(Action):	
	def run(self, patch_config: PatchConfig, options: argparse.Namespace, output_rom_path: str) -> ActionOutput:
		output = ActionOutput()
		
		print('')
		print('Copying:\n"{clean_rom}" to "{output_rom}":'.format(clean_rom=_clean_rom_path, output_rom=output_rom_path))
		
		shutil.copyfile(_clean_rom_path, output_rom_path)
		
		print('')

		return output
		
		
@dataclass
class FlipsPatch(Action):
	"""Defines a patch to apply with Flips."""
	path: str
	
	def run(self, patch_config: PatchConfig, options: argparse.Namespace, output_rom_path: str) -> ActionOutput:
		output = ActionOutput()
		
		command_line: List[str] = [_flips_path]
			
		command_line.append('--apply')
			
		command_line.append(self.path)
			
		command_line.append(output_rom_path)
		
		print('')
		print('Patching (Flips): \n{command_line}'.format(command_line=format_command_line(command_line)))
				
		print('')
		print('Output:')
		
		ret_val = subprocess.run(command_line)
		
		print('')
		
		if ret_val.returncode != 0:
			raise RuntimeError("Patching failed! Please check Flips' error output above.")
		
		return output
		
		
@dataclass
class InsertLevel(Action):
	"""Defines a level file to insert with Lunar Magic."""
	path: str
	level_number: int
	
	def run(self, patch_config: PatchConfig, options: argparse.Namespace, output_rom_path: str) -> ActionOutput:
		output = ActionOutput()
		
		command_line: List[str] = [_lm_path]
			
		command_line.append('-ImportLevel')
			
		command_line.append(output_rom_path)
			
		command_line.append(self.path)
			
		command_line.append(str(self.level_number))
		
		print('')
		print('Inserting level (Lunar Magic): \n{command_line}'.format(command_line=format_command_line(command_line)))
				
		print('')
		print('Output:')
		
		ret_val = subprocess.run(command_line)
		
		print('')
		
		if ret_val.returncode != 0:
			raise RuntimeError("Running Lunar Magic failed! Please check Flips' error output above.")
		
		return output
		
	
# ROM size is controlled via an option, so probably no good reason to expose this class.
@dataclass
class _ExpandRom(Action):
	new_size_in_bytes: dataclasses.InitVar[int]
	patch: Patch = dataclasses.field(default_factory=lambda: Patch(path=_expand_patch_path))
	
	def __post_init__(self, new_size_in_bytes: int) -> None:
		self.patch.defines.append('cmdl_arg_rom_size={size_in_bytes}'.format(size_in_bytes=new_size_in_bytes))

	def run(self, patch_config: PatchConfig, options: argparse.Namespace, output_rom_path: str) -> ActionOutput:
		return self.patch.run(patch_config, options, output_rom_path)

	
class PatchingUtility:
	"""This class is the actual patcher utility that creates the test rom based on
	PatchConfig that is passed in."""
	def __init__(self) -> None:
		self._parser = argparse.ArgumentParser(description='Applies this patch and all dependencies to a clean SMW ROM to create a patched output ROM.')
		
		self._option_values: Dict[str, List[str]] = {}
		self._option_default_indices: Dict[str, int] = {}
		
		self.add_option('--asar_ver', values=list(_asar_paths.keys()), default_index=1)
		self.add_option('--rom_type', values=_rom_types, default_index=0)
		self.add_option('--rom_size', values=list(_rom_size_mappings.keys()), default_index=1)
		
	def add_option(self, name: str, values: List[str], default_index: int = 0) -> None:
		"""Registers a command line option with possible values for this patcher."""
		self._option_values[name] = values
		self._option_default_indices[name] = default_index
		self._parser.add_argument(name, choices=values, default=values[default_index])
		
	def get_option_values(self) -> Dict[str, List[str]]:
		"""Returns all possible options registered for this patcher."""
		return self._option_values
		
	def get_option_default_index(self, name: str) -> int:
		"""Returns the default index for a registered option."""
		return self._option_default_indices[name]
		
	def parse_options(self, args: List[str] = None) -> argparse.Namespace:
		"""Parses option values, either from command line arguments, or from an optional
		list."""
		options = self._parser.parse_args(args)
		
		if options.rom_size in _unsupported_rom_sizes[options.rom_type]:
			raise ValueError('ROM size "{rom_size}" not supported for ROM type "{rom_type}". Please try a different size.'.format(rom_size=options.rom_size, rom_type=options.rom_type))
		
		return options
		
	def construct_output_file_name(self, patch_config: PatchConfig, options: argparse.Namespace, ext: Optional[str] = None) -> str:
		"""Constructs the base name of the output ROM, based on patch config and parsed
		options."""
		rom_name: str = patch_config.rom_base_name
		
		string_options = vars(options)
		
		for option_name, value in string_options.items():
			rom_name += '_{sanitized_value}'.format(sanitized_value=re.sub(r"[^a-zA-Z0-9_]", '', value))
			
		if ext != None:
			ext = cast(str, ext)
			if ext[0] != '.':
				rom_name += '.'
			rom_name += ext
			
		return rom_name
		
	def construct_output_rom_name(self, patch_config: PatchConfig, options: argparse.Namespace) -> str:
		"""Constructs the name of the output ROM, based on patch config and parsed
		options, using the default ROM extension."""
		return self.construct_output_file_name(patch_config, options, rom_extension)
		
	def create_rom(self, patch_config: PatchConfig, options: argparse.Namespace) -> None:
		"""Uses patch config and parsed options to create the final output ROM."""
		pathlib.Path(patch_config.output_dir).mkdir(parents = True, exist_ok = True)
	
		rom_name: str = self.construct_output_file_name(patch_config, options)
		
		output_rom_path: str = os.path.join(patch_config.output_dir, rom_name + rom_extension)
		output_symbols_path: str = os.path.join(patch_config.output_dir, rom_name + '.cpu.sym')
		output_sa1_symbols_path: str = os.path.join(patch_config.output_dir, rom_name + '.sa1.sym')
		
		symbols_output: Dict[str, List[str]] = {}				
		source_file_base_id: int = 0
		
		action_list: List[Action] = []
		
		action_list.append(_CopyCleanRom())
		
		action_list.append(Patch(_lm_base_patch_path))
		
		# Cap the expansion size to 4 MB here, because the patch can't handle more.
		# 6 MB and 8 MB require custom patches that are included with SA-1 Pack.
		expansion_size = min(_rom_size_mappings[options.rom_size], _rom_size_mappings['4mb'])
			
		action_list.append(_ExpandRom(_rom_size_mappings[options.rom_size]))
		
		if options.rom_type == 'sa-1':
			sa1_main_patch_path = os.path.join(_sa1_pack_base_dir, 'sa1.asm')
			action_list.append(Patch(sa1_main_patch_path))
			
			if options.rom_size == '6mb':
				sa1_6mb_patch_path = os.path.join(_sa1_pack_base_dir, '6mb.asm')
				action_list.append(Patch(sa1_6mb_patch_path))
			elif options.rom_size == '8mb':
				sa1_8mb_patch_path = os.path.join(_sa1_pack_base_dir, '8mb.asm')
				action_list.append(Patch(sa1_8mb_patch_path))
			
		action_list.append(InsertLevel(_level_105_path, 105))
		
		action_list.extend(patch_config.actions)
	
		for action in action_list:
			output = action.run(patch_config, options, output_rom_path)
			
			# Do some processing on symbol files, so that we can merge outputs of symbol files further below
			# and also so that we can get rid of stuff we don't really want.
			if output.output_symbols_path != None:
				output.output_symbols_path = cast(str, output.output_symbols_path)
				with open(output.output_symbols_path) as symbols_file:
					group_re: Pattern[str] = re.compile(r"^\s*\[([^\]]+)\]\s*$")
					label_re: Pattern[str] = re.compile(r"^\s*([0-9a-fA-F]{2})\:([0-9a-fA-F]{4})\s+(\S+)\s*$")
					source_file_re: Pattern[str] = re.compile(r"^\s*([0-9a-fA-F]{4})\s+([0-9a-fA-F]{8})\s+(\S+)\s*$")
					addr_to_line_re: Pattern[str] = re.compile(r"^\s*([0-9a-fA-F]{2})\:([0-9a-fA-F]{4})\s+([0-9a-fA-F]{4})\:([0-9a-fA-F]{8})\s*$")
					
					parsing_labels: bool = False
					parsing_source_files: bool = False
					parsing_add_to_line: bool = False
					current_group: Optional[str] = None
					
					num_source_files_in_symbols_file: int = 0
					
					for line in symbols_file:
						group_match: Optional[Match[str]] = group_re.match(line)
						
						if group_match:
							current_group = group_match.group(1)
							parsing_labels = (current_group == 'labels')
							parsing_source_files = (current_group == 'source files')
							parsing_add_to_line = (current_group == 'addr-to-line mapping')
						elif current_group:
							reject_line: bool = False
							
							if parsing_labels:
								label_match: Optional[Match[str]] = label_re.match(line)
								if label_match:
									# RPG Hacker: Reject labels in the range 00:0000 to 00:7FFF.
									# We occasionally use labels as enums or constants, which will usually be in that range,
									# but it's very annoying in the debugger when it applies these mappings to stuff like "lda $00".
									reject_line = (int(label_match.group(1), 16) == 0x00 and int(label_match.group(2), 16) < 0x8000)
									# We also prefix label names with the patch name. Not only because multiple patches might use identical names,
									# but also because pos/neg labels in particular would conflict between them.
									line = '{bank}:{address} {prefix}.{label}'.format(bank=label_match.group(1), address=label_match.group(2), prefix=os.path.basename(output.output_symbols_path), label=label_match.group(3))
									
							if parsing_source_files:
								source_file_match: Optional[Match[str]] = source_file_re.match(line)
								if source_file_match:
									new_file_id = int(source_file_match.group(1), 16) + source_file_base_id
									line = '{file_id:04x} {checksum} {path}'.format(file_id=new_file_id, checksum=source_file_match.group(2), path=source_file_match.group(3))
									num_source_files_in_symbols_file += 1
								
							if parsing_add_to_line:
								addr_to_line_match: Optional[Match[str]] = addr_to_line_re.match(line)
								if addr_to_line_match:
									new_file_id = int(addr_to_line_match.group(3), 16) + source_file_base_id
									line = '{snes_bank}:{snes_address} {source_bank:04x}:{source_address}'.format(snes_bank=addr_to_line_match.group(1), snes_address=addr_to_line_match.group(2), source_bank=new_file_id, source_address=addr_to_line_match.group(4))
							
							# Reject lines that are only whitespace.
							reject_line = reject_line or (re.search(r"^\s*$", line) != None)
								
							if not reject_line:
								symbols_output.setdefault(current_group, []).append(line.strip())
							
					source_file_base_id += num_source_files_in_symbols_file
					
				os.remove(output.output_symbols_path)
		
		# Output new merged symbols file.
		with open(output_symbols_path, 'w') as symbols_file:
			for group_name, lines in symbols_output.items():
				symbols_file.write('[{group_name}]\n'.format(group_name=group_name))
				
				if group_name == 'rom checksum':
					# We only write the last line for the ROM checksum group, since a ROM can't have multiple checksums,
					# and the last checksum is likely to be the most up-to-date one.
					symbols_file.write('{line}\n'.format(line=lines[-1]))
				else:
					for line in lines:
						symbols_file.write('{line}\n'.format(line=line))
						
				symbols_file.write('\n')				
			
		if options.rom_type == 'sa-1':
			shutil.copyfile(output_symbols_path, output_sa1_symbols_path)
				
		print("All patches applied successfully!")
		
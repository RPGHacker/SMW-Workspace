# This script iterates all the directories in the current working directory (except for ones called "shared")
# and creates symbolic links inside them, linking to the "shared" folder. I know this is pretty nasty, but
# when I deploy any of my patches, I'd like the structure of the manuals to be reasonable and to have the
# index.html file in the root directory, which the shared folder right next to it. However, I don't want a
# copy of the shared folder inside each specific manual in the repository. So the only way I can think of to
# be able to test manuals in the repository itself is to create symbolic links to the shared folder.
import os

for subdir, dirs, files in os.walk(os.getcwd()):
	for dir in dirs:
		if dir != 'shared':
			target_dir = os.path.join(subdir, dir, 'manual/shared')
			source_dir = os.path.normpath('../../shared')
			os.symlink(source_dir, target_dir)
	break
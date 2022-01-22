# RPG Hacker's Public SMW Workspace
My SMW workspace for all of my public stuff. Contributions via pull requests are welcome!

# Setup
For testing convenience, please follow the instructions listed in README.md inside the baserom directory.

For better readibility of Asar code (especially using my rather unique coding style), I recommend downloading Notepad++ and importing the [Asar syntax highlighting extension](https://github.com/RPGHacker/asar/blob/master/ext/notepad-plus-plus/syntax-highlighting.xml) from the [official Asar repository](https://github.com/RPGHacker/asar) as a user-defined language. This adds some decent syntax highlighting for Asar-compatible ASM code to Notepad++.

# Patching & Testing
To make patching and testing the patches in this repository easier, a few Python helper scripts are provided (currently Windows-only) that you can use by installing Python version 3.8 or above. Simply running patch_manager.pyw will open a little helper GUI application that lets you select patches to apply and lets you start them directly in an emulator. This works by searching for patch_config.py files in the directories of each patch, which define how the patch is to be applied.

**NOTE:** Starting patch_manager.pyw by double-clicking it might have long start-up times on Windows, due to its native Python launcher pyw.exe being ridiculously slow. It might be faster to pass the script file path to Python directly via the command line. Alternatively, you can try running patch_manager.bat, which will directly pass the script to pythonw.exe. However, if you have multiple Python installations on your system, this might end up picking the wrong one.

# License
All of my own patches (currently all the contents of the patches directory) are licensed under the MIT license. Please check the LICENSE file for details.
This repository contains some tools for debugging and development purposes that are not to be distributed alongside any of the patches and might have their own licenses, different from the license used for the patches. Please check each individual tool's sub directory for details.

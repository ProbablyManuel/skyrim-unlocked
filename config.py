"""Global variables for Skyrim Unlocked build system"""
import os

dir_repo = "C:\\Users\\user\\Documents\\GitHub\\skyrim-unlocked"
"""The directory where the git repository for Skyrim Unlocked is stored."""

dir_le = dir_repo
"""The directory where all files for Legendary Edition are stored."""

skyrim_le = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Skyrim"
"""The Skyrim Legendary Edition directory"""

archive_exe_le = os.path.join(skyrim_le, "Archive.exe")
"""Archive.exe for Legendary Edition"""

"""Global variables for Skyrim Unlocked build system"""
import os

dir_repo = "C:\\Users\\user\\Documents\\GitHub\\skyrim-unlocked"
"""Directory where the git repository for Skyrim Unlocked is stored."""

dir_le = dir_repo
"""Directory where all mod files for Legendary Edition are stored."""

dir_se = os.path.join(dir_repo, "SSE")
"""Directory where all mod files for Special Edition are stored."""

archive_exe_le = ("C:\\Program Files (x86)\\Steam\\steamapps\\common\\"
                  "Skyrim\\Archive.exe")
"""Archive.exe for Legendary Edition"""

archive_exe_se = ("C:\\Program Files (x86)\\Steam\\steamapps\\common\\"
                  "SkyrimSpecialEdition\\Tools\\Archive\\Archive.exe")
"""Archive.exe for Special Edition"""

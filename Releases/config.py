"""Global variables for Skyrim Unlocked build system"""
import os

DIR_REPO = "C:\\Users\\user\\Documents\\GitHub\\skyrim-unlocked"
"""Directory where the git repository for Skyrim Unlocked is stored."""

DIR_REPO_LE = DIR_REPO
"""Directory where all mod files for Legendary Edition are stored."""

DIR_REPO_SE = os.path.join(DIR_REPO, "SSE")
"""Directory where all mod files for Special Edition are stored."""

BSARCH = "C:\\Users\\user\\Documents\\Skyrim Tools\\BSArch\\bsarch.exe"
"""Path to BSArch.exe"""

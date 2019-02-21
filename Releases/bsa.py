import os
import shutil
import subprocess
import tempfile


def build_bsa(archive_exe, dir_source, bsa_target):
    """Build a bsa.

    Args:
        archive_exe: The executable that creates the bsa.
        dir_source: All files in this directory excluding plugins are packed
            into the bsa.
        bsa_target: Target destination of the bsa.
            This is the final path e.g. /Some/Path/Mod.bsa
    """
    # Some genius at Bethesda had the idea to assume that the first occurence
    # of "Data" in a path must be Skyrim's Data folder. Thus the temporary
    # directory must not be created at the default location AppData\Temp
    with tempfile.TemporaryDirectory(dir="C:\\Windows\\Temp") as dir_temp:
        # Another genius' idea: The root of the loose files must be Data
        path_root = os.path.join(dir_temp, "Data")
        shutil.copytree(dir_source, path_root)
        # Create manifest
        path_manifest = os.path.join(dir_temp, "Manifest.txt")
        with open(path_manifest, "w") as manifest:
            for root, subdirs, files in os.walk(dir_source):
                short_root = root[len(dir_source):]
                for file in files:
                    extension = os.path.splitext(file)[1]
                    if extension not in [".esl", ".esp", ".esm"]:
                        manifest.write(os.path.join(short_root, file) + "\n")
        # Create batch file
        path_batch = os.path.join(dir_temp, "Batch.txt")
        with open(path_batch, "w") as batch:
            path_log = os.path.basename(bsa_target).replace(".bsa", ".log")
            batch.write("Log: " + path_log + "\n")
            batch.write("New Archive\n")
            batch.write("Check: Meshes\n")
            batch.write("Check: Textures\n")
            batch.write("Check: Menus\n")
            batch.write("Check: Sounds\n")
            batch.write("Check: Voices\n")
            batch.write("Check: Shaders\n")
            batch.write("Check: Trees\n")
            batch.write("Check: Fonts\n")
            batch.write("Check: Misc\n")
            batch.write("Check: Compress Archive\n")
            batch.write("Check: Retain Directory Names\n")
            batch.write("Check: Retain File Names\n")
            batch.write("Check: Retain File Name Offsets\n")
            batch.write("Check: Retain Strings During Startup\n")
            batch.write("Check: Embed File Names\n")
            batch.write("Set File Group Root: " + path_root + "\n")
            batch.write("Add File Group: " + path_manifest + "\n")
            batch.write("Save Archive: " + bsa_target + "\n")
        # Build bsa
        cmd = [archive_exe, path_batch]
        sp = subprocess.run(cmd, stdout=subprocess.DEVNULL)
        sp.check_returncode()
        # Delete useless bsl file
        path_bsl = bsa_target.replace(".bsa", ".bsl")
        os.remove(path_bsl)

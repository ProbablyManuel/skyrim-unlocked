import logging
import os
import pathlib
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree

"""Valid extensions of a plugin."""
plugin_exts = [".esl", ".esp", ".esm"]

"""All files in these directories will be included in a bsa."""
bsa_include_dirs = ["interface", "meshes", "music", "textures", "scripts",
                    "seq", "shadersfx", "sound", "strings"]


class ArchiveFlags():
    """Flags for Archive.exe"""

    def __init__(self):
        self.check_meshes = False
        self.check_textures = False
        self.check_menus = False
        self.check_sounds = False
        self.check_voices = False
        self.check_shaders = False
        self.check_trees = False
        self.check_fonts = False
        self.check_misc = False
        self.check_compress_archive = False
        self.check_retain_directory_names = False
        self.check_retain_file_names = False
        self.check_retain_file_name_offsets = False
        self.check_retain_strings_during_startup = False
        self.check_embed_file_name = False


def build_release(dir_source, dir_target, archive_exe=None,
                  archive_flags: ArchiveFlags = ArchiveFlags()):
    """Build a release archive.

    Args:
        dir_source: The source directory for which the archive is built.
            It must contain a Fomod subdirectory with Info.xml and
            ModuleConfig.xml.
            Furthermore it must contain a subdirectory for every folder
            specified in ModuleConfig.xml. Such a subdirectory is expected
            to contain at most one plugin.
        dir_target: The target directory for the release archive.
        archive_exe: Path to Archive.exe, the executable that creates the bsa.
            If ommited no bsa will be created.
        archive_flags: Check the corresponding options in Archive.exe
            If ommited no flags will be set.
    """
    logger = logging.getLogger(build_release.__name__)
    logger.setLevel(logging.INFO)
    handler = logging.FileHandler("{}.log".format(build_release.__name__))
    formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.info("------------------------------------------------------------")
    logger.info("Building release")
    logger.info("Source directory: {}".format(dir_source))
    logger.info("Target directory: {}".format(dir_target))
    logger.info("Build bsa: {}".format(bool(archive_exe)))
    # Validate arguments
    dir_source_fomod = os.path.join(dir_source, "Fomod")
    if not os.path.isdir(dir_source):
        logger.error("Source directory does not exist")
        exit()
    if not os.path.isdir(dir_target):
        logger.error("Target directory does not exist")
        exit()
    if not os.path.isfile(os.path.join(dir_source_fomod, "Info.xml")):
        logger.error("Info.xml is missing in {}".format(dir_source_fomod))
        exit()
    if not os.path.isfile(os.path.join(dir_source_fomod, "ModuleConfig.xml")):
        logger.error("ModuleConfig.xml is missing in {}".
                     format(dir_source_fomod))
        exit()
    if archive_exe and not os.path.isfile(archive_exe):
        logger.error("Archive.exe path {} does not exist".format(archive_exe))
        exit()
    if archive_exe and os.path.basename(archive_exe) != "Archive.exe":
        logger.error("{} does not point to Archive.exe".format(archive_exe))
        exit()
    # Get required subdirectories from ModuleConfig.xml
    path = os.path.join(dir_source_fomod, "ModuleConfig.xml")
    root = xml.etree.ElementTree.parse(path).getroot()
    sub_dirs = list()
    loose_files = list()
    for installSteps in root.iterfind("installSteps"):
        for installStep in installSteps.iterfind("installStep"):
            for fileGroups in installStep.iterfind("optionalFileGroups"):
                for group in fileGroups.iterfind("group"):
                    for plugins in group.iterfind("plugins"):
                        for plugin in plugins.iterfind("plugin"):
                            for files in plugin.iterfind("files"):
                                for folder in files.iterfind("folder"):
                                    sub_dirs.append(folder.get("source"))
                                for file in files.iterfind("file"):
                                    loose_files.append(file.get("source"))
    for conditionalFileInstalls in root.iterfind("conditionalFileInstalls"):
        for patterns in conditionalFileInstalls.iterfind("patterns"):
            for pattern in patterns.iterfind("pattern"):
                for files in pattern.iterfind("files"):
                    for folder in files.iterfind("folder"):
                        sub_dirs.append(folder.get("source"))
                    for file in files.iterfind("file"):
                        loose_files.append(file.get("source"))
    # Validate subdirectories
    logger.info("Subdirectories required by the Fomod installer:")
    for sub_dir in sub_dirs:
        logger.info("   {}".format(sub_dir))
        if not os.path.isdir(os.path.join(dir_source, sub_dir)):
            logger.error("Subdirectory {} is missing".format(sub_dir))
            exit()
        if len(find_plugins(os.path.join(dir_source, sub_dir))) > 1:
            logger.warning("Subdirectory {} contains multiple plugins".
                           format(sub_dir))
    # Validate loose files
    logger.info("Loose files required by the Fomod installer:")
    for file in loose_files:
        logger.info("   {}".format(file))
        if not os.path.isfile(os.path.join(dir_source, file)):
            logger.error("Loose file {} is missing".format(file))
            exit()
    # Get version number and release name from Info.xml
    path = os.path.join(dir_source_fomod, "Info.xml")
    root = xml.etree.ElementTree.parse(path).getroot()
    version = root.find("Version").text
    name_release = root.find("Name").text
    # Validate version stamp of plugins
    version_stamp = bytes("Version: {}".format(version), "utf8")
    for sub_dir in sub_dirs:
        for plugin in find_plugins(os.path.join(dir_source, sub_dir)):
            path_plugin = os.path.join(dir_source, sub_dir, plugin)
            with open(path_plugin, "rb") as fh:
                if version_stamp not in fh.read():
                    logger.warning("{} does not have the correct version"
                                   "stamp".format(plugin))
    for file in loose_files:
        if os.path.splitext(file)[1] in plugin_exts:
            path_plugin = os.path.join(dir_source, file)
            with open(path_plugin, "rb") as fh:
                if version_stamp not in fh.read():
                    logger.warning("{} does not have the correct version"
                                   "stamp".format(plugin))
    # Build fomod tree in a temporary directory
    with tempfile.TemporaryDirectory() as dir_temp:
        # Copy fomod files to the fomod tree
        src = os.path.join(dir_source, "Fomod")
        dst = os.path.join(dir_temp, "Fomod")
        shutil.copytree(src, dst)
        # Copy subdirectories to the fomod tree
        for sub_dir in sub_dirs:
            plugins = find_plugins(os.path.join(dir_source, sub_dir))
            if plugins and archive_exe:
                # Create subdirectory
                os.mkdir(os.path.join(dir_temp, sub_dir))
                # Build the bsa
                bsa = "{}.bsa".format(os.path.splitext(plugins[0])[0])
                src = os.path.join(dir_source, sub_dir)
                dst = os.path.join(dir_temp, sub_dir, bsa)
                build_bsa(archive_exe, src, dst, archive_flags)
                # Copy all files that aren't packed in the bsa
                for path in os.listdir(os.path.join(dir_source, sub_dir)):
                    src = os.path.join(dir_source, sub_dir, path)
                    dst = os.path.join(dir_temp, sub_dir, path)
                    if os.path.isfile(src):
                        shutil.copy2(src, dst)
                    elif os.path.isdir(src):
                        if path.lower() not in bsa_include_dirs:
                            shutil.copytree(src, dst)
            else:
                # Copy everything
                src = os.path.join(dir_source, sub_dir)
                dst = os.path.join(dir_temp, sub_dir)
                shutil.copytree(src, dst)
        # Copy loose files to the fomod tree
        for file in loose_files:
            src = os.path.join(dir_source, path)
            dst = os.path.join(dir_temp, path)
            os.makedirs(os.path.basename(dst), exist_ok=True)
            shutil.copy2(src, dst)
        # Pack fomod tree into a 7zip archive
        file_archive = "{} {}.7z".format(name_release, version)
        # Remove whitespaces from archive name because GitHub doesn't like them
        file_archive = "_".join(file_archive.split())
        src = os.path.join(dir_temp, "*")
        dst = os.path.join(dir_target, file_archive)
        if os.path.isfile(dst):
            os.remove(dst)
        cmd = ["7z", "a", dst, src]
        sp = subprocess.run(cmd, stdout=subprocess.DEVNULL)
        sp.check_returncode()
        logger.info("Succesfully built archive for {} of {}".
                    format(version, name_release))
    logger.removeHandler(handler)


def build_bsa(archive_exe, dir_source, bsa_target,
              archive_flags: ArchiveFlags):
    """Build a bsa.

    Args:
        archive_exe: Path to Archive.exe, the executable that creates the bsa.
        dir_source: All valid files in this directory are packed into the bsa.
        bsa_target: Target destination of the bsa.
            This is the final path e.g. /Some/Path/Mod.bsa
        archive_flags: Check the corresponding options in Archive.exe
    """
    # Some genius at Bethesda had the idea to assume that the first occurence
    # of "Data" in a path must be Skyrim's Data directory. Thus the temporary
    # directory must not be created at the default location AppData\Temp
    with tempfile.TemporaryDirectory(dir="C:\\Windows\\Temp") as dir_temp:
        # Another genius' idea: The root of the loose files must be Data
        path_root = os.path.join(dir_temp, "Data")
        shutil.copytree(dir_source, path_root)
        # Create manifest
        path_manifest = os.path.join(dir_temp, "Manifest.txt")
        with open(path_manifest, "w") as manifest:
            for root, subdirs, files in os.walk(dir_source):
                root_relative = pathlib.PurePath(root).relative_to(dir_source)
                for file in files:
                    path_relative = root_relative.joinpath(file)
                    first_dir = path_relative.parts[0]
                    if first_dir.lower() in bsa_include_dirs:
                        manifest.write("{}\n".format(path_relative))
        # Exit if manifest is empty because Archive.exe will crash
        if os.path.getsize(path_manifest) == 0:
            return
        # Create batch file
        path_batch = os.path.join(dir_temp, "Batch.txt")
        with open(path_batch, "w") as batch:
            path_log = os.path.basename(bsa_target).replace(".bsa", ".log")
            batch.write("Log: {}\n".format(path_log))
            batch.write("New Archive\n")
            if archive_flags.check_meshes:
                batch.write("Check: Meshes\n")
            if archive_flags.check_textures:
                batch.write("Check: Textures\n")
            if archive_flags.check_menus:
                batch.write("Check: Menus\n")
            if archive_flags.check_sounds:
                batch.write("Check: Sounds\n")
            if archive_flags.check_voices:
                batch.write("Check: Voices\n")
            if archive_flags.check_shaders:
                batch.write("Check: Shaders\n")
            if archive_flags.check_trees:
                batch.write("Check: Trees\n")
            if archive_flags.check_fonts:
                batch.write("Check: Fonts\n")
            if archive_flags.check_misc:
                batch.write("Check: Misc\n")
            if archive_flags.check_compress_archive:
                batch.write("Check: Compress Archive\n")
            if archive_flags.check_retain_directory_names:
                batch.write("Check: Retain Directory Names\n")
            if archive_flags.check_retain_file_names:
                batch.write("Check: Retain File Names\n")
            if archive_flags.check_retain_file_name_offsets:
                batch.write("Check: Retain File Name Offsets\n")
            if archive_flags.check_retain_strings_during_startup:
                batch.write("Check: Retain Strings During Startup\n")
            if archive_flags.check_embed_file_name:
                batch.write("Check: Embed File Names\n")
            batch.write("Set File Group Root: {}{}\n".
                        format(path_root, os.sep))
            batch.write("Add File Group: {}\n".format(path_manifest))
            batch.write("Save Archive: {}\n".format(bsa_target))
        # Build bsa
        cmd = [archive_exe, path_batch]
        sp = subprocess.run(cmd, stdout=subprocess.DEVNULL)
        sp.check_returncode()
        # Delete useless bsl file
        path_bsl = bsa_target.replace(".bsa", ".bsl")
        os.remove(path_bsl)


def find_plugins(source_dir):
    """Find all plugins in a directory. Does not search in subdirectories."""
    files = os.listdir(source_dir)
    return [f for f in files if os.path.splitext(f)[1] in plugin_exts]

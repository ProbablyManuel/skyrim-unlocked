import logging
import os
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree

"""All files in these directories will be included in a bsa."""
BSA_INCLUDE_DIRS = ["grass", "interface", "lodsettings", "meshes", "music",
                    "textures", "scripts", "seq", "sound", "strings"]
"""All possible archive formats,"""
BSA_FORMATS = ["tes3", "tes4", "fo3", "fnv", "tes5", "sse", "fo4", "fo4dds"]

logger = logging.getLogger(__name__)


def build_release(dir_src: os.PathLike,
                  dir_dst: os.PathLike = os.getcwd(),
                  dir_ver: os.PathLike = None,
                  bsarch: os.PathLike = None,
                  bsa_format: str = None,
                  bsa_compress: bool = False,
                  bsa_exclude: list = list(),
                  warn_modgroups: bool = True,
                  warn_readmes: bool = True,
                  warn_version: bool = True,
                  warn_mult_plugins: bool = True):
    """Build a release archive.

    Args:
        dir_src: Source directory for which the archive is built.
            It must contain a Fomod subdirectory with Info.xml and
            ModuleConfig.xml. Furthermore it must contain all files specified
            in ModuleConfig.xml.
        dir_dst: Target directory for the release archive. Defaults to the
            current working directory.
        dir_ver: Plugins are temporarily moved to this directory to manually
            add a version number to their description.
            If ommited, no version number is added.
        bsarch: Path to BSArch.exe, the executable that creates the bsa.
            If ommited, no bsa is created.
        bsa_format: Archive format for BSArch.
            If ommited, no bsa is created.
        bsa_compress: If True the bsa will be compressed.
            Defaults to False.
        bsa_exclude: No bsa is created for these subdirectories.
        warn_modgroups: If True warn of plugins without a modgroups file.
            Defaults to True.
        warn_readmes: If True warn of plugins with a readme. A readme is
            expected to have the same name as the plugin. Defaults to True.
        warn_version: If True warn of plugins that don't have a version stamp.
            Defaults to True.
        warn_mult_plugins: If True warn of multiple plugins inside a
            subdirectory of the fomod installation. Defaults to True.
    """
    logger.info("------------------------------------------------------------")
    logger.info("Building release")
    logger.info("Source directory: {}".format(dir_src))
    logger.info("Target directory: {}".format(dir_dst))
    logger.info("Add version number: {}".format(bool(dir_ver)))
    if dir_ver:
        logger.info("Versioning directory: {}".format(dir_ver))
    logger.info("Build bsa: {}".format(bool(bsarch) and bool(bsa_format)))
    if bsarch and bsa_format:
        logger.info("BSArch.exe path: {}".format(bsarch))
        logger.info("Archive format: {}".format(bsa_format))
        logger.info("Compress bsa: {}".format(bsa_compress))
    if bsa_exclude:
        logger.info("Subdirectories excluded from bsa creation:")
        for bsa in bsa_exclude:
            logger.info("    {}".format(bsa))
    logger.info("Check modgroups: {}".format(bool(warn_modgroups)))
    logger.info("Check readmes: {}".format(bool(warn_readmes)))
    logger.info("Check version number: {}".format(bool(warn_version)))
    logger.info("Check multiple plugins: {}".format(bool(warn_version)))
    # Validate arguments
    dir_src_fomod = os.path.join(dir_src, "Fomod")
    if not os.path.isdir(dir_src):
        logger.error("Source directory does not exist")
        exit()
    if not os.path.isdir(dir_dst):
        logger.error("Target directory does not exist")
        exit()
    if dir_ver and not os.path.isdir(dir_ver):
        logger.error("Versioning directory does not exist")
        exit()
    if not os.path.isfile(os.path.join(dir_src_fomod, "Info.xml")):
        logger.error("Info.xml is missing in {}".format(dir_src_fomod))
        exit()
    if not os.path.isfile(os.path.join(dir_src_fomod, "ModuleConfig.xml")):
        logger.error("ModuleConfig.xml is missing in {}".format(dir_src_fomod))
        exit()
    if bsarch and not os.path.isfile(bsarch):
        logger.error("Path to BSArch.exe does not exist")
        exit()
    if bsarch and os.path.basename(bsarch).lower() != "bsarch.exe":
        logger.error("Path to BSArch.exe does not point to BSArch.exe")
        exit()
    if bsa_format and bsa_format not in BSA_FORMATS:
        logger.error("{} is not a valid archive format".format(bsa_format))
        exit()
    # Extract relevant information from fomod installation files
    name_release, version, sub_dirs, loose_files = parse_fomod(dir_src_fomod)
    plugins = [file for file in loose_files if is_plugin(file)]
    for sub_dir in sub_dirs:
        for plugin in find_plugins(os.path.join(dir_src, sub_dir)):
            plugins.append(os.path.join(sub_dir, plugin))
    # Validate subdirectories
    logger.info("Subdirectories required by the Fomod installer:")
    for sub_dir in sub_dirs:
        logger.info("   {}".format(sub_dir))
        if not os.path.isdir(os.path.join(dir_src, sub_dir)):
            logger.error("Subdirectory {} is missing".format(sub_dir))
            exit()
        if warn_mult_plugins:
            if len(find_plugins(os.path.join(dir_src, sub_dir))) > 1:
                logger.warning("Subdirectory {} contains multiple plugins".
                               format(sub_dir))
    # Validate loose files
    logger.info("Loose files required by the Fomod installer:")
    for file in loose_files:
        logger.info("   {}".format(file))
        if not os.path.isfile(os.path.join(dir_src, file)):
            logger.error("Loose file {} is missing".format(file))
            exit()
    # Check if all plugins have modgroups and readmes
    if warn_modgroups:
        check_modgroups(plugins, sub_dirs, loose_files, dir_src)
    if warn_readmes:
        check_readmes(plugins, sub_dirs, loose_files, dir_src)
    # Build fomod tree in a temporary directory
    with tempfile.TemporaryDirectory() as dir_temp:
        # Copy fomod files to the fomod tree
        src = os.path.join(dir_src, "Fomod")
        dst = os.path.join(dir_temp, "Fomod")
        shutil.copytree(src, dst)
        # Copy subdirectories to the fomod tree
        for sub_dir in sub_dirs:
            src = os.path.join(dir_src, sub_dir)
            dst = os.path.join(dir_temp, sub_dir)
            shutil.copytree(src, dst)
            # Build bsa
            if bsarch and bsa_format and sub_dir not in bsa_exclude:
                bsa = find_bsa_name(os.path.join(dir_temp, sub_dir))
                if bsa:
                    src = os.path.join(dir_temp, sub_dir)
                    dst = os.path.join(dir_temp, sub_dir, bsa)
                    build_bsa(src, dst, bsarch, bsa_format, bsa_compress)
        # Copy loose files to the fomod tree
        for file in loose_files:
            src = os.path.join(dir_src, file)
            dst = os.path.join(dir_temp, file)
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.copy2(src, dst)
        # Add version number to plugins
        plugins_fomod = [os.path.join(dir_temp, p) for p in plugins]
        if dir_ver:
            version_plugins(plugins_fomod, dir_ver, version)
        if warn_version:
            check_version(plugins_fomod, version)
        # Pack fomod tree into a zip archive
        make_archive(name_release, version, dir_temp, dir_dst)
        logger.info("Succesfully built release archive for {} of {}".
                    format(version, name_release))


def build_bsa(dir_src: os.PathLike, bsa: os.PathLike, bsarch: os.PathLike,
              bsa_format: str(), bsa_compress: bool):
    """Build a bsa.

    Args:
        dir_src: All valid files in this directory are packed into the bsa.
        bsa: The bsa is created at this path.
            This is the final path e.g. /Some/Path/Mod.bsa.
        bsarch: Path to BSArch.exe, the executable that creates the bsa.
        bsa_format: Archive format for BSArch.
        bsa_compress: If True the bsa is compressed.
    """
    with tempfile.TemporaryDirectory() as dir_temp:
        # Since a bsa has no root folder it suffices to copy subdirectories
        for sub_dir in os.listdir(dir_src):
            path = os.path.join(dir_src, sub_dir)
            if os.path.isdir(path) and sub_dir.lower() in BSA_INCLUDE_DIRS:
                src = path
                dst = os.path.join(dir_temp, sub_dir)
                shutil.move(src, dst)
        # BSArch must not be called on an empty directory
        if os.listdir(dir_temp):
            cmd = [bsarch, "pack", dir_temp, bsa, "-{}".format(bsa_format)]
            if bsa_compress:
                cmd.append("-z")
            sp = subprocess.run(cmd, stdout=subprocess.DEVNULL)
            sp.check_returncode()


def make_archive(release_name: str, version: str, root_dir: os.PathLike,
                 release_dir: os.PathLike) -> os.PathLike:
    """Create a zip archive.

    Args:
        release_name: Name of the release.
        version: Version of the release.
        root_dir: Path to the root directory of the archive.
        release_dir: Path to the directory the archive will be created in.

    Return:
        Path to the created archive.
    """
    base_name = "{} {}".format(release_name, version)
    # Remove whitespaces from archive name because GitHub doesn't like them
    base_name = "_".join(base_name.split())
    base_path = os.path.join(release_dir, base_name)
    return shutil.make_archive(base_path, "zip", root_dir)


def version_plugins(plugins: list, dir_ver: os.PathLike, version: str):
    """Add a version number to the description of plugins.
        Since modifying the description of a plugin requires a dedicated
        application, the plugins are temporarily moved to another directory.
        Then the function pauses until the user confirms that the version
        numbers have been added.

    Args:
        plugins: List of paths to the plugins.
        dir_ver: Plugins are temporarily moved to this directory to manually
            add a version number to their description.
        version: The version number.
    """
    for plugin in plugins:
        src = plugin
        dst = os.path.join(dir_ver, os.path.basename(plugin))
        shutil.move(src, dst)
    print("Update the version stamp of all", len(plugins), "plugins to",
          version)
    input("Press any key to continue")
    for plugin in plugins:
        src = os.path.join(dir_ver, os.path.basename(plugin))
        dst = plugin
        shutil.move(src, dst)


def check_version(plugins: list, version: str):
    """Check if the description of plugins have the correct version."""
    version_stamp = bytes("Version: {}".format(version), "utf8")
    for plugin in plugins:
        with open(plugin, "rb") as fh:
            if version_stamp not in fh.read():
                logger.warning("{} does not have the correct version stamp".
                               format(os.path.basename(plugin)))


def check_modgroups(plugins: list, sub_dirs: list, loose_files: list,
                    dir_src: os.PathLike):
    """Check if modgroups are missing.

    Args:
        plugins: Paths of all eligible plugins relative to dir_src.
        sub_dirs: Paths of all eligible subdirectories relative to dir_src.
        loose_files: Paths of all eligible loose files relative to dir_src.
        dir_src: Directory where mod files are stored.
    """
    for plugin in plugins:
        shortname = os.path.splitext(os.path.basename(plugin))[0]
        modgroups = "{}.modgroups".format(shortname)
        found = False
        for file in loose_files:
            if os.path.basename(file) == modgroups:
                found = True
                break
        for sub_dir in sub_dirs:
            for file in os.listdir(os.path.join(dir_src, sub_dir)):
                if file == modgroups:
                    found = True
                    break
        if not found:
            logger.warning("Modgroups for {} not found".format(shortname))


def check_readmes(plugins: list, sub_dirs: list, loose_files: list,
                  dir_src: os.PathLike):
    """Check if readmes are missing.

    Args:
        plugins: Paths of all eligible plugins relative to dir_src.
        sub_dirs: Paths of all eligible subdirectories relative to dir_src.
        loose_files: Paths of all eligible loose files relative to dir_src.
        dir_src: Directory where mod files are stored.
    """
    for plugin in plugins:
        shortname = os.path.splitext(os.path.basename(plugin))[0]
        readme = "{}.txt".format(shortname)
        found = False
        for file in loose_files:
            if os.path.basename(file) == readme:
                found = True
                break
        for sub_dir in sub_dirs:
            for file in os.listdir(os.path.join(dir_src, sub_dir)):
                if file == readme:
                    found = True
                    break
        if not found:
            logger.warning("Readme for {} not found".format(shortname))


def parse_fomod(dir_fomod: os.PathLike) -> (str, str, list, list):
    """Extract relevant information from fomod installation files.

    Args:
        dir_fomod: Directory that contains Info.xml and ModuleConfig.xml.

    Return:
        Extracted information (name, version, sub_dirs, loose_files).
        name: First <name> tag in Info.xml.
        version: First <version> tag in Info.xml.
        sub_dirs: All <folder> tags in ModlueConfig.xml.
        loose_files: All <file> tags in ModlueConfig.xml.
    """
    path = os.path.join(dir_fomod, "Info.xml")
    root = xml.etree.ElementTree.parse(path).getroot()
    version = root.find("Version").text
    name = root.find("Name").text

    path = os.path.join(dir_fomod, "ModuleConfig.xml")
    root = xml.etree.ElementTree.parse(path).getroot()
    sub_dirs = list()
    loose_files = list()
    for requiredInstallFiles in root.iterfind("requiredInstallFiles"):
        for folder in requiredInstallFiles.iterfind("folder"):
            sub_dirs.append(folder.get("source"))
        for file in requiredInstallFiles.iterfind("file"):
            loose_files.append(file.get("source"))
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
    return (name, version, sub_dirs, loose_files)


def find_bsa_name(path: os.PathLike) -> str:
    """Return bsa name that matches a plugin found in the directory or an empty
        string if no matching name is found.
    """
    plugins = find_plugins(path)
    if plugins:
        return "{}.bsa".format(os.path.splitext(plugins[0])[0])
    return ""


def find_plugins(source_dir: os.PathLike):
    """Find all plugins in a directory. Does not search in subdirectories."""
    return [file for file in os.listdir(source_dir) if is_plugin(file)]


def is_plugin(path: os.PathLike) -> bool:
    """Return True if the path has the extension of a plugin."""
    plugin_exts = [".esl", ".esp", ".esm"]
    return os.path.splitext(path)[1] in plugin_exts

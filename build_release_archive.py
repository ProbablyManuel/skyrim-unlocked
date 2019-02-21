import bsa
import config
import logging
import os
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree


def build_release_archive(dir_source, dir_target, archive_exe=None):
    """Build a release archive.

    Args:
        dir_source: The source directory for which the archive is built.
            It must contain a Fomod subdirectory with Info.xml and
            ModuleConfig.xml.
            Furthermore it must contain a subdirectory for every folder
            specified in ModuleConfig.xml. A subdirectory is expected to
            contain at most one plugin.
        dir_target: The target directory for the release archive.
        archive_exe: The executable that creates the bsa.
            If ommited no bsa will be created.
    """
    # Set up logger
    name_script = os.path.splitext(os.path.basename(__file__))[0]
    logfile = name_script + ".log"
    if os.path.isfile(logfile):
        os.remove(logfile)
    logger = logging.getLogger(name_script)
    logger.setLevel(logging.INFO)
    handler = logging.FileHandler(logfile)
    formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    # Validate arguments
    dir_source_fomod = os.path.join(dir_source, "Fomod")
    if not os.path.isdir(dir_source):
        logger.error("Source path " + dir_source + " is not valid")
        exit()
    if not os.path.isdir(dir_target):
        logger.error("Destination path " + dir_target + " is not valid")
        exit()
    if not os.path.isfile(os.path.join(dir_source_fomod, "Info.xml")):
        logger.error("Info.xml is missing in " + dir_source_fomod)
        exit()
    if not os.path.isfile(os.path.join(dir_source_fomod, "ModuleConfig.xml")):
        logger.error("ModuleConfig.xml is missing in " + dir_source_fomod)
        exit()
    # Get required subdirectories from ModuleConfig.xml
    path = os.path.join(dir_source_fomod, "ModuleConfig.xml")
    root = xml.etree.ElementTree.parse(path).getroot()
    sub_dirs = list()
    for installSteps in root.iterfind("installSteps"):
        for installStep in installSteps.iterfind("installStep"):
            for fileGroups in installStep.iterfind("optionalFileGroups"):
                for group in fileGroups.iterfind("group"):
                    for plugins in group.iterfind("plugins"):
                        for plugin in plugins.iterfind("plugin"):
                            for files in plugin.iterfind("files"):
                                for folder in files.iterfind("folder"):
                                    sub_dirs.append(folder.get("source"))
    # Validate subdirectories
    logger.info("Subdirectories required by the Fomod installer:")
    for sub_dir in sub_dirs:
        logger.info(sub_dir)
        if not os.path.isdir(os.path.join(dir_source, sub_dir)):
            logger.error("Subdirectory " + sub_dir + " is missing")
            exit()
        if len(find_plugins(os.path.join(dir_source, sub_dir))) > 1:
            logger.warning("Subdirectory " + sub_dir +
                           " contains multiple plugins")
    # Get version number and release name from info.xml
    path = os.path.join(dir_source_fomod, "Info.xml")
    root = xml.etree.ElementTree.parse(path).getroot()
    version = root.find("Version").text
    logger.debug("Release version is " + str(version))
    name_release = root.find("Name").text
    logger.debug("Release name is " + name_release)
    # Validate version stamp of plugins
    version_stamp = bytes("Version: " + version, "utf8")
    for sub_dir in sub_dirs:
        for plugin in find_plugins(os.path.join(dir_source, sub_dir)):
            path_plugin = os.path.join(dir_source, sub_dir, plugin)
            with open(path_plugin, "rb") as fh:
                if version_stamp not in fh.read():
                    logger.warning(os.path.basename(path_plugin) +
                                   " doesn't have the correct version stamp")
    with tempfile.TemporaryDirectory() as dir_temp:
        # dir_temp_fomod is the directory where the fomod tree will be created
        dir_temp_fomod = os.path.join(dir_temp, name_release)
        os.mkdir(dir_temp_fomod)
        # Copy fomod files to the fomod tree
        src = os.path.join(dir_source, "Fomod")
        dst = os.path.join(dir_temp_fomod, "Fomod")
        shutil.copytree(src, dst)
        # Copy sub directories to the fomod tree
        for sub_dir in sub_dirs:
            plugins = find_plugins(os.path.join(dir_source, sub_dir))
            if plugins and archive_exe:
                # Copy only the plugin
                plugin = plugins[0]
                dst = os.path.join(dir_temp_fomod, sub_dir)
                os.mkdir(dst)
                src = os.path.join(dir_source, sub_dir, plugin)
                dst = os.path.join(dir_temp_fomod, sub_dir, plugin)
                shutil.copy(src, dst)
                # Build the bsa
                name_bsa = plugin.replace(".esp", ".bsa")
                src = os.path.join(dir_source, sub_dir)
                dst = os.path.join(dir_temp_fomod, sub_dir, name_bsa)
                bsa.build_bsa(archive_exe, src, dst)
            else:
                # Copy everything
                src = os.path.join(dir_source, sub_dir)
                dst = os.path.join(dir_temp_fomod, sub_dir)
                shutil.copytree(src, dst)
        # Package fomod tree into a 7zip archive
        name_archive = name_release + " " + version + ".7z"
        # Remove whitespaces because GitHub doesn't like them
        name_archive = "_".join(name_archive.split())
        path_archive = os.path.join(dir_target, name_archive)
        if os.path.isfile(path_archive):
            os.remove(path_archive)
        cmd = ["7z", "a", path_archive, dir_temp_fomod]
        logger.debug("Running command \"" + " ".join(cmd) + "\"")
        sp = subprocess.run(cmd, stdout=subprocess.DEVNULL)
        sp.check_returncode()
        logger.info("Succesfully built archive for " + version + " of " +
                    name_release)


def find_plugins(source_dir):
    """Find all plugins in a directory. Does not search in subdirectories."""
    extensions = [".esl", ".esp", ".esm"]
    files = os.listdir(source_dir)
    plugins = [f for f in files if os.path.splitext(f)[1] in extensions]
    return plugins


if __name__ == '__main__':
    build_release_archive(config.dir_le, config.dir_repo)

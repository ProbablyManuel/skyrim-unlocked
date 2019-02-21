import config
import logging
import os
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree


def build_release_archive(dir_source, dir_target, bsa):
    """Build a release archive.

    Args:
        dir_source: The source directory for which the archive is built.
            It must contain a Fomod subdirectory with Info.xml and
            ModuleConfig.xml.
            Furthermore it must contain a subdirectory for every folder
            specified in ModuleConfig.xml. A subdirectory is expected to
            contain at most one plugin.
        dir_target: The target directory for the release archive.
        bsa: Pass True to pack loose files into a BSA.
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
        for file in os.listdir(os.path.join(dir_source, sub_dir)):
            if os.path.splitext(file)[1] == ".esp":
                plugin_path = os.path.join(dir_source, sub_dir, file)
                with open(plugin_path, "rb") as fh:
                    if version_stamp not in fh.read():
                        logger.warning(os.path.basename(file) + " doesn't have"
                                       "the correct version stamp")
    # dir_temp is the directory where temporary files will be stored
    dir_temp = tempfile.mkdtemp()
    # dir_temp_fomod is the directory where the fomod tree will be created
    dir_temp_fomod = os.path.join(dir_temp, name_release)
    os.mkdir(dir_temp_fomod)
    # Copy fomod files
    src = os.path.join(dir_source, "Fomod")
    dst = os.path.join(dir_temp_fomod, "Fomod")
    shutil.copytree(src, dst)
    # Copy sub directories
    for sub_dir in sub_dirs:
        if bsa:
            plugin = None
            for file in os.listdir(os.path.join(dir_source, sub_dir)):
                if os.path.splitext(file)[1] == ".esp":
                    plugin = file
            if plugin:
                src = os.path.join(dir_source, sub_dir, plugin)
                dst = os.path.join(dir_temp_fomod, sub_dir, plugin)
                shutil.copy(src, dst)
                # TODO: Build BSA
        else:
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
    # Clean up temporary directory
    shutil.rmtree(dir_temp)
    logger.info("Succesfully built archive for " + version + " of " +
                name_release)


if __name__ == '__main__':
    build_release_archive(config.dir_le, config.dir_repo, False)

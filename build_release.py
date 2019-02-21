#!/usr/bin/env python

import logging
import os
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree

""" DIR_REPO is the directory where the git repository for Skyrim Unlocked
is stored."""
DIR_REPO = "C:\\Users\\user\\Documents\\GitHub\\skyrim-unlocked"

""" DIR_LE is the directory where all files for Legendary Edition are stored.
It must contain a Fomod subdirectory with Info.xml and ModuleConfig.xml.
Furthermore it must contain a matching subdirectory for every source folder
specified in ModuleConfig.xml."""
DIR_LE = DIR_REPO

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

sanity_checks_failed = False
if not os.path.isdir(DIR_REPO):
    logger.error("The path to the repository is not valid.")
    sanity_checks_failed = True
if not os.path.isdir(DIR_LE):
    logger.error("The path to the LE files is not valid.")
    sanity_checks_failed = True
if not os.path.isfile(os.path.join(DIR_LE, "Fomod", "Info.xml")):
    logger.error("Info.xml is missing.")
    sanity_checks_failed = True
if not os.path.isfile(os.path.join(DIR_LE, "Fomod", "ModuleConfig.xml")):
    logger.error("ModuleConfig.xml is missing.")
    sanity_checks_failed = True
if sanity_checks_failed:
    exit()

# Get version number and release name from info.xml
path = os.path.join(DIR_LE, "Fomod", "Info.xml")
root = xml.etree.ElementTree.parse(path).getroot()
version = root.find("Version").text
logger.debug("Release version is " + str(version))
name_release = root.find("Name").text
logger.debug("Release name is " + name_release)
# Get required directories from ModuleConfig.xml
path = os.path.join(DIR_LE, "Fomod", "ModuleConfig.xml")
root = xml.etree.ElementTree.parse(path).getroot()
sub_dirs = list()
for installSteps in root.iterfind("installSteps"):
    for installStep in installSteps.iterfind("installStep"):
        for optionalFileGroups in installStep.iterfind("optionalFileGroups"):
            for group in optionalFileGroups.iterfind("group"):
                for plugins in group.iterfind("plugins"):
                    for plugin in plugins.iterfind("plugin"):
                        for files in plugin.iterfind("files"):
                            for folder in files.iterfind("folder"):
                                sub_dirs.append(folder.get("source"))
# Validate subdirectories
sanity_checks_failed = False
logger.info("Subdirectories required by the Fomod installer:")
for sub_dir in sub_dirs:
    logger.info(sub_dir)
    if not os.path.isdir(os.path.join(DIR_LE, sub_dir)):
        logger.error("Subdirectory " + sub_dir + " is missing.")
        sanity_checks_failed = True
if sanity_checks_failed:
    exit()
# Validate version stamp
version_stamp = bytes("Version: " + version, "utf8")
for sub_dir in sub_dirs:
    for file in os.listdir(os.path.join(DIR_LE, sub_dir)):
        if os.path.splitext(file)[1] == ".esp":
            plugin_path = os.path.join(DIR_LE, sub_dir, file)
            with open(plugin_path, "rb") as fh:
                if version_stamp not in fh.read():
                    logger.warning(os.path.basename(file) +
                                   " doesn't have the correct version stamp")

# DIR_TEMP is the directory where temporary files will be stored
DIR_TEMP = tempfile.mkdtemp()
# DIR_TEMP_FOMOD is the directory where the fomod tree will be created
DIR_TEMP_FOMOD = os.path.join(DIR_TEMP, name_release)
os.mkdir(DIR_TEMP_FOMOD)
# Copy fomod files
src = os.path.join(DIR_LE, "Fomod")
dst = os.path.join(DIR_TEMP_FOMOD, "Fomod")
shutil.copytree(src, dst)
# Copy sub directories
for sub_dir in sub_dirs:
    src = os.path.join(DIR_LE, sub_dir)
    dst = os.path.join(DIR_TEMP_FOMOD, sub_dir)
    shutil.copytree(src, dst)

# Package fomod tree into a 7zip archive
name_archive = name_release + " " + version + ".7z"
# Remove whitespaces because GitHub doesn't like them
name_archive = "_".join(name_archive.split())
path_archive = os.path.join(DIR_REPO, name_archive)
if os.path.isfile(path_archive):
    os.remove(path_archive)
cmd = ["7z", "a", path_archive, DIR_TEMP_FOMOD]
logger.debug("Running command \"" + " ".join(cmd) + "\"")
sp = subprocess.run(cmd, stdout=subprocess.DEVNULL)
sp.check_returncode()
# Clean up temporary directory
shutil.rmtree(DIR_TEMP)
logger.info("Succesfully packed version " + version + " of " + name_release)

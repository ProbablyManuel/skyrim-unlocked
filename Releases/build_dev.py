"""Build development archive.
Loose files are not packed into a bsa and version numbers are not added."""
import config
import logging
import release

logger = logging.getLogger(release.__name__)
logger.setLevel(logging.WARNING)
handler = logging.FileHandler("{}.log".format(release.__name__), "w")
logger.addHandler(handler)
try:
    release.build_release(config.DIR_REPO_LE,
                          warn_readmes=False)
except Exception as error:
    logger.exception(error)

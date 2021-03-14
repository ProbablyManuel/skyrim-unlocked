"""Build full release.
Loose files are packed into a bsa."""
import config
import logging
import release

logger = logging.getLogger(release.__name__)
logger.setLevel(logging.INFO)
formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
handler = logging.FileHandler("{}.log".format(release.__name__), "w")
handler.setFormatter(formatter)
logger.addHandler(handler)
try:
    release.build_release(dir_src=config.DIR_REPO_LE,
                          bsarch=config.BSARCH,
                          bsa_format="tes5",
                          bsa_compress=True,
                          warn_readmes=False)
    release.build_release(dir_src=config.DIR_REPO_SE,
                          bsarch=config.BSARCH,
                          bsa_format="sse",
                          bsa_compress=True,
                          warn_readmes=False)
except Exception as error:
    logger.exception(error)

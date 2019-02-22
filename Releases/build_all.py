"""Build release for Legendary and Special Edition.
Loose files are packed into a bsa."""
import config
import os
import release

src = config.dir_le
dst = os.path.join(config.dir_repo, "Releases")
release.build_release(src, dst, config.archive_exe_le)
src = config.dir_se
dst = os.path.join(config.dir_repo, "Releases")
release.build_release(src, dst, config.archive_exe_se)

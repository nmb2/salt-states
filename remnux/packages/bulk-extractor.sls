# Name: bulk_extractor
# Website: https://github.com/simsong/bulk_extractor/
# Description: Extract interesting strings from binary files.
# Category: Artifact Extraction and Decoding
# Author: https://github.com/simsong/bulk_extractor/blob/master/AUTHORS
# License: https://github.com/simsong/bulk_extractor/blob/master/COPYING
# Notes: 

include:
  - remnux.repos.sift
  - remnux.repos.openjdk

bulk-extractor:
  pkg.installed:
    - require:
      - pkgrepo: sift-repo
      - pkgrepo: openjdk-repo
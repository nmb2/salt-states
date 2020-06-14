# Name: Sysdig
# Website: https://github.com/draios/sysdig
# Description: Track and examine system activities on the local Linux system.
# Category: Linux Investigations: System
# Author: Sysdig Inc:  https://sysdig.com/about/
# License: https://github.com/draios/sysdig/blob/dev/COPYING
# Notes: 

include:
  - remnux.repos.draios
  - remnux.packages.linux-headers

remnux-sysdig:
  pkg.installed:
    - name: sysdig
    - require:
      - pkgrepo: draios
      - pkg: remnux-linux-headers

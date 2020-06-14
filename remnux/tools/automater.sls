# Name: Automater
# Website: http://www.tekdefense.com/automater/
# Description: OSINT automation tool
# Category: Examine browser malware: Websites
# Author: 1aN0rmus / TekDefense
# License: https://github.com/1aN0rmus/TekDefense-Automater/blob/master/LICENSE
# Notes: Automater.py

include:
  - remnux.packages.git

remnux-tools-automater:
  git.cloned:
    - name: https://github.com/1aN0rmus/TekDefense-Automater
    - target: /usr/local/automater
    - user: root
    - branch: master

remnux-tools-automater-binary:
  file.managed:
    - replace: False
    - name: /usr/local/automater/Automater.py
    - mode: 755
    - watch:
      - git: remnux-tools-automater

remnux-tools-automater-symlink:
  file.symlink:
    - name: /usr/local/bin/Automater.py
    - target: /usr/local/automater/Automater.py
    - mode: 755

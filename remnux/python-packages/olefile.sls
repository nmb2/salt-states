include:
  - remnux.python-packages.pip

olefile:
  pip.installed:
    - require:
      - sls: remnux.packages.python-pip

include:
  - remnux.packages.git
  - remnux.packages.python-pip
  - remnux.packages.libboost-python-dev
  - remnux.packages.libboost-thread-dev

remnux-pip-pyv8:
  pip.installed:
    - name: git+https://github.com/buffer/pyv8.git
    - require:
      - sls: remnux.packages.git
      - sls: remnux.packages.python-pip
      - sls: remnux.packages.libboost-python-dev
      - sls: remnux.packages.libboost-thread-dev

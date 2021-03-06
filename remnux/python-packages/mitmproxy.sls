# Source: https://mitmproxy.org/
# Authors: https://mitmproxy.org/about.html

include:
  - remnux.packages.libffi-dev
  - remnux.packages.libssl-dev
  - remnux.packages.libxslt1-dev
  - remnux.packages.libxml2-dev
  - remnux.packages.python-dev
  - remnux.packages.python-pip
  - remnux.packages.python3-pip

remnux-mitmproxy:
  pip.installed:
    - name: mitmproxy
    - bin_env: '/usr/bin/pip3'
    - require:
      - sls: remnux.packages.python-pip
      - sls: remnux.packages.python-dev
      - sls: remnux.packages.libffi-dev
      - sls: remnux.packages.libssl-dev
      - sls: remnux.packages.libxslt1-dev
      - sls: remnux.packages.libxml2-dev

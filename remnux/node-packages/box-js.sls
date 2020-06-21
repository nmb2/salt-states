# Name: box-js
# Website: https://github.com/CapacitorSet/box-js
# Description: nodejs tool to analyze malicious JavaScript
# Category: Examine browser malware: JavaScript
# Author: CapacitorSet
# License: https://github.com/CapacitorSet/box-js/blob/master/LICENSE
# Notes: box-js, box-export

include:
  - remnux.packages.nodejs
  - remnux.packages.npm
  - remnux.packages.curl

box-js:
  npm.installed:
    - require:
      - sls: remnux.packages.nodejs
      - sls: remnux.packages.npm
      - sls: remnux.packages.curl

remnux-node-packages-box-export-shebang:
  file.replace:
    - name: /usr/local/bin/box-export
    - pattern: '#!/usr/bin/env node'
    - repl: '#!/usr/bin/env node'
    - prepend_if_not_found: True
    - count: 1
    - require:
      - npm: box-js


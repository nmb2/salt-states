include:
  - remnux.scripts.pdf-parser
  - remnux.scripts.pdfobjflow

remnux-scripts:
  test.nop:
    - require:
      - sls: remnux.scripts.pdf-parser
      - sls: remnux.scripts.pdfobjflow
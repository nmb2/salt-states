include:
  - remnux.scripts.pdf-parser
  - remnux.scripts.pdfobjflow
  - remnux.scripts.pdfid
  - remnux.scripts.oledump
  - remnux.scripts.emldump
  - remnux.scripts.extractscripts
  - remnux.scripts.virustotal-search
  - remnux.scripts.base64dump
  - remnux.scripts.java_idx_parser
  - remnux.scripts.shellcode2exe-py
  - remnux.scripts.ex_pe_xor
  - remnux.scripts.brxor
  - remnux.scripts.nomorexor
  - remnux.scripts.xorbruteforcer

remnux-scripts:
  test.nop:
    - require:
      - sls: remnux.scripts.pdf-parser
      - sls: remnux.scripts.pdfobjflow
      - sls: remnux.scripts.pdfid
      - sls: remnux.scripts.oledump
      - sls: remnux.scripts.emldump
      - sls: remnux.scripts.extractscripts
      - sls: remnux.scripts.virustotal-search
      - sls: remnux.scripts.base64dump
      - sls: remnux.scripts.java_idx_parser
      - sls: remnux.scripts.shellcode2exe-py
      - sls: remnux.scripts.ex_pe_xor
      - sls: remnux.scripts.brxor
      - sls: remnux.scripts.nomorexor
      - sls: remnux.scripts.xorbruteforcer

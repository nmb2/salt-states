include:
  - remnux.config.docs
  - remnux.config.inetsim
  - remnux.config.wget

remnux-config:
  test.nop:
    - require:
      - sls: remnux.config.docs
      - sls: remnux.config.inetsim
      - sls: remnux.config.wget

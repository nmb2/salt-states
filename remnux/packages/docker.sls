# Name: Docker
# Website: https://www.docker.com
# Description: Run and manage containers.
# Category: Other Tasks
# Author: Docker Inc.
# License: https://github.com/moby/moby/blob/master/LICENSE
# Notes: 

include:
  - remnux.repos.docker

docker-docker-engine:
  pkg.removed:
    - name: docker-engine

docker-docker-ce:
  pkg.installed:
    - name: docker-ce
    - require:
      - pkg: docker-docker-engine
      - sls: remnux.repos.docker

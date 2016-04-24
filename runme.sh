#!/bin/sh

set -ex

SONARR_URL="http://download.sonarr.tv/v2/master/mono/NzbDrone.master.2.0.0.3953.mono.tar.gz"

wget --progress=dot -e dotbytes=2M \
  ${SONARR_URL}
tar -xf NzbDrone.master.*.mono.tar.gz

cp -a NzbDrone/* sonarr/lib/

rm -rf NzbDrone*

yaml-to-json.py config.yaml > sonarr/CONTROL/config.json
apkg-tool create sonarr

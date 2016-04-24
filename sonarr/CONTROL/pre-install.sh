#!/bin/sh
# pre-install script for sonarr

set -e

APKG_PKG_DIR=/usr/local/AppCentral/sonarr

case "$APKG_PKG_STATUS" in
    install)
    ;;

    upgrade)
    ;;

    *)
        echo "pre-install called with unknown argument \`$1'" >&2
        exit 1
    ;;
esac

exit 0

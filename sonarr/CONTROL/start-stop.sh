#!/bin/sh

. /etc/script/lib/command.sh

. /lib/lsb/init-functions

MONO=$(which mono)
APKG_PKG_DIR=/usr/local/AppCentral/sonarr

USERNAME=admin

DAEMON_OPTS=""

PATH=${APKG_PKG_DIR}/bin/:${PATH}
DESC="smart PVR for newsgroup and bittorrent users"
NAME=sonarr
DAEMON=$(which $NAME)
PIDFILE=/var/run/$NAME.pid

# libmediainfo and libzen
export LD_LIBRARY_PATH=${APKG_PKG_DIR}/lib:$LD_LIBRARY_PATH

[ -x "$DAEMON" ] || exit 0

do_start() {
    RETVAL=1

    if [ -e ${PIDFILE} ]; then
        if ! kill -0 $(cat ${PIDFILE}) &> /dev/null; then
            rm -f $PIDFILE ${APKG_PKG_DIR}/etc/*.pid
        fi
    fi

    if pgrep -f "^${MONO} --debug $(realpath ${APKG_PKG_DIR})" > /dev/null 2>&1; then
        log_progress_msg "(already running?)"
    else
        start-stop-daemon --chuid $USERNAME --start --pidfile $PIDFILE \
            --make-pidfile --exec $DAEMON --background -- $DAEMON_OPTS
        RETVAL="$?"
    fi

    log_end_msg $RETVAL
}

do_stop() {
    RETVAL=1

    if ! pgrep -f "^${MONO} --debug $(realpath ${APKG_PKG_DIR})" > /dev/null 2>&1; then
        log_progress_msg "(not running?)"
    else
        start-stop-daemon --stop --quiet --retry 15 --pidfile $PIDFILE
        RETVAL="$?"
    fi

    # Many daemons don't delete their pidfiles when they exit.
    rm -f $PIDFILE ${APKG_PKG_DIR}/etc/*.pid

    log_end_msg "$RETVAL"
}

case "$1" in
    start)
        echo "Starting $DESC" "$NAME..."
        do_start
    ;;

    stop)
        echo "Stopping $DESC $NAME..."
        do_stop
    ;;

    *)
        echo "start-stop called with unknown argument \`$1'" >&2
        exit 3
    ;;
esac

exit 0

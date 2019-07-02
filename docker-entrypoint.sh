#!/bin/sh

DIR=/docker-entrypoint.d

if [ -d "$DIR" ]; then
    /bin/run-parts --verbose "$DIR"
fi

exec "$@"

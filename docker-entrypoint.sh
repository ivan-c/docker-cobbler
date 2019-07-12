#!/bin/sh

set -eu

DIR=/docker-entrypoint.d

if [ -d "$DIR" ]; then
    for entrypoint_script in /docker-entrypoint.d/*; do
        test -e "$entrypoint_script" || continue

        echo running $entrypoint_script
        $entrypoint_script .
    done
fi

echo entrypoint script complete
echo executing $@
exec "$@"

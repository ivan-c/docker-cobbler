#!/bin/sh

set -eu

DIR=/post-deploy.d

if [ -d "$DIR" ]; then
    for postdeploy_script in "$DIR"/*; do
        test -e "$postdeploy_script" || continue

        echo running $postdeploy_script
        $postdeploy_script .
    done
fi

echo post-deploy script complete

if [ -z "$@" ]; then exit 0; fi

echo executing $@

#exec "$@"


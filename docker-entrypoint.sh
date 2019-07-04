#!/bin/sh

DIR=/docker-entrypoint.d

if [ -d "$DIR" ]; then
    run-parts --verbose "$DIR"
fi

# update cobblerd host
sed  -i -e '/^server/ s/:.*$/: cobblerd/' /etc/cobbler/settings

echo entrypoint script complete
echo executing $@
exec "$@"

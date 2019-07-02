#!/bin/sh

DIR=/docker-entrypoint.d

if [ -d "$DIR" ]; then
    run-parts --verbose "$DIR"
fi

# proxy XMLRPC requests from cobbler-web:80/cobbler_api to cobblerd:25151
sed  -i 's|127.0.0.1|cobblerd|g' /etc/httpd/conf.d/cobbler.conf

# edit cobblerd default to listen on every interface
# https://github.com/cobbler/cobbler/blob/v2.8.4/cobbler/cobblerd.py#L108
sed  -i "s|remote.CobblerXMLRPCServer(('127.0.0.1', port))|remote.CobblerXMLRPCServer(('0.0.0.0', port))|g" /usr/lib/python2.7/site-packages/cobbler/cobblerd.py

# update cobblerd host
sed  -i -e '/^server/ s/:.*$/: cobbler-web/' /etc/cobbler/settings

echo entrypoint script complete
echo executing $@
exec "$@"

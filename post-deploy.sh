#!/bin/sh

set -eu

docker-compose exec cobblerd docker-post-deploy.sh

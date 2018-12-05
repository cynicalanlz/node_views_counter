#!/bin/bash

set -o errexit
set -o nounset

/usr/bin/supervisord -c /app/supervisor.conf
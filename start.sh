#!/bin/bash

set -o errexit
set -o nounset

/usr/bin/supervisord -c supervisor.conf
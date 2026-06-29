#!/usr/bin/env bash
set -e

chmod +x ./nrfutil
./nrfutil install sdk-manager
./nrfutil sdk-manager toolchain install --ncs-version v3.1.1
./nrfutil sdk-manager toolchain launch --ncs-version v3.1.1 --shell << 'EOF'
west init -m https://github.com/nrfconnect/sdk-nrf --mr v3.1.1 v3.1.1
cd v3.1.1
west update
EOF

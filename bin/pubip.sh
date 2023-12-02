# shellcheck shell=bash
# Get public ip of device
dig +short txt ch whoami.cloudflare @1.1.1.1 | tr -d '"'

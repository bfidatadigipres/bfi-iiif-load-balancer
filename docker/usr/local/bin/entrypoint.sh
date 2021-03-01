#!/bin/bash
#############################################################
# Script name : entrypoint
# Description : Entrypoint for NGINX Proxy Manager container.
# Author      : Daniel Grant <daniel.grant@digirati.com>
#############################################################

set -o errexit

main() {
  show_motd
  copy_configs
  run_nginx
}

log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [${1}] ${2}"
}

log_info() {
  log "INFO" "${1}"
}

show_motd() {
  log_info "Starting BFI IIIF Load Balancer..."
}

copy_configs() {
  # /data/nginx/custom/server_proxy.conf
  mkdir -pv "/data/nginx/custom"
  ln -sfv "/etc/bfi/iiif-load-balancer/server_proxy.conf" "/data/nginx/custom"

  # /data/nginx/custom/ssl/bfi-iiif-root-ca.crt
  mkdir -pv "/data/nginx/custom/ssl"
  ln -sfv "/run/secrets/ssl/bfi-iiif-root-ca.crt" "/data/nginx/custom/ssl"
}

run_nginx() {
  log_info "Executing \"/init\"..."
  set -e
  exec "/init"
}

main

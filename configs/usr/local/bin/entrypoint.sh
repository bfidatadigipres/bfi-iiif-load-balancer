#!/bin/bash
########################################################
# Script name : entrypoint
# Description : Entrypoint for NGINX container.
# Author      : Daniel Grant <daniel.grant@digirati.com>
########################################################

set -o errexit

main() {
  show_motd
  prepare_conf
  run_nginx "$@"
}

log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] [${1}] ${2}"
}

log_info() {
  log "INFO" "${1}"
}

render_template() {
  local target=${1}
  local vars=${2}
  log_info "Rendering template '${target}'..."
  envsubst "${vars}" < "${target}" > "${target}.rendered" && rm "${target}" && mv "${target}.rendered" "${target}"
}

show_motd() {
  log_info "Starting NGINX..."
}

prepare_conf() {
  render_template "/etc/nginx/sites-available/bfinationalarchiveviewer-dev.bfi.org.uk.conf" "\${DEV_BFI_NATIONAL_ARCHIVE_VIEWER_PROTOCOL} \${DEV_BFI_NATIONAL_ARCHIVE_VIEWER_HOST} \${DEV_BFI_NATIONAL_ARCHIVE_VIEWER_PORT}"
  render_template "/etc/nginx/sites-available/bfinationalarchiveviewer.bfi.org.uk.conf" "\${BFI_NATIONAL_ARCHIVE_VIEWER_PROTOCOL} \${BFI_NATIONAL_ARCHIVE_VIEWER_HOST} \${BFI_NATIONAL_ARCHIVE_VIEWER_PORT}"
}

run_nginx() {
  log_info "Executing \"$*\"..."
  set -e
  exec "$@"
}

main "$@"

#!/bin/bash

log_info () {
    echo "[INFO] $1"
}

log_error () {
    echo "[ERROR] $1" >&2
}

check_command () {
    command -v "$1" >/dev/null 2>&1 || {
        log_error "Dependência '$1' não encontrada."
        exit 1
    }
}
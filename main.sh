#!/bin/bash

. ./config.sh
. ./utils.sh
. ./uploader.sh

check_dependencies() {
    # Check if required commands are available
    check_command "aws"
    check_command "jq"
}

log_info "Iniciando o script de upload dos arquivos em $LOCAL_DIR ..."

for file in "$LOCAL_DIR"/*; do
    filename=$(basename "$file")
    log_info "Processando arquivo: $filename"
    upload_files "$file" "$filename"
done

log_info "Todos os arquivos foram processados com sucesso."

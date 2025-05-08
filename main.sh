#!/bin/bash

BASE_DIR=$(dirname "$(realpath "$0")")

. "$BASE_DIR/config.sh"
. "$BASE_DIR/utils.sh"
. "$BASE_DIR/providers/s3.sh"
# . "$BASE_DIR/providers/gcp.sh"
# . "$BASE_DIR/providers/blobs.sh"

check_dependencies() {
    # Check if required commands are available
    check_command "aws"
    check_command "gcloud"
    check_command "az"
}

# Process command line arguments
while getopts "p:" opt; do
    case $opt in
        p)
            if [ "$OPTARG" == "aws" ]; then
                upload_files="upload_files_s3"
            elif [ "$OPTARG" == "gcp" ]; then
                upload_files="upload_files_gcp"
            elif [ "$OPTARG" == "azure" ]; then
                upload_files="upload_files_azure"
            else
                log_error "Provedor inválido. Use 'aws', 'gcp' ou 'azure'."
                exit 1
            fi
            ;;
        *)
            log_error "Uso: ./$0 -p [aws | gcp | azure]"
            exit 1
            ;;
    esac
done

if [ -z "$upload_files" ]; then
    log_error "Nenhum provedor especificado. Use -p [aws | gcp | azure]."
    exit 1
fi

log_info "Iniciando o script de upload dos arquivos em $LOCAL_DIR ..."

for file in "$LOCAL_DIR"/*; do
    filename=$(basename "$file")
    log_info "Processando arquivo: $filename"
    upload_files "$file" "$filename"
    if [ $? -ne 0 ]; then
        log_error "Erro ao processar o arquivo: $filename"
        exit 1
    elif [ -f "$file" ]; then
        log_info "Arquivo $filename já existe no bucket. Pulando o upload."
        continue
    else
        log_info "Arquivo $filename enviado com sucesso."
    fi
done

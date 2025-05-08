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


#### Listar todos os arquivos para envio em lotes ####
file_list=$(find "$LOCAL_DIR" -type f)
if [ -z "$file_list" ]; then
    log_error "Nenhum arquivo encontrado no diretório '$LOCAL_DIR'."
    exit 0
    else
        log_info "Arquivos encontrados para upload: $LOCAL_DIR"
        echo "$file_list" | xargs -n1 basename
fi

log_info "Iniciando o script de upload dos arquivos em $LOCAL_DIR ..."

upload_files 


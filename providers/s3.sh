#!/bin/bash

BASE_DIR=$(dirname "$(realpath "$0")")/..


source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/utils.sh"

upload_files() {

    # Check if the local directory exists
    if [ ! -d "$LOCAL_DIR" ]; then
        log_error "Diretório local '$LOCAL_DIR' não encontrado."
        exit 1
    fi

    # Upload files to the S3 bucket
    aws s3 cp "$LOCAL_DIR" "s3://$BUCKET_NAME/$DESTINATION_PATH/" --recursive

    if [ $? -eq 0 ]; then
        log_info "Arquivos enviados com sucesso para o bucket S3 's3://$BUCKET_NAME/$DESTINATION_PATH/'."
    else
        log_error "Falha ao enviar arquivos para o bucket S3 's3://$BUCKET_NAME/$DESTINATION_PATH/'."
        exit 1
    fi
}
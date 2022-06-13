#!/bin/bash

set -e

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [info]: $1"
}

if [ -z $INPUT_LOG_LEVEL ]; then
    log "Log Level not provided, using default: info"
    logLevel="info"
else 
    logLevel=$INPUT_LOG_LEVEL
fi

if [ -z $INPUT_IMAGE_RESOLUTION ]; then
    log "Image resize resolution not provided, using default: 1920"
    resolution="1920"
else 
    resolution=$INPUT_IMAGE_RESOLUTION
fi

if [ -z $INPUT_COMPRESSION_FACTOR ]; then
    log "Image compression factor not provided, using default: 20"
    compressionFactor="20"
else 
    compressionFactor=$INPUT_COMPRESSION_FACTOR
fi

if [ -z $INPUT_BRANCH ]; then
    log "Branch not provided, using default: publish"
    branch="publish"
else 
    branch=$INPUT_BRANCH
fi

if [ -z $INPUT_SUPPRESS_MKDOCS_LOGS ]; then
    log "Suppress MkDocs Logs variable not provided, using default: true"
    suppressMkdocsLogs="true"
else 
    suppressMkdocsLogs=$INPUT_SUPPRESS_MKDOCS_LOGS
fi

log "\nParameters:"
log "Website ID: ${INPUT_WEBSITEID}"
log "Log Level: ${logLevel}"
log "Branch: ${branch}"
log "Image Resolution: ${resolution}"
log "Image Compression Factor: ${compressionFactor}"
log "Suppress MkDocs Logs: ${suppressMkdocsLogs}\n"

log "Cloning the docs repository: ${GITHUB_REPOSITORY}"
git clone -b $branch "https://github.com/${GITHUB_REPOSITORY}" /app/docs

cd /app/code
npm run start "/app/docs" "${logLevel}"

cd /app
cp /app/docs/mkdocs.yml /app
chmod +x /app/code/scripts/*

log "Compressing Images..."
/app/code/scripts/compress.sh "/app/docs" "${resolution}" "${compressionFactor}"

log "Building Website..."
/app/code/scripts/build.sh "/app/docs" "${suppressMkdocsLogs}"

log "Compressing Images..."
/app/code/scripts/upload.sh "/app/docs" "${INPUT_WEBSITEID}" "${INPUT_TOKEN}"

#!/bin/bash

set -e

echo "Cloning the docs repostiory: ${GITHUB_REPOSITORY}"
# git clone "https://github.com/${GITHUB_REPOSITORY}" /app/docs
git clone "https://github.com/arkalim/obsidian-vault" /app/docs
mkdocs new test
python3 
# ls -alh /app/docs

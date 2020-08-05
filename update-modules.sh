#!/usr/bin/env bash
# Copyright 2020, Collabora, Ltd.
# SPDX-License-Identifier: BSL-1.0
# update-modules.sh - iterates through all files in the cmake-modules repo,
# and copies them to the target directory if they already exist there.
#
# Run to update any CMake modules from the rpavlik/cmake-modules repo.
# You can either pass the target directory, or have the target directory as your current directory.
set -e
MODULES_DIR=$(cd $(dirname $0) && pwd)

(
    if [ "x$1" != "x" ]; then
        cd "$1"
    fi
    
    # Look through nearly every file in the cmake-modules repo, but don't copy this file to your project!
    (cd $MODULES_DIR && git ls-files | grep -v "update-modules") | while read -r relative; do
        if [ -f "${relative}" ]; then
            echo "${relative}"
            cp "${MODULES_DIR}/${relative}" .
        fi
    done
)

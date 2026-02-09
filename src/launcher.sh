#
# Copyright 2026 the original author jacky.eastmoon
#

# ------------------- shell setting -------------------

#!/bin/bash
set -e

# ------------------- declare variable -------------------

IMAGE_NAME=hello-world

# ------------------- declare function -------------------

# Use loop statement to find options in, if find it call processing function by LOOP_CALLBACK variable.
function find-options() {
    for arg in "${@}"; do
      if [[ ${arg} =~ -+[a-zA-Z1-9]* ]]; then
          IFS='=' read -ra ADDR <<< "${arg}"
          ${LOOP_CALLBACK} ${ADDR[0]} "${ADDR[1]}"
      fi
    done
}

# ------------------- Main method -------------------

function check-container() {
    docker image inspect ${IMAGE_NAME} >/dev/null || (
        docker pull ${IMAGE_NAME}
    )
}

function container() {
    [ ! -e "${PWD}/cache" ] && mkdir -p "${PWD}/cache" || true
    echo `date` > "${PWD}/cache/$(date +%Y%m%d%H%M%S)"
    docker run -ti --rm ${IMAGE_NAME}
}

function pre-action() {
    key=${1}
    value=${@:2}
    case ${key} in
        "--clean")
            [ -e "${PWD}/cache" ] && rm -rf "${PWD}/cache" || true
            ;;
    esac
}

function post-action() {
    key=${1}
    value=${@:2}
    case ${key} in
        "--output")
            [ ! -e "${PWD}/${value}" ] && mkdir "${PWD}/${value}" || true
            [ -e "${PWD}/cache" ] && cp -a "${PWD}/cache/." "${PWD}/${value}/" || true
            ;;
    esac
}

# ------------------- execute script -------------------

check-container
LOOP_CALLBACK=pre-action
find-options "${@}"
container "${@}"
LOOP_CALLBACK=post-action
find-options "${@}"

#
# Copyright 2026 the original author jacky.eastmoon
#

# ------------------- shell setting -------------------

#!/usr/bin/env zsh

# ------------------- declare variable -------------------

IMAGE_NAME=hello-world

# ------------------- declare function -------------------

# Use loop statement to find options in, if find it call processing function by LOOP_CALLBACK variable.
function find_options() {
    for arg in "${@}"; do
      if [[ ${arg} =~ -+[a-zA-Z1-9]* ]]; then
          local ADDR=("${(@s:=:)arg}")
          ${LOOP_CALLBACK} ${ADDR[1]} "${ADDR[2]}"
      fi
    done
}

# ------------------- Main method -------------------

function check_container() {
    docker image inspect ${IMAGE_NAME} >/dev/null || (
        docker pull ${IMAGE_NAME}
    )
}

function container() {
    [ ! -e "${PWD}/cache" ] && mkdir -p "${PWD}/cache" || true
    echo `date` > "${PWD}/cache/$(date +%Y%m%d%H%M%S)"
    docker run -ti --rm ${IMAGE_NAME}
}

function pre_action() {
    key=${1}
    value=${@:2}
    case ${key} in
        "--clean")
            [ -e "${PWD}/cache" ] && rm -rf "${PWD}/cache" || true
            ;;
    esac
}

function post_action() {
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

check_container
LOOP_CALLBACK=pre_action
find_options "${@}"
container "${@}"
LOOP_CALLBACK=post_action
find_options "${@}"

#!/bin/bash

function _curl ()
{
    if [[ -n "${ENABLE_DEBUG}" ]] || [[ -n "${DEBUG_CURL}" ]]
    then
        curl "${@}"
    else
        curl --silent "${@}"
    fi
    echo
}

function curljsonp ()
{
    _curl  -X POST -H "Content-Type: application/json" "${@}"
}

function rawurlencode ()
{
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ ))
    do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}" ;;
            * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

export -f _curl
export -f curljsonp
export -f rawurlencode
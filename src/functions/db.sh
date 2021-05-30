#!/bin/bash


if [[ ! "$(type -t _curl)" == 'function' ]]
then
    echo "Missing CURL functions" >&2
    return 251
fi

function validate_api_url ()
{
    local apiURL

    apiURL=${1:-${ORBIT_DB_API_URL}}

    if [[ -z "${apiURL}" ]]
    then
        echo "--api-url=<url> is required or set 'ORBIT_DB_API_URL'" >&2
        return 63
    fi

    echo "${apiURL}"

}



function db.create ()
{
    eval "$(docopts -A args -V - -h - : "$@" <<EOF
Usage: db.create (DB_NAME | --db-name=DB_NAME) (DB_TYPE | --db-type=DB_TYPE) [options]

Options:
      --api-url=<url>       Url for api server
      --help                Show help options.
      --version             Print program version.
----
db.create 0.1.0
EOF
)"

local apiURL
local dbName
local dbType

# shellcheck disable=SC2154
apiURL=$(validate_api_url "${args[--api-url]}") || return $?

dbName=${args[DB_NAME]:-${args[--db-name]}}
dbType=${args[DB_TYPE]:-${args[--db-type]}}

curljsonp -d@- "${apiURL}/db" < <(
    jq -n \
    --arg dbName "${dbName}" \
    --arg dbType "${dbType}" \
    '.create  = true |
    .dbname = $dbName |
    .type = $dbType'
) | jq
}


function db.open ()
{
    local apiURL
    local dbAddr

    apiURL=$(validate_api_url "${2}") || return $?

    if [[ -z "${1}" ]]
    then
        echo "DB address is required" >&2
        return 252
    fi    

    dbAddr=$(rawurlencode "${1}")

    if [[ -z "${ORBIT_DB_ENTRIES_TIMEOUT}" ]]
    then
        curljsonp -d "{\"awaitOpen\": false}" "${apiURL}/db/${dbAddr}" | jq
    else
        curljsonp -d "{\"awaitOpen\": false, \"fetchEntryTimeout\": ${ORBIT_DB_ENTRIES_TIMEOUT}}" "${apiURL}/db/${dbAddr}" | jq
    fi
}


export -f db.create
export -f db.open
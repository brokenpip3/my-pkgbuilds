#!/usr/bin/env bash

set +x

_log() {
    local level=$1
    local msg=$2
    local ts=
    ts=$(date -u --iso-8601=seconds)
    printf "%s - %s - %s" "${ts}" "${level}" "${msg}"
}

extract_info() {
    local re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)$"
    if [[ ${1} =~ $re ]]; then
      local protocol=${BASH_REMATCH[1]}
      local separator=${BASH_REMATCH[2]}
      local hostname=${BASH_REMATCH[3]}
      local user=${BASH_REMATCH[4]}
      local reponame=${BASH_REMATCH[5]}
    fi
    [[ ${hostname} != 'github.com' ]] && _log WARNING "Sources not hosted on github.com"
    local repo="$user/$reponame"
    printf "%s:%s:%s\n" "$pkgname" "$repo" "$pkgver"
}

json_output(){
    local lastl=$(echo "${1}" | wc -l)
    local line=0
    printf '{\"include\":['
    while read pkg; do
        line=$(($line + 1))
        local p=$(printf ${pkg,,}|cut -d ':' -f 1)
        local r=$(printf ${pkg,,}|cut -d ':' -f 2)
        local v=$(printf ${pkg,,}|cut -d ':' -f 3)
        printf '{\"pkg\":\"%s\",\"repo\":\"%s\",\"ver\":\"%s\"}' $p $r $v
        [[ $line -ne $lastl ]] && printf ","
    done <<< ${1}
    printf "]}"
}

loop(){
    for i in ${1}/*; do
        [[ $i != *-git ]] && { source $i/PKGBUILD; extract_info ${url}; } || continue
    done
}

pkg_list=$(loop packages)
json_output "${pkg_list}"

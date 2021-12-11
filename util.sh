#!/bin/bash

remove_quotes() {
    ORIGIN=$1
    # https://stackoverflow.com/a/16623897/9076327 
    BEGIN_QUOTE_REMOVED="${ORIGIN#'"'}"
    QUOTES_REMOVED="${BEGIN_QUOTE_REMOVED%'"'}"
    echo "${QUOTES_REMOVED}"
}

# https://stackoverflow.com/a/10797966/9076327
urlencode() {
    local data
    if [[ $# != 1 ]]; then
        echo "Usage: $0 string-to-urlencode"
        return 1
    fi
    data="$(curl -s -o /dev/null -w %{url_effective} --get --data-urlencode "$1" "")"
    if [[ $? != 3 ]]; then
        echo "Unexpected error" 1>&2
        return 2
    fi
    echo "${data##/?}"
    return 0
}

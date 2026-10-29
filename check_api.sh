#!/bin/bash

if [ $# -lt 1 ]; then
    echo 'The link was not passed as an argument'
    exit 1
fi

all_available=true

for arg in "$@" ; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "$arg")
    if [ "$status" -eq "200" ]; then
        echo "API '$arg' is available"
    else
        echo "API '$arg' is unavailable: http_code = $status"
	all_available=false
    fi
done

if [ "$all_available" = false ]; then
    exit 1
fi

exit 0

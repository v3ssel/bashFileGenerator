#!/bin/bash/

function log_deletion () {
    echo "Where is 'trasher.log'? (default: .)"
    read trasher
    file="$(cat $trasher/trasher.log | grep -E " -" | awk '{print $1}')"

    for i in $file; do
        echo "Deleted: $i"
        sudo rm -rf $i
    done
}

function date_deletion () {
    echo "Inpute start date and time, exp: 2022-10-01 11:09"
    read START_DATE START_TIME
    echo "Inpute end date and time, exp: 2022-10-01 11:11"
    read END_DATE END_TIME
    sudo find / -newermt "$START_DATE $START_TIME" -not -newermt "$END_DATE $END_TIME" 2>/dev/null -delete
    echo "All files created in this interval were deleted"
}

function mask_deletion () {
    echo "Input a mask, e.g.: abc_011022"
    read mask

    echo "Where is 'trasher.log'? (default: .)"
    read trasher
    file="$(cat $trasher/trasher.log | grep -E " -" | awk '{print $1}')"
    for i in $file; do
        e=$(basename $i)
        if [[ ${e##*_} == ${mask##*_} ]]; then
            squizzy_mask=$(sed 's/./&\n/g' <<< ${e%%_*} | awk '!a[$1]++' | sed ':a;N;s/\n//;ba')
            if [[ $squizzy_mask == ${mask%%_*} ]]; then
                echo "Deleted: $i"
                sudo rm -rf $i
            fi
        fi
    done
}

if [[ $# -ne 1 ]]; then
    echo "Expected 1 arg: [123], 1 - log deletion; 2 - date deletion; 3 - delete by mask"
    exit 0
fi

if ! [[ $1 =~ ^[1-3]$ ]]; then
    echo "1 - log deletion; 2 - date deletion; 3 - delete by mask"
    exit 0
fi

if [[ $1 -eq 1 ]]; then
    log_deletion
fi

if [[ $1 -eq 2 ]]; then
    date_deletion
fi

if [[ $1 -eq 3 ]]; then
    mask_deletion
fi

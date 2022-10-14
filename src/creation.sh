#!/bin/bash

function create_dirs () {
    for (( i=0; i < ${count_dirs}; i++ )); do
        directory=$(give_that_dir_a_name)
        local tries_dirs=0
        while [[ -d "${path_}${directory}_$(date +%d%m%y)" ]]; do
            directory=$(give_that_dir_a_name)
            ((tries_dirs++))
            if [[ tries_dirs -gt 15 ]]; then
                echo "Error! All possible names for directories are occupied"
                exit 0
            fi
        done
        local that_dir="${path_}/${directory}_$(date +%d%m%y)/"
        is_enough_space
        sudo mkdir $that_dir
        echo "$that_dir $(date +%d.%m.%y_%H:%M:%S) -" >> trasher.log
        create_files_in_that_dir $that_dir
        path_="$(sudo find / -type d | grep -v -e sbin -e bin -e sys -e proc -e dev -e run -e snap -e boot | shuf -n1)"
        count_files=$[ $RANDOM % 2000 + 1 ]
    done
}

function give_that_dir_a_name () {
    squizzy_dirs=$(sed 's/./&\n/g' <<< $words_dirs | awk '!a[$1]++' | sed ':a;N;s/\n//;ba')
    local dir_name=""
    for (( i=0; i < ${#squizzy_dirs}; i++ )); do
        local rand=$(( $RANDOM % 10 + 1 ))
        for (( j=0; j < rand; j++ )); do
            dir_name+=${squizzy_dirs:$i:1}
        done
    done
    if [[ ${#dir_name} -lt 5 ]]; then
        for (( i=0; i < 4; i++ )); do
            dir_name+=${squizzy_dirs:(( ${#squizzy_dirs}-1 )):1}
        done
    fi
    echo $dir_name
}


function create_files_in_that_dir () {
    for (( L=0; L < $count_files; L++ )); do
        local file_name=$(generate_a_name)
        local tries_files
        while [[ -f "${1}/${file_name}" ]]; do
            file_name=$(generate_a_name)
            ((tries_files++))
            if [[ tries_files -gt 50 ]]; then
                echo "Error! All possible names for files are occupied"
                exit 0
            fi
        done
        is_enough_space
        sudo fallocate -l ${size_files^^} ${1}${file_name}
        echo "${1}${file_name} $(date +%d.%m.%y_%H:%M:%S) $size_files" >> trasher.log
    done
}

function generate_a_name () {
    squizzy_fname=$(sed 's/./&\n/g' <<< ${words_files%%.*} | awk '!a[$1]++' | sed ':a;N;s/\n//;ba')
    squizzy_ftype=$(sed 's/./&\n/g' <<< ${words_files##*.} | awk '!a[$1]++' | sed ':a;N;s/\n//;ba')
    local file_name=""
    for (( I=0; I < ${#squizzy_fname}; I++ )); do
        local rand=$(( $RANDOM % 10 + 1 ))
        for (( J=0; J < rand; J++ )); do
            file_name+=${squizzy_fname:$I:1}
        done
    done
    if [[ ${#file_name} -lt 5 ]]; then
        for (( i=0; i < 4; i++ )); do
            file_name+=${squizzy_fname:(( ${#squizzy_fname}-1 )):1}
        done
    fi
    file_name+="."
    for (( I=0; I < ${#squizzy_ftype}; I++ )); do
        local rand=$(( $RANDOM % 10 + 1 ))
        for (( J=0; J < rand; J++ )); do
            file_name+=${squizzy_ftype:$I:1}
        done
    done
    file_name+="_$(date +%d%m%y)"
    echo "${file_name}"
}

function is_enough_space () {
    free_size=$(df -h / | tail -1 | awk '{print $4}')
    if [[ ${free_size: -1} == "M" ]]; then
        echo "Error! Not enought space left on the device"
        end_time=$(date +%H:%M:%S_%d.%m.%y)
        end_time_sec=$(date +%s)
        echo "Script_started: $start_time Script_ended: $end_time Script_uptime(sec): $(( $end_time_sec-$start_time_sec ))" | tee -a trasher.log
        exit 0
    fi
}

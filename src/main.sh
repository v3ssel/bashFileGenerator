#!/bin/bash
. creation.sh

export words_dirs=$1
export words_files=$2
export size_files=$3
export path_="$(sudo find / -type d | grep -v -e sbin -e bin -e sys -e proc -e dev -e run -e snap -e boot | shuf -n1)"
export count_dirs=$[ $RANDOM % 100 + 1 ] 
export count_files=$[ $RANDOM % 2000 + 1 ]

if [[ $# -ne 3 ]]; then
    echo -e "Expected 3 args:\nmain.sh [folders letters(7)] [files letters(7)].[extension letters(3)] [size of files(<100Mb)]"
    exit 0
fi

if ! [[ $words_dirs =~ ^[a-zA-Z]{1,7}$ ]]; then
    echo "The letters of the folder can only be of the English alphabet, the name must not be longer than 7"
    exit 0
fi

if ! [[ $words_files =~ ^[a-zA-Z]{1,7}[.][a-zA-Z]{1,3}$ ]]; then
    echo "File letters can only be of the English alphabet, the name must not be longer than 7, and the extension must not be longer than 3."
    exit 0
fi

if ! [[ $size_files =~ ^[1-9][0-9]?[0]?(m|M)(b|B)$ ]]; then
    echo "The size is not a number or the type is not specified: e.g. 15mb"
    exit 0
fi

export start_time=$(date +%H:%M:%S_%d.%m.%y)
export start_time_sec=$(date +%s)
create_dirs
end_time=$(date +%H:%M:%S_%d.%m.%y)
end_time_sec=$(date +%s)
echo "Script_started: $start_time Script_ended: $end_time Script_uptime(sec): $(( $start_time_sec-$end_time_sec ))" | tee -a trasher.log

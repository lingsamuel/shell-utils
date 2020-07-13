#!/bin/bash

join_array() {
    local IFS="$1"
    shift
    echo "$*"
}

detect_array_start_index() {
    local x=(y)
    case ${x[1]} in
    '') echo 0 ;;
    y) echo 1 ;;
    esac
}

detect_loop_length() {
    local arr=("$@")
    if [[ $(detect_array_start_index) = 0 ]]; then
        echo "${#arr[@]}"
    else
        echo "$((${#arr[@]} + 1))"
    fi
}

__loop_array_sample() {
    local ARR=(a "b b" c)
    for ((i = $(detect_array_start_index); i < $(detect_loop_length "${ARR[@]}"); i++)); do
        echo "Index $i, total ${#ARR[@]}, current ${ARR[$i]}"
    done
}

#!/bin/bash
prepend () {
    local i=$#*
    while (( $i > 1 )); do
        typeset -g "${1}[1,0]=$*[$i]"
        i=$((i - 1))
    done
}

append() {
    local ARR_NAME=$1
    shift
    local baseIndex=${#${(P)ARR_NAME[@]}}
    for (( i = 1; i <= ${#*}; i++)); do
        typeset -g "${ARR_NAME}[$((baseIndex+i))]=$*[$i]"
    done
}

split_to_array() {
    local RUNNING_SHELL=$(get_running_shell)

    local ARR_NAME=$1
    local IFS="$2"
    if [[ $RUNNING_SHELL = "bash" ]]; then
        local -n arr=$ARR_NAME # use nameref for indirection
        arr=($3)
    elif [[ $RUNNING_SHELL = "zsh" ]]; then
        typeset -g -ax "$ARR_NAME"
        local arr=(${(@ps:$IFS:)3})
        local baseIndex=${#${(P)ARR_NAME[@]}}
        for (( i = 1; i <= ${#arr}; i++)); do
            typeset -g "${ARR_NAME}[$((baseIndex+i))]=${arr[$i]}"
        done
        # declare -p arr
        # eval "$ARR_NAME=(${arr[*]})"
        # echo "${ARR_NAME}+=(${arr[*]})"
        # ${ARR_NAME}+=(${arr[*]})
    else
        echo "Not $RUNNING_SHELL implement yet"
    fi
}

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

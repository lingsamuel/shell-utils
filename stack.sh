#!/bin/bash

new_stack() {
    local STACK_NAME=$1
    local STACK_SIZE=${2:-100}
    declare -ax $STACK_NAME
    local STACK_BASE_POINTER_NAME="${STACK_NAME}_BP"
    export $STACK_BASE_POINTER_NAME=$STACK_SIZE
    local STACK_POINTER_NAME="${STACK_NAME}_SP"
    export $STACK_POINTER_NAME="${!STACK_BASE_POINTER_NAME}"
}

push() {
    local STACK_NAME=$1
    local item=$2
    if [[ -z "$STACK_NAME" ]] || [[ -z $item ]]; then
        return
    fi

    local STACK_POINTER_NAME="${STACK_NAME}_SP"
    export $STACK_POINTER_NAME=$((${!STACK_POINTER_NAME} - 1))
    local index="${STACK_NAME}[${!STACK_POINTER_NAME}]=\"$item\""
    eval "${index}"
}

pop() {
    local STACK_NAME=$1
    local RETURN_VAL_NAME=${STACK_NAME}_POP
    unset $RETURN_VAL_NAME
    local STACK_BASE_POINTER_NAME="${STACK_NAME}_BP"
    local STACK_POINTER_NAME="${STACK_NAME}_SP"
    if [ "${!STACK_BASE_POINTER_NAME}" -eq "${!STACK_POINTER_NAME}" ]; then
        return
    fi
    local index="${STACK_NAME}[${!STACK_POINTER_NAME}]"
    # eecho "executing (pop) $index"
    local VAR="${!index}"
    export $RETURN_VAL_NAME="$VAR"

    export $STACK_POINTER_NAME=$((${!STACK_POINTER_NAME} + 1))   # Probelm: Subshell export won't affect to parent shell... So we can't do `VAL=$(pop stack)`
}

print_stack() {
    local STACK_NAME=$1

    local _print_stack_all=${STACK_NAME}[*]
    local STACK_BASE_POINTER_NAME="${STACK_NAME}_BP"
    local STACK_POINTER_NAME="${STACK_NAME}_SP"
    echo "$STACK_NAME ${!STACK_POINTER_NAME}/${!STACK_BASE_POINTER_NAME} ${!_print_stack_all}"
}

#!/bin/bash

# ==== Path ====

get_location() {
    dirname $(readlink -f $0)
}

# ===== Shell Opts =====

# useful when you want to temporary disable shell-opts like -e or -x and restore it afterward
store_shell_opts() {
    if ! var_is_set SHELL_OPTS; then
        # red "creating SHELL_OPTS"
        new_stack SHELL_OPTS
    fi
    local OLD_SHELL_OPTS="$(set +o); set -$-"
    # export OLD_SHELL_OPTS="$(set +o); set -$-"
    push SHELL_OPTS "$OLD_SHELL_OPTS"
}

restore_shell_opts() {
    # eval "$OLD_SHELL_OPTS"
    # unset OLD_SHELL_OPTS
    pop SHELL_OPTS
    if [[ ! -z $SHELL_OPTS_POP ]]; then
        # echo "restoring: ${SHELL_OPTS_POP}"
        eval "$SHELL_OPTS_POP"
    else
        echo "Stored nothing"
        exit 1
    fi
}

# This makes shellopts inherited
inherit_shellopts() {
    export SHELLOPTS
    eval "$(set +o)"
}

# exit when non-zero exit code (and pipefail)
set_must_success() {
    set -eo pipefail # also exit when pipe fail
}

set_could_fail() {
    set +eo pipefail
}

#

contains_non_ascii() {
    local FILE=$1
    local TEXT="$(cat $FILE)"
    LC_CTYPE=C
    case $TEXT in
    *[![:cntrl:][:print:]]*) echo "true" ;;
    *) echo "false" ;;
    esac
}

# tidy source envs
# 继承全部、部分环境变量
# tidy_source_env script.sh *
# tidy_source_env script.sh VAR_1 VAR_2 VAR_3
tidy_source_env() {
    # source ./script.sh 会很脏
    # 使 script.sh 继承 set -x，然后 grep 需要的变量
    # 然后 eval
    store_shell_opts
    inherit_shellopts
    set -x
    # eval $(source $FILE; echo VERSION="$VERSION") # $FILE stdout is dirty, can't eval

    restore_shell_opts
}

#
is_empty_dir() {
    if [[ -z "$(ls -A $1)" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

variable-is-set() {
    declare -p "$1" &>/dev/null
}
var_is_set() {
    # Works bad in Array variable
    # https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash#comment97916477_17538964
    # local VAR_NAME=$1
    # if [[ -z ${!VAR_NAME+x} ]]; then # parameter expansion
    #     echo "false"
    # else
    #     echo "true"
    # fi

    # https://stackoverflow.com/a/35412000/6109151
    declare -p "$1" &>/dev/null
}

is_url(){
    local __to_test=$1
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    if [[ $__to_test =~ $regex ]]; then 
        true
    else
        false
    fi
}

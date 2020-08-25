#!/bin/bash

BASE_DIR="$(dirname $(readlink -f $0))"
source $BASE_DIR/shell-utils.sh

test_array() {
    ARR=(a b c)
    append ARR d e 'f g'
    prepend ARR '0 1' 2
    declare -p ARR

    ARR=(a b c)
    split_to_array ARR ',' 'd,e,,f'
    declare -p ARR
    split_to_array NEW_ARR ',' 'd,e,,f'
    declare -p NEW_ARR
}

test_stack() {
    new_stack stack 200
    echo "init: $(print_stack stack)"
    push stack 1
    echo "push 1: $(print_stack stack)"
    push stack 2
    echo "push 2: $(print_stack stack)"
    pop stack
    echo $stack_POP
    echo "pop: $(print_stack stack)"
    push stack 3
    echo "push 3: $(print_stack stack)"
    pop stack
    echo $stack_POP
    echo "pop: $(print_stack stack)"
    pop stack
    echo $stack_POP
    echo "pop: $(print_stack stack)"
    pop stack
    echo $stack_POP
    echo "pop: $(print_stack stack)"
    pop stack
    echo $stack_POP
    echo "pop: $(print_stack stack)"
}

test_shell_opts() {
    echo "Testing shell opts:"
    store_shell_opts
    echo "Origin (Shoule be +o): $(set +o | grep pipefail)"
    set_must_success
    echo "  Set Pipefail (Should be -o): $(set +o | grep pipefail)"

    echo "    Temporary disable pipefail"
    store_shell_opts
    set_could_fail
    echo "    Status (Should be +o): $(set +o | grep pipefail)"
    # do something...
    restore_shell_opts
    echo "  Restored pipefail (Should be -o): $(set +o | grep pipefail)"
    
    restore_shell_opts
    echo "Restored Origin (Should be +o): $(set +o | grep pipefail)"
}

test_color() {
    gray "gray"
    red "red"
    green "green"
    yellow "yellow"
    blue "blue"
    magenta "magenta"
    cyan "cyan"
    light_gray "light gray"
    black "black"
    dark_red "dark red"
    dark_green "dark green"
    dark_yellow "dark yellow"
    dark_blue "dark blue"
    dark_magenta "dark magenta"
    dark_cyan "dark cyan"
    white "white"
    light_purple "light purple"
    light_blue "light blue"
}
#test_stack
# test_shell_opts
 test_color

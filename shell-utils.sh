#!/bin/bash

SHELL_UTILS_BASE_DIR="$(dirname $(readlink -f $0))"

# In bash/sh, `source XX.sh` $0 is bash/sh itself
if [[ -n ${BASH_SOURCE[0]} ]]; then
    SHELL_UTILS_BASE_DIR="$( readlink -f "$( dirname "${BASH_SOURCE[0]}" )" )"
fi
source $SHELL_UTILS_BASE_DIR/const.sh
source $SHELL_UTILS_BASE_DIR/log.sh
source $SHELL_UTILS_BASE_DIR/array.sh
source $SHELL_UTILS_BASE_DIR/utils.sh
source $SHELL_UTILS_BASE_DIR/stack.sh
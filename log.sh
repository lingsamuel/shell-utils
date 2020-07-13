#!/bin/bash

# Color functions (echo)
# Usage:
# gray "string here"

decorate(){
    echo -e $@
}

gray() {
    echo -e "\033[90m$@\033[39m"
}

red(){
    echo -e "\033[91m$@\033[39m"
}

green(){
    echo -e "\033[92m$@\033[39m"
}

yellow(){
    echo -e "\033[93m$@\033[39m"
}

blue(){
    echo -e "\033[94m$@\033[39m"
}

magenta(){
    echo -e "\033[95m$@\033[39m"
}

cyan(){
    echo -e "\033[96m$@\033[39m"
}

light_gray() {
    echo -e "\033[97m$@\033[39m"
}

black() {
    echo -e "\033[30m$@\033[39m"
}

dark_red(){
    echo -e "\033[31m$@\033[39m"
}

dark_green(){
    echo -e "\033[32m$@\033[39m"
}

dark_yellow(){
    echo -e "\033[33m$@\033[39m"
}

dark_blue(){
    echo -e "\033[34m$@\033[39m"
}

dark_magenta(){
    echo -e "\033[35m$@\033[39m"
}

dark_cyan(){
    echo -e "\033[36m$@\033[39m"
}

white() {
    echo -e "\033[37m$@\033[39m"
}

light_purple() {
    if [[ -z $_PURPLE ]]; then
        _PURPLE=$(tput setaf 171)
    fi
    echo -e "${_PURPLE}$@\033[39m"
}

light_blue() {
    if [[ -z $_BLUE ]]; then
        _BLUE=$(tput setaf 38)
    fi
    echo -e "${_BLUE}$@\033[39m"
}

# export -f decorate
# export -f red
# export -f green
# export -f yellow
# export -f blue
# export -f magenta
# export -f cyan
# export -f dark_red
# export -f dark_green
# export -f dark_yellow
# export -f dark_blue
# export -f dark_magenta
# export -f dark_cyan

# Color variables

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)


Bold="\033[1m"
Dim="\033[2m"
Underlined="\033[4m"
Blink="\033[5m"
Reverse="\033[7m"
Hidden="\033[8m"

ResetBold="\033[21m"
ResetDim="\033[22m"
ResetUnderlined="\033[24m"
ResetBlink="\033[25m"
ResetReverse="\033[27m"
ResetHidden="\033[28m"

# Log functions
# Usage:
# e_header "ArchLinux Installation"

e_header() {
    light_purple "========== $@ =========="
}
e_arrow() {
    echo "➜ $@"
}

e_success() {
    green "✔ $@"
}
e_error() {
    red "✖ $@"
}
e_warning() {
    dark_yellow $(e_arrow "$@")
}
e_underline() {
    printf "${underline}%s${reset}\n" "$@"
}
e_bold() {
    printf "${bold}%s${reset}\n" "$@"
}
e_note() {
    light_blue "${Underlined}${Bold}Note:${ResetBold}${ResetUnderlined} $@"
}

# has: Check if executable exist
# Usage:
# has tput
# has bash
# has foo
has() {
    if [[ $(type $1) = *"is"* ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Step function
# Usage:
# e_reset_step
# e_step "Install requirements"
# e_step "Install binaries"
# e_reset_step
# e_step "Another step"
e_step() {
    if [[ -z $_DE_COLOR ]]; then
        export _DE_COLOR="\033[39m"
    fi
    if [[ -z $_UNDERLINE ]]; then
        export _UNDERLINE="\033[4m"
        export _DE_UNDERLINE="\033[24m"
    fi
    if [[ -z $_BLUE ]]; then
        if [[ $(has tput) = "true" ]]; then
            _BLUE=$(tput setaf 38)
        else
            _BLUE="\033[94m"
        fi
    fi
    echo -en "${_UNDERLINE}${_BLUE}Step"
    # if [[ $(has expr) ]]; then
    export E_STEP=${E_STEP:-1}
    echo -en " $E_STEP"
    export E_STEP=$((E_STEP + 1))
    # fi
    echo -e ".${_DE_COLOR}${_DE_UNDERLINE} $@"
}

e_reset_step() {
    export E_STEP=
}

# Indent strings
# Usage:
# echo "haha" | indent 2
# cat file.txt | indent 1 4

indent() {
  local indentCount=1
  local indentWidth=2
  if [[ -n "$1" ]]; then indentCount=$1; fi
  if [[ -n "$2" ]]; then indentWidth=$2; fi
  pr -to $((indentCount * indentWidth))
}

eecho() {
    echo "$@" 1>&2
}
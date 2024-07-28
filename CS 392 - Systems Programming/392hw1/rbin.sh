#!/bin/bash

# *******************************************************************************
#  Author  : Amane Chibana
#  Date    : 1/31/2024
#  Description: CS392 - Homework 1
#  Pledge  : I pledge my honor that I have abided by the Stevens Honor System. 
# ******************************************************************************

readonly recycle_bin="$HOME/.recycle"

if [[ !(-e $recycle_bin) ]]; then
    mkdir "$recycle_bin"
fi 

show_help() {
    cat << EOF  
Usage: rbin.sh [-hlp] [list of files]
   -h: Display this help;
   -l: List files in the recycle bin;
   -p: Empty all files in the recycle bin;
   [list of files] with no other flags,
        these files will be moved to the
        recycle bin.
EOF
} 

if  [[ $# -eq 0 ]]; then
    show_help
fi

help=0
list=0
empty=0

while getopts ":hlp" options; do
    case "${options}" in 
        h)
        ((help++))
        ;;
        l)
        ((list++))
        ;;
        p)
        ((empty++))
        ;;
        *) 
        echo "Error: Unknown option '-${OPTARG}'." >&2
        show_help
        exit 1 
        ;;
    esac
done

if [[ $((help+list+empty)) -gt 1 || (($((help + list +empty)) -gt 0) && ($# -gt 1)) ]]; then
    echo "Error: Too many options enabled." >&2
    show_help
    exit 1
fi 

if [[ $help -eq 1 ]]; then
    show_help 
elif [[ $list -eq 1 ]]; then 
    ls -lAF $recycle_bin
elif [[ $empty -eq 1 ]]; then
    rm -r $recycle_bin
else
    for file in "$@"; do 
        if [[ -e $file ]]; then
            mv $file $recycle_bin
        else
            echo "Warning: '$file' not found." >&2
        fi
done 
fi 

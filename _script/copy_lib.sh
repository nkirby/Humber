#!/bin/bash

while [[ $# > 1 ]]
do
    key="$1"

    case $key in
        -c|--configuration-build-dir)
        BUILD="$2"
        shift
        ;;
        -s|--src-root)
        SRC="$2"
        shift
        ;;
        *)
        ;;
    esac
    shift
done

printf "Copying From: $BUILD \n"
printf "Target: $SRC \n"
printf " \n\n"

rm -rf $SRC/../_lib/_build
mkdir $SRC/../_lib/_build

declare -a libs=("HMCore" "HMGithub")
for i in "${libs[@]}"
do
    printf "Copying: $i"
    cp -r $BUILD/$i.framework $SRC/../_lib/_build/$i.framework
    printf " - Done\n"
done

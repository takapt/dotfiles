#!/bin/zsh

script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

for f in `ls -a $script_dir`
do
    if [ -d $f ] || [ "$f" = ".git" ]
    then
        continue
    fi

    if [[ "$f" =~ "^\..+$" ]]
    then
        ln -snfv $script_dir/"$f" "$HOME"/"$f"
    fi
done

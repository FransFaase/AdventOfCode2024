#!/bin/bash
while true; do
  exetime=`stat -c %Y day$1`
  mdtime=`stat -c %Y Day$1.md`
  if [ -z "${exetime}" ] || [ $mdtime -gt $exetime ]; then
    ../IParse/software/MarkDownC Std.md Day$1.md >day$1.c
    gcc day$1.c -g -o day$1 2>errors.txt
    if [ $? -eq 0 ]; then
      clear
      ./day$1
      echo Done
    else
      clear
      head errors.txt
    fi
  fi
  sleep 1
done

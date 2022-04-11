#!/bin/bash
#判断两个整数的关系

if [ $1 -eq $2 ]
  then
      echo "$1 = $2"
else
   if [ $1 -gt $2 ]
      then
          echo "$1 > $2"
   else
          echo "$1 < $2"
   fi
fi

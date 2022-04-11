#!/bin/bash

array=(a b c d e f g)
count=${#array[*]}

for ((i=0;i<$count;i++))
   do
	echo "array[$i]=${array[$i]}"
done

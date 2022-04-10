#!/bin/bash

ARRAY1=('a' 'b' 'c' 'd')
echo ${ARRAY1[2]}

ARRAY1[4]='E'
ARRAY1[5]='F'
echo ${ARRAY1[*]}
echo ${#ARRAY1[@]}
echo ${!ARRAY1[@]}
echo ${ARRAY1[@]:1:4}

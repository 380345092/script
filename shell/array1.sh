#!/bin/bash

declare -A ass_array1

ass_array1[name]='luwei'
ass_array1[age]=18
echo ${ass_array1[name]}

ass_array2=([name]='luweiwei' [age]=20)
echo ${ass_array2[name]}

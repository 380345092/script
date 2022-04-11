#!/bin/bash

for ((;;))
   do
        #屏幕显示char: 然后把后面输入的值赋予ch  
	read -p "char: " ch              
	if [ $ch == 'Q' ]
	  then
           #break跳出当前循环
		break
		#如果循环多层嵌套，循环从里往外排序0-N
                #如果想跳出某层循环  break N
	  else
		echo "你输入的字符是: $ch"
	fi
done

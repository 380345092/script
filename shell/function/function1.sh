#!/bin/bash
#函数默认不会执行  除非调用
start () {
	echo "Apache start ...		[OK]"
	#return 0
}

stop () {
	echo "Apache stop ...		[FAIL]"
}

stop
start

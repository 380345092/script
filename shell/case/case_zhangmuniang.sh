#!/bin/bash
case $1 in
zmn|ZMN)
	echo "伯母好"
	echo "伯母辛苦了"
;;
lzr|LZR)
	echo "伯父好"
	echo "伯父辛苦了"
;;
lnn|LNN)
	echo "奶奶号"
	echo "奶奶辛苦了"
;;
*)
#告知对方要按如下方式执行
	echo "USAGE: $0 zmn|lzr|lnn"
;;
esac

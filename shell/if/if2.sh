#!/bin/bash
#假如用户是root。输出管理员，你好
#假如用户是普通用户。输出guest，你好

if [ $USER == "root" ]
   then
       echo "管理员你好"
else 
       echo "普通用户你好"
fi

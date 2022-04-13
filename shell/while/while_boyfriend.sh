#!/bin/bash
# 第一个男朋友
read -p "money: " money
read -p "car: " car_num
read -p "house: " house

# 第一个男朋友不满足，进入循环，第二个男朋友，开始选择模式
while [ $money -lt 10000 ] || [ $car_num -lt 1 ] || [ $house -lt 1 ]
   do
	echo "no way"
	read -p "money: " money
	read -p "car: " car_num
	read -p "house: " house
done

echo "yes"

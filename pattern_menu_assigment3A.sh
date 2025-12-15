#!/bin/bash

source /home/saransh/Ninja_33_Assignments/assigment3a_functions


echo "Select pattern to print:"
echo "1) Right Triangle"
echo "2) Inverted Right Triangle"
echo "3) Right Triangle with Spaces"
echo "4) Equilateral Triangle"
echo "5) Diamond"
echo "6) Reverse Right Triangle"
echo "7) Reverse Equilateral Triangle"

read -p "enter number of rows :" n

read -p "Enter choice [1-7]: " choice

case $choice in
	1) draw_right_triangle $n ;;
	2) draw_inverse_right_triangle $n ;;
	3) draw_spaced_right_traingle $n ;;
	4) draw_euilatoral_traingle $n ;;
	5) draw_diamond $n ;;
	6) reverse_right_triangle $n ;;
	7) reverse_equilatoral_triangle $n ;;
	*) echo "Invalid choice!" ;;
esac

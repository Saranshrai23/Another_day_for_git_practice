#!/bin/bash

read -p "What is the number: " number

if (( number % 15 == 0 )); then
    echo "tomcat"
elif (( number % 5 == 0 )); then
    echo "cat"
elif (( number % 3 == 0 )); then
    echo "tom"
else
    echo "No match"
fi


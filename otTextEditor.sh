#!/bin/bash

# Load all functions
source  ~/Ninja_33_Assignments/final_function_list_assignement_5 

# Show menu
echo "Choose an option:"
echo "1) Add line at TOP"
echo "2) Add line at BOTTOM"
echo "3) Add line at Specific Number"
echo "4) Replace a Word"
echo "5) Delete a Word"
echo "6) Insert Word at a Line"
echo "7) Delete a Line"
echo "8) Delete lines containing a word"

read -p "Enter your choice: " CHOICE

case $CHOICE in

    1)
        addLineTop
        ;;

    2)
        addLineBottom
        ;;

    3)
        echo "Enter file path:"; read FILE
        echo "Enter line number:"; read NUM
        echo "Enter line to add:"; read LINE
        addLineAt "$FILE" "$NUM" "$LINE"
        ;;

    4)
        replaceWord
        ;;

    5)
        deleteWord
        ;;

    6)
        insertWordAtLine
        ;;

    7)
        deleteLine
        ;;

    8)
        deleteLineContainingWord
        ;;

    *)
        echo " Invalid choice!"
        ;;
esac


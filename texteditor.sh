#!/bin/bash

# COMMON: Check if file exists

check_file() {
    if [ ! -e "$1" ]; then
        echo " File NOT found!"
        exit 1
    fi
}

# Add a line at TOP

addLineTop() {
    echo "Enter file path:"
    read FILE

    echo "Enter text to add at TOP:"
    read DATA

    check_file "$FILE"
    sed -i "1i $DATA" "$FILE"
    echo "Top line added successfully."
}

#Add a line at BOTTOM

addLineBottom() {
    echo "Enter file path:"
    read FILE

    echo "Enter text to add at BOTTOM:"
    read DATA

    check_file "$FILE"
    echo "$DATA" >> "$FILE"
    echo "Bottom line added successfully."
}


addLineAt() {
    FILE=$1
    NUM=$2
    LINE=$3
    check_file "$FILE"

    # Valid number check
    if ! [[ "$NUM" =~ ^[0-9]+$ ]]; then
        echo "Error: Line number must be numeric."
        exit 1
    fi

    # Count total lines
    TOTAL_LINES=$(wc -l < "$FILE")

    if [ "$NUM" -lt 1 ] || [ "$NUM" -gt "$TOTAL_LINES" ]; then
        echo "Error: File has only $TOTAL_LINES lines. Line $NUM does NOT exist!"
        exit 1
    fi

    sed -i "${NUM}i $LINE" "$FILE"
    echo " Line added at line number $NUM."
}


replaceWord() {
    echo "Enter file path:"
    read FILE

    echo "Enter old word:"
    read oldword

    echo "Enter new word:"
    read newword

    check_file "$FILE"

    sed -i "s/${oldword}/${newword}/gi" "$FILE"
    echo " Replaced '$oldword' with '$newword' successfully."
}


deleteWord() {
    echo "Enter file path:"
    read FILE

    echo "Enter word to delete:"
    read WORD

    check_file "$FILE"

    sed -i "s/$WORD//gI" "$FILE"
    echo "Word '$WORD' deleted successfully."
}

insertWordAtLine() {
    echo "Enter file path:"
    read FILE

    echo "Enter the line number:"
    read LINE

    echo "Enter the word to insert:"
    read WORD

    check_file "$FILE"

    # Check numeric line
    if ! [[ "$LINE" =~ ^[0-9]+$ ]]; then
        echo " Error: Line number must be numeric."
        exit 1
    fi

    # Check if line exists
    TOTAL_LINES=$(wc -l < "$FILE")

    if [ "$LINE" -lt 1 ] || [ "$LINE" -gt "$TOTAL_LINES" ]; then
        echo " Error: File has only $TOTAL_LINES lines. Line $LINE does NOT exist!"
        exit 1
    fi

    # Add word at the specific line
    sed -i "${LINE}i $WORD" "$FILE"
    echo " Word '$WORD' inserted at line $LINE successfully."
}

deleteLine() {
    echo "Enter file path:"
    read FILE

    echo "Enter the line number to delete:"
    read LINE

    check_file "$FILE"

    # Validate line number
    if ! [[ "$LINE" =~ ^[0-9]+$ ]]; then
        echo "Error: Line number must be numeric."
        exit 1
    fi

    # Count total lines
    TOTAL_LINES=$(wc -l < "$FILE")

    if [ "$LINE" -lt 1 ] || [ "$LINE" -gt "$TOTAL_LINES" ]; then
        echo "Error: File has only $TOTAL_LINES lines. Line $LINE does NOT exist!"
        exit 1
    fi

    # Delete the line
    sed -i "${LINE}d" "$FILE"
    echo " Line $LINE deleted successfully."
}

deleteLineContainingWord() {
    echo "Enter file path:"
    read FILE

    echo "Enter the word to search and delete the entire line:"
    read WORD

    check_file "$FILE"

    # Check if word is empty
    if [[ -z "$WORD" ]]; then
        echo " Error: Word cannot be empty."
        exit 1
    fi

    # Check if word exists in file (case-insensitive)
    if ! grep -qi "$WORD" "$FILE"; then
        echo " Error: No line contains the word '$WORD'. Nothing to delete."
        exit 1
    fi

    sed -i "/$WORD/Id" "$FILE"
    echo " All lines containing '$WORD' deleted successfully."
}



#!/bin/bash

#########################################
# 1. Check if template file is provided
#########################################

if [ -z "$1" ]; then
    echo ":x: Error: No template file provided."
    echo "Usage: $0 <template_file> key=value key=value ..."
    exit 1
fi

TEMPLATE_FILE="$1"

#########################################
# 2. Check if file exists
#########################################

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo " Error: Template file '$TEMPLATE_FILE' not found."
    exit 1
fi


#########################################
# 3. Check if key=value arguments exist
#########################################

if [ "$#" -lt 2 ]; then
    echo "Error: No key=value arguments provided."
    echo "Example: $0 trainer.template fname=sandeep topic=linux"
    exit 1
fi

#########################################
# Load the template content
#########################################

CONTENT=$(cat "$TEMPLATE_FILE")

#########################################
# Process all key=value pairs
#########################################

for pair in "$@"; do
    # Skip the template file name (not a key=value pair)
    [[ "$pair" == "$TEMPLATE_FILE" ]] && continue
    # Extract KEY (before '=')
    KEY=$(echo "$pair" | sed 's/=.*//')
    # Extract VALUE (after '=')
    VALUE=$(echo "$pair" | sed 's/[^=]*=//')
    # Replace {{KEY}} in the content with VALUE
    CONTENT=$(echo "$CONTENT" | sed "s/{{${KEY}}}/${VALUE}/g")
done

#########################################
# Print final processed template
#########################################

echo "$CONTENT"

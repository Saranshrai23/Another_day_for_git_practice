#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: ./FileManager.sh <action> [arguments]"
    echo ""
    echo "Available actions:"
    echo "  addDir <path> <dirname>"
    echo "  deleteDir <path> <dirname>"
    echo "  listFiles <path>"
    echo "  listDirs <path>"
    echo "  listAll <path>"
    echo "  addFile <path> <filename> [content]"
    echo "  addContentToFile <path> <filename> <content>"
    echo "  addContentToFileBegining <path> <filename> <content>"
    echo "  showFileBeginingContent <path> <filename> <n>"
    echo "  showFileEndContent <path> <filename> <n>"
    echo "  showFileContentAtLine <path> <filename> <line>"
    echo "  showFileContentForLineRange <path> <filename> <start> <end>"
    echo "  moveFile <src> <dest>"
    echo "  copyFile <src> <dest>"
    echo "  clearFileContent <path> <filename>"
    echo "  deleteFile <path> <filename>"
    exit 1
fi


action=$1

# Create Directory
if [ "$action" = "addDir" ]; then
    path=$2
    dirname=$3
    if [ ! -d "$path" ]; then
        echo "Path does not exist"
        exit 1
    fi
    mkdir -p "$path/$dirname"
    echo "Directory created: $path/$dirname"

# Delete Directory
elif [ "$action" = "deleteDir" ]; then
    path=$2
    dirname=$3
    if [ ! -d "$path/$dirname" ]; then
        echo "Directory does not exist"
        exit 1
    fi
    rm -r "$path/$dirname"
    echo "Directory deleted: $path/$dirname"

# List Only Files
elif [ "$action" = "listFiles" ]; then
    path=$2
    if [ ! -d "$path" ]; then
        echo "Path does not exist"
        exit 1
    fi
    ls -la "$path" | grep "^-"

# List Only Directories
elif [ "$action" = "listDirs" ]; then
    path=$2
    if [ ! -d "$path" ]; then
        echo "Path does not exist"
        exit 1
    fi
    ls -la "$path" | grep "^d"

# List All
elif [ "$action" = "listAll" ]; then
    path=$2
    if [ ! -d "$path" ]; then
        echo "Path does not exist"
        exit 1
    fi
    ls -a "$path"

# Create File
elif [ "$action" = "addFile" ]; then
    path=$2
    filename=$3
    content=$4
    if [ ! -d "$path" ]; then
        echo "Path does not exist"
        exit 1
    fi
    if [ -z "$content" ]; then
        touch "$path/$filename"
    else
        echo "$content" > "$path/$filename"
    fi
    echo "File created: $path/$filename"

# Add content at end of file
elif [ "$action" = "addContentToFile" ]; then
    path=$2
    filename=$3
    content=$4
    if [ ! -f "$path/$filename" ]; then
        echo "File does not exist"
        exit 1
    fi
    echo "$content" >> "$path/$filename"
    echo "Content added"

# Add content at beginning
elif [ "$action" = "addContentToFileBegining" ]; then
    path=$2
    filename=$3
    content=$4
    if [ ! -f "$path/$filename" ]; then
        echo "File does not exist"
        exit 1
    fi
    temp="/tmp/tempfile_$$"
    echo "$content" > "$temp"
    cat "$path/$filename" >> "$temp"
    mv "$temp" "$path/$filename"
    echo "Content added at beginning"

# Show top n lines
elif [ "$action" = "showFileBeginingContent" ]; then
    path=$2
    filename=$3
    n=$4
    if [ ! -f "$path/$filename" ]; then
        echo "File does not exist"
        exit 1
    fi
    head -n "$n" "$path/$filename"

# Show last n lines
elif [ "$action" = "showFileEndContent" ]; then
    path=$2
    filename=$3
    n=$4
    if [ ! -f "$path/$filename" ]; then
        echo "File does not exist"
        exit 1
    fi
    tail -n "$n" "$path/$filename"

# Show specific line
elif [ "$action" = "showFileContentAtLine" ]; then
    path=$2
    filename=$3
    line=$4
    if [ ! -f "$path/$filename" ]; then
        echo "File does not exist"
        exit 1
    fi
    head -n "$line" "$path/$filename" | tail -n 1

# Show line range
elif [ "$action" = "showFileContentForLineRange" ]; then
    path=$2
    filename=$3
    start=$4
    end=$5
    if [ ! -f "$path/$filename" ]; then
        echo "File does not exist"
        exit 1
    fi
    head -n "$end" "$path/$filename" | tail -n +"$start"

# Move file
elif [ "$action" = "moveFile" ]; then
    src=$2
    dest=$3
    if [ ! -f "$src" ]; then
        echo "Source file does not exist"
        exit 1
    fi
    mv "$src" "$dest"
    echo "File moved"

# Copy file
elif [ "$action" = "copyFile" ]; then
    src=$2
    dest=$3
    if [ ! -f "$src" ]; then
        echo "Source file does not exist"
        exit 1
    fi
    cp "$src" "$dest"
    echo "File copied"

# Clear file content
elif [ "$action" = "clearFileContent" ]; then
    path=$2
    filename=$3
    if [ ! -f "$path/$filename" ]; then
        echo "File does not exist"
        exit 1
    fi
    > "$path/$filename"
    echo "File cleared"

# Delete file
elif [ "$action" = "deleteFile" ]; then
    path=$2
    filename=$3
    if [ ! -f "$path/$filename" ]; then
        echo "File does not exist"
        exit 1
    fi
    rm "$path/$filename"
    echo "File deleted"

else
    echo "Invalid action"
fi


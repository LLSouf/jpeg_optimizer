#!/bin/bash

# Description:
# This script finds all .jpg and .jpeg files in the current directory and subdirectories,
# checks for the 'Optimized' tag, optimizes images using jpegtran if not tagged, and ensures
# the smallest file version is kept while tagging the image as 'Optimized'.

# Dependencies:
# - jpegtran (part of libjpeg)
# - exiftool

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display error messages
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Check if jpegtran is installed
command -v jpegtran >/dev/null 2>&1 || error_exit "jpegtran is not installed. Please install it and try again."

# Check if exiftool is installed
command -v exiftool >/dev/null 2>&1 || error_exit "exiftool is not installed. Please install it and try again."

# Inform the user about the process
echo "Starting optimization and tagging of JPEG images..."
echo

# Find and process .jpg and .jpeg files
find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | while IFS= read -r -d '' file; do
    echo "Processing: $file"

    # Check if the image already has the 'Optimized' tag
    if exiftool -Keywords "$file" | grep -iq "Optimized"; then
        echo " -> Already tagged as 'Optimized'. Skipping."
        echo
        continue
    fi

    # Initialize variables
    original_file="$file"
    tmpfile="$(dirname "$file")/$(basename "$file").tmp"
    smallest_file="$file"
    smallest_size=$(stat -c%s "$file")

    # Iteratively optimize until no further size reduction
    while true; do
        # Optimize the image with jpegtran
        if jpegtran -optimize -progressive -copy all -outfile "$tmpfile" "$smallest_file"; then
            tmp_size=$(stat -c%s "$tmpfile")
            if (( tmp_size < smallest_size )); then
                # Replace the smallest file and update size
                mv "$tmpfile" "$smallest_file"
                smallest_size="$tmp_size"
                echo " -> Optimized further. New size: $smallest_size bytes."
            else
                # No further size reduction; stop optimization
                rm -f "$tmpfile"
                echo " -> No further optimization possible. Keeping smallest version."
                break
            fi
        else
            echo " -> Failed to optimize $file. Skipping."
            rm -f "$tmpfile"
            break
        fi
    done

    # Add a custom tag 'Optimized' using exiftool
    if exiftool -overwrite_original -keywords+="Optimized" "$smallest_file"; then
        echo " -> Added 'Optimized' tag to metadata."
    else
        echo " -> Failed to tag $smallest_file."
    fi

    echo
done

echo "All images processed."

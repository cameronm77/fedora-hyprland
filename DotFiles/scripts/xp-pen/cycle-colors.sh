#!/usr/bin/bash
# Set default number
number=5

# Check if there is a previous number stored
if [ -f /tmp/last_color ]; then
    number=$(cat /tmp/last_color)
fi

# Increase the number by 1
((number++))

# If the number exceeds 9, reset it to 0
if [ $number -gt 9 ]; then
    number=0
fi

# Write the new number to the file
echo $number > /tmp/last_color

# Run the command with the new number
wtype -k $number
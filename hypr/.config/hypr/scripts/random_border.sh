#!/bin/bash

# Define colors in an array
colors=(
    "rgba(005c29ff) rgba(00ff73ee)" # Emerald Green
    "rgba(004999ff) rgba(00ccffee)" # Ocean Blue
    "rgba(b30000ff) rgba(ff3333ee)" # Deep Red
)

# Get the array size
size=${#colors[@]}

# Generate a random number index
index=$(($RANDOM % $size))

# Select the color at that index
selected="${colors[$index]}"

# Apply it
hyprctl keyword general:col.active_border "$selected 45deg"

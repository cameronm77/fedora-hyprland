#!/usr/bin/bash
# Get the IDs of the active workspaces
workspace_ids=$(hyprctl workspaces | grep -Po '(?<=workspace ID )\d+')

# Get the ID of the current workspace
current_workspace=$(hyprctl activeworkspace | grep -Po '(?<=workspace ID )\d+')

# Convert workspace IDs into an array and find the max ID
workspaces=($workspace_ids)
max_id=${workspaces[0]}

for id in "${workspaces[@]:1}"; do
  if (( id > max_id )); then
    max_id=$id
  fi
done

# If current workspace is the highest, switch to the first workspace
if [ "$current_workspace" -eq "$max_id" ]; then
  hyprctl dispatch workspace 1
else
  # Otherwise, increment the workspace
  next_workspace=$((current_workspace + 1))
  hyprctl dispatch workspace $next_workspace
fi
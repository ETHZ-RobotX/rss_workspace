#!/bin/bash

# List top-level catkin packages in a workspace
workspace_folder=$(dirname "$(dirname "$(readlink -f $0)")")

catkin_packages=$(catkin list --directory ${workspace_folder} -u | sort -u)
catkin_packages_dependencies=$(catkin list --directory ${workspace_folder} --deps -u | grep -oP '(?<= - ).*?(?=$)' | sort -u)

top_level_packages=$(comm -23 <(echo "$catkin_packages") <(echo "$catkin_packages_dependencies"))

echo "$top_level_packages"

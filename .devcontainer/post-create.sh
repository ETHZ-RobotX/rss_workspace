#!/bin/bash
set -e

ROOT=$(dirname "$(dirname "$(readlink -f $0)")")

# Store command history in the workspace which is persistent across rebuilds
echo "export HISTFILE=${ROOT}/.zsh_history" >> ~/.zshrc

# Setup the ROS environment in shells
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc

# Setup fzf
echo "eval \"\$(fzf --bash)\"" >> ~/.bashrc
echo "source <(fzf --zsh)" >> ~/.zshrc

# Setup aliases
source "${ROOT}/.devcontainer/setup_alias.sh" ${ROOT}

# Make folder `src` if not exists
if [ ! -d "${ROOT}/src" ]; then
    mkdir -p "${ROOT}/src"
fi

# Clone the repository
vcs import --input "${SMB_RAW_REPO_URL}" --recursive --skip-existing "${ROOT}/src"

# Setup catkin workspace
catkin init --workspace "${ROOT}" 

# Generate skiplist for catkin config
# TODO: Add the packages to build in the list below
# NOTE: catkin build will only build the packages themselve listed in the buildlist but not their dependencies
#       so we need to generate a skiplist to skip the packages that are not recursively dependent on the packages we want to build
# NOTE: The input to the script is a list of packages to build and the output is the list of packages to skip
# NOTE: You can use the `scripts/list_top_level_packages.sh` script to list the top level packages in the workspace
# CAUTION: This script should be run after the workspace is created and the repositories are cloned as it uses the workspace to generate the skiplist
SKIP_PKG_LIST=$(python3 "${ROOT}/.devcontainer/generate_catkin_skiplist.py" --workspace "${ROOT}" \
                catkin_simple \
                smb_exploration \
                smb_gazebo \
                smb_mission_planner \
                smb_mpc \
                smb_msf \
                smb_msf_graph \
                smb_path_planner \
                )

# Split the string into an array of package names to pass to catkin config as positional arguments
IFS=' ' read -r -a SKIP_PKGS_ARRAY <<< "${SKIP_PKG_LIST}"

# Configure the workspace
catkin config --workspace "${ROOT}" \
              --extend /opt/ros/noetic \
              --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -- \
              --skiplist "${SKIP_PKGS_ARRAY[@]}"
              
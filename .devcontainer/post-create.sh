#!/bin/bash
set -e

ROOT=$(dirname "$(dirname "$(readlink -f $0)")")

# Store command history in the workspace which is persistent across rebuilds
echo "export HISTFILE=${ROOT}/.zsh_history" >> ~/.zshrc

# Setup the ROS environment in shells
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc

# Setup fzf completions
echo "eval \"\$(fzf --bash)\"" >> ~/.bashrc
echo "source <(fzf --zsh)" >> ~/.zshrc

# Setup vcs completions
echo "source /usr/share/vcstool-completion/vcs.bash" >> ~/.bashrc
echo "source /usr/share/vcstool-completion/vcs.zsh" >> ~/.zshrc

# Setup aliases
source "${ROOT}/.devcontainer/setup_alias.sh" ${ROOT}

# Clone repositories and configure the workspace if `src` folder does not exist
if [ ! -d "${ROOT}/src" ]; then
    # Create the `src` folder
    mkdir -p "${ROOT}/src"

    # Clone the repository
    vcs import --input "${SMB_RAW_REPO_FILE_URL}" --recursive --skip-existing "${ROOT}/src"

    # Setup catkin workspace
    catkin init --workspace "${ROOT}" &>/dev/null

    # Generate buildlist for catkin config
    # NOTE: catkin build will only build the packages themselve listed in the buildlist but not their dependencies
    #       so we need to generate a buildlist of packages that are recursively dependent on the packages we want to build
    # NOTE: The input to the script is a list of top-level packages to build and the output is the complete list of packages to build
    # NOTE: You can use the `scripts/list_top_level_packages.sh` script to list the top level packages in the workspace
    # CAUTION: This script should be run after the workspace is created and the repositories are cloned as it uses the workspace to generate the buildlist
    BUILD_PKG_LIST=$(python3 "${ROOT}/.devcontainer/generate_catkin_buildlist.py" --workspace "${ROOT}" \
                    catkin_simple \
                    smb_exploration \
                    smb_gazebo \
                    smb_mission_planner \
                    smb_mpc \
                    smb_msf \
                    smb_msf_graph \
                    smb_path_planner \
                    object_detection \
                    )

    # Split the string into an array of package names to pass to catkin config as positional arguments
    IFS=' ' read -r -a BUILD_PKGS_ARRAY <<< "${BUILD_PKG_LIST}"

    # Configure the workspace
    catkin config --workspace "${ROOT}" \
                  --extend /opt/ros/noetic \
                  --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -- \
                  --buildlist "${BUILD_PKGS_ARRAY[@]}"
else
    echo "Workspace already exists. Skipping cloning and configuring the workspace."
    echo "If you want to re-clone the repository, please remove the 'src' folder and rebuild the workspace."
fi
#!/bin/bash
ROOT=$1

setup_alias_in_zsh() {
  echo "alias \"$1\"=\"$2\"" >> ~/.zshrc
}

setup_alias_in_bash() {
  echo "alias \"$1\"=\"$2\"" >> ~/.bashrc
}

setup_alias_in_shell() {
  setup_alias_in_zsh "$1" "$2"
  setup_alias_in_bash "$1" "$2"
}

# Setup alias for sourcing workspace
setup_alias_in_zsh "wssetup" "source ${ROOT}/devel/setup.zsh"
setup_alias_in_bash "wssetup" "source ${ROOT}/devel/setup.bash"

## Setup alias for other commands
## Example: define ROS_MASTER_URI and ROS_IP for connecting to SMB 263
## The ip address of every SMB is 10.0.x.5 where x is the last digit of SMB Robot Number. Example: For SMB 263 the on-board computer IP address is 10.0.3.5
setup_alias_in_shell "connect-smb263" "export ROS_MASTER_URI=http://10.0.3.5:11311 && export ROS_IP=$(hostname -I | awk '{print $1}')"

# Catkin build memory & job limit
setup_alias_in_shell "build-limit" "catkin build --jobs 8 --mem-limit 70%"

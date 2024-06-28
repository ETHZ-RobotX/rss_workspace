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
## Example: define ROS_MASTER_URI and ROS_IP for connecting to SMB
## It will automatically set ROS_MASTER_URI to the IP address of the SMB NUC and ROS_IP to the IP address of the host machine
## based on the default gateway IP address (the IP address of the router on the SMB)
## Note: The ip address of every SMB is 10.0.x.5 where x is the last digit of SMB Robot Number. Example: For SMB 261 the on-board computer IP address is 10.0.1.5
setup_alias_in_shell "connect-smb" "export ROS_MASTER_URI=http://\$(ip route show default | grep -oP 'via \K\d+\.\d+\.\d+').5:11311 ; export ROS_IP=\$(ip route get 8.8.8.8 | grep -oP '(?<=src )\S+') ; echo 'ROS_MASTER_URI and ROS_IP set to ' ; printenv ROS_MASTER_URI ; printenv ROS_IP"

# Catkin build memory & job limit
setup_alias_in_shell "build-limit" "catkin build --jobs 8 --mem-limit 70%"

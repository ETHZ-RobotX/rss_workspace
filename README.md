# Workspace for Robotics Summer School (RSS)

**rss_workspace** is an unified development environment for the SuperMegaBot (SMB). It leverages [Docker](https://www.docker.com/) and [Development Containers](https://containers.dev) to provide a consistent and reproducible development environment across different platforms.

To quickly setup the development environment locally, please follow the instructions below.

## Preparation
1. Follow the [Dev Containers tutorial](https://code.visualstudio.com/docs/devcontainers/tutorial) to setup Dev container locally. You need to install [Docker](https://docs.docker.com/get-docker/) and [VScode](https://code.visualstudio.com/download) on your local machine. Install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in VScode. Make sure you can run [Dev Container samples](https://code.visualstudio.com/docs/devcontainers/tutorial#_get-the-sample) described in the tutorial. If you have more capacity, you can also take a look at the [Dev Containers documentation](https://code.visualstudio.com/docs/devcontainers/containers) to get a better understanding of how Dev Containers work.


2. To use SSH (for pushing commits to GitHub and connecting robots over SSH) inside container without copying your private ssh-key, you need to setup ssh-agent locally and add your ssh key to the ssh-agent. Follow the instructions [here](https://www.ssh.com/academy/ssh/agent) to properly setup ssh-agent. For some OS, ssh-agent is already running by default. You can check if ssh-agent is running by 
```bash
echo $SSH_AUTH_SOCK
```
if it is set, then ssh-agent is presumably running. You can run
```bash
ssh-add -l
```
to list the keys added to the ssh-agent. If you see your key, then you are good to go. If not, follow the instructions in the link above to setup ssh-agent.

## Open workspace locally

### **Method 1 (recommended for Linux/WSL 2)**: Clone the workspace to your local file system and open it in VScode.
> [!WARNING]  
> The Dev Containers extension uses "bind mounts" to source code in your local filesystem by default. While this is the simplest option, on macOS and Windows, you may encounter slower disk performance when using `catkin build` or other disk-intensive operations. If you encounter this issue, consider using Method 2.

```bash
git clone https://github.com/ETHZ-RobotX/rss_workspace.git

code rss_workspace # Open the workspace in VScode. You can also open the folder in VScode manually.
```
##### Reopen workspace in dev container

Press `F1` to open the command palette, type `Reopen in Container` and select the command to reopen the workspace in a Dev Container.

You can also find the command in the quick actions Status bar item (the blue button at the bottom-left corner of VScode).

![quick action bar](images/quick_action_icon.png)

### **Method 2** (recommended for Mac): Clone the workspace to a docker volume and open it in VScode.
Follow the instruction - [Open a GitHub repos in an isolated container volume](https://code.visualstudio.com/docs/devcontainers/containers#_quick-start-open-a-git-repository-or-github-pr-in-an-isolated-container-volume).

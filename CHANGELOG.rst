Changelog
=========

1.0.0 (2024-06-21)
--------------
* Initial release

1.1.0 (2024-06-26)
--------------
* Change `matplotlib` backend to `Qt5Agg` to avoid `tkinter` dependency

1.2.0 (2024-06-28)
--------------
* Comment out `initializeCommand` in `.devcontainer/devcontainer.json` to avoid always pulling the image
* Add `.devcontainer/devcontainer-lock.json` to lock the feature version
* Add `connect-smb` alias in `.devcontainer/setup_alias.sh`
* Add shell completion for `vcs`
* Do not clone repositories and configure workspace if `src` exists
* Add pane title for `tmux`
* fix: add top-level packages to `.devcontainer/generate_catkin_buildlist.py`

1.2.1 (2024-06-29)
--------------
* Fix `connect-smb` shell alias.
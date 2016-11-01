# ansible-laptop-config
Ansible playbooks for managing my personal laptop config

This has only been tested on macOS 10.12 Sierra, but should function on older version's of macOS. Almost everything for macOS is completely automated.

#### Some of the items to be configured:
- Install zsh/oh-my-zsh
- Clone and symlink my personal dotfiles
- Install homebrew packages
- Install homebrew cask apps
- Add preferred apps to dock using dockutil
- Install preferred Mac App Store apps using (mas-cli)[https://github.com/mas-cli/mas]

## Running on macOS
1. (optional) Modify the sudoers file to not require a password for the main user. This step makes it so you don't have to enter your sudo password mid run since the playbook takes a long time to run.
    ```
    myuseraccount    ALL= (ALL) NOPASSWD: ALL
    ```
2. Run `sudo ./bootstrap.sh` to configure everything listed above.
3. Enter your Apple ID and password when prompted.
4. Wait a long time for the playbook to complete.
5. Click on any GUI apps that present a visual installer. Some apps do not offer a command line approach to installation.
6. Remove the line from *step 1*. It is a security risk to run your system without requiring a password for sudo.
7. Profit!

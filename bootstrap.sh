#!/bin/bash

# Check if the mas-cli exists and look up the latest release to install 
# mas-cli recommends using brew, but the ansible playbook will install brew for us
if [ ! -f /usr/local/bin/mas ]; then
    echo "mas-cli was not found! Looking up latest version from Github releases"
    mas_latest_release=$(curl -s https://api.github.com/repos/mas-cli/mas/releases/latest | python -c "import sys, json; sys.stdout.write(json.load(sys.stdin)['assets'][0]['browser_download_url']);");
    echo "Downloading and installing mas-cli from Github"
    curl -sL $mas_latest_release -o mas.zip > /dev/null
    sudo unzip mas.zip -d /usr/local/bin/ > /dev/null
    rm mas.zip
fi

if [ ! -d "/Applications/Xcode.app" ]; then
    echo "Xcode is not currently installed. We need Xcode for git and gcc"
    echo "Getting ready to install from the Mac App Store using mas-cli"
    signed_in=$([[ $(mas account) == *"Not signed in"* ]] && echo "No" || echo "Yes")
    if [ $signed_in == "No" ]; then
        echo "You are not currently signed in to the Mac App Store. Let's get you signed in!"
        read -p 'Apple ID Email: ' apple_id
        mas signin $apple_id
    fi
    bash scripts/mas_install.sh Xcode
    /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept
fi

# Newly setup computers often don't have pip install.
if [ ! -f /usr/local/bin/pip ]; then
    echo "Missing pip! Installing with easy_install"
    sudo easy_install pip
fi

# For now we need to specifically install ansible 2.2 since some of the tasks utilize features only in
# 2.2 and that is not the current version install by `pip installed ansible`
if [ ! -f /usr/local/bin/ansible ]; then
    echo "Installing Ansible 2.2"
    sudo pip install git+git://github.com/ansible/ansible.git@stable-2.2
fi

# This will get our current console user regardless of whether the script if run with sudo or not
logged_in_user=$(python -c "import SystemConfiguration, sys; sys.stdout.write(SystemConfiguration.SCDynamicStoreCopyConsoleUser(None, None, None)[0]);")

# Install ansible-galaxy roles and run main playbook
sudo -u "$logged_in_user" ansible-galaxy install -r requirements.yml
sudo -u "$logged_in_user" ansible-playbook -i "localhost," main.yml $@


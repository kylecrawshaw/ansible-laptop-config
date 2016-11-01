#!/bin/bash

# Check if the mas-cli exists and look up the latest release to install 
if [ ! -f /usr/local/bin/mas ]; then
    mas_latest_release=$(curl -s https://api.github.com/repos/mas-cli/mas/releases/latest | python -c "import sys, json; sys.stdout.write(json.load(sys.stdin)['assets'][0]['browser_download_url']);");
    curl -L $mas_latest_release -o mas.zip;
    unzip mas.zip -d /usr/local/bin/
    rm mas.zip
fi

if [ ! -d "/Applications/Xcode.app" ]; then
    signed_in=$([[ $(mas account) == *"Not signed in"* ]] && echo "No" || echo "Yes")
    if [ $signed_in == "No" ]; then
        echo "You are not currently signed in to the Mac App Store. Let's get you signed in!"
        read -p 'Apple ID Email: ' apple_id
        mas signin $apple_id
    fi
    bash scripts/mas_install.sh Xcode
    /Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept
fi

[ ! -f /usr/local/bin/ansible ] && sudo easy_install pip
[ ! -f /usr/local/bin/ansible ] && sudo pip install git+git://github.com/ansible/ansible.git@stable-2.2

logged_in_user=$(python -c "import SystemConfiguration, sys; sys.stdout.write(SystemConfiguration.SCDynamicStoreCopyConsoleUser(None, None, None)[0]);")

# Certain ansible tasks call command line tools that prompt for sudo and 'become' will not help
#echo "Extending sudo timestamp_timeout to 60 minutes."
# sudo -u "$logged_in_user" ansible -c "local" localhost -m lineinfile -a "dest=/etc/sudoers line='Defaults:{{ ansible_user }} timestamp_timeout=60' state=present" --become --ask-become-pass

# Install ansible-galaxy roles and run main playbook
sudo -u "$logged_in_user" ansible-galaxy install -r requirements.yml
sudo -u "$logged_in_user" ansible-playbook -i "localhost," main.yml $@


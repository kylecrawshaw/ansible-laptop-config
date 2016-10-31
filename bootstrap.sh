#!/bin/bash

[ ! -f /usr/local/bin/ansible ] && sudo easy_install pip

[ ! -f /usr/local/bin/ansible ] && sudo pip install git+git://github.com/ansible/ansible.git@stable-2.2

logged_in_user=$(python -c "import SystemConfiguration, sys; sys.stdout.write(SystemConfiguration.SCDynamicStoreCopyConsoleUser(None, None, None)[0]);")
sudo -u "$logged_in_user" ansible-galaxy install -r requirements.yml
sudo -u "$logged_in_user" ansible-playbook -i "localhost," main.yml $@

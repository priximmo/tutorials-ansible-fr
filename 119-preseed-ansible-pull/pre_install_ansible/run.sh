#!/usr/bin/bash


ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook /root/preinstall/install_ansible_pull.yml 2>&1 > error.log

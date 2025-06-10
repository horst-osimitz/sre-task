#!/bin/bash

export PATH=/usr/local/bin:$PATH
export ANSIBLE_CONFIG=/Users/horstosimitz/.ansible.cfg

cd /Users/horstosimitz/github/com/horst-osimitz/sre-task/ansible/
ansible-playbook -i inventories/demo -u ansible renew-certificate.yaml --extra-vars "{\"domain_name\": \"$1\"}" > /var/log/ansible/renew_certificate_app.log 2>&1

#!/bin/bash

set -e
set -x

cd tests
ansible-galaxy install -r requirements.yml
ansible-playbook test.yml

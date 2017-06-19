#!/bin/bash

set -e
set -x


container_name=ansible
container_id=$(mktemp)

# Need to run Ansible as separate process, so that systemd is started within the container. Create a random file to store the container ID.
# https://www.jeffgeerling.com/blog/2016/how-i-test-ansible-configuration-on-7-different-oses-docker
docker run \
  -d -it --privileged --name "$container_name" \
  --volume=`pwd`:/etc/jenkins-deploy:ro \
  --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
  geerlingguy/docker-centos7-ansible > "${container_id}"

sleep 3
docker logs "$container_name"

# https://circleci.com/docs/1.0/docker/#docker-exec
sudo lxc-attach -n "$(cat ${container_id})" -- bash -c \
  "cd /etc/jenkins-deploy/tests && ansible-playbook --syntax-check test.yml"

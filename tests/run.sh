#!/bin/sh

set -e
set -x


function cleanup() {
  docker kill "$container_name" || true
  docker rm "$container_name" || true
}


container_name=ansible
cleanup

# Need to run Ansible as separate process, so that systemd is started within the container. Create a random file to store the container ID.
# https://www.jeffgeerling.com/blog/2016/how-i-test-ansible-configuration-on-7-different-oses-docker
docker run \
  -d -it --privileged --name "$container_name" \
  --volume=`pwd`:/etc/jenkins-deploy:ro \
  --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
  --workdir /etc/jenkins-deploy/tests \
  geerlingguy/docker-centos7-ansible

sleep 3
docker logs "$container_name"

docker exec \
  -it "$container_name" \
  ansible-playbook --syntax-check test.yml

cleanup

#!/usr/bin/bash

###############################################################
#  TITRE: 
#
#  AUTEUR:   Xavier
#  VERSION: 
#  CREATION:  
#  MODIFIE: 
#
#  DESCRIPTION: 
###############################################################

set -eo pipefail

# Variables ###################################################

CONTAINER_USER=$USER
ANSIBLE_DIR="ansible_dir"

# Functions ###################################################

help(){
  echo "
Usage: $0 
-c <number> : create container and add the number of containers
-i : information (ip and name)
-s : start all containers created by this script
-t : same to stop all containers
-d : same for drop all containers
-a : create an inventory for ansible with all ips
  "
}

createContainers(){
  CONTAINER_NUMBER=$1
  CONTAINER_HOME=/home/${CONTAINER_USER}
  CONTAINER_CMD="sudo podman exec "

	# Calcul du id à utiliser
  id_already=`sudo podman ps -a --format '{{ .Names}}' | awk -v user="${CONTAINER_USER}" '$1 ~ "^"user {count++} END {print count}'`
  id_min=$((id_already + 1))
  id_max=$((id_already + ${CONTAINER_NUMBER}))
  
	# Création des conteneurs en boucle
	for i in $(seq $id_min $id_max);do
		sudo podman run -d --systemd=true --publish-all=true -v /srv/data:/srv/data --name ${CONTAINER_USER}-debian-$i -h ${CONTAINER_USER}-debian-$i docker.io/priximmo/buster-systemd-ssh
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "useradd -m -p sa3tHJ3/KuYvI ${CONTAINER_USER}"
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "mkdir -m 0700 ${CONTAINER_HOME}/.ssh && chown ${CONTAINER_USER}:${CONTAINER_USER} ${CONTAINER_HOME}/.ssh"
		sudo podman cp ${HOME}/.ssh/id_rsa.pub ${CONTAINER_USER}-debian-$i:${CONTAINER_HOME}/.ssh/authorized_keys
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "chmod 600 ${CONTAINER_HOME}/.ssh/authorized_keys && chown ${CONTAINER_USER}:${CONTAINER_USER} ${CONTAINER_HOME}/.ssh/authorized_keys"
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "echo '${CONTAINER_USER}   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "service ssh start"
	done

	infosContainers

  exit 0
}

infosContainers(){
	echo ""
	echo "Informations des conteneurs : "
	echo ""
  sudo podman ps -aq | awk '{system("sudo podman inspect -f \"{{.Name}} -- IP: {{.NetworkSettings.IPAddress}}\" "$1)}'
	echo ""
  exit 0
}

dropContainers(){
  sudo podman ps -a --format {{.Names}} | awk -v user=${CONTAINER_USER} '$1 ~ "^"user {print $1" - dropping...";system("sudo podman rm -f "$1)}'
  infosContainers
}

startContainers(){
  sudo podman ps -a --format {{.Names}} | awk -v user=${CONTAINER_USER} '$1 ~ "^"user {print $1" - starting...";system("sudo podman start "$1)}'
  infosContainers
}

stopContainers(){
  sudo podman ps -a --format {{.Names}} | awk -v user=${CONTAINER_USER} '$1 ~ "^"user {system(print $1" - stopping...";"sudo podman stop "$1)}'
  infosContainers
}

createAnsible(){
	echo ""
  mkdir -p ${ANSIBLE_DIR}
  echo "all:" > ${ANSIBLE_DIR}/00_inventory.yml
  echo "  vars:" >> ${ANSIBLE_DIR}/00_inventory.yml
  echo "    ansible_python_interpreter: /usr/bin/python3" >> ${ANSIBLE_DIR}/00_inventory.yml
  echo "  hosts:" >> ${ANSIBLE_DIR}/00_inventory.yml
  sudo podman ps -aq | awk '{system("sudo podman inspect -f \"    {{.NetworkSettings.IPAddress}}:\" "$1)}' >> ${ANSIBLE_DIR}/00_inventory.yml
  mkdir -p ${ANSIBLE_DIR}/host_vars
  mkdir -p ${ANSIBLE_DIR}/group_vars
	echo ""
}


# Let's Go !! #################################################

if [ "$#" -eq  0 ];then
help
fi

while getopts ":c:ahitsd" options; do
  case "${options}" in 
		a)
			createAnsible
			;;
    c)
			createContainers ${OPTARG}
      ;;
		i)
			infosContainers
			;;
		s)
			startContainers
			;;
		t)
			stopContainers
			;;
		d)
			dropContainers
			;;
    h)
      help
      exit 1
      ;;
    *)
      help
      exit 1
      ;;
  esac
done

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


# Functions ###################################################

help(){
  echo "Usage: $0 [ -c <number> ] [ -u <user> ] " 1>&2
  exit 1
}

createContainers(){
  CONTAINER_NUMBER=$1
  CONTAINER_USER=$2
  CONTAINER_HOME=/home/$2
  CONTAINER_CMD="sudo podman exec "

	# Calcul du id à utiliser
  id_already=`sudo podman ps -a --format '{{ .Names}}' | awk -v user="${CONTAINER_USER}" '$1 ~ "^"user {count++} END {print count}'`
  id_min=$((id_already + 1))
  id_max=$((id_already + ${CONTAINER_NUMBER}))
  
	# Création des conteneurs en boucle
	for i in $(seq $id_min $id_max);do
		sudo podman run -d --systemd=true --publish-all=true -v /srv/data:/srv/html --name ${CONTAINER_USER}-debian-$i -h ${CONTAINER_USER}-debian-$i docker.io/priximmo/buster-systemd-ssh
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "useradd -m -p sa3tHJ3/KuYvI ${CONTAINER_USER}"
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "mkdir -m 0700 ${CONTAINER_HOME}/.ssh && chown ${CONTAINER_USER}:${CONTAINER_USER} ${CONTAINER_HOME}/.ssh"
		sudo podman cp ${CONTAINER_HOME}/.ssh/id_rsa.pub ${CONTAINER_USER}-debian-$i:${CONTAINER_HOME}/.ssh/authorized_keys
		${CONTAINER_CMD} ${USERNAME}-debian-$i /bin/sh -c "chmod 600 ${CONTAINER_HOME}/.ssh/authorized_keys && chown ${CONTAINER_USER}:${CONTAINER_USER} ${CONTAINER_HOME}/.ssh/authorized_keys"
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "echo '${CONTAINER_USER}   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
		${CONTAINER_CMD} ${CONTAINER_USER}-debian-$i /bin/sh -c "service ssh start"
	done

	infosContainers ${CONTAINER_USER}

  exit 0
}

infosContainers(){
	echo ""
	echo "Informations des conteneurs : "
	echo ""
  sudo podman ps -aq | awk '{system("sudo podman inspect -f \"{{.Name}} -- IP: {{.NetworkSettings.IPAddress}}\" "$1)}'
	echo ""

}

dropContainers(){
  CONTAINER_USER=$1
  sudo podman ps -a --format {{.Names}} | awk -v user=$CONTAINER_USER '$1 ~ "^"user {system("sudo podman rm -f "$1)}'
}

startContainers(){
  CONTAINER_USER=$1
  sudo podman ps -a --format {{.Names}} | awk -v user=$CONTAINER_USER '$1 ~ "^"user {system("sudo podman start "$1)}'
}

stopContainers(){
  CONTAINER_USER=$1
  sudo podman ps -a --format {{.Names}} | awk -v user=$CONTAINER_USER '$1 ~ "^"user {system("sudo podman stop "$1)}'
}

createAnsible(){
  CONTAINER_USER=$1
	echo ""
  	ANSIBLE_DIR="ansible_dir"
  	mkdir -p $ANSIBLE_DIR
  	echo "all:" > $ANSIBLE_DIR/00_inventory.yml
	echo "  vars:" >> $ANSIBLE_DIR/00_inventory.yml
    echo "    ansible_python_interpreter: /usr/bin/python3" >> $ANSIBLE_DIR/00_inventory.yml
  echo "  hosts:" >> $ANSIBLE_DIR/00_inventory.yml
  for conteneur in $(sudo podman ps -a | awk -v user=$CONTAINER_USER '$0 ~ "^"user {print $1}');do      
    docker inspect -f '    {{.NetworkSettings.IPAddress }}:' $conteneur >> $ANSIBLE_DIR/00_inventory.yml
  done
  mkdir -p $ANSIBLE_DIR/host_vars
  mkdir -p $ANSIBLE_DIR/group_vars
	echo ""
}


# Let's Go !! #################################################


if [ $# == 0 ];then
  help
fi


while getopts ":a:c:u:h:i:t:s:d:" options; do
  case "${options}" in 
		a)
			createAnsible ${OPTARG}
			;;
    c)
			ACTION="create"
      CONTAINER_NUMBER=${OPTARG}
      ;;
    u)
      CONTAINER_USER=${OPTARG}
      ;;
		i)
			infosContainers
			;;
		s)
			startContainers ${OPTARG}
			;;
		t)
			stopContainers ${OPTARG}
			;;
		d)
			dropContainers ${OPTARG}
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

if [[ "$ACTION" == "create" ]];then
	createContainers ${CONTAINER_NUMBER} ${CONTAINER_USER}
fi

help

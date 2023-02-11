#!/bin/bash

############################################################
#
#  Description : déploiement à la volée de conteneur podman
#
#  Auteur : Xavier
#
#  Date : 28/12/2018 - V2.0
#
###########################################################


# Functions #########################################################

help(){
echo "

Attention script à lancer en sudo avec podman
avec podman d'installé sur la machine
sudo apt install podman 

Options :
		- --create : lancer des conteneurs -- nb + username

		- --drop : supprimer les conteneurs créer par le deploy.sh
	
		- --infos : caractéristiques des conteneurs (ip, nom, user...)

		- --start : redémarrage des conteneurs

		- --ansible : déploiement arborescence ansible

"

}

createNodes() {
	# définition du nombre de conteneur
	nb_machine=1
	[ "$1" != "" ] && nb_machine=$1
	# setting min/max
	min=1
	max=0
  USERNAME=$2
  HOME_USER="/home/${USERNAME}"
	# récupération de idmax
	idmax=`docker ps -a --format '{{ .Names}}' | awk -F "-" -v user="$USERNAME" '$0 ~ user"-debian" {print $3}' | sort -r |head -1`
	# redéfinition de min et max
	min=$(($idmax + 1))
	max=$(($idmax + $nb_machine))

	# lancement des conteneurs
	for i in $(seq $min $max);do
		podman run -tid --systemd=true --publish-all=true -v /srv/data:/srv/html --name ${USERNAME}-debian-$i -h ${USER}-debian-$i docker.io/priximmo/buster-systemd-ssh
		podman exec -ti ${USERNAME}-debian-$i /bin/sh -c "useradd -m -p sa3tHJ3/KuYvI $USERNAME"
		podman exec -ti ${USERNAME}-debian-$i /bin/sh -c "mkdir  ${HOME_USER}/.ssh && chmod 700 ${HOME_USER}/.ssh && chown $USERNAME:$USERNAME $HOME_USER/.ssh"
	podman cp ${HOME_USER}/.ssh/id_rsa.pub ${USERNAME}-debian-$i:$HOME_USER/.ssh/authorized_keys
	podman exec -ti ${USERNAME}-debian-$i /bin/sh -c "chmod 600 ${HOME_USER}/.ssh/authorized_keys && chown $USERNAME:$USERNAME $HOME_USER/.ssh/authorized_keys"
		podman exec -ti $USERNAME-debian-$i /bin/sh -c "echo '$USERNAME   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
		podman exec -ti $USERNAME-debian-$i /bin/sh -c "service ssh start"
		echo "Conteneur $USERNAME-debian-$i créé"
	done
	infosNodes $USERNAME

}

dropNodes(){
  USERNAME=$1
	echo "Suppression des conteneurs..."
	podman rm -f $(podman ps -a | grep $USERNAME-debian | awk '{print $1}')
	echo "Fin de la suppression"
}

startNodes(){
  USERNAME=$1
	echo ""
	docker start $(docker ps -a | grep $USERNAME-debian | awk '{print $1}')
  for conteneur in $(docker ps -a | grep $USERNAME-debian | awk '{print $1}');do
		podman exec -ti $conteneur /bin/sh -c "service ssh start"
  done
	echo ""
}


createAnsible(){
  USERNAME=$1
	echo ""
  	ANSIBLE_DIR="ansible_dir"
  	mkdir -p $ANSIBLE_DIR
  	echo "all:" > $ANSIBLE_DIR/00_inventory.yml
	echo "  vars:" >> $ANSIBLE_DIR/00_inventory.yml
    echo "    ansible_python_interpreter: /usr/bin/python3" >> $ANSIBLE_DIR/00_inventory.yml
  echo "  hosts:" >> $ANSIBLE_DIR/00_inventory.yml
  for conteneur in $(docker ps -a | grep $USERNAME-debian | awk '{print $1}');do      
    docker inspect -f '    {{.NetworkSettings.IPAddress }}:' $conteneur >> $ANSIBLE_DIR/00_inventory.yml
  done
  mkdir -p $ANSIBLE_DIR/host_vars
  mkdir -p $ANSIBLE_DIR/group_vars
	echo ""
}

infosNodes(){
  USERNAME=$1
	echo ""
	echo "Informations des conteneurs : "
	echo ""
	for conteneur in $(podman ps -a | grep $USERNAME-debian | awk '{print $1}');do      
		podman inspect -f '   => {{.Name}} - {{.NetworkSettings.IPAddress }}' $conteneur
	done
	echo ""
}



# Let's Go !!! ###################################################################""

#si option --create
if [ "$1" == "--create" ];then
	createNodes $2 $3

# si option --drop
elif [ "$1" == "--drop" ];then
	dropNodes $2

# si option --start
elif [ "$1" == "--start" ];then
	startNodes $2

# si option --ansible
elif [ "$1" == "--ansible" ];then
	createAnsible $2

# si option --infos
elif [ "$1" == "--infos" ];then
	infosNodes $2

# si aucune option affichage de l'aide
else
	help

fi





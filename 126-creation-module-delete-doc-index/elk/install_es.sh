#!/bin/bash


## Variables ##############################################

VERSION="7.6.1"
#VERSION="7.4.1"
IP=$(hostname -I | cut -d " " -f 2)


## Check root ############################################

sudo -n true
if [ $? -ne 0 ]
    then
        echo "This script requires user to have passwordless sudo access"
        exit
fi


## Functions ###########################################

dependency_check_deb() {
java -version
if [ $? -ne 0 ]
    then
        sudo apt install openjdk-11-jdk-headless -y
    elif [ "`java -version 2> /tmp/version && awk '/version/ { gsub(/"/, "", $NF); print ( $NF < 1.7 ) ? "YES" : "NO" }' /tmp/version`" == "YES" ]
        then
            sudo apt-get install java-11-openjdk-headless -y
fi
}

dependency_check_rpm() {
    java -version
    if [ $? -ne 0 ]
        then
				sudo yum install java-11-openjdk-headless.x86_64 -y
    fi
}

debian_elk() {
    sudo apt-get update
    sudo wget --directory-prefix=/opt/ https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}-amd64.deb
    sudo dpkg -i /opt/elasticsearch*.deb
    #sudo service elasticsearch start
}

rpm_elk() {
    sudo yum install wget -y
    sudo wget --directory-prefix=/opt/ https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}-x86_64.rpm
    sudo rpm -ivh /opt/elasticsearch*.rpm
    sudo systemctl enable elasticsearch
    #sudo systemctl start elasticsearch
}

vagrant_steps(){
#sudo systemctl stop firewalld
#sudo systemctl disable firewalld
sed -i s/"#discovery.seed_hosts:".*/"discovery.seed_hosts: [\"${IP}\", \"127.0.0.1\"]"/g /etc/elasticsearch/elasticsearch.yml
sed -i s/"#network.host:".*/"network.host: 0.0.0.0"/g /etc/elasticsearch/elasticsearch.yml
#sudo systemctl restart elasticsearch
}


## Exec ##################################

if [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]
    then
        echo " It's a Debian based system"
        dependency_check_deb
        debian_elk
				vagrant_steps
elif [ "$(grep -Ei 'fedora|redhat|centos' /etc/*release)" ]
    then
        echo "It's a RedHat based system."
        dependency_check_rpm
        rpm_elk
				vagrant_steps
else
    echo "This script doesn't support ELK installation on this OS."
fi

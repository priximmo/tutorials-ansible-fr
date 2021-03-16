%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : PACKER + ANSIBLE LOCAL/PULL

<br>

* packer : builder d'images (cloud, vmware, kvm...)

* ansible > installation de l'instance qui génère l'image

<br>

Deux exemples :

		* ansible simple : en local run de ansible avec vault

		* installation de ansible-pull

----------------------------------------------------------------------------------

# ANSIBLE : PACKER + ANSIBLE LOCAL/PULL


```
  "provisioners": [
    {
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'",
      "inline": [
        "sudo apt update 2>&1 >/dev/null",
        "sudo apt -qq -y install software-properties-common git ansible 2>&1 >/dev/null",
        "sed -i s/ens3/enp1s0/g /etc/netplan/50-cloud-init.yaml"
      ],
      "type": "shell"
    },
    {
      "type": "ansible-local",
      "command": "echo '{{user `pass`}}' | ansible-playbook",
      "playbook_file": "ansible/playbook.yml",
      "playbook_dir": "ansible",
      "staging_directory": "/tmp/",
      "extra_arguments": "--vault-password-file=/bin/cat"
    }
  ],
```

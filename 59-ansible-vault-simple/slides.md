%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Vault cas simple


<br>

Documentation : https://docs.ansible.com/ansible/latest/user_guide/vault.html
https://docs.ansible.com/ansible/latest/cli/ansible-vault.html

Objectif : chiffrer les secrets

<br>

La commande ansible-vault :

	* create : créé et ouvre un fichier dans un éditeur, sera chiffré à la fermeture

	* decrypt : déchiffre un fichier/variable (ne pas oublier de rechiffrer après)

	* edit : ouvre un fichier chiffré dans un éditeur (déchiffré)

	* view : voir le contenu d'un fichier chiffré

	* encrypt : chiffre un fichier

  * encrypt_string : chiffré une variable

	* rekey : reencrypt avec un nouveau secret

	
<br>

* type de données encryptées :
       * group variables files from inventory
       * host variables files from inventory
       * variables files passed to ansible-playbook with -e @file.yml or -e @file.json
       * variables files loaded by include_vars or vars_files
       * variables files in roles
       *  defaults files in roles
       *  tasks files
       *  handlers files
       *  binary files or other arbitrary files

-------------------------------------------------------------------------------

# ANSIBLE : Vault cas simple


<br>

* le cas le plus simple la création d'un fichier chiffré

```
ansible-vault create group_vars/vault.yml
```

<br>

* voir son contenu

```
ansible-view group_vars/vault.yml
```

<br>

* éditer son contenu

```
ansible-vault edit group_vars/vault.yml
```

<br>

* utiliser une variable

```
ansible -i "127.0.0.1," all -e "@mysecretfile.yml" --ask-vault -m debug -a "var=mavariable1"
```

-------------------------------------------------------------------------------

# ANSIBLE : Vault cas simple


<br>

* si dans l'inventaire ou le playbook

```
ansible -i "127.0.0.1," all  --ask-vault -m debug -a "var=mavariable1"
```

Cf : bonne pratique 

```
mavariable: "{{ vault_mavariable}}"
```

<br>

* ou sans prompt par un fichier

```
ansible -i "127.0.0.1," all  --vault-password-file ./.vault.txt -m debug -a "var=mavariable1"
```

<br>

ou encore en variable d'environnement

```
export ANSIBLE_VAULT_PASSWORD_FILE=./.vault.txt
```

<br>

* changement d'éditeur (bashrc)

```
export EDITOR=vim
```

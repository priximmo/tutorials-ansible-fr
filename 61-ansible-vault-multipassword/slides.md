%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Vault ID & multipassword


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

--------------------------------------------------------------------------------------------

# ANSIBLE : Vault ID & multipassword
	
<br>

* simple remplacement du prompt : --vault-id

```
ansible-vault encrypt --vault-id pwd.txt group_vars/all/vault.yml
ansible-vault edit --vault-id pwd.txt group_vars/all/vault.yml
ansible-vault edit --vault-id @prompt group_vars/all/vault.yml
ansible -i "127.0.0.1," all --vault-id pwd.txt  -m debug -a "msg='{{mysecret}}'"
```

<br>

* avec un id spécifique

```
ansible-vault encrypt --vault-id prod@pwd.txt group_vars/all/vault.yml
cat group_vars/all/vault.yml 
ansible -i "127.0.0.1," all --vault-id prod@pwd.txt  -m debug -a "msg='{{mysecret}}'"
```

--------------------------------------------------------------------------------------------

# ANSIBLE : Vault ID & multipassword
	

<br>

* playbook avec deux secrets

```
- name: test
  hosts: all
  connection: local
  tasks:
  - name: debug
    debug:
      msg: "{{montitre}} {{mysecret}}"
```

* deux fichiers en enrées :

```
ansible-vault encrypt --vault-id data@pwd-data.txt group_vars/all/vault-prod.yml
ansible-vault encrypt --vault-id app@pwd-app.txt group_vars/all/vault-dev.yml
ansible-playbook -i "127.0.0.1," --vault-id data@pwd-data.txt --vault-id app@pwd-app.txt playbook.yml
```

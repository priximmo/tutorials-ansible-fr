%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Vault String > pkoi pas ??


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

* définir un vault pour une variable

```
ansible-vault encrypt_string 'mon secret chut...' --name 'mysecret'
ansible -i "127.0.0.1," all --ask-vault  -m debug -a "var=mysecret"
```

<br>

* Pb : déchiffrement 

```
ansible-vault edit group_vars/all/vault.yml
```

Solution : recopier dans un fichier

<br>

* Pb de recherche si chiffrement total

```
grep -ri "mysecret" group_vars/
```

Solution : 

```
mavariable: "{{ vault_mavariable}}"
```

%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : UN PEU DE CLEAN... VERS LE STATEFUL ;)


<br>

Ansible ne possède pas de base de données > diff Terraform

<br>

Ansible possède pas de source de vérité stricte
		> un user déjà créé, un fichier... ne sera pas supprimé

<br>

Mais comment cleaner quand on débute ??

	* avoir une liste de référence > les variables ansible

	* avoir une liste existante > la collecte via une task

	* comparer et virer le surplus

<br>

Pour cela, un exemple :
 
		* module shell + set_fact : liste de l'existant

		* module template : création/maj des fichiers légitimes

		* module file : pour le clean

		* changed_when : traitement de l'idempotence

Attention : retenez le principe...

-----------------------------------------------------------------------------------

# ANSIBLE : UN PEU DE CLEAN... VERS LE STATEFUL ;)


<br>

* variable de fichiers et un répertoire

```
my_files:
  - file1
  - file2
  - file3
  - file4
my_dir: "/tmp/xavki"
```

<br>

* création du répertoire si il n'existe pas

```
  - name: ensure directory exists
    file:
      path: "{{ my_dir }}"
      state: directory
```

-----------------------------------------------------------------------------------

# ANSIBLE : UN PEU DE CLEAN... VERS LE STATEFUL ;)


<br>

* collecte de la liste des fichiers existants (connaître les intrus)

```
  - name: list of files in the directory
    shell: "ls {{ my_dir }}"
    register: __files_list_before
    changed_when: __files_list_before.rc != 0
```

<br>

* éventuellement on affiche (cf stdout_lines)

```
  - name: print __files_list_before
    debug:
      var: __files_list_before.stdout_lines
```


-----------------------------------------------------------------------------------

# ANSIBLE : UN PEU DE CLEAN... VERS LE STATEFUL ;)


<br>

* utilisation classique du module template

```
  - name: add/update files from my_files
    template:
      src: mytemplate.txt.j2
      dest: "{{ my_dir }}/{{ item }}.txt"
    with_items: "{{ my_files }}"
```

* on oublie pas le fichier ;)

```
Je suis le fichier {{ item }} !!
```

<br>

* remise en forme de notre liste de fichier issue de la variable 

```
  - name: format list of files with myfiles var
    set_fact: 
      __list_of_files_trusted: "{{ __list_of_files_trusted | default([]) }} + [ '{{ item }}.txt' ]" 
    with_items: "{{ my_files }}"
```

Rq : c'est notre source de vérité


-----------------------------------------------------------------------------------

# ANSIBLE : UN PEU DE CLEAN... VERS LE STATEFUL ;)



<br>

* on check le contenu et le fonctionnement de notre fact

```
  - name: print trusted list
    debug:
      var: __list_of_files_trusted
```

<br>

* et on fait le clean avec le module file (plus idempotent qu'un rm)

```
  - name: clean older files
    file:
      path: "{{ my_dir }}/{{ item }}"
      state: absent
    when: item not in __list_of_files_trusted
    with_items: "{{ __files_list_before.stdout_lines }}"
```

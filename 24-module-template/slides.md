%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module TEMPLATE


Documentation: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html

Objectifs : génération de fichier à partir de modèles intégrant des variables
		format jinja2 (python)

<br>

PARAMETRES :

<br>

* attributes : attributs de fichiers

<br>

* backup : créé une sauvegarde avant la modification (idem copy)

<br>

* block_end_string : fin de block dans les templates ( %})

<br>

* block_start_string : début de block ({%)

<br>

* dest : fichier cible ou généré

<br>

* follow : suivre les liens symboliques

<br>

* force : écraser si le fichier de destination existe (défaut : yes)

<br>

* group : group propriétaire du fichier

<br>

* lstrip_blocks : respect stricte ou non des tabulations et blancs

```
#jinja2:lstrip_blocks: True
```

-------------------------------------------------------------------------------------------

# ANSIBLE : Module TEMPLATE


<br>

* mode : permissions du fichier (0755 ou r+rwx,g+rx,o+rx)

<br>

* newline_sequence : quel élément est utilisé pour les nouvelles lignes

<br>

* output_encoding : encodage du fichier généré (defaut : utf8)

<br>

* owner : propriétaire du fichier

<br>

* src : fichier source (template), attention localisation
		* attention : rôles / dir template / .

<br>

* trim_blocks : supprimer les retours à la ligne des blocks

<br>

* unsafe_writes : éviter la corruption des fichiers

<br>

* validate : commande de validation avant modification (idem copy)

<br>

* variable_end_string : caractères des fins des variables

<br>

* variable_start_string : caractères de début des variables


-------------------------------------------------------------------------------------------

# ANSIBLE : Module TEMPLATE


<br>

* le plus simplte : 

```
- name: preparation local
  hosts: all
  vars:
    var1: "Xavier !!!"
  tasks:
  - name: template
    template:
      src: montemplate.txt.j2
      dest: /tmp/hello.txt
```

avec comme template :

```
Hello {{ var1 }}
````

-------------------------------------------------------------------------------------------

# ANSIBLE : Module TEMPLATE


<br>

* quelques variables utiles

```
    ansible_managed : pour afficher en début de chaque template (prévenir)
    template_host : machine qui a joué le template
    template_uid : user à l'origine de la modification via le template
    template_path : localisation du fichier
    template_fullpath : chemin complet
    template_run_date : date de modification

```

exemple au début du fichier

```
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}

```


-------------------------------------------------------------------------------------------

# ANSIBLE : Module TEMPLATE



<br>

* permissions, user et group

```
  - name: template
    template:
      src: montemplate.txt.j2
      dest: /tmp/hello.txt
      owner: oki
      group: oki
      mode: 0755
```

<br>

* le backup avant modification


```
  - name: template
    template:
      src: montemplate.txt.j2
      dest: /tmp/hello.txt
      owner: oki
      group: oki
      mode: 0755
      backup: yes
```


----------------------------------------------------------------------------------------------

# ANSIBLE : Module TEMPLATE


<br>

* parcourir une liste > un fichier par itération

```
  vars:
    var1: "Xavier !!!"
    var2:
      - { nom: "xavier", age: "40" }
      - { nom: "paul", age: "22" }
      - { nom: "pierre", age: "25" }
  tasks:
  - name: template
    template:
      src: montemplate.txt.j2
      dest: "/tmp/hello_{{ item.nom }}.txt"
    with_items:
    - "{{ var2 }}"
```

template :

```
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}
Hello {{ var1 }}
je suis {{ item.nom }}
j'ai {{ item.age }}
```

----------------------------------------------------------------------------------------------

# ANSIBLE : Module TEMPLATE



<br>

* itération dans le template

```
  vars:
    var1: "Xavier !!!"
    var2:
      - { nom: "xavier", age: "40" }
      - { nom: "paul", age: "22" }
      - { nom: "pierre", age: "25" }
  tasks:
  - name: template
    template:
      src: montemplate.txt.j2
      dest: "/tmp/hello_all.txt"
```

template :

```
#{{ template_run_date }} - "{{ ansible_managed }}" via {{ template_uid }}@{{ template_host }}
Hello {{ var1 }}
{% for personne in var2 %}
    je suis {{ personne.nom }}
    j'ai {{ personne.age }}
{% endfor %}
```

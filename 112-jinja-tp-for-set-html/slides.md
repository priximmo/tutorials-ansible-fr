%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : JINJA TP - SET & FOR

<br>

* cf vidéo 73 > templates HTML

<br>

PAGE ACCUEIL : index.html

* boucle sur les machines de l'inventaire

* noms explicites (hostname vs nom d'invenaire)

* liens cliquables

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR


<br>

* entête html (rien de spécial)

```
<html>
<head>
<link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="wrapper">
    <div class="table">
        <div class="row header grey">
          <div class="cell">
            Server
          </div>
        </div>
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

* Itération de chaque ligne sur chaque serveur

```
{% for server in groups['all'] %}
```

Note :  Ouverture de la boucle > liste du group ALL

<br>

* définition de la ligne

```
        <div class="row">
          <div class="cell" data-title="Server">
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

* récupération du nom/hostname

```
<a href="./server-{{ hostvars[server]['ansible_hostname'] }}.html" >{{ hostvars[server]['ansible_hostname'] }}</a><br>
```

Notes :
		* utilisation et récupération des hostvars
		* balise <a>
		* renvoi vers une page <hostname>.html

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

* on ferme les balises et la boucle for

```
          </div>
        </div>
        {% endfor %}
    </div>
  </div>
</body>
</html>
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

PAGES SERVEURS : <serveurs>.html

* informations spécifiques machine par machine

* traitement des variables > split (;)

* agrégation d'information (boucle sur boucle)

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

* entête HTML > nom de la machine

```
#jinja2: lstrip_blocks: "True"
<html>
<head>
<link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="wrapper">
    <div class="table">
        <div class="row header grey">
          <div class="cell">
            {{ ansible_hostname }}
          </div>
          <div class="cell">
          </div>
          <div class="cell">
          </div>
        </div>
    </div>
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

TABLEAU 1: entête

```
    <div class="table">
        <div class="row header pink">
          <div class="cell">
            Cpu per core
          </div>
          <div class="cell">
            Mem Total Mb
          </div>
          <div class="cell">
            Mem Used Mb
          </div>
          <div class="cell">
            Nb Services Sd
          </div>
        </div>
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>


TABLEAU 1: partie variable

```
        <div class="row">
          <div class="cell" data-title="CpuPerCore">
            {{ ansible_processor_cores }}
          </div>
          <div class="cell" data-title="MemTotal">
            {{ ansible_memory_mb.real.total }}
          </div>
          <div class="cell" data-title="MemUsed">
            {{ ansible_memory_mb.real.used }}
          </div>
          <div class="cell" data-title="Service">
            {{ service_up }}
          </div>
        </div>
    </div>
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

TABLEAU 2: entête du tableau

```
    <div class="table">
        <div class="row header">
          <div class="cell">
            Database
          </div>
          <div class="cell">
            Size Db (Mb)
          </div>
          <div class="cell">
            Table
          </div>
          <div class="cell">
            Nb rows
          </div>
        </div>
``` 

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

TABLEAU 2: boucle sur boucle

```
        {% for db in __data_db_size_mb.stdout_lines %}
        {% set db = db.split(";") %}
          {% for tb in __data_tb_rows_nb.stdout_lines %}
            {% set tb = tb.split(";") %}
            {% if tb[0] == db[0] %}
            <div class="row">
              <div class="cell" data-title="CpuPerCore">
                {{ db[0] }}
              </div>
              <div class="cell" data-title="MemTotal">
                {{ db[1] }}
              </div>
              <div class="cell" data-title="MemUsed">
                {{ tb[1] }}
              </div>
              <div class="cell" data-title="Service">
                {{ tb[2] }}
              </div>
            </div>
          {% endif %}
          {% endfor %}
        {% endfor %}
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

TABLEAU 3: contenu plat

```
    <div class="table">
      <div class="row header blue">
          <div class="cell">
            Sudoers
          </div>
      </div>
      <div class="row">
        <div class="cell">
          Sudoers :
          {% for line in __file_sudoers.stdout_lines %}
            {{ line }}<br>
          {% endfor %}
        </div>
      </div>
    </div>
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA TP - SET & FOR

<br>

TABLEAU 4: contenu plat

```
    <div class="table">
      <div class="row header green">
        <div class="cell">
          OS_Release
        </div>
      </div>
      <div class="row">
        <div class="cell">
          Release :
          {% for line in __os_release.stdout_lines %}
            {{ line }}<br>
          {% endfor %}
        </div>
      </div>
    </div>
  </div>
</body>
</html> 
```

%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module URI


<br>

Documentation : https://docs.ansible.com/ansible/2.3/uri_module.html

Objectifs : passer des requêtes http ou https et interagir avec

<br>

PARAMETRES :

<br>

* HEADER_ : paramètre header pour passer vos requêtes

<br>

* body : si activation du format json récupérer une variable

<br>

* body_format : format du body json ou raw

<br>

* creates : si le fichier existe la tâche n'est pas lancée

<br>

* dest : répertoire de destination

<br>

* follow_redirects : suivre les redirections

<br>

* force_basic_aut : forcer le basic auth

--------------------------------------------------------------------------------

# ANSIBLE : Module URI


<br>

* headers : ajout de header (format yaml)

<br>

* method : GET / POST/ DELETE / PUT / HEAD / PATCH / TRACE...

<br>

* others : autre argument pour le file module (fichier créé)

<br>

* password : pour le basic auth

<br>

* removes : supprime le fichier avant

<br>

* return_content : pour récupérer le contenu

<br>

* status_code : 200, 301... [200,201...]

<br>

* timeout : en seconde

<br>

* url : target

<br>

* user : pour basic_auth

<br>

* validate_certs : stricte tls ou non

--------------------------------------------------------------------------------

# ANSIBLE : Module URI


<br>

* cas simple

```
- name: test
  hosts: all
  tasks:
  - name: uri
    uri: 
      url: http://xavki.blog
      method: GET
      validate_certs: False
```

<br>

* vérification du status

```
- name: test
  hosts: all
  tasks:
  - name: uri
    uri: 
      url: http://xavki.blog
      method: GET
      validate_certs: False
      status_code: 200
```

--------------------------------------------------------------------------------

# ANSIBLE : Module URI


<br>

* liste de code retour

```
  - name: uri
    uri: 
      url: https://httpbin.org/status/500
      method: POST
      status_code: [200,201,301]
      validate_certs: False
```

<br>

* récupération du contenu

```
- name: test
  hosts: all
  tasks:
  - name: uri
    uri: 
      url: http://httpbin.org/get
      return_content: yes
      method: GET
    register: __content
  - name: debug
    debug:
      var: __content.content
```

--------------------------------------------------------------------------------

# ANSIBLE : Module URI


<br>

* utilisation du format json

```
  - name: uri
    uri: 
      url: https://httpbin.org/get
      method: GET
      return_content: yes
      validate_certs: False
      body_format: json
    register: __body
  - name: debug
    debug:
      var: __body.json.url
```

<br>

* validation du contenu

```
- name: test
  hosts: all
  tasks:
  - name: uri
    uri: 
      url: http://xavki.blog
      return_content: yes
      method: GET
      validate_certs: False
    register: __content
    failed_when: " 'xavki' not in __content.content"
```

--------------------------------------------------------------------------------

# ANSIBLE : Module URI


<br>

* basic auth

```
  - name: uri
    uri: 
      url: https://httpbin.org/basic-auth/toto/test
      user: "toto"
      password: "test"
      method: GET
      validate_certs: False
```



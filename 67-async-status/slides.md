%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : ASYNC STATUS


<br>

Documentation : https://docs.ansible.com/ansible/2.9/user_guide/playbooks_async.html

<br>

Objectifs : tâche long mise en background

Ansible lance une tache et reste dessus 

Maintien de la connexion ssh (évite le timeout)

2 cas de figures :
	* poll > 0 : reste en connexion mais sur la task
	* poll = 0 : passe en background et passe à la tache suivante

<br>

PARAMETRES A PASSER A UNE TASK

* poll : fréquence de check

* async : durée accordée à la tâche

<br>

```
#/bin/bash
echo "START"
sleep $1
echo "END"
exit
```

-----------------------------------------------------------------

# ANSIBLE : ASYNC STATUS

<br>

* connexion pour le test en local

```
- name: local test
  hosts: 127.0.0.1
  connection: local
  tasks:
```

<br>

* copie du script

```
  - name: Copy the script 
    copy: 
      src: takeyourtime.sh
      dest: "/tmp"
```

<br>

* lancement du script pour 20s en autorisant une duée de 100s
   
```
  - name: Execute the script
    shell:
      "chmod a+x /tmp/takeyourtime.sh &&  /tmp/takeyourtime.sh 20"  
    async: 100
    poll: 5
    register: __output_script
```

-----------------------------------------------------------------

# ANSIBLE : ASYNC STATUS

<br>

* suivi d'une autre task

```
  - name: test
    shell: echo toto
```

<br>

* debug de l'output

```
  - name: Some task just to debug
    debug: 
      var: __output_script.stdout_lines
```

<br>

* vérification du status de la tâche en background

```
  - name: Checking the Job Status
    async_status:
      jid: "{{ __output_script.ansible_job_id }}"
    register: job_result
    until: job_result.finished
    retries: 30
```

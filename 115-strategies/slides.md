%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Stratégies

<br>

* les forks > ansible.cfg

```
[defaults]
forks = 20
```

<br>

* strategy > playbook.yml

		* linear (default) : les hosts s'attendent (commencement de task)

		* free : ils ne s'attendent pas

--------------------------------------------------------------------

# ANSIBLE : Stratégies


<br>

* serial > playbook.yml

		* cadence de déploiement

		* important pour prévenir des risques de failed

```
serial: 2
serial: 30%
serial:
  - 1
  - 5
  - 100%
```

Note : reste sur le dernier chiffre pour finir

--------------------------------------------------------------------

# ANSIBLE : Stratégies


<br>

* throttle > pour une task

```
throttle: 1
```

<br>

* run_once

* delegate_to


https://docs.ansible.com/ansible/2.5/user_guide/playbooks_debugger.html

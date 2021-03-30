%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : VAGRANT PROVISIONNING

<br>

provisionning vagrant + ansible

<br>

Deux modes :

		* standard : via le host vagrant/ansible

		* ansible_local : ansible est lancé sur les noeuds distants

<br>

ANSIBLE via le host vagrant

* attention aux différentes phases et manière de lancer le playbook

	* au provisionning de chaque machine > avantage : clareté / inconvénient : sans dépendances

	* à la fin du provisionning de toutes les machines > avantage : dépendance / inconvénient : en cas d'erreur tout reprovisionner

----------------------------------------------------------------

# ANSIBLE : VAGRANT PROVISIONNING

<br>

PLAYBOOK

```
- name: install nginx
  hosts: all
  become: yes
  tasks:
  - name: install nginx
    apt:
      name: nginx,curl
      update_cache: yes
      cache_valid_time: 3600
  - name: start nginx
    service:
      name: nginx
      state: started
  - name: edit file
    copy:
      content: |
        {{ myvar }}
      dest: /var/www/html/index.nginx-debian.html
```

----------------------------------------------------------------

# ANSIBLE : VAGRANT PROVISIONNING

STANDARD

<br>

* simple :

```
      cfg.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/playbook.yml"
      end
```

* inventaire :

```
mkdir - p ansible/host_vars/
vim ansible/host_vars/vag1.yml
```

----------------------------------------------------------------

# ANSIBLE : VAGRANT PROVISIONNING

<br>

* construction d'un inventaire

```
      cfg.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/playbook.yml"
        #ansible.inventory_path = "ansible/inventory.yml"
        ansible.groups = {
          "group1" => ["vag1"],
          "group2" => ["vag2"],
          "group3" => ["vag[3:5]"],
          "all_groups:children" => ["group1", "group2"],
          "group1:vars" => {"myvar" => "grp1"},
          "group2:vars" => {"myvar" => "grp2"},
          "group3:vars" => {"myvar" => "grp2"},
          "all_groups:vars" => {"myvar" => "all"}
          }
      end
```

----------------------------------------------------------------

# ANSIBLE : VAGRANT PROVISIONNING


<br>

* prompt vagrant

```
  case ARGV[0]
  when "provision", "up"
  print "Define myvar ?\n"
  myvar = STDIN.gets.chomp
  print "\n"
  end
```

<br>

* intégration de la variable

```
      cfg.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/playbook.yml"
        ansible.host_vars = {
          "vag1" => {
              "myvar" => myvar
          }
        }
      end
```

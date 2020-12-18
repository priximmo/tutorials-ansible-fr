%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Modules Parted & LVM & Filesystem


<br>

Documentation Parted :
https://docs.ansible.com/ansible/2.9/modules/parted_module.html

Documentation LVG (PV/VG) :
https://docs.ansible.com/ansible/2.9/modules/lvg_module.html

Documentation filesystem :
https://docs.ansible.com/ansible/2.9/modules/filesystem_module.html


<br>

Objectifs : Créer une partition, PV > VG > LV > filesystem


<br>

PARTED :

* align : cylinder / minimal, none, optimal (d)

* device : le device

* flags : type de partition

* number : le nombre

* part_start : début de la partition en unités reconnues

* part_end : fin de la partition en unités reconnues

* part_type : extended / logical / primary (d)

* state : present / absent / info

* unit : B / % / cyl...

------------------------------------------------------------------------------

# ANSIBLE : Modules Parted & LVM & Filesystem


<br>

LVG :

* force : suppression des VG avec les LV

* pesize : taille du physical extend (d=4MB)

* pv_options : options complémentaires (pvcreate)

* pvs : PV du VG

* state : present / absent

* vg : nom du VG

* vg_options : options complémentaires du VG



------------------------------------------------------------------------------

# ANSIBLE : Modules Parted & LVM & Filesystem


<br>

LVOL :

* acitve : volume visible pour le host (d=yes)

* force : permettre la redimenssion du volume

* lv : nom du LV

* pvs : liste des volumes physiques (gain une étape)

* resizefs : yes / no

* shrink : pour la réduction

* size : %VG/PVS/FREE ou untiés

* state : present / absent

* thinpool : thin provisionning

* vg : nom du VG


------------------------------------------------------------------------------

# ANSIBLE : Modules Parted & LVM & Filesystem



<br>

* création d'une partition primaire

```
  - name: create a new primary partition
    parted:
      device: /dev/vdb
      number: 1
      flags: [ lvm ]
      state: present
```

<br>

* afficher les facts LVM

```
  - name: lvm debug
    debug:
      msg: "{{ ansible_lvm }}"
```

------------------------------------------------------------------------------

# ANSIBLE : Modules Parted & LVM & Filesystem

<br>

* création du PV et ajout au VG

```
  - name: create PV and VG
    lvg:
      vg: vg_xavki
      pvs: /dev/vdb1
```

<br>

* création du LV prenant 100% du VG

```
  - name: resize root lv
    lvol:
      vg: vg_xavki
      lv: lv_xavki
      size: 100%VG
```

------------------------------------------------------------------------------

# ANSIBLE : Modules Parted & LVM & Filesystem

<br>

* création du filesystème en ext4

```
  - name: create filesystem
    filesystem:
      fstype: ext4
      dev: "/dev/vg_xavki/lv_xavki"
      force: no
```

<br>

* création d'un répertoire pour le montage


```
  - name: Create a directory to mount the filesystem.
    file:
      path: "/xavki"
      state: directory
      mode: '0775'
```

<br>

* montage du volume dans le répertoire

```
  - name: Mount the created filesystem.
    mount:
      path: "/xavki"
      src: "/dev/vg_xavki/lv_xavki"
      fstype: "ext4"
      opts: rw,nosuid,noexec
      state: mounted
```


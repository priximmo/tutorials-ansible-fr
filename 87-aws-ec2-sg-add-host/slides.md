%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWS - Security Group & instances & add hosts

<br>

OBJECTIFS : 

* découvrir  des modules aws

* monter un blog wordpress

* en simplifiant les choses pour la pédagogie

* architecture


```
       |
       |
       |      +-------------------------+       +-------------------------+
       |      |  Worpdress              |       |                         |
+------------->  apache + php + code wp +------->        MariaDB          |
       |      +-------------------------+       +-------------------------+
       |
       |
       |
```


<br>

* Pré-Requis : boto & boto3

```
sudo apt python3-pip
pip3 install boto boto3 --user
```

Rq : boto n'est pas utilisable sur toutes les régions

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Security Group & instances & add hosts


<br>

```
  - name: Create security group for wordpress
    ec2_group:
      name: "{{ sec_group_wordpress }}"
      description: "Sec group for {{ sec_group_wordpress }}"
      vpc_id: "{{ vpc_id }}"
      region: "{{ region }}"
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{ ec2_secret_key }}"
      rules:
        - proto: tcp
          ports:
            - 22
          cidr_ip: 0.0.0.0/0
          rule_desc: allow all on ssh port
        - proto: tcp
          ports:
            - 80
          cidr_ip: 0.0.0.0/0
          rule_desc: allow http for allow
    register: __ec2_info_sec_group_wordpress
```


-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Security Group & instances & add hosts

<br>

```
  - name: Create security group for mariadb
    ec2_group:
      name: "{{ sec_group_mariadb }}"
      description: "Sec group for {{ sec_group_mariadb }}"
      vpc_id: "{{ vpc_id }}"
      region: "{{ region }}"
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{ ec2_secret_key }}"
      rules:
        - proto: tcp
          ports:
            - 22
          cidr_ip: 0.0.0.0/0
          rule_desc: allow all on ssh port
        - proto: tcp
          ports:
            - 3306
          cidr_ip: 172.31.0.0/16
          rule_desc: allow mariadb for allow
    register: __ec2_info_sec_group_mariadb
```


-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Security Group & instances & add hosts


<br>

```
  - name: create instance
    ec2:
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{  ec2_secret_key }}"
      key_name: "{{ key_name }}"
      id: "{{ id_wordpress }}-{{ ansible_date_time.date }}-9"
      group_id: "{{ __ec2_info_sec_group_wordpress.group_id }}"
      image: "{{ image }}"
      instance_type: t2.micro
      region: "{{ region }}"
      wait: true
      instance_tags:
        Type: Wordpress
        Env: Production
      exact_count: 1
      count_tag:
        Type: Wordpress
    register: __wordpress_instances
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Security Group & instances & add hosts


<br>

```
  - name: create instance
    ec2:
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{  ec2_secret_key }}"
      key_name: "{{ key_name }}"
      id: "{{ id_mariadb }}-{{ ansible_date_time.date }}-9"
      group_id: "{{ __ec2_info_sec_group_mariadb.group_id }}"
      image: "{{ image }}"
      instance_type: t2.micro
      region: "{{ region }}"
      wait: true
      instance_tags:
        Type: Mariadb
        Env: Production
      exact_count: 1
      count_tag:
        Type: Mariadb
    register: __mariadb_instances
```

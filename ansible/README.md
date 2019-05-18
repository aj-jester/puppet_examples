# ansible
Install ansible and define playbooks.

## Usage

Adding a playbook

  * Default path for playbook `<caller_module_name>/<title>.yaml.playbook.ansible.erb`
  * The template suffix must be `.yaml.playbook.ansible.erb`

  ~~~
  ansible::playbook { '<title>': }
  ~~~


Lets add a `r10k` playbook to `ccm_puppet` module

  * Add template to `ccm_puppet/templates/r10k.yaml.ansible.playbook.erb`

  * Add resource anywhere inside the calling module, in thie case `ccm_puppet`.
  ~~~
  ansible::playbook { 'r10k': }
  ~~~

If you would like to share playbooks between modules, pass `module` param

  ~~~
  ansible::playbook {
    'cool_task':
      module => 'module_b',
  }
  ~~~

**Pop Quiz** (Yah, I hated those too.)

  Q: Can you guess the template path for the define above?

  A: `modules/module_b/templates/cool_task.yaml.ansible.playbook.erb` :D

## Dynamic Inventory
The inventory script in `files/ansible_inventory_ccm.rb` dynamically generates ansible host groups based on environment and foreman hostgroup name.

In your home directory add `~/.ansible_inventory_ccm.yml` with Foreman LDAP creds:
  ~~~
  foreman:
    username: <ldap_username>
    password: <ldap_password>
  ~~~

Run ansible command with `-i <inventory_file>`:
  ~~~
  $ ansible stg_site_cdh \
      -i /usr/local/bin/ansible_inventory_ccm.rb \
      -m ping
  ~~~

You can use these host groups in `ansible-playbook` as well.

## Unit and Acceptance tests
Before merging run unit and acceptance tests.
~~~
rspec spec/unit
rspec spec/acceptance
~~~

## Ansible docs
http://docs.ansible.com/

# Ansible Collection - my.homelab

My collection of Ansible roles and plugins, developed specifically for my homelab. 

## Usage

### Within this repository

> [!NOTE]
> Commands listed below should be executed from the [repository root](../../../).

Create a [playbook](../../../plays/) and import tasks from the `my.homelab` collection using `ansible.builtin.import_role`.

For example, to call tasks from the [`my.homelab.git` role](./roles/git/), import the `my.homelab.git` role, which will run the [`main.yml` tasks](./roles/git/tasks/main.yml):

```yaml
---
- name: "Install & configure git"
  hosts: all

  vars:
    git_default_branch: "{{ git_default_branch_name }}"
    git_user: "{{ git_user_name }}"
    git_email: "{{ git_user_email }}"

  tasks:
    - name: "Gather facts"
      ansible.builtin.import_role:
        name: my.homelab.facts

    - name: "Call homelab collection's configure_git role"
      ansible.builtin.import_role:
        name: my.homelab.git

```

You can also target specific tasks in a role using `tasks_from`. For example, the [`clear-bash-history.yml` playbook](../../../plays/maint/clear-bash-history.yml) imports the [`clear-bash-history.yml` tasks](./roles/cron/tasks/clear-bash-history.yml) from the [`my.homelab.cron` role](./roles/cron/):

```yaml
---
- name: "Clear bash history"
  hosts: all

  tasks:
    - name: "Include homelab collection's cron.clear_bash_history role"
      ansible.builtin.import_role:
        name: my.homelab.cron
        tasks_from: clear-bash-history.yml

```

### Install my.homelab collection in another Ansible project

First, install the `my.homelab` collection:

```shell
ansible-galaxy collection install \
  git+https://github.com/redjax/Ansible.git#/ansible_collections/my/homelab/
```

You can also pin to a branch, a specific commit, or a tag:

> [!WARNING]
> My Ansible repository does not create releases yet, so there are no tags to pin.

```shell
# specific branch
ansible-galaxy collection install \
  git+https://github.com/redjax/Ansible.git,main#/ansible_collections/my/homelab/

# specific tag
ansible-galaxy collection install \
  git+https://github.com/redjax/Ansible.git,v1.0.0#/ansible_collections/my/homelab/

```

> [!NOTE]
> If you prefer to keep vendor collections in a separate path, i.e. `.collections/`, you can modify the install command:
>
> ```shell
> ansible-galaxy collection install \
>   -p ./collections \
>   git+https://github.com/redjax/Ansible.git#/ansible_collections/my/homelab/
> ```

You can also create a `requirements.yml` in your project. This is the preferred approach:

```yaml
---
collections:
  - name: https://github.com/redjax/Ansible.git#/ansible_collections/my/homelab/
    type: git
    ## Use main branch. You can also use a tag or commit
    version: main

```

Then install the requirements with:

```shell
ansible-galaxy collection install -r requirements.yml
```

Then create a playbook [like you would in this repository](#within-this-repository).

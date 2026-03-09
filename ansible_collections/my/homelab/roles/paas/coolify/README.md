Coolify PaaS
=========

Ansible Role to install/configure/uninstall [coolify](https://coolify.io).

Requirements
------------

- Target host(s) must have Docker installed.

Role Variables
--------------

> [!NOTE]
> You can omit any of these in your configuration to use the [role's default values](./defaults/main.yml).

- `coolify_action`
  - This option should be passed in a playbook, i.e. an `install-coolify.yml` playbook should have a var `coolify_action: "install"`, while an `uninstall-coolify.yml` playbook should have `coolify_action: "uninstall"`
  - Options:
    - (default) `"install"`
    - `"uninstall"`
    - `"update"`
    - `"restart"`
    - `"stop"`
- `coolify_mode`
  - Alters the install/setup with different defaults based on the environment
    - A production environment allows coolify's ports through the firewall
    - A homelab environment assumes no firewall
  - Options:
    - (default) `"production"`
    - `"homelab"`
    - `"vps"`
- `coolify_port`
  - Sets the port Coolify's webUI runs on
  - Default is `8000`
  - Reacts to `coolify_mode`, i.e. sets the port to `8080` on `homelab` and `vps` deployments, but uses `8000` for production
  - If no value is passed, the role uses default: `"{{ 8000 if coolify_mode == 'production' else 8080 }}"`
- `coolify_firewall_enabled`
  - Set to `true` if the remote host uses a firewall to allow the role to configure Coolify's ports
  - If no value is passed, the role uses default: `"{{ coolify_mode == 'production' }}"` (`true` if the mode is `production`)
- `coolify_lan_subnet`
  - Set the CIDR notation scheme for the LAN schema of the target host
  - Default: `"192.168.1.0/24"`
- `coolify_docker_pool_base`
  - Set the Docker IP pool base address
  - Default: `"172.20.0.0/16"`
- `coolify_autoupdate`
  - If `true`, Coolify will automatically update when there's a new version
  - This is bad for production environmennts, so the default is `false`
- `coolify_root_username`
  - The username to use for the initial root/admin user
  - Default: `"admin"`
- `coolify_root_email`
  - The email address for the root user
  - Default: `"admin@{{ ansible_fqdn | default('local.lan') }}"`
- `coolify_homelab_domain`
  - Set the domain name to use if the mode is `homelab`
  - Default: `"coolify.local.lan"`
- `coolify_homelab_skip_firewall`
  - Skip firewall setup in homelab
  - Default: `true`
- `coolify_nuke`
  - During uninstall, this bool controls data retention
  - Default: `false`
  - When `true`, the uninstall will also remove Docker data volumes managed by Coolify, and the `/data/coolify` directory

Example Inventory
-----------------

```yaml
all:
  hosts:
    coolify-host:
      coolify_mode: "homelab"
      coolify_port: 8010
      coolify_firewall_enabled: false
      coolify_lan_subnet: "10.10.0.0/24"
      coolify_autoupdate: true
      coolify_root_email: "admin@example.com"

```

Example `install-coolify.yml` playbook
--------------------------------------

```yaml
---
- name: Install Coolify
  hosts: all

  vars:
    coolify_action: install

  roles:
    - role: my.homelab.paas.coolify

```

Example `configure-coolify.yml` playbook
----------------------------------------

```yaml
---
- name: Configure Coolify
  hosts: all

  vars:
    coolify_action: configure

  roles:
    - my.homelab.paas.coolify

```

Example `uninstall-coolify.yml` playbook
----------------------------------------

```yaml
---
- name: Uninstall Coolify (preserve data)
  hosts: all

  vars:
    coolify_action: uninstall

  roles:
    - my.homelab.paas.coolify

```

Example `nuke-coolify.yml` playbook
-----------------------------------

```yaml
---
- name: Nuke Coolify (nuclear version, remove all data dirs/volumes)
  hosts: all

  vars:
    coolify_action: uninstall
    coolify_nuke: true

  roles:
    - role: my.homelab.paas.coolify

```

License
-------

BSD

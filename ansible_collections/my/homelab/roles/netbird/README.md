# Netbird

Install & manage [Netbird](server) servers and clients.

## Role Variables

| Variable                            | Default                     | Description                                                                                     |
| ----------------------------------- | --------------------------- | ----------------------------------------------------------------------------------------------- |
| `netbird_enabled`                   | `true`                      | Master switch for the role. Set to `false` to skip NetBird setup.                               |
| `netbird_role`                      | `client`                    | Selects the NetBird mode to configure: `client` or `server`.                                    |
| `netbird_register`                  | `true`                      | Whether to enroll the machine in NetBird during the role run.                                   |
| `netbird_update_packages`           | `true`                      | Whether to install the latest available NetBird package instead of only ensuring it is present. |
| `netbird_management_url`            | `"https://vpn.example.com"` | NetBird management server URL used when enrolling the machine.                                  |
| `netbird_setup_key`                 | `""`                        | Setup key used for unattended enrollment. Leave empty to skip enrollment.                       |
| `netbird_enable_peer_ssh`           | `false`                     | Enables peer-to-peer SSH access through NetBird when supported.                                 |
| `netbird_enable_peer_ssh_root`      | `false`                     | Allows root SSH access for peer-to-peer SSH when enabled.                                       |
| `netbird_manage_firewall`           | `true`                      | Whether the role should configure firewall rules for NetBird and SSH access.                    |
| `netbird_firewall_backend`          | `auto`                      | Firewall backend to use: `auto`, `ufw`, `firewalld`, `iptables`, or `none`.                     |
| `netbird_manage_host_ssh`           | `false`                     | Whether the role should manage the host’s SSH configuration.                                    |
| `netbird_host_ssh_port`             | `22`                        | SSH port to configure on the host when SSH management is enabled.                               |
| `netbird_manage_host_ssh_firewall`  | `false`                     | Whether the role should open the host SSH port in the firewall.                                 |
| `netbird_host_ssh_allow_from_cidrs` | `[]`                        | CIDR ranges allowed to reach the host SSH port.                                                 |
| `netbird_manage_dns`                | `true`                      | Use Netbird server's DNS (you must configure a custom zone in the dashboard).                   |
| `netbird_service_enabled`           | `true`                      | Whether the NetBird service should be enabled at boot.                                          |
| `netbird_service_state`             | `started`                   | Desired runtime state of the NetBird service.                                                   |

## Examples

### Example Playbooks

Install Netbird:

```yaml
---
- name: "Install NetBird"
  hosts: all
  become: true
  gather_facts: true

  vars:
    netbird_role: client
    netbird_register: false
    netbird_management_url: "{{ netbird_server_url | default('https://vpn.example.com') }}"
    netbird_enable_peer_ssh: false
    netbird_enable_peer_ssh_root: false
    netbird_manage_host_ssh: false
    netbird_manage_firewall: false
    netbird_firewall_backend: auto
    netbird_update_packages: true

  tasks:
    - name: "Install NetBird"
      ansible.builtin.import_role:
        name: my.homelab.netbird
        tasks_from: install.yml

    - name: "Enroll NetBird"
      ansible.builtin.import_role:
        name: my.homelab.netbird
        tasks_from: enroll.yml
      when: netbird_register | bool

```

Enroll Netbird device:

```yaml
---
- name: "Enroll NetBird client"
  hosts: all
  become: true
  gather_facts: true

  vars:
    netbird_role: client
    netbird_register: true
    netbird_management_url: "{{ netbird_server_url | default('https://vpn.example.com') }}"
    netbird_setup_key: "{{ netbird_enroll_key }}"
    netbird_enable_peer_ssh: false
    netbird_enable_peer_ssh_root: false

  tasks:
    - name: "Gather facts"
      ansible.builtin.import_role:
        name: my.homelab.facts

    - name: "Enroll NetBird"
      ansible.builtin.import_role:
        name: my.homelab.netbird
        tasks_from: enroll.yml

```

Install and enroll Netbird device:

```yaml
---
- name: "Install and Enroll NetBird"
  hosts: all
  become: true
  gather_facts: true

  vars:
    netbird_role: client
    netbird_register: true
    netbird_management_url: "{{ netbird_server_url | default('https://vpn.example.com') }}"
    netbird_setup_key: "{{ netbird_enroll_key }}"
    netbird_enable_peer_ssh: false
    netbird_enable_peer_ssh_root: false
    netbird_manage_host_ssh: false
    netbird_manage_firewall: false
    netbird_firewall_backend: auto
    netbird_update_packages: true

  tasks:
    - name: "Gather facts"
      ansible.builtin.import_role:
        name: my.homelab.facts

    - name: "Install NetBird"
      ansible.builtin.import_role:
        name: my.homelab.netbird
        tasks_from: install.yml

    - name: "Enroll NetBird"
      ansible.builtin.import_role:
        name: my.homelab.netbird
        tasks_from: enroll.yml

```

Uninstall Netbird:

```yaml
---
- name: "Uninstall NetBird"
  hosts: all
  become: true
  gather_facts: true

  vars:
    netbird_purge_data: false

  tasks:
    - name: "Gather facts"
      ansible.builtin.import_role:
        name: my.homelab.facts

    - name: "Uninstall NetBird"
      ansible.builtin.import_role:
        name: my.homelab.netbird
        tasks_from: uninstall.yml

```

Configure firewall for Netbird:

```yaml
---
- name: "Configure NetBird firewall"
  hosts: all
  become: true
  gather_facts: true

  vars:
    netbird_manage_firewall: true
    netbird_firewall_backend: auto

  tasks:
    - name: "Gather facts"
      ansible.builtin.import_role:
        name: my.homelab.facts

    - name: "Configure firewall"
      ansible.builtin.import_role:
        name: my.homelab.netbird
        tasks_from: firewall.yml

```

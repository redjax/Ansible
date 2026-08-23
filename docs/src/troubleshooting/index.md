# Troubleshooting

## Fix: Could not detect a supported package manager

When installing packages on a remote, you might see an error like this:

```plaintext
Module failed: Could not detect a supported package manager from the following list: ['apk', 'apt', 'pacman', 'pkg', 'pkg_info', 'portage', 'rpm', 'dnf', 'dnf5', 'yum', 'zypper', 'pkg5', 'pkgng', 'openbsd_pkg'], or the required Python library is not installed. Check warnings for details.
```

To fix it, install the `python3-<package-manager>` package on the remote before running Ansible.

| Distro                                | Command                           |
| ------------------------------------- | --------------------------------- |
| Debian/Ubuntu                         | `sudo apt install -y python3-apt` |
| RedHat family (Fedora, OpenSuSE, etc) | `sudo dnf install python3-rpm`    |

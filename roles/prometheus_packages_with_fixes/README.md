Ansible Role: prometheus packages with fixes
============================================

An Ansible role that installs a timer to collect how many packages have
available security fixes.


Table of Contents
-----------------

<!-- toc -->

- [Role Variables](#role-variables)
  * [Time Zone](#time-zone)
  * [NTP Servers](#ntp-servers)
  * [Remove Legacy Packages](#remove-legacy-packages)
- [Dependencies](#dependencies)
- [Example Playbook](#example-playbook)
  * [Top-Level Playbook](#top-level-playbook)
  * [Role Dependency](#role-dependency)

<!-- tocstop -->


Role Variables
--------------

As who to run the timer:
```
prometheus_packages_with_fixes_user: root
prometheus_packages_with_fixes_group: root
```

When to run the timer:

```
prometheus_packages_with_fixes_on_calendar: hourly
prometheus_packages_with_fixes_on_startup_sec: 0
```

What to exclude (only works with `dnf` at the moment):

```
prometheus_packages_with_fixes_exclude: 'kernel*'
```


Dependencies
------------

```yml
---

# requirements.yml

collections:

  - name: idiv_biodiversity.security_updates
    version: X.Y.Z

...
```


Example Playbook
----------------

### Top-Level Playbook

Write a top-level playbook:

```yml
---

- name: servers
  hosts: servers

  roles:

    - role: idiv_biodiversity.security_updates.prometheus_packages_with_fixes
      tags:
        - prometheus-packages-with-fixes

...
```

### Role Dependency

Define the role dependency in `meta/main.yml`:

```yml
---

dependencies:

  - role: idiv_biodiversity.security_updates.prometheus_packages_with_fixes
    tags:
      - prometheus-packages-with-fixes

...
```

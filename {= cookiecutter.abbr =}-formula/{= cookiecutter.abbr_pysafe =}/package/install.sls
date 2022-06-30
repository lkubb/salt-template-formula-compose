# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{= cookiecutter.name =} user account is present:
  user.present:
{%- for param, val in {= cookiecutter.abbr_pysafe =}.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

{= cookiecutter.name =} user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - enable: {{ {= cookiecutter.abbr_pysafe =}.install.rootless }}

{= cookiecutter.name =} paths are present:
  file.directory:
    - names:
      - {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.base }}
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - group: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}

{= cookiecutter.name =} compose file is managed:
  file.managed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
    - source: {{ files_switch(['docker-compose.yml', 'docker-compose.yml.j2'],
                              lookup='{= cookiecutter.name =} compose file is present'
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ {= cookiecutter.abbr_pysafe =}.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        {= cookiecutter.abbr_pysafe =}: {{ {= cookiecutter.abbr_pysafe =} | json }}

{= cookiecutter.name =} is installed:
  compose.installed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
{%- for param, val in {= cookiecutter.abbr_pysafe =}.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in {= cookiecutter.abbr_pysafe =}.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
{%- if {= cookiecutter.abbr_pysafe =}.install.rootless %}
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - require:
      - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
{%- endif %}

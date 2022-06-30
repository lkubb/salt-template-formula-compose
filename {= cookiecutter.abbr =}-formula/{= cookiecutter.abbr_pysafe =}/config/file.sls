# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

{= cookiecutter.name =} environment files are managed:
  file.managed:
    - names:
{!- for cnt in cookiecutter.containers.split(",") !}
      - {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.config_{= cnt =} }}:
        - source: {{ files_switch(['{= cnt =}.env', '{= cnt =}.env.j2'],
                                  lookup='{= cnt =} environment file is managed',
                                  indent_width=10,
                     )
                  }}
{!- endfor !}
    - mode: '0640'
    - user: root
    - group: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - watch_in:
      - {= cookiecutter.name =} is installed
    - context:
        {= cookiecutter.abbr_pysafe =}: {{ {= cookiecutter.abbr_pysafe =} | json }}

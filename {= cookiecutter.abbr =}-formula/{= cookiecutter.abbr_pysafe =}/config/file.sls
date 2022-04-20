# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

{= cookiecutter.abbr_pysafe =}-config-file-file-managed:
  file.managed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.config }}
    - source: {{ files_switch(['example.tmpl'],
                              lookup='{= cookiecutter.abbr_pysafe =}-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ {= cookiecutter.abbr_pysafe =}.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        {= cookiecutter.abbr_pysafe =}: {{ {= cookiecutter.abbr_pysafe =} | json }}

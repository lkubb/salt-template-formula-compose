# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{!- if cookiecutter.config !}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{!- endif !}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{!- if cookiecutter.config !}

include:
  - {{ sls_config_file }}
{!- endif !}

{= cookiecutter.abbr_pysafe =}-{= cookiecutter.subcomponent =}-config-file-file-managed:
  file.managed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.{= cookiecutter.subcomponent =}.config }}
    - source: {{ files_switch(['{= cookiecutter.subcomponent =}-example.tmpl'],
                              lookup='{= cookiecutter.abbr_pysafe =}-{= cookiecutter.subcomponent =}-config-file-file-managed',
                              use_subpath=True
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ {= cookiecutter.abbr_pysafe =}.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
{!- if cookiecutter.config !}
    - require_in:
      - sls: {{ sls_config_file }}
{!- endif !}

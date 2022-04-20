# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{!- if cookiecutter.service !}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{!- endif !}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{!- if cookiecutter.service !}

include:
  - {{ sls_service_clean }}
{!- endif !}

{= cookiecutter.abbr_pysafe =}-{= cookiecutter.subcomponent =}-config-clean-file-absent:
  file.absent:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.{= cookiecutter.subcomponent =}.config }}
{!- if cookiecutter.service !}
    - watch_in:
        - sls: {{ sls_service_clean }}
{!- endif !}

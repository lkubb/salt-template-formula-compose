# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{!- if cookiecutter.config !}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{!- endif !}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{!- if cookiecutter.config !}

include:
  - {{ sls_config_file }}
{!- endif !}

{= cookiecutter.abbr_pysafe =}-service-running-service-running:
  service.running:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.service.name }}
    - enable: True
{!- if cookiecutter.config !}
    - watch:
      - sls: {{ sls_config_file }}
{!- endif !}

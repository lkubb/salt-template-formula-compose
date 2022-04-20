# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{!- if cookiecutter.service !}

include:
  - {{ sls_service_clean }}
{!- endif !}

{= cookiecutter.abbr_pysafe =}-config-clean-file-absent:
  file.absent:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.config }}
{!- if cookiecutter.service !}
    - require:
      - sls: {{ sls_service_clean }}
{!- endif !}

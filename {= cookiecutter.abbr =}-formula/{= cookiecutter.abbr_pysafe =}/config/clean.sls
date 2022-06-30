# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - {{ sls_service_clean }}

# This does not lead to the containers/services being rebuilt
# and thus differs from the usual behavior
{= cookiecutter.name =} environment files are absent:
  file.absent:
    - names:
{!- for cnt in cookiecutter.containers.split(",") !}
      - {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.config_{= cnt =} }}
{!- endfor !}
    - require:
      - sls: {{ sls_service_clean }}

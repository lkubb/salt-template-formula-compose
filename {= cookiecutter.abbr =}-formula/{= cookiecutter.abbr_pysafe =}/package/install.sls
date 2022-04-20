# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{!- if 'y' == cookiecutter.needs_repo !}

include:
  - {{ slsdotpath }}.repo
{!- endif !}

{= cookiecutter.abbr_pysafe =}-package-install-pkg-installed:
  pkg.installed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.pkg.name }}

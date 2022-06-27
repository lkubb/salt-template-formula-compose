# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}


{%- if {= cookiecutter.abbr_pysafe =}.lookup.pkg_manager not in ['apt', 'dnf', 'yum', 'zypper'] %}
{%-   if salt['state.sls_exists'](slsdotpath ~ '.' ~ {= cookiecutter.abbr_pysafe =}.lookup.pkg_manager ~ '.clean') %}

include:
  - {{ slsdotpath ~ '.' ~ {= cookiecutter.abbr_pysafe =}.lookup.pkg_manager ~ '.clean' }}
{%-   endif %}

{%- else %}
{%-   for reponame, enabled in {= cookiecutter.abbr_pysafe =}.lookup.enablerepo.items() %}
{%-     if enabled %}

{= cookiecutter.name =} {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-       for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-         if conf in {= cookiecutter.abbr_pysafe =}.lookup.repos[reponame] %}
    - {{ conf }}: {{ {= cookiecutter.abbr_pysafe =}.lookup.repos[reponame][conf] }}
{%-         endif %}
{%-       endfor %}
{%-     endif %}
{%-   endfor %}
{%- endif %}

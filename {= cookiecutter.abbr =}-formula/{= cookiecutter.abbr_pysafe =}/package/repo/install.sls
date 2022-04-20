# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{%- if grains['os'] in ['Debian', 'Ubuntu'] %}

Ensure {= cookiecutter.name =} APT repository can be managed:
  pkg.installed:
    - pkgs:
      - python-apt                    # required by Salt
{%-   if 'Ubuntu' == grains['os'] %}
      - python-software-properties    # to better support PPA repositories
{%-   endif %}
{%- endif %}

{%- for reponame, enabled in {= cookiecutter.abbr_pysafe =}.lookup.pkg.enablerepo %}
{%-   if enabled %}

{= cookiecutter.name =} {{ reponame }} repository is available:
  pkgrepo.managed:
{%-     for conf, val in {= cookiecutter.abbr_pysafe =}.lookup.repos[reponame].items() %}
    - {{ conf }}: {{ val }}
{%-     endfor %}
{%-     if {= cookiecutter.abbr_pysafe =}.lookup.pkg.manager in ['dnf', 'yum', 'zypper'] %}
    - enabled: 1
{%-     endif %}
    - require_in:
      - {= cookiecutter.abbr_pysafe =}-package-install-pkg-installed

{%-   else %}

{= cookiecutter.name =} {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ['name', 'ppa', 'ppa_auth', 'keyid', 'keyid_ppa', 'copr'] %}
{%-       if conf in {= cookiecutter.abbr_pysafe =}.lookup.repos[reponame] %}
    - {{ conf }}: {{ {= cookiecutter.abbr_pysafe =}.lookup.repos[reponame][conf] }}
{%-       endif %}
{%-     endfor %}
    - require_in:
      - {= cookiecutter.abbr_pysafe =}-package-install-pkg-installed
{%-   endif %}
{%- endfor %}

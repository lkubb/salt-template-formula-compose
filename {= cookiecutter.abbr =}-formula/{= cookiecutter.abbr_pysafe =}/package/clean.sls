# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - {{ sls_config_clean }}

{%- if {= cookiecutter.abbr_pysafe =}.install.autoupdate_service %}

Podman autoupdate service is disabled for {= cookiecutter.name =}:
{%-   if {= cookiecutter.abbr_pysafe =}.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

{= cookiecutter.name =} is absent:
  compose.removed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
    - volumes: {{ {= cookiecutter.abbr_pysafe =}.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if {= cookiecutter.abbr_pysafe =}.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ {= cookiecutter.abbr_pysafe =}.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if {= cookiecutter.abbr_pysafe =}.install.rootless %}
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

{= cookiecutter.name =} compose file is absent:
  file.absent:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
    - require:
      - {= cookiecutter.name =} is absent

{= cookiecutter.name =} user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}

{= cookiecutter.name =} user account is absent:
  user.absent:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - purge: {{ {= cookiecutter.abbr_pysafe =}.install.remove_all_data_for_sure }}
    - require:
      - {= cookiecutter.name =} is absent
    - retry:
        attempts: 5
        interval: 2

{%- if {= cookiecutter.abbr_pysafe =}.install.remove_all_data_for_sure %}

{= cookiecutter.name =} paths are absent:
  file.absent:
    - names:
      - {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.base }}
    - require:
      - {= cookiecutter.name =} is absent
{%- endif %}

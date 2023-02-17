# vim: ft=sls

{#-
    Removes the {= ", ".join(cookiecutter.containers.split(",")) =} containers
    and the corresponding user account and service units.
    Has a depency on `{= cookiecutter.abbr_pysafe =}.config.clean`_.
    If ``remove_all_data_for_sure`` was set, also removes all data.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
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

{%- if {= cookiecutter.abbr_pysafe =}.install.podman_api %}

{= cookiecutter.name =} podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}

{= cookiecutter.name =} podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
{%- endif %}

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

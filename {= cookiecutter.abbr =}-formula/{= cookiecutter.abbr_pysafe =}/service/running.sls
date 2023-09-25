# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - {{ sls_config_file }}

{= cookiecutter.name =} service is enabled:
  compose.enabled:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if {= cookiecutter.abbr_pysafe =}.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ {= cookiecutter.abbr_pysafe =}.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - {= cookiecutter.name =} is installed
{%- if {= cookiecutter.abbr_pysafe =}.install.rootless %}
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
{%- endif %}

{= cookiecutter.name =} service is running:
  compose.running:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if {= cookiecutter.abbr_pysafe =}.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ {= cookiecutter.abbr_pysafe =}.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if {= cookiecutter.abbr_pysafe =}.install.rootless %}
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
{%- endif %}
    - watch:
      - {= cookiecutter.name =} is installed
      - {= cookiecutter.name =} environment files are managed

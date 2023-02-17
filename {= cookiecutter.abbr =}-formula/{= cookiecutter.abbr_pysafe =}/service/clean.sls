# vim: ft=sls


{#-
    Stops the {= ", ".join(cookiecutter.containers.split(",")) =} container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

{= cookiecutter.abbr_pysafe =} service is dead:
  compose.dead:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if {= cookiecutter.abbr_pysafe =}.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ {= cookiecutter.abbr_pysafe =}.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if {= cookiecutter.abbr_pysafe =}.install.rootless %}
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
{%- endif %}

{= cookiecutter.abbr_pysafe =} service is disabled:
  compose.disabled:
    - name: {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if {= cookiecutter.abbr_pysafe =}.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ {= cookiecutter.abbr_pysafe =}.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if {= cookiecutter.abbr_pysafe =}.install.rootless %}
    - user: {{ {= cookiecutter.abbr_pysafe =}.lookup.user.name }}
{%- endif %}

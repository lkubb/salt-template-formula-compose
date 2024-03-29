# vim: ft=sls

{#-
    Removes the configuration of the {= ", ".join(cookiecutter.containers.split(",")) =} containers
    and has a dependency on `{= cookiecutter.abbr_pysafe =}.service.clean`_.

    This does not lead to the containers/services being rebuilt
    and thus differs from the usual behavior.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as {= cookiecutter.abbr_pysafe =} with context %}

include:
  - {{ sls_service_clean }}

{= cookiecutter.name =} environment files are absent:
  file.absent:
    - names:
{!- for cnt in cookiecutter.containers.split(",") !}
      - {{ {= cookiecutter.abbr_pysafe =}.lookup.paths.config_{= cnt =} }}
{!- endfor !}
    - require:
      - sls: {{ sls_service_clean }}

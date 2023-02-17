# vim: ft=sls

{#-
    Manages the configuration of the {= ", ".join(cookiecutter.containers.split(",")) =} containers.
    Has a dependency on `{= cookiecutter.abbr_pysafe =}.package`_.
#}

include:
  - .file

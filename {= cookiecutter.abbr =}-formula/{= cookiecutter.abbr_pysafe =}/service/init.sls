# vim: ft=sls

{#-
    Starts the {= ", ".join(cookiecutter.containers.split(",")) =} container services
    and enables them at boot time.
    Has a dependency on `{= cookiecutter.abbr_pysafe =}.config`_.
#}

include:
  - .running

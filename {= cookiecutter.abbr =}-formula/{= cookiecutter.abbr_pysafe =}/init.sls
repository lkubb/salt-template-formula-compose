# vim: ft=sls

{#-
    *Meta-state*.

    This installs the {= ", ".join(cookiecutter.containers.split(",")) =} containers,
    manages their configuration and starts their services.
#}

include:
  - .package
  - .config
  - .service

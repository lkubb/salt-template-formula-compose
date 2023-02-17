# vim: ft=sls

{#-
    Installs the {= ", ".join(cookiecutter.containers.split(",")) =} containers only.
    This includes creating systemd service units.
#}

include:
  - .install

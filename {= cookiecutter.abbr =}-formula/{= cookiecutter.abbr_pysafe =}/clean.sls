# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``{= cookiecutter.abbr_pysafe =}`` meta-state
    in reverse order, i.e. stops the {= ", ".join(cookiecutter.containers.split(",")) =} services,
    removes their configuration and then removes their containers.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean

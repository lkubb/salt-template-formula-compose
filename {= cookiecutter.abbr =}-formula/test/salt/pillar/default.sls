# -*- coding: utf-8 -*-
# vim: ft=yaml
---
{= cookiecutter.abbr_pysafe =}:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
{!- if cookiecutter.needs_repo !}
    enablerepo:
      stable: true
{!- endif !}
{!- if cookiecutter.config !}
    config: '{= cookiecutter.config =}'
{!- endif !}
{!- if cookiecutter.service !}
    service:
      name: {= cookiecutter.service =}
{!- endif !}
{!- if cookiecutter.subcomponent and cookiecutter.subcomponent_config !}
    {= cookiecutter.subcomponent =}:
      config: {= cookiecutter.subcomponent_config =}
{!- endif !}
{!- if cookiecutter._lookup !}
    {= cookiecutter._lookup | yaml(False) | indent(4) =}
{!- endif !}
{!- if cookiecutter._settings !}
  {= cookiecutter._settings | yaml(False) | indent(2) =}
{!- endif !}

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://{= cookiecutter.abbr_pysafe =}/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   {= cookiecutter.abbr_pysafe =}-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      {= cookiecutter.abbr_pysafe =}-config-file-file-managed:
        - 'example.tmpl.jinja'
{!- if cookiecutter.subcomponent !}
      {= cookiecutter.abbr_pysafe =}-{= cookiecutter.subcomponent =}-config-file-file-managed:
        - '{= cookiecutter.subcomponent =}-example.tmpl.jinja'
{!- endif !}

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value

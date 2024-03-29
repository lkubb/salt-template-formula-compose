# vim: ft=yaml
---
{= cookiecutter.abbr_pysafe =}:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
{!- set composeconf = cookiecutter.lookup.get("compose", {}) !}
    compose:
      create_pod: {= composeconf.get("create_pod", "null") | lower =}
      pod_args: {= composeconf.get("pod_args", "null") =}
      project_name: {= cookiecutter.project_name =}
      remove_orphans: {= composeconf.get("remove_orphans", "true") | lower =}
      build: {= composeconf.get("build", "false") | lower =}
      build_args: {= composeconf.get("build_args", "null") =}
      pull: {= composeconf.get("pull", "false") | lower =}
{!- for conf in composeconf !}
{!-   if conf not in ["create_pod", "pod_args", "project_name", "remove_orphans", "build", "build_args", "pull", "service"] !}
      {= conf =}: {= composeconf[conf] =}
{!-   endif !}
{!- endfor !}
{!- set serviceconf = composeconf.get("service", {}) !}
      service:
        container_prefix: {= serviceconf.get("container_prefix", "null") =}
        ephemeral: {= serviceconf.get("ephemeral", "true") | lower =}
        pod_prefix: {= serviceconf.get("pod_prefix", "null") =}
        restart_policy: {= serviceconf.get("restart_policy", "on-failure") =}
        restart_sec: {= serviceconf.get("restart_sec", 2) =}
        separator: {= serviceconf.get("separator", "null") =}
        stop_timeout: {= serviceconf.get("stop_timeout", "null") =}
{!- for conf in serviceconf !}
{!-   if conf not in ["container_prefix", "ephemeral", "pod_prefix", "restart_policy", "restart_sec", "separator", "stop_timeout"] !}
        {= conf =}: {= serviceconf[conf] =}
{!-   endif !}
{!- endfor !}
    paths:
      base: /opt/containers/{= cookiecutter.project_name =}
      compose: docker-compose.yml
{!- for cnt in cookiecutter.containers.split(",") !}
      config_{= cnt =}: {= cnt =}.env
{!- endfor !}
{!- if "paths" in cookiecutter.lookup !}
      {= cookiecutter.lookup.paths | yaml(False) | indent(6) =}
{!- endif !}
    user:
{!- set userconf = cookiecutter.lookup.get("user", {}) !}
      groups: {= userconf.get("groups", []) =}
      home: {= userconf.get("home", "null") =}
      name: {= userconf.get("name", cookiecutter.project_name) =}
      shell: {= userconf.get("shell", "/usr/sbin/nologin") =}
      uid: {= userconf.get("uid", "null") =}
      gid: {= userconf.get("gid", "null") =}
{!- for conf in userconf !}
{!-   if conf not in ["groups", "home", "name", "shell", "uid", "gid"] !}
      {= conf =}: {= userconf[conf] =}
{!-   endif !}
{!- endfor !}
{!- if cookiecutter.lookup !}
{!-   for var, val in cookiecutter.lookup.items() !}
{!-     if var not in ["compose", "paths", "user"] !}
    {= {var: val} | yaml(False) | indent(4) =}
{!-     endif !}
{!-   endfor !}
{!- endif !}
  install:
    rootless: true
    autoupdate: true
    autoupdate_service: false
    remove_all_data_for_sure: false
    podman_api: true
{!- if "install" in cookiecutter.settings !}
    {= cookiecutter.settings.install | yaml(False) | indent(4) =}
{!- endif !}
{!- if cookiecutter.settings !}
{!-   for var, val in cookiecutter.settings.items() !}
{!-     if "install" != var !}
  {= {var: val} | yaml(False) | indent(2) =}
{!-     endif !}
{!-   endfor !}
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
      {= cookiecutter.name =} environment file is managed:
      - {= cookiecutter.abbr_pysafe =}.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value

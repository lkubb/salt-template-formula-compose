# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - .package
{!- if cookiecutter.config !}
  - .config
{!- endif !}
{!- if cookiecutter.service !}
  - .service
{!- endif !}
{!- if cookiecutter.subcomponent !}
  - .{= cookiecutter.subcomponent =}
{!- endif !}

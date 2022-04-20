# -*- coding: utf-8 -*-
# vim: ft=sls

include:
{!- if cookiecutter.subcomponent_config !}
  - .config.clean
{!- else !}
  []
{!- endif !}

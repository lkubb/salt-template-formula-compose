import os
import shutil

# hooks are not respecting jinja env vars atm
root = '{{ cookiecutter.abbr_pysafe }}'

QUESTION_PATH_RM = [
    ('{{ cookiecutter.pkg }}', [
        'test/integration/default/controls/packages.rb',
    ]),
    ('{{ cookiecutter.needs_repo }}', [root + '/package/repo']),
    ('{{ cookiecutter.service }}', [
            root + '/service',
            'test/integration/default/controls/services.rb',
    ]),
    ('{{ cookiecutter.config }}', [root + '/config']),
    ('{{ cookiecutter.subcomponent }}', [root + '/subcomponent']),
    ('{{ cookiecutter.subcomponent_config }}', [
            root + '/{{ cookiecutter.subcomponent or 'subcomponent' }}/config',
            'test/integration/default/controls/subcomponent_config.rb',
    ]),
]


def remove(filepath):
    if os.path.isfile(filepath):
        os.remove(filepath)
    elif os.path.isdir(filepath):
        shutil.rmtree(filepath)


for question in QUESTION_PATH_RM:
    answer, paths = question

    if not answer:
        for path in paths:
            remove(path)

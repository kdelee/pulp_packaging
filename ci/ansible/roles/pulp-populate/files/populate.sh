#!/bin/bash
# must not use "set -euo" because virtualenv activate script has unbound
# environment variables. See https://github.com/probcomp/packaging/issues/9
set -eo pipefail
IFS=$'\n\t'

cd /root
easy_install-3.4 pip
pip3.4 install virtualenv
rm -rf /root/pulp_smash_env
python3.4 -m venv /root/pulp_smash_env
source /root/pulp_smash_env/bin/activate
pip install --upgrade pip
git clone https://github.com/kdelee/pulp-smash
cd pulp-smash
git checkout --track origin/backup-restore-tests
pip install -r requirements.txt -r requirements-dev.txt
python -m unittest pulp_migrate.populate

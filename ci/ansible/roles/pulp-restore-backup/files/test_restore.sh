#!/bin/bash
# must not use "set -euo" because virtualenv activate script has unbound
# environment variables. See https://github.com/probcomp/packaging/issues/9
set -eo pipefail
IFS=$'\n\t'

cd /root
rm -rf pulp-migrate
easy_install-3.4 pip
pip3.4 install virtualenv
export VENV=/root/$(date +%s%m%d%y)env
python3.4 -m venv ${VENV}
source $VENV/bin/activate
pip install --upgrade pip
git clone https://github.com/PulpQE/pulp-migrate
cd pulp-migrate
python setup.py install
python -m unittest pulp_migrate.test_restore
deactivate
cd /root
rm -rf pulp-migrate
rm -rf ${VENV}

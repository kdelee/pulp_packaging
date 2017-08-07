#!/bin/bash
# must not use "set -euo" because virtualenv activate script has unbound
# environment variables. See https://github.com/probcomp/packaging/issues/9
set -eo pipefail
IFS=$'\n\t'

export EXEC_DIR=${PWD}
# provide root directory for test results as first argument
export TEST_RESULTS_DIR=$1
rm -rf ${EXEC_DIR}/pulp-migrate
easy_install-3.4 pip
pip3.4 install virtualenv
export VENV=${EXEC_DIR}/$(date +%s.%m.%d.%y).env
python3.4 -m venv ${VENV}
source $VENV/bin/activate
pip install --upgrade pip
git clone https://github.com/PulpQE/pulp-migrate ${EXEC_DIR}/pulp-migrate
cd ${EXEC_DIR}/pulp-migrate
python setup.py install
pip install pytest
set +e
set +o pipefail
# don't want to exit if tests fail
pytest --junit-xml="${TEST_RESULTS_DIR}/restore.test.report.xml"  pulp_migrate/test_restore.py
set -eo pipefail
deactivate
cd ${EXEC_DIR}
rm -rf ${EXEC_DIR}/pulp-migrate
rm -rf ${VENV}

#!/bin/bash
set -eux

(
cd src
rm -f .coverage coverage.xml nosetests.xml
)

export SONAR_RUNNER_HOME=$(readlink -f ../../../sonar-runner/sonar-runner-2.4/)
export PATH=$PATH:$SONAR_RUNNER_HOME/bin:$(readlink -f ../../../sonar/jdk1.7.0_60/bin/)

[ -e .env ] || (
    virtualenv .env
    set +u
    . .env/bin/activate
    set -u

    pip install pylint pep8 nose coverage

    set +u
    deactivate
    set -u
)

set +u
. .env/bin/activate
set -u

(
cd src
coverage erase
set +e
coverage run --branch --source=mymodule $(which nosetests) --with-xunit mymodule
TESTRESULT=$?
set -e
coverage xml -i
)

# Publish stuff with sonar
sonar-runner -X

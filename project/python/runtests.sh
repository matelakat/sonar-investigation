#!/bin/bash
set -eux

git pull

rm -f .coverage coverage.xml nosetests.xml

export SONAR_RUNNER_HOME=$(readlink -f ../../../sonar-runner/sonar-runner-2.4/)
export PATH=$PATH:$SONAR_RUNNER_HOME/bin:$(readlink -f ../../../sonar/jdk1.7.0_60/bin/)

[ -e .env ] || (
    virtualenv .env
    set +u
    . .env/bin/activate
    set -u

    pip install pep8 nose coverage
    pip install pylint==0.25

    set +u
    deactivate
    set -u
)

set +u
. .env/bin/activate
set -u

coverage erase
set +e
coverage run --branch --source=mymodule $(which nosetests) --with-xunit
TESTRESULT=$?
set -e
coverage xml -i

# Hacks
THISDIR=$(pwd)
sed -ie "s,filename=\",filename=\"$THISDIR/,g" coverage.xml
sed -ie "s,classname=\",classname=\"$THISDIR/,g" nosetests.xml
# Publish stuff with sonar
sonar-runner -X

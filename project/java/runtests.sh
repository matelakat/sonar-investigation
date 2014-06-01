#!/bin/bash

export SONAR_RUNNER_HOME=$(readlink -f ../../../sonar-runner/sonar-runner-2.4/)
export PATH=$PATH:$SONAR_RUNNER_HOME/bin:$(readlink -f ../../../sonar/jdk1.7.0_60/bin/)

mkdir -p lib
LIB=$(readlink -f lib)

(
    cd lib
    wget -nc http://repo1.maven.org/maven2/junit/junit/4.11/junit-4.11.jar
    wget -nc http://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar
)


[ -d cobertura ] ||
(
    mkdir -p cobertura
    cd cobertura
    wget -nc http://downloads.sourceforge.net/project/cobertura/cobertura/2.0.3/cobertura-2.0.3-bin.tar.gz
    tar -xzf cobertura-2.0.3-bin.tar.gz
)

[ -d jacoco ] ||
(
    mkdir -p jacoco
    cd jacoco
    wget -nc http://repo1.maven.org/maven2/org/jacoco/org.jacoco.agent/0.7.1.201405082137/org.jacoco.agent-0.7.1.201405082137.jar
)

JACOCO_JAR=$(find jacoco -name "*.jar")
JACOCO_JAR=$(readlink -f $JACOCO_JAR)

[ -d jacoco_extracted ] ||
(
    mkdir -p jacoco_extracted
    cd jacoco_extracted
    unzip $JACOCO_JAR
)

JACOCO_AGENT=$(find jacoco_extracted -name "jacocoagent.jar")
JACOCO_AGENT=$(readlink -f $JACOCO_AGENT)


# Perform some cleanup
rm -f cobertura.ser coverage.xml jacoco.exec

function compile() {

EXTRA_OPTS=""
if [ "${1:-}" == "debug" ]; then
    EXTRA_OPTS="-g"
fi

rm -rf obj
mkdir -p obj

OBJ=$(readlink -f obj)

(
    cd src
    javac $EXTRA_OPTS -d "$OBJ" $(find -name "*.java")
)

(
    cd test
    javac $EXTRA_OPTS -cp "$OBJ:$LIB/*" -d "$OBJ" $(find -name "*.java")
)
}

# Compile sources
compile

# Instrument the code with cobertura
rm -rf instrumented
mkdir -p instrumented
java \
    -cp "cobertura/cobertura-2.0.3/cobertura-2.0.3.jar:cobertura/cobertura-2.0.3/lib/*" \
    net.sourceforge.cobertura.instrument.Main --destination instrumented obj


# Execute the Unit tests
java -cp "instrumented:$LIB/*:cobertura/cobertura-2.0.3/cobertura-2.0.3.jar" \
    org.junit.runner.JUnitCore eu.lakat.sonarexample.UtilityTest

# Generate cobertura report
java \
    -cp "cobertura/cobertura-2.0.3/cobertura-2.0.3.jar:cobertura/cobertura-2.0.3/lib/*" \
    net.sourceforge.cobertura.reporting.Main --destination ./ --format xml

# Compile sources again (to throw away the instrumented bits)
compile debug

# Run integration tests
java -cp "$OBJ:$JACOCO_AGENT" \
    -javaagent:$JACOCO_AGENT \
    eu.lakat.sonarexample.IntegrationTest

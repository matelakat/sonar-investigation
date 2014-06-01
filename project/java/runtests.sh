#!/bin/bash

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

JACOCO_AGENT=$(find jacoco -name "*.jar")


function compile() {
rm -rf obj
mkdir -p obj

OBJ=$(readlink -f obj)

(
    cd src
    javac -d "$OBJ" $(find -name "*.java")
)

(
    cd test
    javac -cp "$OBJ:$LIB/*" -d "$OBJ" $(find -name "*.java")
)
}

# Compile sources
compile

# Instrument the code with cobertura
java \
    -cp "cobertura/cobertura-2.0.3/cobertura-2.0.3.jar:cobertura/cobertura-2.0.3/lib/*" \
    net.sourceforge.cobertura.instrument.Main obj


# Execute the Unit tests
java -cp "$OBJ:$LIB/*:cobertura/cobertura-2.0.3/cobertura-2.0.3.jar" \
    org.junit.runner.JUnitCore eu.lakat.sonarexample.MainTest

# Generate cobertura report
java \
    -cp "cobertura/cobertura-2.0.3/cobertura-2.0.3.jar:cobertura/cobertura-2.0.3/lib/*" \
    net.sourceforge.cobertura.reporting.Main --destination ./ --format xml

# Compile sources again (to throw away the instrumented bits)
compile

# Run integration tests
java -cp "$OBJ:$JACOCO_AGENT" \
    -javaagent:$JACOCO_AGENT \
    eu.lakat.sonarexample.Main

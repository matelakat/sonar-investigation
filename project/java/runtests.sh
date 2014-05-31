#!/bin/bash

mkdir -p lib
LIB=$(readlink -f lib)

(
    cd lib
    wget -nc http://repo1.maven.org/maven2/junit/junit/4.11/junit-4.11.jar
    wget -nc http://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar
)


rm -rf obj
mkdir -p obj

OBJ=$(readlink -f obj)

(
    cd src
    javac -d "$OBJ" $(find -name "*.java")
)

(
    cd test
    javac -cp "$LIB/*" -d "$OBJ" $(find -name "*.java")
)



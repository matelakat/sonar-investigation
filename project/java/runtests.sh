#!/bin/bash

mkdir -p lib

(
    cd lib
    wget -O junit.jar -nc http://bit.ly/My9IXz
    wget -O hamcrest-core.jar -nc http://bit.ly/1gbl25b
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
    javac -d "$OBJ" $(find -name "*.java")
)



#!/bin/bash

# This script pulls all the dependency graph data from the header comments of
# the Find*.cmake files and generates a dependency graph using GraphViz.

if [ $# -lt 1 ]; then
    echo "Usage: $(basename $0) cmake_script [cmake_script2 [cmake_script3 [...]]]"
    echo ""
    echo "\t$(basename $0) Looks at the header comments in the cmake scripts and "
    echo "\tgenerates a graph of the dependencies."
    exit 1
fi

DOT=$(which dot)

if [ ! -x "$DOT" ]; then
    echo "Error: Couldn't locate dot. Please install GraphViz."
    exit 1
fi

DOT_FILE=/tmp/cmake-deps-$(whoami).dot
PNG_FILE=$(dirname $DOT_FILE)/$(basename $DOT_FILE .dot).png

echo "digraph G {" > $DOT_FILE

while [ $# -gt 0 ]; do
    CMAKE_FILE=$1
    START_LINE=$(grep -n BEGIN_DOT_FILE "$CMAKE_FILE" | cut -d: -f1)
    END_LINE=$(grep -n END_DOT_FILE "$CMAKE_FILE" | cut -d: -f1)
    if [ -n "$START_LINE" -a -n "$END_LINE" ]; then
        LENGTH=$(($END_LINE - $START_LINE - 1))
        DOT_CODE=$(head -n$(($END_LINE - 1)) "$CMAKE_FILE" | tail -n$LENGTH | sed -e 's/^\s*#\s*//')
        echo $DOT_CODE >> $DOT_FILE
        #START_LINE=""
        #END_LINE=""
        #LENGTH=""
    fi
    #FIND_PACKAGE_COUNT=$(grep -ci find_package "$CMAKE_FILE")
    #INCLUDE_COUNT=$(grep -ci include "$CMAKE_FILE")
    shift
done

echo "};" >> $DOT_FILE

$DOT $DOT_FILE -Tpng > $PNG_FILE


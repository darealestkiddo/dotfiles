#!/bin/bash

if [[ $1 -eq 0 ]]
then
    g++ -DQUYNX_DEBUG -std=c++11 -Wshadow -Wall -o $2 $2.cpp -O2 -Wno-unused-result
else
    g++ -DQUYNX_DEBUG -std=c++11 -Wshadow -Wall -o $2 $2.cpp -g -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG
fi

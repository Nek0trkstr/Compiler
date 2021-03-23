#!/usr/bin/env bash
flex ouml.l
gcc lex.yy.c
./a.out test.txt
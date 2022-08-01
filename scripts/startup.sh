#!/bin/bash

export SOME_VAR="${some_var}"

echo whoami | tee -a output.txt
echo pwd | tee -a output.txt
echo "$SOME_VAR" | tee -a output.txt


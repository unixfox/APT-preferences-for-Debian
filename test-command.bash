#!/bin/bash

if ! type "caca" > /dev/null; then
  apt-get install git
  echo "pas git"
fi

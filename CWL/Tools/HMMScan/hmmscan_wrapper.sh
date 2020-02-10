#!/bin/bash

# hmmscan wrapper
# will output an empty tsv file if the sequence file is empty

if [ ! -s "$7" ]; # the file is in the fifth position
then
  touch "empty_hmmscan.tbl"
  exit 0
fi

hmmscan "$@"

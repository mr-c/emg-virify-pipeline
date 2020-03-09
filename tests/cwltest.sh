#!/bin/bash

# scipts
PATH="$(dirname $(pwd))/emg-virify-scripts/virify_scripts":$PATH

cwltest "$@"
#!/bin/bash

# scipts
PATH="$(dirname $(pwd))/emg-virify-scripts":$PATH

cwltest "$@"
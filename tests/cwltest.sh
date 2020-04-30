#!/bin/bash

# scripts path
PATH="$(dirname $(pwd))/emg-virify-scripts/virify_scripts":$PATH

cwltest "$@"

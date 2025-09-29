#!/bin/bash
for d in [1-9]*; do
    if [[ -d "$d" ]]; then
        echo "Removing $d"
        rm -rf "$d"
    fi
done

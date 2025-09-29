#!/bin/bash
decomposePar -force -copyZero
mpirun --allow-run-as-root -n 4 simpleFoam -parallel
reconstructPar

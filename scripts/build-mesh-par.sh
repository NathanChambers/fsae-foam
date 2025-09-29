#!/bin/bash
blockMesh
transformPoints -yawPitchRoll "(45 0 0)"
surfaceFeatureExtract
decomposePar -force -copyZero > log.decomposePar
mpirun --allow-run-as-root -n 4 snappyHexMesh -overwrite -parallel
reconstructParMesh -constant

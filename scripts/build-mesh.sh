#!/bin/bash
blockMesh
transformPoints -yawPitchRoll "(45 0 0)"
surfaceFeatureExtract
snappyHexMesh -overwrite

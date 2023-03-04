.PHONY: rebuild
rebuild: clean clean-ep build-par run-par

.PHONY: run
run-foam:
	@echo ===== decomposePar;\
	decomposePar -force -copyZero > log.decomposePar; \
	echo ===== simpleFoam;\
	mpirun -n 4 simpleFoam -parallel > log.simpleFoam;\
	echo ===== reconstructPar;\
	reconstructPar > log.reconstructParS

################################################################

.PHONY: clean
clean:
	@rm -rf ./constant/polyMesh; \
	rm -rf ./constant/extendedFeatureEdgeMesh; \
	rm -rf ./constant/cube.eMesh;

.PHONY: clean-ep
clean-ep:
	@ls | grep -P "(?=[^0])(?=[0-9]+)" | xargs -d "\n" rm -drf

.PHONY: render
render:
	@cat constant/triSurface/fsae*.stl > constant/triSurface/model.stl

.PHONY: build-par
build-par:
	@rm -rf ./log.*; \
	rm -rf ./processor*; \
	echo ===== combine stl;\
	cat constant/triSurface/fsae*.stl > constant/triSurface/model.stl; \
	echo ===== blockMesh;\
	blockMesh > log.blockMesh; \
	echo ===== transformPoints;\
	transformPoints -yawPitchRoll "(45 0 0)" > log.transformPoints;\
	echo ===== surfaceFeatureExtract;\
	surfaceFeatureExtract > log.surfaceFeatureExtract; \
	echo ===== decomposePar;\
	decomposePar -force -copyZero > log.decomposePar; \
	echo ===== snappyHexMesh;\
	mpirun -n 4 snappyHexMesh -overwrite -parallel > log.snappyHexMesh; \
	echo ===== reconstructParMesh;\
	reconstructParMesh -constant > log.reconstructParMesh

.PHONY: run-par
run-par:
	@echo ===== simpleFoam;\
	mpirun -n 4 simpleFoam -parallel > log.simpleFoam;\
	echo ===== reconstructPar;\
	reconstructPar > log.reconstructPar


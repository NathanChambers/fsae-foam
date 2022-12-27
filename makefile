render:
	@cat constant/triSurface/fsae*.stl > constant/triSurface/model.stl

build: clean clean-ep
	@rm -rf ./log.*; \
	rm -rf ./processor*; \
	cat constant/triSurface/fsae*.stl > constant/triSurface/model.stl; \
	blockMesh; \
	surfaceFeatureExtract; \
	snappyHexMesh -overwrite

build-par:
	@rm -rf ./log.*; \
	rm -rf ./processor*; \
	echo ===== combine stl;\
	cat constant/triSurface/fsae*.stl > constant/triSurface/model.stl; \
	echo ===== blockMesh;\
	blockMesh > log.blockMesh; \
	echo ===== surfaceFeatureExtract;\
	surfaceFeatureExtract > log.surfaceFeatureExtract; \
	echo ===== decomposePar;\
	decomposePar -force -copyZero > log.decomposePar; \
	echo ===== snappyHexMesh;\
	mpirun -n 4 snappyHexMesh -overwrite -parallel > log.snappyHexMesh; \
	echo ===== reconstructParMesh;\
	reconstructParMesh -constant > log.reconstructParMesh

clean:
	@rm -rf ./constant/polyMesh; \
	rm -rf ./constant/extendedFeatureEdgeMesh; \
	rm -rf ./constant/cube.eMesh;

clean-ep:
	@ls | grep -P "(?=[^0])(?=[0-9]+)" | xargs -d "\n" rm -drf

rebuild: clean clean-ep build run

rebuild-par: clean clean-ep build-par run-par

.PHONY: run
run:
	@simpleFoam

.PHONY: run-par
run-par:
	@echo ===== simpleFoam;\
	mpirun -n 4 simpleFoam -parallel > log.simpleFoam;\
	echo ===== reconstructPar;\
	reconstructPar > log.reconstructPar

save:
	@ep=${shell date +"%s"}; \
	fileName=results/$$ep; \
	echo mkdir -p $$fileName; \
	ls | grep -P "[0-9]+" | xargs -d "\n" echo cp -rd

.PHONY: rerun
rerun:
	@echo ===== decomposePar;\
	decomposePar -force -copyZero > log.decomposePar; \
	echo ===== simpleFoam;\
	mpirun -n 4 simpleFoam -parallel > log.simpleFoam;\
	echo ===== reconstructPar;\
	reconstructPar > log.reconstructParS
FOAM_VERSION ?= 2206
FOAM_IMAGE = opencfd/openfoam-run:$(FOAM_VERSION)
FOAM_CMD = docker run --rm -it -v "$$(pwd -W)":/root $(FOAM_IMAGE)

cli:
	$(FOAM_CMD) bash

build-mesh:
	$(FOAM_CMD) ./scripts/build-mesh.sh

build-mesh-par:
	$(FOAM_CMD) ./scripts/build-mesh-par.sh

run-sim:
	$(FOAM_CMD) ./scripts/run-sim.sh

run-sim-par:
	$(FOAM_CMD) ./scripts/run-sim-par.sh

clean:
	./scripts/clean.sh

clean-ep:
	./scripts/clean-ep.sh

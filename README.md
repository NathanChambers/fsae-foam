# Requirements

- **OpenFOAM (ESI/OpenCFD version, not the Foundation build)**
  - Tested with: `OpenFOAM-v2206`
  - Docker image: `opencfd/openfoam-run:2206`
- Paraview https://www.paraview.org/

# Meshing

All STL files must be exported into `constant/triSurface` from your modeling software (Blender, SolidWorks, etc).

## Naming rules

Every STL must have an `fsae` prefix so the `0/` configuration files can identify the geometry as part of the car.

Examples:

- `fsaeHighHelmet.stl`
- `fsaeBody.stl`

For the sim to account for rotating wheels, the tyre mesh should match the following names:

- `fsaeTyreFL`
- `fsaeTyreFR`
- `fsaeTyreRL`
- `fsaeTyreRR`

## Mesh registration

Any STL placed in `constant/triSurface` must also be declared in:

- [Path] `system/snappyHexMeshDict` → `geometry` block and corresponding refinement settings
- [Path] `system/surfaceFeatureExtractDict` → to generate feature edges

## Orientation

Airflow is defined along the **X+ axis**.
The front of the car model must therefore face the **X− direction** when exported to STL.

# CFD Parameter Files

- [Path] `0/include/constants`

  - `wheelSpeedKPH` → set wheel rotation speed and flow velocity
  - `flowAngle` → set flow angle from center line

- [Path] `system/controlDict`
  - general solver controls (timestep, write interval, etc.)

# Run

The workflow depends on whether you are adding/changing geometry or only updating simulation parameters.

## Full rebuild (required when meshes change)

1. Place \*.stl files into [Path] `constant/triSurface`.
2. Update `system/snappyHexMeshDict` and `system/surfaceFeatureExtractDict` to include the new STL files.
3. Open a terminal and navigate to the `fsae-foam` project folder.
4. Run the full meshing and simulation sequence:

```bash
# generate initial background volume
blockMesh

# rotate domain to allow airflow angle variation
transformPoints -yawPitchRoll "(45 0 0)"

# extract feature edges from STL surfaces
surfaceFeatureExtract

# mesh vehicle geometry into the volume
snappyHexMesh -overwrite

# run the CFD simulation
simpleFoam
```

5. Open the generated `view.foam` in ParaView.

## Parameter-only changes (no new geometry)

1. Update values in [Path] `0/include/constants`

- `wheelSpeedKPH`
- `flowAngle`

2. Optionally update `system/controlDict` for solver settings.
3. Rerun only:

```bash
simpleFoam
```

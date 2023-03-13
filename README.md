# Requirements
* Make (Windows: https://www.gnu.org/software/make/#download)
* OpenFOAM https://openfoam.org
* Paraview https://www.paraview.org/

# Meshing
Export stl files into [Path] `constant/triSurface` from modeling software (blender, solid works, etc). The files have to have one of the following prefix;
* fsaeLow
* fsaeMid
* fsaeHigh
* fsaeMod

eg. `fsaeHighHelmet.stl`, `fsaeModSidepod.stl`

Each prefix determins the level of detail for the meshing stage. The high/mod have the highest level of subdivision/accuracy

For the sim to account for rotating wheels, the tyre mesh should match the following names;
* fsaeHighWheel_Tyre_FL
* fsaeHighWheel_Tyre_FR
* fsaeHighWheel_Tyre_RL
* fsaeHighWheel_Tyre_RR

# CDF Parameter Files
* [Path] `0/include/constants`
    * `wheelSpeedKPH` - Set wheel rotation speed and flow velocity
    * `flowAngle` - Sets flow angle from center line

# Run
1. Place *.stl files into [Path] `constant/triSurface`
2. Update [Path] `system/snappyHexMeshDict` [File Contents] `geometry.fsae.regions` to match stl files
    * Running rebuild will generate a list of all components if there is a mismatch
3. Open a terminal and navigate to the fsae-foam project folder
4. Run `make rebuild`
    * This will generate the mesh and run the simulation
5. Open the `view.foam` in Paraview
6. (Optional) Run `make run-foam` 
    * Runs with CFD with different any updated parameters without having to regenerate the mesh


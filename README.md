
# benchmark
Within this folder is possible to find some scripts used during the simulation
of the DLX. The compilation can be done running this command within the working folder
with the source ASM script and the compiler + conv2memory files:

source compile_benchmark.scr <target_asm_file_name.txt>

ATT!
Sometimes it may be needed to check the .mem file since consecutive nop operations may be
collapsed in only one. In addition the final empty row should be removed to avoid possible
errors while reading the file.

# vhdlsim 
This folder contains the full DXL commented.
Within this folder is possible to run the simulation adding the .mem file named test.asm.mem and running

source launch_questa_sim.scr

and into the questa sim console:

source simulation_DLX.scr

# syn
This folder contains the DLX fully synthetizable.

# phy
This folder contains some results obtained after the physical design and the place & route.

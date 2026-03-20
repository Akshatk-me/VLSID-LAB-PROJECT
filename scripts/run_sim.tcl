# ==============================================================================
# RV32I SHA-256 SoC - Simulation Script
# ==============================================================================

set proj_name "RV32I_SHA256_SoC"
set proj_dir  "./project"

puts "Opening project $proj_name for simulation..."
open_project $proj_dir/$proj_name.xpr

puts "Launching behavioral simulation..."
launch_simulation

# You can change "run all" to a specific time like "run 1000ns" if your TB doesn't have a $finish
#puts "Running simulation..."
#run all

puts "Simulation complete. Closing project."
close_project
exit 0

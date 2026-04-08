# ==============================================================================
# RV32I SHA-256 SoC - Simulation Script
# ==============================================================================

set proj_name "RV32I_SHA256_SoC"
set proj_dir  "./project"

# Replace this with the actual module name of your testbench!
set my_tb_name "tb_MultiCycleMultiplier" 

puts "Opening project $proj_name for simulation..."
open_project $proj_dir/$proj_name.xpr

# --- NEW STEPS: Set the new testbench as the top module ---
puts "Setting $my_tb_name as the top simulation module..."
set_property top $my_tb_name [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Update the compile order so Vivado recognizes the new hierarchy
update_compile_order -fileset sim_1
# ----------------------------------------------------------

puts "Launching behavioral simulation..."
launch_simulation

# If your testbench doesn't use $finish, you will want to uncomment the line below
# puts "Running simulation..."
# run all

puts "Simulation complete. Closing project."
close_project
exit 0

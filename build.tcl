# ------------------------------------------------------------
# Ultimate Vivado Team Build & Refresh Script
# ------------------------------------------------------------

set root [file dirname [file normalize [info script]]]
cd $root

# 1. Handle "Clean" Argument (Only run from terminal, not GUI)
if {[llength $argv] > 0 && [lindex $argv 0] == "clean"} {
    puts "Cleaning project artifacts..."
    file delete -force project *.log *.jou *.str .Xil
    exit 0
}

set proj_name "RV32I_SHA256_SoC"
set proj_dir  "./project"
set board_part "tul.com.tw:pynq-z2:part0:1.0"

# 2. Recursive search procedure (From your original script)
proc find_files {basedir pattern} {
    set files {}
    if {[catch {glob -nocomplain -type f [file join $basedir $pattern]} matched_files] == 0} {
        set files $matched_files
    }
    if {[catch {glob -nocomplain -type d [file join $basedir *]} dirs] == 0} {
        foreach dir $dirs {
            set files [concat $files [find_files $dir $pattern]]
        }
    }
    return $files
}

# 3. Check if project is already open (The "Refresh" Magic)
set is_open [current_project -quiet]

if {$is_open == ""} {
    puts "No project open. Creating new project $proj_name..."
    create_project $proj_name $proj_dir -force
    set_property board_part $board_part [current_project]
} else {
    puts "Project already open. Refreshing and pulling in new files..."
}

# 4. Find and Add Files (Now with .vh and .mem support)

# -> RTL Sources & Headers
set rtl_files [concat [find_files "$root/src" "*.v"] [find_files "$root/src" "*.sv"] [find_files "$root/src" "*.vh"]]
if {[llength $rtl_files]} { 
    add_files -fileset sources_1 $rtl_files 
    # Ensure headers are treated correctly globally
    set_property is_global_include true [get_files -filter {FILE_TYPE == "Verilog Header"}]
}

# -> Memory Initialization Files (Crucial for RISC-V BRAM)
set mem_files [find_files "$root/src" "*.mem"]
if {[llength $mem_files]} { add_files -fileset sources_1 $mem_files }

# -> Constraints
set xdc_files [find_files "$root/constraints" "*.xdc"]
if {[llength $xdc_files]} { add_files -fileset constrs_1 $xdc_files }

# -> Simulation Testbenches
set sim_files [concat [find_files "$root/sim" "*.v"] [find_files "$root/sim" "*.sv"]]
if {[llength $sim_files]} { add_files -fileset sim_1 $sim_files }

# -> IP Cores (.xci)
set ip_files [find_files "$root/ip" "*.xci"]
if {[llength $ip_files]} { import_ip $ip_files }

# 5. Build Hierarchy & Set Top Module
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Attempt to auto-detect the top module gracefully
catch {
    set top_mod [lindex [find_top] 0]
    if {$top_mod != ""} {
        set_property top $top_mod [current_fileset]
        puts "Auto-detected top module: $top_mod"
    }
}

puts "--------------------------------------------------------"
if {$is_open == ""} {
    puts "Project $proj_name generated successfully!"
} else {
    puts "Project refreshed! All new files from outside are now tracked."
}
puts "--------------------------------------------------------"

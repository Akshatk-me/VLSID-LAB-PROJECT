# ------------------------------------------------------------
# Vivado Build & Refresh Script (SystemVerilog Safe)
# ------------------------------------------------------------

set root [file dirname [file normalize [info script]]]
cd $root

# ------------------------------------------------------------
# 1. Clean mode
# ------------------------------------------------------------
if {[llength $argv] > 0 && [lindex $argv 0] == "clean"} {
    puts "Cleaning project artifacts..."
    file delete -force project *.log *.jou *.str .Xil
    exit 0
}

set proj_name "RV32I_SHA256_SoC_SV"
set proj_dir  "./project"
set board_part "tul.com.tw:pynq-z2:part0:1.0"

# ------------------------------------------------------------
# 2. Recursive file finder
# ------------------------------------------------------------
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

# ------------------------------------------------------------
# 3. Create or reuse project
# ------------------------------------------------------------
set is_open [current_project -quiet]

if {$is_open == ""} {
    puts "Creating project $proj_name..."
    create_project $proj_name $proj_dir -force
    set_property board_part $board_part [current_project]
} else {
    puts "Refreshing existing project..."
}

# ------------------------------------------------------------
# 4. Remove old sources (prevents duplication bugs)
# ------------------------------------------------------------
if {$is_open != ""} {
    remove_files [get_files -of_objects [get_filesets sources_1]]
    remove_files [get_files -of_objects [get_filesets sim_1]]
}

# ------------------------------------------------------------
# 5. Add RTL sources
# ------------------------------------------------------------
set rtl_files [concat \
    [find_files "$root/src" "*.v"] \
    [find_files "$root/src" "*.sv"] \
    [find_files "$root/src" "*.vh"] \
]

if {[llength $rtl_files]} {
    add_files -fileset sources_1 $rtl_files
}

# --- CRITICAL: mark SystemVerilog files correctly
set sv_files [get_files -filter {FILE_NAME =~ "*.sv"}]
if {[llength $sv_files]} {
    set_property file_type SystemVerilog $sv_files
}

# --- Headers as global include
set vh_files [get_files -filter {FILE_NAME =~ "*.vh"}]
if {[llength $vh_files]} {
    set_property is_global_include true $vh_files
}

# --- Include directory (important!)
set_property include_dirs "$root/src" [current_fileset]

# ------------------------------------------------------------
# 6. Memory files (.mem)
# ------------------------------------------------------------
set mem_files [find_files "$root/src" "*.mem"]
if {[llength $mem_files]} {
    add_files -fileset sources_1 $mem_files
}

# ------------------------------------------------------------
# 7. Constraints
# ------------------------------------------------------------
set xdc_files [find_files "$root/constraints" "*.xdc"]
if {[llength $xdc_files]} {
    add_files -fileset constrs_1 $xdc_files
}

# ------------------------------------------------------------
# 8. Simulation files
# ------------------------------------------------------------
set sim_files [concat \
    [find_files "$root/sim" "*.v"] \
    [find_files "$root/sim" "*.sv"] \
]

if {[llength $sim_files]} {
    add_files -fileset sim_1 $sim_files

    # mark SV testbenches
    set sim_sv [get_files -of_objects [get_filesets sim_1] -filter {FILE_NAME =~ "*.sv"}]
    if {[llength $sim_sv]} {
        set_property file_type SystemVerilog $sim_sv
    }
}

# ------------------------------------------------------------
# 9. IP cores
# ------------------------------------------------------------
set ip_files [find_files "$root/ip" "*.xci"]
if {[llength $ip_files]} {
    import_ip $ip_files
}

# ------------------------------------------------------------
# 10. Compile order (VERY IMPORTANT for SV/interfaces)
# ------------------------------------------------------------
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# ------------------------------------------------------------
# 11. Auto-detect top module
# ------------------------------------------------------------
catch {
    set top_mod [lindex [find_top] 0]
    if {$top_mod != ""} {
        set_property top $top_mod [current_fileset]
        puts "Top module: $top_mod"
    }
}

# ------------------------------------------------------------
# Done
# ------------------------------------------------------------
puts "--------------------------------------------------------"
if {$is_open == ""} {
    puts "Project created successfully!"
} else {
    puts "Project refreshed successfully!"
}
puts "--------------------------------------------------------"

# ==============================================================================
# RV32I SHA-256 SoC - Project Makefile
# ==============================================================================

# Variables
VIVADO_BATCH = vivado -nolog -nojournal -mode batch -source
VIVADO_GUI   = vivado -nolog -nojournal -mode gui -source
SCRIPT       = buildsv.tcl

# Phony targets (not actual files)
.PHONY: help build gui sim clean

# Default target when you just type 'make'
help:
	@echo "======================================================================"
	@echo " RV32I SHA-256 SoC Build System"
	@echo "======================================================================"
	@echo " Available commands:"
	@echo "   make build  - Creates or updates the project in the background (no GUI)"
	@echo "   make gui    - Opens Vivado GUI and loads/refreshes the project"
	@echo "   make sim    - Runs the default behavioral simulation in the terminal"
	@echo "   make clean  - Deletes the project folder and all temporary Vivado files"
	@echo "======================================================================"

# Create or refresh the project silently in the background
build:
	$(VIVADO_BATCH) $(SCRIPT)

# Open the project in the Vivado GUI (Backgrounds the process with '&')
gui:
	$(VIVADO_GUI) $(SCRIPT) &

# Run simulation in terminal (Assumes project is built)
sim:
	@echo "Running command-line simulation..."
	vivado -nolog -nojournal -mode batch -source scripts/run_sim.tcl

# Nuke the project folder and all Xilinx junk
clean:
	$(VIVADO_BATCH) $(SCRIPT) -tclargs clean
	rm -rf .Xil/ *.jou *.log *.str *.pb project/
	@echo "Clean complete! Repository is pristine."



# ==============================================================================
# Fast Simulation (Icarus Verilog)
# ==============================================================================

# ==============================================================================
# Fast Simulation (Verilator)
# ==============================================================================

VERILATOR = verilator

# Defaults (override from CLI)
TOP   ?= riscv_coretb1
SRC   ?= $(shell find src -name "*.sv")
TB  ?= riscv_coretb1
TB_FILE := $(shell find sim -name "$(TB).sv" -o -name "$(TB).v")
SIM   ?= $(shell find sim -name "*.v")
DEFS  ?=
BUILD ?= build

.PHONY: fastsim wave clean_vlt

fastsim:
	@echo "----------------------------------------"
	@echo " Running Verilator Simulation"
	@echo " TOP  = $(TOP)"
	@echo " DEFS = $(DEFS)"
	@echo "----------------------------------------"
	$(VERILATOR) -Wall -Wno-fatal -Wno-DECLFILENAME --binary --trace \
		--top-module $(TB) \
		$(DEFS) \
		$(SRC) $(TB_FILE) \
		--Mdir $(BUILD)
	./$(BUILD)/V$(TOP)

wave:
	gtkwave $(BUILD)/*.vcd &

clean_vlt:
	rm -rf $(BUILD)

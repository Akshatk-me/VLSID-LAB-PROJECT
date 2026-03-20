# ==============================================================================
# PYNQ-Z2 Base Constraints
# ==============================================================================

# 125 MHz System Clock, physically 125 MHz system clock is wired to pin H16
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 8.000 -waveform {0 4.000} [get_ports { clk }];

# (Later, you will add the UART and GPIO pins here for your physical demo!)

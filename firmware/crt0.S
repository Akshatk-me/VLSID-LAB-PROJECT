.section .text.init
.global _start
.global trap_handler  # We will define this in C

_start:
    # Load the stack pointer address (defined in linker script)
    la sp, __stack_top
    
    # 1. Point the CPU to our interrupt handler
    la t0, trap_handler
    csrw mtvec, t0
    
    # 2. Enable Machine External Interrupts (MEIE) in the 'mie' register (bit 11)
    li t0, 0x800
    csrw mie, t0
    
    # 3. Enable Global Interrupts (MIE) in the 'mstatus' register (bit 3)
    li t0, 0x8
    csrw mstatus, t0
    
    # Jump to the main() function in C
    call main
    
    # If main ever finishes, trap into an infinite loop
    j .

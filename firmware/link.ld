MEMORY
{
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 32K
}

SECTIONS
{
    .text : {
        *(.text.init) /* Puts the crt0.S startup code at the very beginning! */
        *(.text*)     /* Your main.c code goes next */
    } > RAM

    .data : {
        *(.data*)     /* Initialized variables */
        *(.sdata*)
    } > RAM

    .bss : {
        *(.bss*)      /* Uninitialized variables */
        *(.sbss*)
    } > RAM

    /* Set the stack pointer to the very top of your 32KB RAM */
    __stack_top = ORIGIN(RAM) + LENGTH(RAM);
}

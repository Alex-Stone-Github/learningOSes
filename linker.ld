OUTPUT_FORMAT(binary)

SECTIONS {
    . = 0x7c00;
    .bootloader : { *(.bootloader) }
    .text :       { *(.text) }
    .rodata :     { *(.rodata) }
    .bss :        { *(.bss) }
    .data :       { *(.data) }

}
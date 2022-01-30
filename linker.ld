OUTPUT_FORMAT(binary)

SECTIONS {
    . = 0x7c00;
    .bootloader : { *(.bootloader) }
    .text : { *(.text) }
    .data : { *(.data) }
    .bss : { *(.bss) }
    .rodata : { *(.rodata) }
}
[BITS 16]
SECTION .bootloader

; this lets the user know that the bootloader has been loaded properly
mov ah, 0x0e
mov al, 'H'
int 0x10
mov ah, 0x0e
mov al, 'i'
int 0x10
mov ah, 0x0e
mov al, '!'
int 0x10

jmp readnextDisk
error:
mov ah, 0x0e
mov al, 'N'
int 0x10
mov al, 'o'
int 0x10
mov al, '!'
int 0x10



readnextDisk:
;reset the disk
mov ah, 0
int 0x13
; read from disk
mov ah, 0x2        ; read mode
mov al, 15        ; number of sectors to read
mov ch, 0x0        ; cylinder
mov dh, 0x0        ; head
mov dl, 0x0        ; drive
mov cl, 0x2        ; sector
mov ax, 0x0
mov bx, 0x1000       ; address to be loaded into
int 0x13           ; perform the action
jc error           ; panic if it fails


; jump to new code
jmp dword 0x8:0x1000

times 510-($-$$) db 0 ; pad the file with zeros until the 510 byte
dw 0xaa55             ; this is the magic boot number
BITS 16
SECTION .bootloader

;
; CONSTANTS: this has all of the constants
;
MEMKERNELLOC equ 0x1000

;
; NOTIFY: this lets the user know that the bootloader has been loaded properly
;
mov ah, 0x0e
mov al, 'H'
int 0x10
mov ah, 0x0e
mov al, 'i'
int 0x10
mov ah, 0x0e
mov al, '!'
int 0x10

;
; DISK: read the disk
;
;reset the disk
mov ah, 0
int 0x13
; memory address
mov ax, 0        ; this is here because you cannot move directly to a segment register
mov es, ax
mov bx, MEMKERNELLOC
; cylinder, head, sector
mov ch, 0
mov dh, 0
mov cl, 0x02
; mode, num sectors
mov ah, 0x02
mov al, 0x02
; execute and check for errors
int 0x13
jc error


;
; RUN: run the new code
;
; jump to new code dword = define word
jmp dword 0x0:MEMKERNELLOC


; error for if the disk failed to read
error:
mov ah, 0x0e
mov al, 'N'
int 0x10
mov al, 'o'
int 0x10
mov al, '!'
int 0x10
jmp $


times 510-($-$$) db 0 ; pad the file with zeros until the 510 byte
dw 0xaa55             ; this is the magic boot number
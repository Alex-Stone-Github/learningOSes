BITS 16
SECTION .bootloader

;
; CONSTANTS: this has all of the constants
;
MEMKERNELLOC equ 0x1000
CODESEGMENT  equ GDTcode - GDT
DATASEGMENT  equ GDTdata - GDT

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
; RUN: switch to 32 bit mode setup stack and jump to new code
;
;
cli                      ; disable interupts
lgdt [GDTdescription]    ; load the memory segment table
mov eax, cr0             ; set the last bit of cr0 register to 1 - this is needed to officialy make the switch
or eax, 1
mov cr0, eax
jmp CODESEGMENT:PROTECTEDMODE   ; jump to 32 bit code

BITS 32 ; 32 bit code ----------------------------------------------

PROTECTEDMODE:
mov al, '@'                           ; put an at at video memory [0] to let the user know we are in protected mode
mov [0xb8000], al
mov ax, 0x10                          ; set up the segment registers     ((((((((((((((((((POTENTIAL ERROR)))))))))))))))))) @@@@@@@@@@@@@@@@@@@@@@@@@@
mov ss, ax
mov ax, 0x0
; mov ds, ax
mov esp, 0x0900000                    ; set up the stack pointer
call dword CODESEGMENT:MEMKERNELLOC   ; jump to kernel code
jmp $                                 ; hang if the jump fails



BITS 16 ; 16 bit code ----------------------------------------------
;
; GDT TABLE: defines a bunch of stuff like interupts and memory
;
GDT:
GDTnull:
  dd 0
  dd 0
GDTcode:
  dw 0xffff
  dw 0
  db 0
  db 10011010b
  db 11001111b
  db 0
GDTdata:
  dw 0xFFFF
  dw 0
  db 0
  db 10010010b
  db 11001111b
  db 0
GDTend:
GDTdescription:
   dw GDTend - GDT - 1
   dd GDT

;
; ERRORS: for if the disk failed to read
;
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
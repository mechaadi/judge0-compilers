; hello.asm
; An ARM64 "Hello World" program using NASM

SECTION .data
    msg db "Hello, ARM64 World!", 0xA ; Our message, including a newline character (0xA)
    len equ $-msg                  ; Length of the message

SECTION .text
    GLOBAL _start                  ; Entry point for the program

_start:
    ; Call write syscall
    mov x0, #1                     ; File descriptor (stdout)
    adr x1, msg                    ; Address of the message string
    mov x2, len                    ; Length of the message
    mov x8, #64                    ; Syscall number for 'write' on ARM64 Linux
    svc #0                         ; Invoke the syscall

    ; Call exit syscall
    mov x0, #0                     ; Exit status (0 for success)
    mov x8, #93                    ; Syscall number for 'exit' on ARM64 Linux
    svc #0                         ; Invoke the syscall
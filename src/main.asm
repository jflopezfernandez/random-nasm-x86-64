
;==============================================================================
;
;
;                                           Random
;
;
;==============================================================================
;
;   Author:     Jose Fernando Lopez Fernandez
;
;   Date:       02 Jun 2019
;
;   Description:
;
;       The purpose of this program is to circumvent traditional methods of
;       random number generation, specifically software implementations, and
;       provide a clean, clear, simple, and small interface by which to
;       generate random numbers.
;
;       The program is written using the Netwide Assembler (NASM), and targets
;       Intel x86-86 processors with the RDRAND instruction, which Intel
;       introduced with the release of its Ivy Bridge processors in 2012.
; 
;   Technical Details:
;
;       According the the Intel documentation, the CPU is capable of generating
;       cryptographically secure, deterministic random numbers that meet the
;       NIST SP 800-90A standard(Intel, pg. 192). The random number generator
;       is frequently reseeded using a non-deterministic entropy source on the
;       chip, which Intel claims allows for the generation of statistically
;       uniform, non-periodic, and non-deterministic outputs.
;
;
;==============================================================================

            global      _start

            SECTION     .data
ver:        db          "Random - Version 2.1.1", 10, 0
verlen:     equ         $-ver
author:     db          "Author: Jose Fernando Lopez Fernandez", 10, 0
authlen:    equ         $-author
nl:         db          10

            SECTION     .text
_start:     push        rbp
            mov         rbp, rsp
            xor         rcx, rcx
            mov         r9, 10
.get_rand:  rdrand      rax
            cmp         rax, 0
            je          .get_rand
            jg          .get_digit
            imul        rax, -1
.get_digit: cmp         rax, 0
            jz          .print
            inc         rcx
            xor         rdx, rdx
            div         r9
            add         rdx, 48     ; Convert to ASCII
            push        rdx
            jmp         .get_digit
.print:     jrcxz       .final_nl
            mov         rax, 1
            mov         rdi, 1
            mov         rsi, rsp
            mov         rdx, 1
            push        rcx
            syscall
            pop         rcx
            pop         rax         ; Dump into garbage register
            dec         rcx
            jmp         .print
.final_nl:  mov         rax, 1
            mov         rdi, 1
            mov         rsi, nl
            mov         rdx, 1
            syscall
.call_exit: pop         rbp
            mov         rbp, rsp
            mov         rax, 60
            xor         rdi, rdi
            syscall

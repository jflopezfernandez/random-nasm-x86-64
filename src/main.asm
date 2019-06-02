
;==============================================================================
;
;
;                               Random - Version 1.0.0
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

            SECTION     .data
ver:        db          "Random - Version 1.1.1", 10, 0
verlen:     equ         $-ver
author:     db          "Author: Jose Fernando Lopez Fernandez", 10, 0
authlen:    equ         $-author

            SECTION     .text
            global      main
main:       push        rbp
            mov         rbp, rsp
.get_rnd:   rdrand      rdi
            jnc         .get_rnd
            pop         rbp
            mov         rbp, rsp
.call_exit: mov         rax, 60
            xor         rdi, rdi
            syscall

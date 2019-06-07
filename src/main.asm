
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
;
;                           PREPROCESSOR DEFINITIONS
;
;==============================================================================

    %define     FALSE           0
    %define     TRUE            1

    %define     SYSCALL_READ    0
    %define     SYSCALL_WRITE   1
    %define     SYSCALL_EXIT    60

    %define     STDIN           0
    %define     STDOUT          1
    %define     STDERR          2

    %define     NULL            0

    %define     CHAR_NEWLINE    10

    %define     SECTOR_SIZE     512
    %define     BUFSIZE         SECTOR_SIZE

;==============================================================================
;
;                               TEXT SECTION
;
;==============================================================================

                SECTION .TEXT
                GLOBAL _start

;            SECTION     .data
;ver:        db          "Random - Version 2.1.1", 10, 0
;verlen:     equ         $-ver
;author:     db          "Author: Jose Fernando Lopez Fernandez", 10, 0
;authlen:    equ         $-author
;nl:         db          10

_start:         POP     RBX                 ; Move argc into RBX

                ; If RBX equals 1, there were no arguments passed in. Skip
                ; argument parsing and checking stage.

                CMP     RBX,1               ; test (argc == 1)
                JE      .GET_RAND           ; If TRUE, skip to .GET_DIGITS

                POP     RBX                 ; Overwrite RBX with &argv[0]
.GET_NEXT_ARG:  POP     RBX                 ; ++argv
                CMP     RBX,NULL            ; Check if arg == NULL
                JZ      .GET_RAND           ; If argv = 0, args process. done

                ; Check each argument for valid values and set settings

.GET_RAND:      RDRAND  RAX                 ; Get random number
                JNC     .GET_RAND           ; If CF=0, result invalid. Repeat.
                CMP     RAX,0               ; Need to check if positive
;                JG      .GET_DIGITS         ; If positive, proceed to parse
;                MUL    RAX,-1               ; Neg value causes SIGFPE

                ; Get each digit using 'MOD 10, DIV 10' algorithm.

.GET_DIGITS:    MOV     R15,10              ; This is the divisor
                PUSH    0                   ; Push NUL terminator for finish
                                            ; condition with no counter.

.GET_DIGIT:     CMP     RAX,0               ; If RAX = 0, done getting digits
                JE      .PRINT_DIGIT        ; If RAX = 0, done
                XOR     RDX,RDX             ; Zero out top half of dividend
                DIV     R15                 ; Divide [RDX:RAX] by R15
                ADD     RDX,48              ; Convert to ASCII
                PUSH    RDX                 ; This is the current least sig dig
                JMP     .GET_DIGIT          ; Loop back to get next digit

.PRINT_DIGIT:   CMP     QWORD[RSP],0        ; TODO: Implement PRINT_DIGIT
                JE      .FINISH             ; Found NULL terminator. goto EXIT
                MOV     RAX,SYSCALL_WRITE
                MOV     RDI,STDOUT
                MOV     RSI,RSP             ; 'String' addr. = RSP
                MOV     RDX,1               ; Single char length = 1
                SYSCALL                     ; TODO: Check return value
                POP     RSI                 ; Remove char off stack after print
                JMP     .PRINT_DIGIT        ; Go print next char

.FINISH:        POP     RBX                 ; Pop final char from stack

                ; Print final newline

                PUSH    CHAR_NEWLINE        ; Push newline char to stack
                MOV     RAX,SYSCALL_WRITE
                MOV     RDI,STDOUT
                MOV     RSI,RSP             ; 'String' addr: RSP
                MOV     RDX,1               ; Single char length = 1
                SYSCALL                     ; Print newline
                POP     RBX                 ; Pop newline char from stack

                ; Exit program

.EXIT_SUCCESS:  XOR     RDI,RDI             ; Exit code 0 (EXIT_SUCCESS)
.EXIT:          MOV     RAX,60              ; Alow JMP to exit with code RDI
                SYSCALL


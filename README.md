
# random-nasm-x86-64
Cryptographically secure, hardware-generated RNG written in NASM x86-64 assembly.

## Overview

The current version on the master branch (<em>version 2.0.0</em>) produces an execuatble 
<strong>8,536</strong> bytes long. It uses the `printf` function from glibc, as well as all of 
the setup and shutdown code that gcc's `main` function implies. The goal is to 
reduce the size of the executable as much as possible to allow other programs 
the maximum cache space possible.

## Progress

 | Executable Size | Status | Date | Changelog |
 | --------------- | ------ | ---- | --------- |
 | 16,848 bytes    | Functional | 02 Jun 2019 | Initial build, using gcc |
 | 16,504 bytes    | Functional | 02 Jun 2019 | Stripped debug symbols, removed superfluous code |
 | 4,336 bytes     | No Output  | 02 Jun 2019 | Removed gcc helper code completely, no glibc, printf, etc. |
 | 8,536 bytes     | Functional | 02 Jun 2019 | Correctly outputting cryptographically secure, hardware-generated random numbers with no calls to glibc |

<hr />

# Building

The application uses the Netwide Assembler ([NASM](https://www.nasm.us/)) for compilation and GNU [ld](https://www.gnu.org/software/binutils/) as the linker. To build the application, simply clone the repository run `make` in the project directory. The makefile uses the `vpath` variable to find the source files in the included `src` directory.

```
$ git clone https://github.com/jflopezfernandez/random-nasm-x86-64.git random
$ cd random
$ make
```

 > <strong>Note:</strong> As an assembly application, it is not portable without making some changes to the source. These are platform dependent and will vary, but at the very least you will for sure have to change the value of `RAX` before every `syscall` from what I have to whatever your system uses, depending on whether you are using Windows or MacOS.

# Using

Having built the application, you can run it from the project directory by calling it like you normally would from `bash`:

```
$ ./random
4912874162021245581
```

I have not added a `make install` feature yet, but you can literally just copy the executable to your `/usr/bin` or `/usr/local/bin` directories if you want to. The application has no software dependencies, so provided you're on a Linux system and your CPU has the `RDRAND` instruction, you should be golden.

The [RDRAND](https://en.wikipedia.org/wiki/RdRand) instruction was introduced by Intel in 2012 with its Ivy Bridge processors, so as long as your processor is newer than about that time, you should be okay.

# TODO

 | Issue ID | Description | Status |
 | -------- | ----------- | ------ |
 | [Issue #0001](https://github.com/jflopezfernandez/random-nasm-x86-64/issues/1#issue-451221439) | Add check for `RDRAND` return value | Critical |

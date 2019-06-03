
# random-nasm-x86-64
Cryptographically secure, hardware-generated random number provider-interface written in NASM x86-64 assembly.

## Overview

The current version on the master branch (<em>version 2.1.0</em>) produces an executable <strong>8,536</strong> bytes long. It initially used the `printf` function by calling GCC and linking with glibc, which meant an unfortunate amount of size bloat because of all of the setup, shutdown, and miscellaneous helper code that gcc's `main` function and linking to the standard library imply. The goal is to reduce the size of the executable as much as possible to allow other programs the maximum cache space possible, while providing an extremely lightweight, low-memory footprint interface for generating cryptographically secure, statistically uniform random numbers.

The current version does not use the C Standard Library at all; instead, writing to standard output is done directly via system calls by writing everything in x86-64 assembly. The application currently returns an unsigned long long integer (64 bits) which it prints to standard output, but eventually the goal is to allow for minimum and maximum parameters to be set, as well as querying the interface for a specific number of outputs instead of having to call it for one at a time.

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

I set up a bash script to generate `n` random numbers while I implement the functionality natively, and it looks something like this.

```bash
#!/bin/sh

if [[ "$#" -ne 1 ]]
then
    echo "Usage: rand [n]"
    exit
fi

for (( i = 0; i < $1; i++ ))
do
    random
done
```

Assuming you're still either in the project directory, or `random` is in your `PATH`, you should get something like this:

```
$ rand
Usage: rand [n]
$ rand 10
8499345643546254815
2694828518955488459
8325431899581510166
8656937487568858518
1048997955614388542
6484560130390556974
2065750195224245233
4070076239724635225
8734172364984907491
4674330604802842582
```

You can then pipe this output to wherever you need it to go.

# TO DO

 | Issue ID | Type | Description | Status |
 | -------- | ---- | ----------- | ------ |
 | [Issue #1](https://github.com/jflopezfernandez/random-nasm-x86-64/issues/1#issue-451221439) | Error | Add check for `RDRAND` return value | [Closed](https://github.com/jflopezfernandez/random-nasm-x86-64/commit/f42b6e4ef2eb77fe6f6a19439fd33b0e7c71cb07) |
 | [Issue #2](https://github.com/jflopezfernandez/random-nasm-x86-64/issues/2) | Feature | Add invocation args for generating multiple RNs | Open |
 | [Issue #3](https://github.com/jflopezfernandez/random-nasm-x86-64/issues/3) | Feature | Add invocation arg for printing current application version | Open |

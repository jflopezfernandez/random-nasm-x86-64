
# random-nasm-x86-64
Cryptographically secure, hardware-generated RNG written in NASM x86-64 assembly.

## Overview

The current version on the master branch (version 1.1.1) produces an execuatble 
<strong>16,848</strong> bytes long. It uses the `printf` function from glibc, as well as all of 
the setup and shutdown code that gcc's `main` function implies. The goal is to 
reduce the size of the executable as much as possible to allow other programs 
the maximum cache space possible.


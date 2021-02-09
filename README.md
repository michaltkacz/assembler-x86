# Assembler x86
> Repository containing list of Assembly x86 programms.

## Table of contents
- [Assembler x86](#assembler-x86)
  - [Table of contents](#table-of-contents)
  - [General info](#general-info)
  - [Technologies](#technologies)
  - [Setup and run](#setup-and-run)
  - [Contact](#contact)

## General info
This repository containts 18 Assembler programs numbered from 1 to 18, where the first program is the least complex, and the last one is the most complex. Every program was created as an exercise for Assembler course.

## Technologies
Programs are written for [GNU Assembler (GAS)](https://en.wikipedia.org/wiki/GNU_Assembler) x86. They where created in Linux environment, thus they are written using the AT&T syntax.

## Setup and run
In order to compile and link programs, GNU Assembler is required. Every file in each folder contains setup and run instructions in comments at the very top of the file, e.g. [01_multiplying/mnozenie.s](./01_multiplying/mnozenie.s):
```
# Compilation:  as mnozenie.s --32 -o mnozenie.o -g
# Linker:       ld mnozenie.o -m elf_i386 -o mnozenie
# Execution:    ./mnozenie; echo $?
# Or            kdbg mnozenie
```

## Contact
Created by [@michaltkacz](https://github.com/michaltkacz) - feel free to contact me!
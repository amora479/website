---
title: "CPS 230"
date: 2018-08-16T00:00:00-04:00
---

# Course Description

Assembler language, interrupts, registers, memory addressing techniques, parameter passing mechanisms and the relationship between high-level languages and the computer.

**Prerequisites**: CPS 110.

# Announcements

_None at this time._

# Course Information

[Syllabus](/bju/cps230/info/syllabus)

[Schedule](/bju/cps230/info/schedule)

# Reference Material

## General

* [ASCII Chart](/bju/cps230/downloads/ascii.pdf) *(cached copy from CTAN)*
* [Big Boy Computer Datasheet](/bju/cps230/downloads/bbc_handout.pdf)

## IA-32 Assembly

* [Intel IA-32/Intel64 Instruction Set Architecture Reference](/bju/cps230/downloads/64ia32_isa_ref.pdf) *(cached copy from Intel's website)*
* [NASM Reference Manual](/bju/cps230/downloads/nasmdoc.pdf) *(cached copy from NASM's official website)*

## Ancient PC/DOS Programming

* [HelpPC](http://stanislavs.org/helppc/)
* [The PC Game Programmer's Encylopedia](http://qzx.com/pc-gpe/)

# Tools

## Needed Right Away

* Microsoft Windows
    - Preferably Windows 10
    - If you don't wish to install it natively, you can run it in a VM
    - Available to you free of charge via MSDNAA (see the CS lab monitors for details)

* Microsoft Visual Studio 2017
    - The free [community edition](https://www.visualstudio.com/downloads/) is fine
    - Or you can get the professional/enterprise versions, also for free, via MSDNAA (see the CS lab monitors for details)
    - Make sure you install the C++ tools and project templates (which are not enabled by default)
    - [VS 2017 Build Tools](https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2017)

# Needed Before Too Long

* NASM (the Netwide Assembler)
    - v2.12.02 (or later)
    - If the installer asks, you *don't* need either "RDOFF" support or "VS8 Integration"

* DOSBox (with the integrated debugger)
    - *The normal DOSBox installer typically doesn't give you this!*
    - You can build DOSBox from source to get the debugger [have fun!]
    - Or you can download this [ZIP file](/bju/cps230/downloads/dbd.zip)
    - Either way, I will assume you installed the executable at `C:\cps230\bin\dbd.exe` (you're free to put it somewhere else, just remember to translate the instructions appropriately)

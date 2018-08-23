---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 26: IA-32 Protected Mode

## What is it?

IA-32 Protected Mode (or just Protected Mode) is a special mode available on all modern PCs (since the Intel 80286) that provides protection against memory corruption.  To better understand this mode, let's compare it to the mode we've been programming in on the Intel 8086 (also known as Real Mode).

## Real Mode vs Protected Mode

In Real Mode, the program has access to all of memory (including the Interrupt Vector Table).  If you want to blow away the IVT and replace it with a textual representation of a unicorn, you are both welcome and allowed to do so (NOTE: not recommeded, unicorns are, in general, less useful than interrupts).  Additionally, if you have two programs running, these programs can compete for resources (including access to the same memory address).  Side Note: this was how some programs in DOS communicated with other programs.

In Protected Mode, your programs are sectioned off and given boundaries.  Generally, these boundaries are OS enforced and invisible to your program unless it tries to access memory outside of the boundary.  At this point the program is killed so that a memory violation doesn't occur.

Protected Mode (or at least more recent versions of it) also protect the true IVT by giving your program access to an Interrupt Descriptor Table where you can register your own interrupt handlers, but they don't override the actual handler. Instead they receive an event that contains the parameters and data of the real handler.

## History

Protected Mode was introduced on the Intel 80286, but the computer and mode wasn't popular for several reasons.  First, you couldn't access any DOS or BIOS interrupts while in protected mode on the 80286.  Second, as the 80286 had 16-bit registers, protected mode only allowed you at access up to 256 kb at a time of memory in protected mode (vs the 1 mb of memory on the 8086).  Finally, once you entered protected mode, you couldn't revert back to real mode (at least without some weird hacks).

The Intel 80386 introduced 32-bit registers and corrected many of protected mode's faults.  It also greatly increased the amount of memory supported (up to 4 GB!).
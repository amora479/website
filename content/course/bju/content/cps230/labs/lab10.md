---
title: "CPS 230 Lab 10"
---

# Lab 10
## Overview

In this lab you will *hook* the timer interrupt so that you can execute a small snippet of code 18.2 times per second,
*interrupting whatever code is currently running on the CPU!*

## Procedure

Grab the [starting code](/course/bju/content/cps230/downloads/lab10.asm) and have a read.  Try assembling and running it as-is.
It's a boring little program that repeatedly asks you to type in your name (with personalized greetings between prompts).
Enter nothing (i.e., just hit `ENTER` without typing anything) at one of the prompts to quit.

Now lets make this program walk and chew gum at the same time!!

## Steps

Find the  TODO comments in `lab10.asm`.  I recommend the following approach:

* Follow the comment instructions to *install* the `timer_isr` procedure as the interrupt handler for `INT 8`;
        before you go any farther, assemble and test your program
    * Launch your program in DOSBox with the `debugbox` prefix to immediately halt in the DOSBox debugger as soon as the program starts
    * Figure out how to place a *breakpoint* on the `jmp far [cs:ivt_offset]` line at the end of `timer_isr` 
    * Resume running the program (the `F5` key)
    * If you installed the hook correctly, you should hit your breakpoint
    * Remove your breakpoint and resume execution; the program should continue to work normally...
    * ...until you exit; if you then run a *different* `COM` program (say, another one of you labs), DOSBox will freeze or otherwise go nuts
    * **Why?** Easy--you left IVT slot 8 pointing at *code that got replaced by something entirely different in memory*

*  Time to add the necessary code to *uninstall* your interrupt hook after the main loop of the program is done and before we exit to DOS,
        restoring the original interrupt 8 vector as it was
    * If you assemble/run the program now, you should be able to exit and run anything else without making DOSBox sad
    * To be super safe, use the DOSBox debugger to step through the install/uninstall and make sure the original vector gets restored correctly

* Now, it's time to make `timer_isr` do *something* besides just chain to the original handler!  Follow the TODOs...

    * You will need a way to convert the counter value into its hexadecimal representation (i.e., `0x1337` to the ASCII characters `1`, `3`, `3`, and `7`)
    * You cannot use `puts` to print these characters, since you need the counter to show up in a fixed position on screen
    * You will need to use either BIOS functions under INT 0x10 or direct text-mode video ram writes (see the graphics examples)

## Hints

* Remember, when *installing* and *uninstalling* your interrupt hook that `MOV` (like all x86 instructions)
        does not support 2 memory operands; you'll need to move *from*
        the source memory location into a register, then from that register *to* the destination memory location
* Write a function that takes a single 16-bit number (in `AX`, perhaps) and prints it as text in the upper-left corner of the screen
    * It should be very careful to save/restore any registers it needs to trash
    * Obviously, you'll call this function from inside `timer_isr`
    * But perhaps less obviously, you should write/test/debug this function *in a normal, vanilla DOS program with no interrupt handlers in sight*
    * Trust me, you don't want to debug that sort of thing inside the context of an interrupt handler!!
* Direct video memory access is pretty easy, especially in text mode; don't be afraid of it (and see the `textgraf.asm` example program)
* Don't overthink the print-number-in-hex thing; you don't need to create strings or do anything fancy
    * Ask yourself "how would I convert the *least-significant* nybble [4 bits] of this 16-bit number into an ASCII digit"?
    * `AND` is definitely your friend
    * There's a suspicious looking 16-character string sitting down there in the data section named `digits` with no NUL terminator
    * What's the range of values for a single hex digit again?
    * Remember how array indexing works in x86 assembly?
    * Now ask yourself "how would I convert the *most-significant* nybble [4 bits] of this 16-bit number into an ASCII digit"?
    * Perhaps `ROL` is your friend

## Report

Usual lab report.

## Submission

Submit your completed `lab10.asm` and your report file, which must be named either:

* `report.docx` (Microsoft Word file)
* `report.pdf` (Adobe PDF file)

Case matters. :-)


---
title: "CPS 230 Lab 6"
---

# Lab 6
## Overview

In this lab you will port a C implementation of the the mathematical game "Towers of Hanoi" to x86 assembly.

Don't worry, there are no graphics to draw: you will simply print out the moves a player must make to win (for a given number of disks).

The goal is to gain familiarity with how C functions work, including

* how parameters are passed *and accessed by the called function*
* how local variables are stored and accessed
* issues like register saving/restoring

**This lab is challenging.**  It is therefore worth **25 points**.

## Procedure

## Reference Implementation

Your final program should work *exactly* like the following C program:

```c
#define _CRT_SECURE_NO_WARNINGS 
#include <stdio.h>

void hanoi(int disk, int src, int dst, int tmp) {
    if (disk == 1) {
        printf("Move disk 1 from %d to %d\n", src, dst);
    } else {
        hanoi(disk - 1, src, tmp, dst);
        printf("Move disk %d from %d to %d\n", disk, src, dst);
        hanoi(disk - 1, tmp, dst, src);
    }
}

int main() {
    int num_disks;

    printf("How many disks do you want to play with? ");
    if (scanf("%d", &num_disks) != 1) {
        printf("Uh-oh, I couldn't understand that...  No towers of Hanoi for you!\n");
        return 1;
    }

    hanoi(num_disks, 1, 2, 3);

    return 0;
}
```

> **Note**: you are *required* to make `num_disks` a local (i.e., stack-allocated) variable in your assembly program, even if you could make it work as a global instead.


## The Win32 C Calling Convention Help

The rules by which functions manage the stack and registers while being called and in turn
calling other functions are collectively called (har-har) a "calling convention."  The
calling convention we are concerned with is the Win32 C calling convention, i.e., the
calling convention used by C compilers on the 32-bit Windows platform.

The basic rules are:

* Parameters are passed by pushing them onto the stack in right-to-left order (e.g., the C function call `foo(1, 2, 3)` would involve pushing 3, 2, and 1, in that order)
* The called function is free to change (i.e., will change) the contents of `eax`, `ecx`, and `edx`, but must preserve the contents of all other registers ("leave it like you found it")
* The return value (if any) will be placed into `eax` before the function returns
* The caller must remove all parameters pushed onto the stack after the called function returns

The precise sequence of operations (w.r.t. the stack) is typically:

* Push parameter (for as many parameters as we are passing, in right-to-left order)
* Call function (which automatically pushes a return address onto the stack)
* *(now inside the called function)*
    * Push the current value of the frame pointer (EBP) onto the stack
    * Set the frame pointer to point to the old/saved frame pointer on the stack
    * Push any non-volatile registers you need to use later on onto the stack
    * Adjust the stack pointer (ESP) to reserve space for any local variables
    * *(do function logic)*
    * Adjust ESP to "release" the space reserved for local variables
    * Pop (restore) any saved non-volatile registers
    * Pop the old frame pointer value back into EBP
    * Return (which automatically pops the return address from the stack)
* *(now back in the original caller)*
* Adjust ESP to "remove" all the pushed parameters from the stack

## Lab Tips

* Finish **Homework 3** first (seriously; don't even *think* about doing this lab until then)

* Compile/run the C program (preferably under a debugger) until you are *very* confident that you understand how it works.

* Before you write any code, draw a stack frame diagram for both `main` and `hanoi`; make sure you
    account for (and label, with offsets from EBP) all of the following:

    * Parameters coming into each function (if any)
    * The return address
    * The saved frame pointer (EBP)
    * Local variables (if any)

* The `lea` instruction ("load effective address") is very handy for computing the address of
    stack-based local variables; e.g., `lea eax, [ebp + 12]` acts almost like `mov eax, [ebp + 12]`,
    but with one **critical** difference: the `lea` version moves the *address* `ebp + 12` into
    `eax`, while the `mov` version actually moves the *value from* address `ebp + 12` into `eax`
* When you `push` values from memory, you *must* indicate to NASM how *big* the value from memory is
    (since it cannot know in advance); for our examples, you will always be pushing DWORDs, so write
    your pushes like this: `push dword [blah-blah-blah]` instead of just `push [blah-blah-blah]`
* You may also need to use the `dword` marker in front of other memory references, like this:

        cmp dword [some_variable], 1

    Without the `dword`, NASM doesn't know whether you want the version of `cmp` that works with
    8-bit, 16-bit, or 32-bit values (since "1" could be an 8-bit, 16-bit, or 32-bit number).
    
    
    > *We don't have this problem when the operation involves a register, since those are of
    a known/fixed size.*


## Submission

Submit your completed `lab6.asm` as well as a report file (either `report.docx`, or `report.pdf`, as appropriate).


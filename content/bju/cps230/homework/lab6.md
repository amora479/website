---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lab 6
## Overview

In this lab you will port a C implementation of the the mathematical game "Towers of Hanoi" to x64 assembly.

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


## The Win64 C Calling Convention Help

The rules by which functions manage the stack and registers while being called and in turn calling other functions are collectively called (har-har) a "calling convention."  The calling convention we are concerned with is the Win32 C calling convention, i.e., the calling convention used by C compilers on the 64-bit Windows platform.

The basic rules are:

* Parameters 1-4 are put into registers (rcx, rdx, r8 and r9; in that order)
* If you have more than 4 parameters, you must also create shadow space on the stack for the function (`sub rsp, 32`)
* The return value (if any) will be placed into `rax` before the function returns
* The caller must remove the shadow space as well as any pushed paramgers (`add rsp, <32 + number of pushed parameters * 8>`)

The precise sequence of operations (w.r.t. the stack) is typically:

* Push parameters after parameter 4 in reverse (if more than 4 parameters)
* Create shadow space (if more than 4 parameters)
* Put parameter 4 in r9 (if 4 parameters)
* Put parameter 3 in r8 (if 3 parameters)
* Put parameter 2 in rdx (if 2 parameters)
* Put parameter 1 in rcx (if 1 parameter)
* Call function (which automatically pushes a return address onto the stack) *whew...*
* *(now inside the called function)*
    * Push the current value of the frame pointer (RBP) onto the stack (`push rbp`)
    * Set the frame pointer to point to the old/saved frame pointer on the stack (`mov rbp, rsp`)
    * Push any registers that you want to preserve by pushing them onto the stack
    * Adjust the stack pointer (RSP) to reserve space for any local variables (`sub rsp, <number of variables * 8>`)
    * *(do function logic)*
    * Adjust RSP to "release" the space reserved for local variables (`add rsp, <number of variables * 8>`)
    * Pop (restore) any saved non-volatile registers
    * Ensure the stack is fully cleared (`mov rsp, rbp`)
    * Pop the old frame pointer value back into RBP (`pop rbp`)
    * Return (which automatically pops the return address from the stack)
* *(now back in the original caller)*
* Adjust RSP to "remove" all the pushed parameters and shadow space from the stack (if more than 4 parameters, `add rsp, <32 + number of pushed parameters * 8>`)

## Lab Tips

* Finish **Homework 3** first (seriously; don't even *think* about doing this lab until then)

* Compile/run the C program (preferably under a debugger) until you are *very* confident that you understand how it works.

* Before you write any code, draw a stack frame diagram for both `main` and `hanoi`; make sure you
    account for (and label, with offsets from RBP) all of the following:

    * Parameters coming into each function (if any)
    * The return address
    * The saved frame pointer (RBP)
    * Local variables (if any)

* The `lea` instruction ("load effective address") is very handy for computing the address of stack-based local variables; e.g., `lea rax, [rbp + 24]` acts almost like `mov rax, [rbp + 24]`, but with one **critical** difference: the `lea` version moves the *address* `rbp + 24` into `rax`, while the `mov` version actually moves the *value from* address `rbp + 24` into `rax`
* When you `push` values from memory, you *must* indicate to NASM how *big* the value from memory is (since it cannot know in advance); for our examples, you will always be pushing QWORDs, so write  your pushes like this: `push qword [blah-blah-blah]` instead of just `push [blah-blah-blah]`
* You may also need to use the `qword` marker in front of other memory references, like this:

        qmp dword [some_variable], 1

    Without the `qword`, NASM doesn't know whether you want the version of `cmp` that works with
    8-bit, 16-bit, 32-bit or 64-bit values (since "1" could be an 8-bit, 16-bit, 32-bit or 64-bit number).
        
    > *We don't have this problem when the operation involves a register, since those are of
    a known/fixed size.*


## Submission

Submit your completed `lab6.asm` as well as a report file (either `report.docx` or `report.pdf`, as appropriate).

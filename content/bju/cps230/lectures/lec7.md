---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lecture 7: Assembly Introduction

At this point, we have covered all of the major data representations used by the computer, and we've learned C.  Now it's time to move into Assembly.

``` nasm
; printf1.asm   print an integer from storage and from a register
; Assemble:    nasm -f elf -l printf.lst  printf1.asm
; Link:        gcc -o printf1  printf1.o
; Run:        printf1
; Output:    a=5, eax=7

; Equivalent C code
; /* printf1.c  print an int and an expression */
; #include 
; int main()
; {
;   int a=5;
;   printf("a=%d, eax=%d\n", a, a+2);
;   return 0;
; }

bits 64                              ; tell nasm this is 64-bit assembly
default rel                          ; use relative addresses

extern printf                        ; the C function, to be called

section .data                        ; Data section, initialized variables

    a:      dq    5                  ; int a=5;
    fmt:    db "a=%d, rax=%d",10, 0  ; The printf format, "\n",'0'

section .text                        ; Code section.

global main                          ; the standard gcc entry point
main:                                ; the program label for the entry point
    mov     rax, [a]                 ; put a from store into register
    add     rax, 2                   ; a+2
    mov     r8, rax                  ; 3rd parameter, value of rax
    mov     rdx, [a]                 ; 2nd parameter, value of a
    mov     rcx, fmt                 ; 1st parameter, value of fmt
    call    printf                   ; Call C function
    
    mov     rax, 0                   ; normal, no error, return value
    ret                              ; return
```

For right now, I'm only going to over the very basics of assembly and its structure.  What the individual lines mean, we'll discuss later.

## Data or Text

Notice that Assembly has two sections `.data` and `.text`.  The `.data` section represents the "variables" (aka named memory locations) that are defined for this program.  The `.text` contains the actual instructions about what to do.

## Instructions

Each instruction in C is of the format `opcode parameter1, parameter2` where `parameter1` and `parameter2` might be removed depending on how many parameters the command needs.  Note, an opcode can't have more than two parameters.

## Memory Referencing

Notice the `[a]` in the file?  That is how you reference memory.  At the top of the program `a` is defined as 5.  Every time you see `[a]`, the assembly is referencing the memory location in which 5 is stored.

## Labels

Also notice that some lines begin with a name followed by a colon.  This is called a label, and they have a special purpose in assembly.  Labels are how blocks of code are delinated and they are how variables and methods are introduced.  It is always a good idea to put an underscore in front of your label names because assembly will allow you to name you labels the same as opcodes if you want, but if you do so, you will throw some assemblers for a loop.  So good practice to get in the habit of doing.

## Good Habits

Labels, section, and global instructions are always all the way over as well as comments that are on their own line (comments start with a `;` in assembly).  Everything is one tab over.  This makes your assembly easier to read for both you and those trying to assist you.

## Warnings

Googling for help with NASM will yield a large number of 32-bit articles.  Most of time these solutions will work provided you change the register names.  However, calling printf and scanf will be utterly different.  Also, do not forget the `default rel` at the top of your assembly files.  The linker errors will spew forth in abundance for your sin of leaving that out.
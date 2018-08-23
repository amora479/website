---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 7: Assembly Introduction

At this point, we have covered all of the major data representations used by the computer, and we've learned C.  Now it's time to move into Assembly.

``` nasm
; printf1.asm   print an integer from storage and from a register
; Assemble:	nasm -f elf -l printf.lst  printf1.asm
; Link:		gcc -o printf1  printf1.o
; Run:		printf1
; Output:	a=5, eax=7

; Equivalent C code
; /* printf1.c  print an int and an expression */
; #include 
; int main()
; {
;   int a=5;
;   printf("a=%d, eax=%d\n", a, a+2);
;   return 0;
; }

; Declare some external functions
;
extern	_printf	; the C function, to be called

SECTION .data	; Data section, initialized variables

	a:		dd	5					 ; int a=5;
	fmt:    db "a=%d, eax=%d", 10, 0 ; The printf format, "\n",'0'


SECTION .text   ; Code section.

global _main			; the standard gcc entry point
_main:					; the program label for the entry point
    push    ebp			; set up stack frame
    mov     ebp,esp

	mov	eax, [a]		; put a from store into register
	add	eax, 2			; a+2
	push	eax			; value of a+2
    push    dword [a]	; value of variable a
    push    dword fmt	; address of ctrl string
    call    _printf		; Call C function
    add     esp, 12		; pop stack 3 push times 4 bytes

    mov     esp, ebp	; takedown stack frame
    pop     ebp			; same as "leave" op

	mov	eax,0			;  normal, no error, return value
	ret					; return
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
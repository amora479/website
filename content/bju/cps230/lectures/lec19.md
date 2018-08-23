---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 19: Using the BIOS API

## Changing Tactics

So we finally reach the third part of this course, programming on bare metal (or emulated bare metal).  We're not going to jump into bare metal just yet; we'll ease into first by writing programs for DOS, the ye olde precursor to Windows.  DOS is fairly close to bare-metal programming, but it does provide a few things that will make transitioning a bit easier.  So what is going to change?

1. Register Names

	Up to this point, we have been using 32-bit registers: eax, ebx, ecx, edx.  Chop those e's off the front because we're in 16-bit land now folks.

	As a side note, start all of your assembly files now with
	``` asm
	bits 16
	org 0x100
	```
	as this provides a little bit of information to NASM to help it produce more helpful error messages.

1. Assembling

	We won't be assembling and linking anymore (no C standard library on DOS after all).  We'll just be assembling.  This will change the structure of our NASM commands just a small bit: `nasm -fbin -o<asm file name>.com <asm file name>.asm`.

1. Input / Output

	We don't have printf, getchar, putchar, scanf and other C I/O functions anymore.  We'll have to use interrupts (more on that in a bit).

1. Exiting

	Up to this point, we've been letting main's ret call exit for us.  We'll need to use an interrupt now, specifically `0x21`.

	``` asm
	mov	ah, 0x4c
	mov	al, 0 ; this is the return code
	int	0x21
	```

1. Starting

	Up to this point, we have just taken for granted that _main would be where execution started.  In DOS, we start execution on the first assembly command after the first `SECTION .text`.

1. Running / Debugging

	This will now be done inside DosBox, and you'll see how to do this in lab 8.

1. Parameter Passing

	Parameters in DOS can be passed via the stack like we have been doing, but the normal convention here is to pass via register (or partial register) instead!  We'll see some examples when we get to interrupt calls.

1. Function Preambles / Postambles

	Since we aren't passing parameters via the stack (unless you want to), you no longer need our standard `push bp` / `mov bp, sp` preamble or the associated postamble.

## Why are we doing this?

Programming assembly for modern processors is no easy feat as there is so much to keep track of that the task is virtually impossible without a large team.  Older architectures / processors can also be complex, but that complexity pales in comparision to modern computers.  To better learn how computer systems actually work, we'll program for older, simpler architectures instead.  The same theoretical concepts learned apply to modern architectures; the only real difference is the implementation details.

## Interrupts

So, since we no longer have C, we need a way to do input and output, or we need a way to interface with an external device attached to the processor.  This is done through the use of interrupts.  An interrupt is a small routine that allows you to pause your program's execution and interface with hardware or the OS in order to get / give a piece of data.  The two interrupts we use below are interrupt 0x10 (Video / Display Interrupt) and 0x16 (Keyboard / Input Interrupt).  The details for these and their sub-interrupts can be found on the scheduled reading for today.  However, in short, each interrupt requires you to pass certain pieces of information (like the subinterrupt code in AH) when you invoke it using the `int` opcode with the interrupt code.

Here is an example of a small program that has interrupt implementations for `_getchar`, `_putchar`, `_getstring`, and `_putstring`.  Note that we will explain addresses next class period.  For now, just know that the si register is being used to hold the address of the strings and array.

``` asm
BITS 16

org	0x100

SECTION .text
_main:
	mov si, prompt
	call _putstring

	mov si, string
	call _getstring

	mov si, hello
	call _putstring

	mov si, string
	call _putstring

	mov	ah, 0x4c
	mov	al, 0
	int	0x21

_getchar:
	mov ah, 0
	int 0x16
	mov ah, 0
	ret

_putchar:
	mov ax, dx
	mov ah, 0x0E
	mov cx, 1
	int 0x10
	ret

_getstring:
_getstring_while:
	call _getchar
	cmp ax, 13
	jne _getstring_check_10
	jmp _getstring_done
_getstring_check_10:
	cmp ax, 10
	jne _getstring_continue 
	jmp _getstring_done
_getstring_continue:
	mov [si], al
	inc si
	mov dx, ax
	call _putchar
	jmp _getstring_while
_getstring_done:
	mov dx, 13
	call _putchar
	mov dx, 10
	call _putchar
	ret

_putstring:
_putstring_while:
	cmp byte [si], 0
	jne _putstring_continue
	jmp _pustring_done
_putstring_continue:
	mov dl, [si]
	mov dh, 0
	call _putchar
	inc si
	jmp _putstring_while
_pustring_done:
	ret

SECTION .data

	prompt: db "Please enter your first name: ", 0
	string: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	hello: db "Hello, ", 0
```
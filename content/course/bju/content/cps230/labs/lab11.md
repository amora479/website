---
title: "CPS 230 Lab 11"
---

# Lab 11
## Overview

In this lab you will return to the protected mode world of Windows and convert your [Lab 6](/course/bju/content/cps230/labs/lab6)
Towers of Hanoi implementation into x86-64 assembly code.

## Example

For some tips on what changes from Win32 to Win64, see the following "hello world" program:

```nasm
; "Hello world" in x86-64 assembly for Windows
bits 64

; CHANGE: no name mangling of C function names ("printf", not "_printf")
extern printf

section .text

global main
main:
	push	rbp
	mov	rbp, rsp		; Standard prologue upgraded to x64
	
	; CHANGE: first 4 integer/pointer params passed in RCX, RDX, R8, R9 (in that order)
	;		(remaining, if any, pushed on stack in right-to-left order)
	mov	rcx, hello_world
	sub	rsp, 32			; Win64 quirk: reserve 32 bytes of stack before call
	call	printf
	add	rsp, 32
	
	mov	rsp, rbp		; Standard epilogue upgraded to x64
	pop	rbp
	ret


section .data
hello_world	db	`hello, world\n`, 0
```

## Report

Usual lab report.

## Submission

Submit your completed `lab11.asm` and your report file, which must be named either:

* `report.docx` (Microsoft Word file)
* `report.pdf` (Adobe PDF file)

Case matters. :-)


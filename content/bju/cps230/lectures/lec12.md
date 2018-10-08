---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lecture 12: Stack Frames

So far, we've stuck everything in a single function (main), so now let's break things up into functions, but there are two things we need to handle: recursion and local variables.  Guess how we're going to handle it, the stack!!  *Grumble Grumble Grumble*

## 64-bit Calling Convention Method

Let's start by defining a function (in C) that has local variables and recursion.

``` c
int factorial(int x) {
	int local;
	if(x == 2) {
		local = 2;
	} else {
		local = factorial(x-1) * x;
	}
	return local;
}
```

In assembly, this function would look something like the following:

``` asm
global _factorial
_factorial:
	mov	[rsp + 8], rcx		; shove rcx into shadow space
	push	rbp			; save old frame pointer
	mov  	rbp, rsp		; make a new frame
	sub	rsp, 8			; create a local variable to hold result
	cmp 	rcx, 2			; parameter is in rcx 
	je 	.true_part
	jmp 	.false_part
.true_part:
	mov 	[rbp - 8], 2			; result is 2
	jmp 	.end_if
.false_part:
	sub	rsp, 32			; create shadow space for recursive call (not shared since this is the only
					; function call, otherwise would be created up top)
	dec 	rcx			; param is still in rcx, so just decrement it
	call 	_factorial
	add 	rsp, 32			; remove local shadow space
	mov 	rcx, dword [rbp + 16]	; load saved parameter into rcx (we clobbered it with recursion)
	imul 	rcx			; multiply (x-1)! by x; (x-1)! is already in rax, sets rax up for return
	mov	[rbp - 8], rax
.end_if:
	mov	rax, [rbp - 8]
	mov 	rsp, rbp		; pop off locals / return value
	pop 	rbp			; restore caller's frame
	ret
```

Let's break down the opening and closing sections and talk about why they are necessary. 

``` asm
global _factorial
_factorial:
```

These two lines define the functions name as well as allow the function to be called from C or C++.  The global isn't necessary if you aren't going to do this, but it doesn't hurt anything.  The label, however, is always required.

``` asm
mov	[rsp + 8], rcx	; save rcx into shadow space
push 	rbp		; save the caller's frame
mov 	rbp, rsp	; make a new frame
```

These three lines contain a lot of *magic* so let's make it unmagical.  In 64-bit assembly the first four parameters go into rcx, rdx, r8 and r9 in that order.  A typical function main which calls our factorial function might look something like this...

``` asm
global main
main:
	sub	rsp, 32		; create shadow space that is shared by all function calls
	mov	rcx, 4
	call 	_factorial
	add	rsp, 32		; remove shared shadow space
	ret
```

the stack (when we get to the start or \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- | --- |
| 0x80000018 | ? | | shadow space for r9 |
| 0x80000010 | ? | | shadow space for r8 |
| 0x80000008 | ? | | shadow space for rdx |
| 0x80000000 | ? | | shadow space for rcx |
| 0x7FFFFFF8 | *some address* | RSP | The address of `add rsp, 32` |

Since factorial is recursive and our parameter is in a register, we need to save the value somewhere lest it clobbered away by our calling another function. `RSP` currently points at the top of the stack (or the return address). So `[RSP + 8]` would be the start of the shadow space.  Creating a frame pointer allows us to have a non-changing reference to this shadow space area, but we need to save the current frame pointer first thus the `push rbp`. `mov rbp, rsp` creates a new frame pointer which points to the top of the stack (or the old base pointer).

Now our stack looks (after the `mov rbp, rsp` in \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- | --- |
| 0x80000018 | ? | | shadow space for r9 |
| 0x80000010 | ? | | shadow space for r8 |
| 0x80000008 | ? | | shadow space for rdx |
| 0x80000000 | 4 | | shadow space for rcx |
| 0x7FFFFFF8 | *some address* |  | The address of `add rsp, 8` |
| 0x7FFFFFF0 | *some address* | RSP, RBP | Caller's RBP |

Finally, we need a place to put our local variables (that isn't global!).  If we just make them all global, the recurive variables will get overwritten, and that is not good.  We can make space on the stack by subtracting (8 * the number of locals we need) from rsp, and then mentally making note of which local variables go to which slot.  Note: I generally make the first slot below the Caller's RBP the address for the return variable.

Now our stack looks (after `sub rsp, 8` in \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- | --- |
| 0x80000018 | ? | | shadow space for r9 |
| 0x80000010 | ? | | shadow space for r8 |
| 0x80000008 | ? | | shadow space for rdx |
| 0x80000000 | 4 | | shadow space for rcx |
| 0x7FFFFFF8 | *some address* |  | The address of `add rsp, 4` |
| 0x7FFFFFF0 | *some address* | RBP | Caller's RBP |
| 0x7FFFFFE8 | ? | RSP | Return Variable |

Now, we just need to undo all of this before we return.  Also need to put the return variable into RAX.

``` asm
mov 	rax, dword [rbp-8]	; put the return value in rax
mov 	rsp, rbp		; pop off locals / return value
pop 	rbp			; restore caller's frame
ret
```

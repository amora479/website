---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 12: Stack Frames

So far, we've stuck everything in a single function (main), so now let's break things up into functions, but there are two things we need to handle: recursion and local variables.  Guess how we're going to handle it, the stack!!  *Grumble Grumble Grumble*

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
	push rbp               ; save the caller's frame
	mov rbp, rsp           ; make a new frame
	sub rsp, 8             ; make space for local variables / return variable
	cmp dword [rbp+16], 2
	je true_part
	jmp false_part
true_part:
	mov dword [rbp-8], 2
	jmp end_if
false_part:
	mov rax, dword [rbp+16]
	sub rax, 1
	push rax
	call _factorial
	add rsp, 8             ; rax is (x-1)!
	mov rbx, dword [rbp+16]
	imul rbx
	mov dword [rbp-8], rax
end_if:
	mov rax, dword [rbp-8] ; put the return value in rax
	mov rsp, rbp           ; pop off locals / return value
	pop rbp                ; restore caller's frame
	ret
```

Let's break down the opening and closing sections and talk about why they are necessary. 

``` asm
global _factorial
_factorial:
```

These two lines define the functions name as well as allow the function to be called from C or C++.  The global isn't necessary if you aren't going to do this, but it doesn't hurt anything.  The label, however, is always required.

``` asm
push rbp               ; save the caller's frame
mov rbp, rsp           ; make a new frame
sub rsp, 8             ; make space for local variables / return variable
```

These three lines contain a lot of *magic* so let's make it unmagical.  When you are referencing variables on the stack (i.e. your parameters), you need a way to reference them.  After a typical function call in assembly,

``` asm
push 4
call _factorial
add rsp, 8
```

the stack (when we get to start \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- | --- |
| 0x80000000 | 4 | | The parameter to _factorial |
| 0x7FFFFFF8 | *some address* | RSP | The address of `add rsp, 8` |

In order to get to our parameter, we just need to grab `[RSP+8]`.  But wait, what happens if we push or pop anything in the function (which we are guilty of in this case), RSP will change and we'll have to jump around a lot more and we'll have to keep track of the offset.  Or will we?  There is a better way and that is to use the frame pointer.  Since the frame pointer isn't affected by pushes and pops, we can set it to RSP for the duration of the function.  This is accomplished by `mov rbp, rsp`.  However, for recursion purposes, we need to save our caller's frame pointer so we can restore it when we're done.  This is accomplished by the push to the stack `push rbp`.

Now our stack looks (when we get to start \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- | --- |
| 0x80000000 | 4 | | The parameter to _factorial |
| 0x7FFFFFF8 | *some address* |  | The address of `add rsp, 8` |
| 0x7FFFFFF0 | *some address* | RSP, RBP | Caller's RBP |

Finally, we need a place to put our local variables (that isn't global!).  If we just make them all global, the recurive variables will get overwritten, and that is not good.  We can make space on the stack by subtracting (8 * the number of locals we need) from rsp, and then mentally making note of which local variables go to which slot.  Note: I generally make the first slot below the Caller's RBP the address for the return variable.

Now our stack looks (when we get to start \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- | --- |
| 0x80000000 | 4 | | The parameter to _factorial |
| 0x7FFFFFF8 | *some address* |  | The address of `add rsp, 4` |
| 0x7FFFFFF0 | *some address* | RBP | Caller's RBP |
| 0x7FFFFFE8 | 0 | RSP | Return Variable |

Now, we just need to undo all of this before we return.  Also need to put the return variable into EAX.

``` asm
mov rax, dword [rbp-8] ; put the return value in rax
mov rsp, rbp           ; pop off locals / return value
pop rbp                ; restore caller's frame
ret
```
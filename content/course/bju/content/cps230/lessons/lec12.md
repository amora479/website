---
title: "CPS 230 Lecture 12"
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
	push ebp               ; save the caller's frame
	mov ebp, esp           ; make a new frame
	sub esp, 4             ; make space for local variables / return variable
	cmp dword [ebp+8], 2
	je true_part
	jmp false_part
true_part:
	mov dword [ebp-4], 2
	jmp end_if
false_part:
	mov eax, dword [ebp+8]
	sub eax, 1
	push eax
	call _factorial
	add esp, 4             ; eax is (x-1)!
	mov ebx, dword [ebp+8]
	imul ebx
	mov dword [ebp-4], eax
end_if:
	mov eax, dword [ebp-4] ; put the return value in eax
	mov esp, ebp           ; pop off locals / return value
	pop ebp                ; restore caller's frame
	ret
```

Let's break down the opening and closing sections and talk about why they are necessary. 

``` asm
global _factorial
_factorial:
```

These two lines define the functions name as well as allow the function to be called from C or C++.  The global isn't necessary if you aren't going to do this, but it doesn't hurt anything.  The label, however, is always required.

``` asm
push ebp               ; save the caller's frame
mov ebp, esp           ; make a new frame
sub esp, 4             ; make space for local variables / return variable
```

These three lines contain a lot of *magic* so let's make it unmagical.  When you are referencing variables on the stack (i.e. your parameters), you need a way to reference them.  After a typical function call in assembly,

``` asm
push 4
call _factorial
add esp, 4
```

the stack (when we get to start \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- |
| 0x80000000 | 4 | | The parameter to _factorial |
| 0x7FFFFFFC | <some address> | ESP | The address of `add esp, 4` |

In order to get to our parameter, we just need to grab `[ESP+4]`.  But wait, what happens if we push or pop anything in the function (which we are guilty of in this case), ESP will change and we'll have to jump around a lot more and we'll have to keep track of the offset.  Or will we?  There is a better way and that is to use the frame pointer.  Since the frame pointer isn't affected by pushes and pops, we can set it to ESP for the duration of the function.  This is accomplished by `mov ebp, esp`.  However, for recursion purposes, we need to save our caller's frame pointer so we can restore it when we're done.  This is accomplished by the push to the stack `push ebp`.

Now our stack looks (when we get to start \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- |
| 0x80000000 | 4 | | The parameter to _factorial |
| 0x7FFFFFFC | <some address> |  | The address of `add esp, 4` |
| 0x7FFFFFF8 | <some address> | ESP, EBP | Caller's EBP |

Finally, we need a place to put our local variables (that isn't global!).  If we just make them all global, the recurive variables will get overwritten, and that is not good.  We can make space on the stack by subtracting (4 * the number of locals we need) from esp, and then mentally making note of which local variables go to which slot.  Note: I generally make the first slot below the Caller's EBP the address for the return variable.

Now our stack looks (when we get to start \_factorial) looks something like this:

| Address | Value | Register, Pointers | Notes |
| --- | --- | --- |
| 0x80000000 | 4 | | The parameter to _factorial |
| 0x7FFFFFFC | <some address> |  | The address of `add esp, 4` |
| 0x7FFFFFF8 | <some address> | EBP | Caller's EBP |
| 0x7FFFFFF4 | 0 | ESP | Return Variable |

Now, we just need to undo all of this before we return.  Also need to put the return variable into EAX.

``` asm
mov eax, dword [ebp-4] ; put the return value in eax
mov esp, ebp           ; pop off locals / return value
pop ebp                ; restore caller's frame
ret
```
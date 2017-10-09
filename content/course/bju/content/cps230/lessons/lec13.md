---
title: "CPS 230 Lecture 13"
---

# Lecture 13: Arrays & Structures

## Arrays

We have already seen how to create arrays in C.  Simply declare the array and give it a size like so `int foo[26]`.  We also seen how to index into an array, well, at least we've seen one of the many ways.  In C, arrays are laid out as sequential blocks of memory (that are all the same size!) and the variable is really a reference to the address of the start of the array, also known as a pointer.

Let's look at a simple C program that implements a stack using an array.

``` c
#include "stdio.h"

int stack[100];
int top_of_stack = 0;

void push(int value) {
	stack[top_of_stack] = value;
	++top_of_stack;
}

int pop() {
	--top_of_stack;
	return stack[top_of_stack];
}

int peek() {
	return stack[top_of_stack-1];
}

int main() {
	int number;
	scanf("%d", &number);
	push(number);
	printf("%d", peek());
	return 0;
}
```

If we were to reach into an arbitrary position, let's say the 22nd position, there are several ways that we could do so in C.

``` c
stack[21]; // the one we're most familiar with
21[stack]; // weird but it works
*(stack + 21); // pointer arithmetic
*(21 + stack); // pointer arithmetic
```

The last two methods are the most curious, because there is some magic going on behind the scenes. Remember that we address memory in bytes, and that each 32-bit number is 4 bytes.  So logically, shouldn't we wind up somewhere in the middle of our 5th number?  No because the C compiler actually multiplies the 21 by 4 (since the array is of type int).  Note, this feature exists in the C compiler, and we do not have this luxury in assembly.

## Structs

C also allows us to group related data into the same block of memory using structs.

``` c
struct Person {
	char name[50];
	int age;
	int weight;
};

int main() {
	Person p;
	return 0;
}
```

If we were to inspect the memory of this program and look at p, what we would see would be a block of memory 58 bytes long.  The first 50 would be reserved for the string, the next 4 would be for age, and the final 4 would be for weight.

## Arrays in Assembly

Arrays in assembly are much like you might expect; they are just blocks of memory, and there are two ways of declaring them: initialized and uninitialized.  For initialized arrays, declare your array in the .data section with each value in a comma-separated list.

``` asm
SECTION .data
	array: dd 0,0,0,0,0,0,0,0,0,0
```

The above generates an array of ints (10 long) with each set to 0.  If we just want a block of memory and don't care about initialization, then we use the .bss section instead.

``` asm
SECTION .bss
	array: resd 10
```

`resd` is the counterpart to `dd`.  Both request 32-bit blocks of memory, but rather than request the value of the blocks like `dd`, `resd` just asks how many blocks you want.

Let's use this to translate our C stack to assembly.

``` asm
extern _scanf
extern _printf
 
SECTION .bss
    stack: resd 9001
SECTION .data
    number: dd 0
    fmt: db "%d", 0
    top_of_stack: dd 0
SECTION .text
 
global _push
_push:
    push ebp
    mov ebp, esp

    mov eax, dword [ebp + 8] ; value to be pushed
    mov ecx, dword [top_of_stack]
    mov dword [stack + ecx * 4], eax
    inc dword [top_of_stack]

    mov esp, ebp
    pop ebp
    ret
 
global _pop
_pop:
    push ebp
    mov ebp, esp

    dec dword [top_of_stack]
    mov ecx, dword [top_of_stack]
    mov eax, dword [stack + ecx * 4]

    mov esp, ebp
    pop ebp
    ret
 
global _peek
_peek:
    push ebp
    mov ebp, esp

    mov ecx, dword [top_of_stack]
    sub ecx, 1
    mov eax, dword [stack + ecx * 4]

    mov esp, ebp
    pop ebp
    ret
 
global _main
_main:
    push ebp
    mov ebp, esp

    push number
    push fmt
    call _scanf
    add esp, 8

    push dword [number]
    call _push
    add esp, 4

    call _peek
    push eax
    push fmt
    call _printf
    add esp, 8

    mov esp, ebp
    pop ebp
    ret
```

## Structures in Assembly


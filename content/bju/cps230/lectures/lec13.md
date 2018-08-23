---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
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

Let's make a struct containing information about cats.

``` c
struct Cat {
    int legs;
    int unfriendliness;
    char liftsWeights;
    char name[50];
};
```

To create the same structure in assembly, we simply need to use the STRUC directive (which is done before any sections are declared).  Note that the `.size:` parameter at the of the struc is important because it gives us an easy way to determine the size (in bytes) of the struc.

``` asm
STRUC Cat 
    .legs: resd 1
    .unfriendliness: resd 1
    .liftsWeights: resb 1
    .name: resb 50
    .size:
ENDSTRUC
```

To create an initialized instance of this struct, we need to do the following in the `.data` section.

``` asm
authur: ISTRUC Cat
    AT Cat.legs, dd 6
    AT Cat.unfriendliness, dd 95
    AT Cat.liftWeights, db 0
    AT Cat.name, db "Poochkins", 0
IEND
```

Referencing the individual properites of a struc is done much the same way as an array.  Load the starting address of the struc and then get the offset, but offsets for strucs don't have to be manually calculated.  You can simply do `[register + Cat.unfriendliness]`.

Let's look at an example program that prints authur.

``` asm
extern _scanf
extern _printf
 
STRUC Cat
    .legs: resd 1
    .unfriendliness: resd 1
    .liftWeights: resb 1
    .name: resb 50
    .size:
ENDSTRUC
 
SECTION .bss
 
    cats: resb Cat.size * 500
 
SECTION .data
 
    _printf_fmt: db "Cat %s has %d legs and %d/10 unfriendly but ", 0
    _printf_fmt1: db "lifts weights", 10, 0
    _printf_fmt2: db "doesn't lifts weights", 10, 0

    authur: ISTRUC Cat
        AT Cat.legs, dd 6
        AT Cat.unfriendliness, dd 95
        AT Cat.liftWeights, db 0
        AT Cat.name, db "Poochkins", 0
    IEND
 
SECTION .text
 
global _print_cat
_print_cat:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    push eax
    push dword [eax + Cat.unfriendliness]
    push dword [eax + Cat.legs]
    lea ebx, [eax + Cat.name]
    push ebx
    push _printf_fmt
    call _printf
    add esp, 16
    pop eax

    cmp byte [eax + Cat.liftsWeights], 1
    je _true
    jmp _false
_true:
    push _printf_fmt1
    call _printf
    add esp, 4
    jmp _end
_false:
    push _printf_fmt2
    call _printf
    add esp, 4
_end:
    mov esp, ebp
    pop ebp
    ret
 
global _main
_main:
    push authur
    call _print_cat
    add esp, 4
    ret
```

Additionally, here is another example that allows you to write / read a Person struc to and from an array.

``` asm
extern _scanf
extern _printf

STRUC Person
    .first_name: resb 50
    .last_name: resb 50
    .age: resd 1
    .weight: resd 1
    .size:
ENDSTRUC

SECTION .data

    p: ISTRUC Person
        AT Person.first_name, db "John", 0
        AT Person.last_name, db "Doe", 0
        AT Person.age, dd 10
        AT Person.weight, dd 150
    IEND

    number: dd 0

    scanf_fmt_1: db " %s", 0
    scanf_fmt_2: db " %d", 0
    scanf_fmt_3: db " %c", 0

    printf_fmt_1: db "Enter a number (1-5): ", 0
    printf_fmt_2: db "Enter a first_name: ", 0
    printf_fmt_3: db "Enter a last_name: ", 0
    printf_fmt_4: db "Enter an age: ", 0
    printf_fmt_5: db "Enter a weight: ", 0
    printf_fmt_6: db "[R]ead or [W]rite? ", 0
    printf_fmt_7: db "Person (%s %s) is %d years old and weights %d", 10, 0

SECTION .bss

    person_array: resb Person.size * 5

SECTION .text

global _main
_main:
    mov ebx, p

    lea ecx, [ebx + Person.weight]
    push dword [ecx]
    lea ecx, [ebx + Person.age]
    push dword [ecx]
    lea ecx, [ebx + Person.last_name]
    push ecx
    lea ecx, [ebx + Person.first_name]
    push ecx
    push printf_fmt_7
    call _printf
    add esp, 20

    push printf_fmt_6
    call _printf
    add esp, 4

    push number
    push scanf_fmt_3
    call _scanf
    add esp, 8

    cmp dword [number], 87
    je _writing
    jmp _reading
_writing:
    push printf_fmt_1
    call _printf
    add esp, 4

    push number 
    push scanf_fmt_2
    call _scanf
    add esp, 8

    mov ebx, person_array
    mov eax, Person.size
    imul dword [number]
    sub eax, Person.size
    add ebx, eax

    push printf_fmt_2
    call _printf
    add esp, 4

    lea ecx, [ebx + Person.first_name]
    push ecx
    push scanf_fmt_1
    call _scanf
    add esp, 8

    push printf_fmt_3
    call _printf
    add esp, 4

    lea ecx, [ebx + Person.last_name]
    push ecx
    push scanf_fmt_1
    call _scanf
    add esp, 8

    push printf_fmt_4
    call _printf
    add esp, 4

    lea ecx, [ebx + Person.age]
    push ecx
    push scanf_fmt_2
    call _scanf
    add esp, 8

    push printf_fmt_5
    call _printf
    add esp, 4

    lea ecx, [ebx + Person.weight]
    push ecx
    push scanf_fmt_2
    call _scanf
    add esp, 8

    jmp _end
_reading:
    push printf_fmt_1
    call _printf
    add esp, 4

    push number 
    push scanf_fmt_2
    call _scanf
    add esp, 8

    mov ebx, person_array
    mov eax, Person.size
    imul dword [number]
    sub eax, Person.size
    add ebx, eax

    mov ecx, ebx
    lea ecx, [ebx + Person.weight]
    push dword [ecx]
    lea ecx, [ebx + Person.age]
    push dword [ecx]
    lea ecx, [ebx + Person.last_name]
    push ecx
    lea ecx, [ebx + Person.first_name]
    push ecx
    push printf_fmt_7
    call _printf
    add esp, 20
    _end:
    jmp _main
    ret
```
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
	array: dq 0,0,0,0,0,0,0,0,0,0
```

The above generates an array of ints (10 long) with each set to 0.  If we just want a block of memory and don't care about initialization, then we use the .bss section instead.

``` asm
SECTION .bss
	array: resq 10
```

`resq` is the counterpart to `dq`.  Both request 64-bit blocks of memory, but rather than request the value of the blocks like `dq`, `resq` just asks how many blocks you want.

Let's use this to translate our C stack to assembly.

``` asm
default rel

extern scanf
extern printf
 
section .bss
    stack: resq 9001

section  .data
    number: dq 0
    fmt: db "%lld", 0               ; %lld is always 64-bit regardless of compiler
    top_of_stack: dq 0              ; always is the location of where we insert the next item

section .text
 
; item to be pushed is in rcx
global _push
_push:
    mov     rdx, rcx                ; we need the counting register (rcx) below so save our value into an unused register
    mov     rcx, [top_of_stack]     ; top of stack is a counter of how many items are on the stack
    lea     rax, [stack]            ; put the address of the beginning of the stack into rax
    mov     [rax + rcx * 8], rdx    ; calculate the location of where we should insert the value, and insert it
    inc     qword [top_of_stack]    ; we put something on the stack so increment the counter

    ret
 
global _pop
_pop:
    dec     qword [top_of_stack]    ; we are taking something off the stack so decrement the counter
    mov     rcx, [top_of_stack]     ; get the new counter value
    lea     rax, [stack]            ; put the address of the beginning of the stack into rax 
    mov     rax, [rax + rcx * 8]    ; move the item we popped off into the return register

    ret
 
global _peek
_peek:
    mov     rcx, [top_of_stack]     ; we want the top of the stack but not to pop, so grab the location of the next insert
    sub     rcx, 1                  ; then decrement it
    lea     rax, [stack]            ; put the address of the beginning of the stack into rax
    mov     rax, [rax + rcx * 8]    ; move the item at the top of our stack into the return register

    ret
 
global main
main:
    sub     rsp, 32                 ; just share the shadow space with everybody rather than recreate it each time
    
    lea     rdx, [number]           ; address of number
    lea     rcx, [fmt]              ; address of format string
    call    scanf
    
    mov     rcx, [number]           ; value of number into rcx
    call    _push

    call    _peek
    mov     rdx, rax                ; print takes the actual value not an address like scanf
    lea     rcx, [fmt]              ; address of format string
    call    printf

    add     rsp, 32
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
    .legs: resq 1
    .unfriendliness: resq 1
    .liftsWeights: resb 1
    .name: resb 50
    .size:
ENDSTRUC
```

To create an initialized instance of this struct, we need to do the following in the `.data` section.

``` asm
authur: ISTRUC Cat
    AT Cat.legs, dq 6
    AT Cat.unfriendliness, dq 95
    AT Cat.liftWeights, db 0
    AT Cat.name, db "Poochkins", 0
IEND
```

Referencing the individual properites of a struc is done much the same way as an array.  Load the starting address of the struc and then get the offset, but offsets for strucs don't have to be manually calculated.  You can simply do `[register + Cat.unfriendliness]`.

Let's look at an example program that prints authur.

``` asm
default rel

extern scanf
extern printf
 
STRUC Cat
    .legs: resq 1
    .unfriendliness: resq 1
    .liftsWeights: resb 1
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
        AT Cat.legs, dq 6
        AT Cat.unfriendliness, dq 95
        AT Cat.liftsWeights, db 0
        AT Cat.name, db "Poochkins", 0
    IEND
 
SECTION .text
 
global _print_cat
_print_cat:
    mov     [rsp + 8], rcx                          ; store rcx in the shadow space, we'll need it later
    sub     rsp, 32                                 ; shared shadow space

    mov     rax, rcx                                ; put the address of the cat to print in rax
    mov     r9, qword [rax + Cat.unfriendliness]    ; grab the cat's unfriendliness
    mov     r8, qword [rax + Cat.legs]              ; grab the cat's leg count
    lea     rdx, [rax + Cat.name]                   ; grab the address of the cat's name
    lea     rcx, [_printf_fmt]                      ; grab the address of the format string
    call    printf
    
    mov     rax, [rsp + 40]                         ; told you we would the original rcx later
    cmp     byte [rax + Cat.liftsWeights], 1        ; the liftsWeights variable is a single byte so make sure we only grab that much
    je      .true                                   ; conditional jump to local label .true
    jmp     .false                                  ; jump to local label .false
.true:
    lea     rcx, [_printf_fmt1]                     ; address of "does lift weights"
    call    printf
    jmp     .end                                    ; jump to local label .end
.false:
    lea     rcx, [_printf_fmt2]                     ; address of "doesn't lift weights"
    call    printf
.end:
    add     rsp, 32                                 ; drop shared shadow space
    ret
 
global main
main:
    sub     rsp, 32                                 ; shared shadow space
    lea     rcx, [authur]                           ; address of authur
    call    _print_cat
    add     rsp, 32                                 ; remove shared shadow space
    ret
```

Additionally, here is another example that allows you to write / read a Person struc to and from an array.

``` asm
default rel

extern scanf
extern printf

STRUC Person
    .first_name: resb 50
    .last_name: resb 50
    .age: resq 1
    .weight: resq 1
    .size:
ENDSTRUC

SECTION .data

    p: ISTRUC Person
        AT Person.first_name, db "John", 0
        AT Person.last_name, db "Doe", 0
        AT Person.age, dq 10
        AT Person.weight, dq 150
    IEND

    number: dq 0

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

global main
main:
    sub     rsp, 32
.continue_loop:
    lea     rax, [p]                        ; load address of p (or John Doe)

    push    qword [rax + Person.weight]     ; oh noes, we have 5 things to print and only 4 registers, push value of weight
    sub     rsp, 32                         ; for things that have more than 4 parameters, they get their own shadow space
    mov     r9, [rax + Person.age]          ; value of page
    lea     r8, [rax + Person.last_name]    ; address of last name
    lea     rdx, [rax + Person.first_name]  ; address of first name
    lea     rcx, [printf_fmt_7]             ; address of "Person (%s %s) is %d years old and weights %d"
    call    printf
    add     rsp, 40                         ; pop off personal shadow space and 5th parameter

    lea     rcx, [printf_fmt_6]             ; address of "[R]ead or [W]rite? "
    call    printf

    lea     rdx, [number]                   ; address of number variable
    lea     rcx, [scanf_fmt_3]              ; address of " %c"
    call    scanf

    cmp     qword [number], 'W'             ; compare read value against W
    je      .writing                        ; local writing label
    jmp     .reading                        ; local reading label
.writing:
    lea     rcx, [printf_fmt_1]             ; address of "Enter a number (1-5): "
    call    printf

    lea     rdx, [number]                   ; address of number
    lea     rcx, [scanf_fmt_2]              ; address of " %d"
    call    scanf

    lea     rbx, [person_array]             ; we can't use fancy address calculation so manual it is
    mov     rax, Person.size
    imul    qword [number]
    sub     rax, Person.size                ; we force the user to start at 1, but we start counting at 0
    add     rbx, rax
    
    lea     rcx, [printf_fmt_2]             ; address of "Enter a first_name: "
    call    printf

    lea     rdx, [rbx + Person.first_name]  ; address of first name
    lea     rcx, [scanf_fmt_1]              ; address of " %s"
    call    scanf

    lea     rcx, [printf_fmt_3]             ; address of "Enter a last_name: "
    call    printf

    lea     rdx, [rbx + Person.last_name]   ; address of last name
    lea     rcx, [scanf_fmt_1]              ; address of " %s"
    call    scanf

    lea     rcx, [printf_fmt_4]             ; address of "Enter an age: "
    call    printf

    lea     rdx, [rbx + Person.age]         ; address of age
    lea     rcx, [scanf_fmt_2]              ; address of " %d"
    call    scanf

    lea     rcx, [printf_fmt_5]             ; address of "Enter a weight: "
    call    printf

    lea     rdx, [rbx + Person.weight]      ; address of weight
    lea     rcx, [scanf_fmt_2]              ; address of " %d"
    call    scanf

    jmp .end
.reading:
    lea     rcx, [printf_fmt_1]             ; address of "Enter a number (1-5): "
    call    printf

    lea     rdx, [number]                   ; address of number
    lea     rcx, [scanf_fmt_2]              ; address of " %d"
    call    scanf

    lea     rbx, [person_array]             ; we can't use fancy address calculation so manual it is
    mov     rax, Person.size
    imul    qword [number]
    sub     rax, Person.size                ; we force the user to start at 1, but we start counting at 0
    add     rbx, rax

    push    qword [rbx + Person.weight]     ; value of weight
    sub     rsp, 32                         ; personal shadow space because > 4 params
    mov     r9, [rbx + Person.age]          ; value of age
    lea     r8, [rbx + Person.last_name]    ; address of last name
    lea     rdx, [rbx + Person.first_name]  ; address of first name
    lea     rcx, [printf_fmt_7]             ; address of "Person (%s %s) is %d years old and weights %d"
    call    printf
.end:
    jmp .continue_loop
    ret
```
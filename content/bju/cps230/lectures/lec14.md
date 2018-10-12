---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lecture 14: C Strings

Strings in C are, as we've said before, just a block of ASCII characters in memory (at least, if you're not using unicode).  Up until now, we've been delcaring our assembly strings globally, but what happens if that isn't possible?  Can we put them on the stack as a local variable?  How about dynamically sized strings?

## String Operations in C

Before we get into the fun stuff, let's talk about how you do things in C first.  First, creating a dynamically sized array, struct or string is done with the malloc command (or one of its derivatives, like calloc).  malloc takes the size (in bytes) you need and returns an address to a block of that size.  calloc does the same thing, except is 0s out the block before giving you the address.  malloc leaves whatever gibberish was there before.

``` c
#include "string.h"
#include "stdio.h"

int main() {
	printf("Enter a string length: ");
	int blockSize;
	scanf("%d", &blockSize);

	char *myString = (char*)malloc(sizeof(char) * blockSize);
	-or-
	char *myString = (char*)calloc(sizeof(char) * blockSize);

	return 0;
}
```

Note: if you're creating something other than strings, like a struct or an array of ints, the sizeof function is your friend.  No having to manually calculate how big an entity is.

There are bunch of utility functions that are of use now.

``` c
gets(char *string); // reads an entire line of input into the address specified
puts(char *string); // writes the string to standard out followed by a newline

strcmp(char* string1, char* string2); // compares two strings byte by byte, returns 0 if equal
strcpy(char* dest, char* src); // copies the string from src into destination byte by byte until a \0 is encountered

memcpy(char* dest, char* src, int bytesToCopy); // generic version of strcpy that allows you specify how many bytes to copy
memset(char* block, int value, int bytesToSet); // writes value to bytesToSet bytes of block
```

## In Assembly

We can use the functions from the C string library in assembly as well, just like printf and scanf.  Let's say we wanted to create a local string variable of user-defined size then 0 it out before having the user enter a string.  We'll then print that string back to the user.

``` asm
default rel

extern malloc
extern memset
extern gets
extern puts
extern printf
extern scanf
 
SECTION .data
    
    prompt: db "Enter the size of the string you need: ", 0
    scanf_format: db "%lld", 0
               
SECTION .text
 
global main
main:
    push    rbp                     ; save old base pointer
    mov     rbp, rsp                ; create a new base pointer (we do lots of stack access here)
    sub     rsp, 48                 ; shadow space + two local variables (1 is the size of the string, 2 is the address of the string)

    lea     rcx, [prompt]           ; load address of prompt
    call    printf
   
    lea     rdx, [rbp - 8]          ; address of place to store size
    lea     rcx, [scanf_format]     ; load address of format string
    call    scanf                   ; set the size variable
    
    mov     rcx, [rbp - 8]          ; pass malloc the size of the string we need to allocate
    call    malloc
    mov     [rbp - 16], rax         ; store the address of the string
   
    mov     r8, [rbp - 8]           ; size of string
    mov     rdx, 0
    mov     rcx, [rbp - 16]         ; address of string
    call    memset
    
    mov     rcx, [rbp - 16]         ; address of string
    call    gets                    ; first call gets the newline from number entry
    
    mov     rcx, [rbp - 16]         ; address of string
    call    gets                    ; second call gets the string
    
    mov     rcx, [rbp - 16]         ; address of string
    call    puts
    
    mov     rsp, rbp                ; pop everything off the stack (shadow space included)
    pop     rbp                     ; restore whatever base pointer existed before me
    ret
```

Let's look at another example.  Here we create a string dynamically, and store that string as a local variable, before having the user enter a value into the local string.  We then compare the local string to a global string printing a value based on if they match.

``` asm
default rel
 
extern gets
extern printf
extern malloc
extern strcmp
extern strlen
 
SECTION .data

    electionString: db "make america great again", 0
    trump: db "trump", 10, 0
    hillary: db "hillary", 10, 0
   
SECTION .text
 
global main
main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 40                 ; 1 local variable + shadow space

    lea     rcx, [electionString]   ; address of election string
    call    strlen
    
    mov     rcx, rax                ; pass malloc how many bytes to allocate
    call    malloc
    mov     [rbp - 8], rax          ; store the address for later

    mov     rcx, rax                ; we need to ask the user for something
    call    gets
    
    mov     rdx, qword [rbp - 8]    ; address of second string
    lea     rcx, [electionString]   ; address of first string
    call    strcmp
    
    cmp     eax, 0                  ; compare the return of strcmp to 0
    je      .true                   ; jump to local .true label
    jmp     .false                  ; jump to local .false label
.true:
    lea     rcx, [trump]            ; load address of trump
    call    printf
    jmp     .end                    ; jump to local .end label
.false:
    lea     rcx, [hillary]          ; load address of hillary
    call    printf
.end:
    mov     rsp, rbp                ; pop everything off the stack (shadow space included)
    pop     rbp                     ; restore whatever base pointer existed before me
    ret
```
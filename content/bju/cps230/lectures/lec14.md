---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
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
extern _malloc
extern _memset
extern _gets
extern _puts
extern _printf
extern _scanf
 
SECTION .data
    prompt: db "Enter the size of the string you need: ", 0
    scanf_format: db "%d", 0
               
SECTION .text
 
global _main
_main:
    push ebp
    mov ebp, esp
    sub esp, 8 ; two local variables (1 is the size of the string, 2 is the address of the string)

    push prompt
    call _printf
    add esp, 4
   
    lea eax, [ebp - 4]
    push eax
    push scanf_format
    call _scanf ; set the size variable
    add esp, 8
   
    push dword [ebp - 4]
    call _malloc
    add esp, 4
    mov [ebp - 8], eax ; set the string variable
   
    push dword [ebp - 4]; size of string
    push 0
    push dword [ebp - 8]; address of string
    call _memset
    add esp, 12

    push dword [ebp - 8]
    call _gets ; first call gets the newline from number entry
    add esp, 4
   
    push dword [ebp - 8]
    call _gets ; second call gets the string
    add esp, 4
   
    push dword [ebp - 8]
    call _puts
    add esp, 4
   
    mov esp, ebp
    pop ebp
    ret

```

Let's look at another example.  Here we create a string dynamically, and store that string as a local variable, before having the user enter a value into the local string.  We then compare the local string to a global string printing a value based on if they match.

``` asm
; create a local string variable
; read into the string using gets
; compare the string to "make america great again"
; if equal print trump
; else print hillary
 
extern _gets
extern _printf
extern _malloc
extern _strcmp
extern _strlen
 
SECTION .data
    electionString: db "make america great again", 0
    trump: db "trump", 10, 0
    hillary: db "hillary", 10, 0
    format: db "%s", 0
 
SECTION .text
 
global _main
_main:
    push ebp
    mov ebp, esp
    sub esp, 4

    push electionString
    call _strlen
    add esp, 4
    push eax
    call _malloc
    add esp, 4
    mov [ebp - 4], eax

    push eax
    call _gets
    add esp, 4

    push dword [ebp - 4]
    push electionString
    call _strcmp
    add esp, 8

    cmp eax, 0
    je _true
    jmp _false
_true:
    push trump
    push format
    call _printf
    add esp, 8
    jmp _end
_false:
    push hillary
    push format
    call _printf
    add esp, 8
_end:
    mov esp, ebp
    pop ebp
    ret
```
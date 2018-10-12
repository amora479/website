---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 15: Strings / Overflow Attacks

Last class, we looked at some basic string operations in C, using the C string library.  However, what happens if we don't have, or can't use, said library.  The instructions for manipulating strings in raw assembly (or manipulating arrays) are a bit more complex than in C, but they can also be signifigantly faster.  Let's look at several examples of standard string operations in just assembly.

## Prior Information

Before we begin, there are a couple of registers and flags that we need to briefly introduce.  The RSI and RDI registers are the two primary entities for working with memory blocks.  RDI is the reference to the destination address, and RSI is the reference to the source address.  These need to be setup prior to executing the memory specific commands.  Second is the pointers, ES and DS.  These are known as segment registers and they provide offsets for RDI and RSI.  DS is used to represent the address of the program's data segment, and ES is used to represent any location of you're choosing (in general, ES and DS are equal).

Finally, counting and direction.  Counting is done by the RCX register; you might have noticed this if you tried to use RCX and printf at the same time.  Since printf takes a variable number of arguments, RCX is used to count them.  The direction we move in memory with the following commands is controlled by a special flag known as DF (direction flag).  We move forward in memory if the flag is clear and backward if the flag is set.  There are also special commands that exist for changing the flag (STD [setting] and CLD [clearing]).  

## Copying

Let's copy two strings!  In C, we can just use strcpy (or memcpy).

``` c
#include "string.h"
#include "stdio.h"

int main() {
	char string1[12] = "hello world";
	char string2[12] = {0};

	strcpy(string2, string1);

	printf("%s\n", string2);
	return 0;
}
```

For raw assembly, things are a bit different.  First, since we are producting win32 objects with nasm, we don't have to worry about ESI and EDI.  We will later when we get to raw hardware!

``` asm
default rel

extern printf

SECTION .data

	string1: db "hello world", 0
	string2: db 0,0,0,0,0,0,0,0,0,0,0,0
	fmt: db "%s", 10, 0

SECTION .text
global main
main:
	sub     rsp, 32			; shadow space

	mov     rdi, string2    ; copying to
	mov     rsi, string1    ; copying from
	cld                     ; direction to copy

	mov     rcx, 12         ; indicate how many bytes to copy
	rep     movsb           ; execute movsb edi, esi until ecx is 0

	lea     rdx, [string2]	; load address of string 2
	lea     rcx, [fmt]		; load address of fmt
	call    printf

    add     rsp, 32			; drop shadow space
	ret
```

In the above program, several things are happening.  First we move string2's address into the destination index and string1's address into the source index.  The we clear the direction flag to indicate that we are going to copy forward.  Next we execute movsb until ecx is 0.

## Index Of

C:

``` c
#include "string.h"
#include "stdio.h"

int main() {
	char string1[12] = "hello world";
	
	char *ptr = strchr(string1, 'o');

	printf("%d\n", (ptr - string1));
	return 0;
}
```

Assembly:

``` asm
default rel

extern printf

SECTION .data

	string1: db "hello world", 0
	fmt: db "%d", 10, 0

SECTION .text
global main
main:
    sub     rsp, 32			; shadow space

   	mov     rdi, string1    ; string to search
	cld     				; direction to search
	mov     al, 'o'         ; al contains the character we are searching for

	mov     rcx, 12         ; indicates when search should stop
	repne   scasb           ; execute until al is found or ecx is 0

	mov     rax, 12			; max index to rax so we can calculate where we stopped
	sub     rax, rcx		; rcx contains where we stopped
	sub     rax, 1			; sub 1 to get index
	mov     rdx, rax		; setup for printf 
	lea     rcx, [fmt]		; setup for printf
	call    printf
	
    add     rsp, 32			; drop shadow space
	ret
```

## String Compare

C:

``` c
#include "string.h"
#include "stdio.h"

int main() {
	char string1[12] = "hello world";
	char string2[12] = "hello groot";

	printf("%d\n", strcmp(string1, string2));
	return 0;
}
```

Assembly:

``` asm
default rel

extern printf

SECTION .data

	string1: db "hello world", 0
	string2: db "hello groot", 0
	fmt: db "%d", 10, 0

SECTION .text

global main
main:
    sub     rsp, 32			; shadow space

	mov     rdi, string2    ; copying to
	mov     rsi, string1    ; copying from

	mov     rcx, 12
	repe    cmpsb           ; execute while they are equal
	je      .push_0
	jmp     .push_1
.push_0:
	mov     rdx, 0			; print 0 if equal
	jmp     .pushed
.push_1:
	mov     rdx, 1			; print 1 if not
.pushed:
	lea     rcx, [fmt]		; load format string
	call    printf

    add     rsp, 32			; drop shadow space
	ret
```

## Reading Character By Character

C:

``` c
#include "string.h"
#include "stdio.h"

int main() {
	char string1[12] = {0};
	
	int i = 0;
	for(i = 0; i < 12 && string[i-1] != '\n'; ++i) {
		string1[i] = getchar();
	}
	string1[11] = 0; // remember to 0 terminate your strings
	printf("%s\n", string1);
	return 0;
}
```

Assembly:

``` asm
default rel

extern getchar
extern printf

SECTION .data

	string1: db 0,0,0,0,0,0,0,0,0,0,0,0
	count: dq 12

	fmt: db "%s", 10, 0

SECTION .text
global main
main:
    sub     rsp, 32				; shadow space

	mov     rdi, string1        ; printing to
	cld							; clear direction flag

.while:
	cmp     qword [count], 0	; only get a char while counter is > 0
	jne     .continue
	jmp     .done
.continue:
	mov     rax, 0				; clear rax before we get a char
	call    getchar
	cmp     eax, 10 			; newline
	jne     .continue2			; stop collecting on new lines
	jmp     .done
.continue2:
	stosb						; puts al into [rdi] and then increments rdi
	sub     qword [count], 1
	jmp     .while
.done:
	mov     byte [rdi+1], 0     ; don't forget to 0 terminate your strings
	lea     rdx, [string1]		; load the address of our string
	lea     rcx, [fmt]
	call    printf
    
    add     rsp, 32				; drop shadow space
	ret
```

## Printing Character By Character

C:

``` c
#include "string.h"
#include "stdio.h"

int main() {
	char string1[12] = "hello world";
	
	int i = 0;
	for(i = 0; i < 12; ++i) {
		putchar(string1[i]);
	}
	return 0;
}
```

Assembly:

``` asm
default rel

extern putchar

SECTION .data

	string1: db "hello world", 0
	count: dq 12

SECTION .text
global main
main:
    sub     rsp, 32				; shadow space

	mov     rsi, string1 		; printing from
	cld
.while:
	cmp     qword [count], 0	; only print while count > 0
	jne     .continue
	jmp     .done
.continue:
	mov     rax, 0				; clear rax
	lodsb                       ; copy byte [rsi] into al then increment rsi
	mov     rcx, 0				; get ready to print the character using rcx
    mov     cl, al 				; copy the character
	call    putchar
	
    dec     qword [count]		; decrement our counter
	jmp     .while
.done:
    add     rsp, 32				; drop shadow space
	ret
```

## Buffer Overflow Attacks

A buffer overflow occurs when data is written beyond the end of an array (usually because of gets or a similar function).  Consider the following login script:

``` c
#include "stdio.h"
#include "string.h"

char username[15];
char password[15];
int loginSuccessful = 0, isRoot = 0;

int main() {
	gets(username);
	gets(password);

	if(strcmp(username, "emcgee") == 0 && strcmp(password, "password")) {
		printf("Login Successful!\n");
		loginSuccessful = 1;
		isRoot = 1;
	} else {
		printf("Login Unsuccessful!\n");
	}

	if(loginSuccessful) {
		printf("You are logged in\n");
	} else {
		printf("You are not logged in\n");
	}

	if(isRoot) {
		printf("You are root\n");
	} else {
		printf("You are groot\n");
	}

	return 0;
}

```

Converted to assembly, this would (with a few optimizations) become:

``` asm
extern _gets
extern _printf
extern _strcmp

SECTION .data

	username: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	password: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	login_successful: dd 0
	is_root: dd 0

	real_username: db "emcgee", 0
	real_password: db "password", 0

	login_unsuccessful_str: db "Login Unsuccessful!", 10, 0
	login_successful_str: db "Login Successful!", 10, 0

	you_are_logged_in: db "You are logged in", 10, 0
	you_are_not_logged_in: db "You are not logged in", 10, 0

	you_are_root: db "You are root", 10, 0
	you_are_groot: db "You are groot", 10, 0

SECTION .text

global _main
_main:
	push username
	call _gets
	add esp, 4

	push password
	call _gets
	add esp, 4

	push username
	push real_username
	call _strcmp
	add esp, 8

	cmp eax, 0
	je username_correct
	jmp username_incorrect
username_correct:
	push password
	push real_password
	call _strcmp
	add esp, 8

	cmp eax, 0
	je password_correct
	jmp password_incorrect
password_correct:
	push login_successful_str
	call _printf
	add esp, 4

	mov dword [login_successful], 1
	mov dword [is_root], 1

	jmp continue
password_incorrect:
username_incorrect:
	push login_unsuccessful_str
	call _printf
	add esp, 4
continue:
	cmp dword [login_successful], 0
	jne login_was_successful
	jmp login_was_not_successful
login_was_successful:
	push you_are_logged_in
	call _printf
	add esp, 4
	jmp continue1
login_was_not_successful:
	push you_are_not_logged_in
	call _printf
	add esp, 4
continue1:
	cmp dword [is_root], 0
	jne root_was_successful
	jmp root_was_not_successful
root_was_successful:
	push you_are_root
	call _printf
	add esp, 4
	jmp continue2
root_was_not_successful:
	push you_are_groot
	call _printf
	add esp, 4
continue2:
	ret
```

If we look at both programs, both look relatively sane.  If the user enters the user/pass incorrectly, they reject him, and if he enters the info correctly, they accept.  However, these programs have a rather insidious bug.  If we look at the memory layout of `login_successful` and `is_root`, we see they come immediately after the password field.  Since gets doesn't prevent us from entering more than 15 characters, if we enter 23 h's as the password, the login fails but we are still authenticated and we get root access to boot.  Compile this program yourself, and try it out.

Why does this work with the Assembly program but not the C program?  Most C compilers nowadays auto inject checks to prevent attackers from executing buffer overflow attacks.  That doesn't mean that you can't, but it is definitely much harder than it used to be.  Assemblers do not insert checks for you.

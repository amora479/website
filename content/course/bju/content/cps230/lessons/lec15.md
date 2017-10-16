---
title: "CPS 230 Lecture 15"
---

# Lecture 14: Strings / Overflow Attacks

Last class, we looked at some basic string operations in C, using the C string library.  However, what happens if we don't have, or can't use, said library.  The instructions for manipulating strings in raw assembly (or manipulating arrays) are a bit more complex than in C, but they can also be signifigantly faster.  Let's look at several examples of standard string operations in just assembly.

## Prior Information

Before we begin, there are a couple of registers and flags that we need to briefly introduce.  The ESI and EDI registers are the two primary entities for working with memory blocks.  EDI is the reference to the destination address, and ESI is the reference to the source address.  These need to be setup prior to executing the memory specific commands.  Second is the pointers, ES and DS.  These are known as segment registers and they provide offsets for EDI and ESI.  DS is used to represent the address of the program's data segment, and ES is used to represent any location of you're choosing (in general, ES and DS are equal).

Finally, counting and direction.  Counting is done by the ECX register; you might have noticed this if you tried to use ECX and printf at the same time.  Since printf takes a variable number of arguments, ECX is used to count them.  The direction we move in memory with the following commands is controlled by a special flag known as DF (direction flag).  We move forward in memory if the flag is clear and backward if the flag is set.  There are also special commands that exist for changing the flag (STD [setting] and CLD [clearing]).  

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
extern _printf

SECTION .data

	string1: db "hello world", 0
	string2: db 0,0,0,0,0,0,0,0,0,0,0,0
	fmt: db "%s", 10, 0

SECTION .text
global _main
_main:
	mov edi, string2 ; copying to
	mov esi, string1 ; copying from
	cld ; direction to copy

	mov ecx, 12 ; indicate how many bytes to copy
	rep movsb ; execute movsb edi, esi until ecx is 0

	push string2
	push fmt
	call _printf
	add esp, 8

	ret
```

In the above program, several things are happening.  First we move string2's address into the destination index and string1's address into the source index.  The we clear the direction flag to indicate that we are going to copy forward.  Next we execute movsb until ecx is 0.

## Index Of

Index Of can be done in much the same way as moving, we simply need to call the right opcode and make sure to put the character we are searching for in al.

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
extern _printf

SECTION .data

	string1: db "hello world", 0
	fmt: db "%d", 10, 0

SECTION .text
global _main
_main:
	mov edi, string1 ; string to search
	cld ; direction to search
	mov al, 'o'

	mov ecx, 12 ; indicates when search should stop
	repne scasb ; execute until al is found or ecx is 0

	mov eax, 12
	sub eax, ecx
	sub eax, 1
	push eax
	push fmt
	call _printf
	add esp, 8

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
extern _printf

SECTION .data

	string1: db "hello world", 0
	string2: db "hello groot", 0
	fmt: db "%d", 10, 0

SECTION .text
global _main
_main:
	mov edi, string2 ; copying to
	mov esi, string1 ; copying from

	mov ecx, 12
	repe cmpsb
	je push_0
	jmp push_1
push_0:
	push 0
	jmp pushed
push_1:
	push 1
pushed:
	push fmt
	call _printf
	add esp, 8

	ret
```

## Reading Character By Character

C:

``` c

```

Assembly:

``` asm

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
extern _putchar

SECTION .data

	string1: db "hello world", 0
	count: dd 12

SECTION .text
global _main
_main:
	mov esi, string1 ; printing from
	cld

while:
	cmp dword [count], 0
	jne continue
	jmp done
continue:
	mov eax, 0
	lodsb
	push eax
	call _putchar
	add esp, 4
	sub dword [count], 1
	jmp while
done:
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

## Stack Overflow Attacks


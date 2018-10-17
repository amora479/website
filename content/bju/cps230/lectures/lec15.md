---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
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
	sub		rsp, 32			; shadow space

	mov		rdi, string2	; copying to
	mov		rsi, string1	; copying from
	cld						; direction to copy

	mov		rcx, 12			; indicate how many bytes to copy
	rep		movsb			; execute movsb edi, esi until ecx is 0

	lea		rdx, [string2]	; load address of string 2
	lea		rcx, [fmt]		; load address of fmt
	call	printf

	add		rsp, 32			; drop shadow space
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
	sub		rsp, 32			; shadow space

	mov		rdi, string1	; string to search
	cld						; direction to search
	mov		al, 'o'			; al contains the character we are searching for

	mov		rcx, 12			; indicates when search should stop
	repne	scasb			; execute until al is found or ecx is 0

	mov		rax, 12			; max index to rax so we can calculate where we stopped
	sub		rax, rcx		; rcx contains where we stopped
	sub		rax, 1			; sub 1 to get index
	mov		rdx, rax		; setup for printf 
	lea		rcx, [fmt]		; setup for printf
	call	printf
	
	add		rsp, 32			; drop shadow space
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
	sub		rsp, 32			; shadow space

	mov		rdi, string2	; copying to
	mov		rsi, string1	; copying from

	mov		rcx, 12
	repe	cmpsb			 ; execute while they are equal
	je		.push_0
	jmp		.push_1
.push_0:
	mov		rdx, 0			; print 0 if equal
	jmp		.pushed
.push_1:
	mov		rdx, 1			; print 1 if not
.pushed:
	lea		rcx, [fmt]		; load format string
	call	printf

	add		rsp, 32			; drop shadow space
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
	sub		rsp, 32				; shadow space

	mov		rdi, string1		; printing to
	cld							; clear direction flag

.while:
	cmp		qword [count], 0	; only get a char while counter is > 0
	jne		.continue
	jmp		.done
.continue:
	mov		rax, 0				; clear rax before we get a char
	call	getchar
	cmp		eax, 10 			; newline
	jne		.continue2			; stop collecting on new lines
	jmp		.done
.continue2:
	stosb						; puts al into [rdi] and then increments rdi
	sub		qword [count], 1
	jmp		.while
.done:
	mov		byte [rdi+1], 0	 	; don't forget to 0 terminate your strings
	lea		rdx, [string1]		; load the address of our string
	lea		rcx, [fmt]
	call	printf
	
	add		rsp, 32				; drop shadow space
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
	sub		rsp, 32				; shadow space

	mov		rsi, string1 		; printing from
	cld
.while:
	cmp		qword [count], 0	; only print while count > 0
	jne		.continue
	jmp		.done
.continue:
	mov		rax, 0				; clear rax
	lodsb						; copy byte [rsi] into al then increment rsi
	mov		rcx, 0				; get ready to print the character using rcx
	mov		cl, al				; copy the character
	call	putchar
	
	dec		qword [count]		; decrement our counter
	jmp		.while
.done:
	add		rsp, 32				; drop shadow space
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
default rel

extern gets
extern printf
extern strcmp

SECTION .data

	username: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	password: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	login_successful: dq 0
	is_root: dq 0

	real_username: db "emcgee", 0
	real_password: db "password", 0

	login_unsuccessful_str: db "Login Unsuccessful!", 10, 0
	login_successful_str: db "Login Successful!", 10, 0

	you_are_logged_in: db "You are logged in", 10, 0
	you_are_not_logged_in: db "You are not logged in", 10, 0

	you_are_root: db "You are root", 10, 0
	you_are_groot: db "You are groot", 10, 0

SECTION .text

global main
main:
	sub		rsp, 32							; create shadow space

	lea		rcx, [username]					; ask for username (no prompt)
	call	gets

	lea		rcx, [password]					; ask for password (no prompt)
	call	gets

	lea		rdx, [username]					; address of user entered username
	lea		rcx, [real_username]			; address of our not so secret username
	call	strcmp
	
	cmp		rax, 0							; if username == real_username
	je		.username_correct				; compare was true
	jmp		.username_incorrect				; compare was false
.username_correct:
	lea		rdx, [password]					; address of user entered password
	lea		rcx, [real_password]			; address of our not so secret password
	call	strcmp

	cmp		rax, 0							; if password == real_password
	je		.password_correct				; compare was true
	jmp		.password_incorrect				; compare was false
.password_correct:
	mov		qword [login_successful], 1		; the user is able to do stuff
	mov		qword [is_root], 1				; and they can be admin to boot after all they knew the password!

	jmp		.continue
.password_incorrect:
.username_incorrect:
	lea		rcx, [login_unsuccessful_str]	; the user didn't get in, no admin for you haha!
	call	printf
.continue:
	cmp		qword [login_successful], 0		; if login_successful == 0
	je		.login_was_not_successful		; compare was not true
	jmp		.login_was_successful			; compare was false
.login_was_not_successful:
	lea		rcx, [you_are_not_logged_in]	; tell the user they didn't get ins
	call	printf
	jmp		.check_root
.login_was_successful:
	lea		rcx, [you_are_logged_in]		; tell the user they got in
	call	printf
.check_root:
	cmp		qword [is_root], 0				; if is_root == 0
	je		.root_was_not_successful		; compare was true
	jmp		.root_was_successful			; compare was false
.root_was_not_successful:
	lea		rcx, [you_are_groot]			; let the user know they are not root
	call	printf
	jmp		.end
.root_was_successful:
	lea		rcx, [you_are_root]				; let the user know they are root
	call	printf
.end:
	add		rsp, 32
	ret
```

If we look at both programs, both look relatively sane.  If the user enters the user/pass incorrectly, they reject him, and if he enters the info correctly, they accept.  However, these programs have a rather insidious bug.  If we look at the memory layout of `login_successful` and `is_root`, we see they come immediately after the password field.  Since gets doesn't prevent us from entering more than 15 characters, if we enter 23 h's as the password, the login fails but we are still authenticated and we get root access to boot.  Compile this program yourself, and try it out.

Why does this work with the Assembly program but not the C program?  Most C compilers nowadays auto inject checks to prevent attackers from executing buffer overflow attacks.  That doesn't mean that you can't, but it is definitely much harder than it used to be.  Assemblers do not insert checks for you.

## Stack Smashing

```
default rel

extern gets, puts, printf

STRUC User
	.username: resb 50
	.password: resb 50
	.is_admin: resb 1
	.size:
ENDSTRUC

section .data

	admin: dq 0
	regular_user: dq 0

	user_is_admin: db "user is admin", 10, 0
	user_is_not_admin: db "user is not admin", 10, 0
	user_is_regular_user: db "user is regular user", 10, 0
	user_is_not_regular_user: db "user is not regular user", 10, 0

	address: db "%llx", 10, 0

section .text

times 4000 int 3							; pad 0s to the start of the binary

global auth
auth:
	sub		rsp, 40							; 40 bytes for username
	sub		rsp, 40							; 40 bytes for password
	sub		rsp, 32							; oh yeah and shadow space too

	lea		rcx, [rsp + 72]					; read username
	call	gets
	lea		rcx, [rsp + 32]					; read password
	call	gets

	; do some logic here for comparing username and password
	; if the user is a regular user call make user regular user
	; if the user is an admin call make user admin
	; this isn't important for the example, the bad stuff has already
	; happened at this point

	add		rsp, 112						; pop all the things off
	ret

global main
main:
	sub		rsp, 32							; create shadow space

	call	auth							; authenticate!

	cmp		qword [admin], 1				; if admin == 1
	je		.yes_admin						; compare was true
	jmp		.no_admin						; compare was not
.yes_admin:
	lea		rcx, [user_is_admin]			; user is admin
	call	puts
	jmp		.end_admin_check				; skip false
.no_admin:
	lea		rcx, [user_is_not_admin]		; print user isn't admin
	call	puts
.end_admin_check:

	cmp		qword [regular_user], 1			; if regular_user == 1
	je		.yes_regular_user				; compare was true
	jmp		.no_regular_user				; compare was false
.yes_regular_user:
	lea		rcx, [user_is_regular_user]		; print user is regular user
	call	puts
	jmp		.end_admin_check
.no_regular_user:
	lea		rcx, [user_is_not_regular_user]	; print user is not regular user
	call	puts
.end_regular_user_check:

	add		rsp, 32							; remove shadow space
	ret

global make_user_admin
make_user_admin:
	mov		qword [admin], 1				; helper function for elevating to admin
	ret

global make_user_regular_user
make_user_regular_user:
	mov		qword [regular_user], 1			; helper function for elevating to admin
	ret
```

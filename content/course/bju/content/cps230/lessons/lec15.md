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
	mov al, 'o' ; al contains the character we are searching for

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
	repe cmpsb ; execute while they are equal
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
extern _getchar
extern _printf

SECTION .data

	string1: db 0,0,0,0,0,0,0,0,0,0,0,0
	count: dd 12

	fmt: db "%s", 10, 0

SECTION .text
global _main
_main:
	mov edi, string1 ; printing to
	cld

while:
	cmp dword [count], 0
	jne continue
	jmp done
continue:
	mov eax, 0
	call _getchar
	cmp eax, 10 ; newline
	jne continue2
	jmp done
continue2:
	stosb
	sub dword [count], 1
	jmp while
done:
	mov [esp+12], 0 ; don't forget to 0 terminate your strings
	push string1
	push fmt
	call _printf
	add esp, 8
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
	lodsb ; al will contain the next character
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

## Stack Smashing (Overflow) Attacks

Stack Smashing (or Stack Overflow) attacks are very similar to buffer overflow attacks, but they require more work.  Let's look at an example C program that is vulnerable to this attack.

```c
#include "stdio.h"

char username[80];
char password[80];
char path[20];
int isLoggedIn = 0, isAdmin = 0;

void setAdmin() {
	printf("granting admin permission\n");
	isAdmin = 1;
}

void getAndSetPath() {
	char tempPath[20];
	int first = 1;
	do {
		if(!first) printf("Paths must start with /home/\n");
		first = 0;
		printf("Path (/home/<username>): ");
		gets(tempPath);
	} while(strncmp(tempPath, "/home/", 6) != 0);
}

int main() {
	printf("setAdmin is at address %d\n", &setAdmin);
	printf("Username: ");
	gets(username);
	printf("Password: ");
	gets(password);

	if(strcmp(username, "emcgee") == 0 && strcmp(password, "password") == 0) {
		isLoggedIn = 1;
		getAndSetPath();
	} else {
		isLoggedIn = 0;
	}

	if(isLoggedIn) {
		printf("You are logged in.\n");
		if(isAdmin) {
			printf("You are admin.\n");
		} else {
			printf("You are not admin.\n");
		}
	} else {
		printf("You are not logged in.\n");
	}

	return 0;
}
```

Now you might protest this program, which is a modified version of the previous example is still vulnerable to a buffer overflow attack, and you would be correct.  But, our goal this time is to cause the setAdmin function to run.  Note: this method isn't called anywhere in the current code.

How are we going to do it?  Well, if you've been following the method we used in class to covert the assembly file, then the assembly you generated would probably not be vulnerable.  But C compilers often try to optimize space.  Take a look at the `getAndSetPath` method.  The `tempPath` variable is used only here and no where else.  Following the method presented in class, we would allocate 4 bytes for the pointer and then create the string on the heap.  Since this variable isn't used anywhere else, most C compilers will instead create this string on the stack instead!!  This is due to the string not being used elsewhere.

```asm
bits 32

extern _printf
extern _gets
extern _strcmp
extern _strncmp

SECTION .data

	start_msg: db "setAdmin is at address %X", 10, 0
	granting_admin: db "granting admin permission", 10, 0

	real_username: db "emcgee", 0
	real_password: db "password", 0
	real_path_start: db "/home/", 0

	paths_error: db "Paths must start with /home/", 10, 0
	paths_prompt: db "Path (/home/<username>): ", 0

	username_prompt: db "Username: ", 0
	password_prompt: db "Password: ", 0
	logged_in_result: db "You are logged in.", 10, 0
	not_logged_in_result: db "You are not logged in.", 10, 0
	admin_result: db "You are admin.", 10, 0
	not_admin_result: db "You are not admin.", 10, 0

	is_logged_in: dd 0
	is_admin: dd 0

SECTION .bss

	username: resb 80
	password: resb 80
	path: resb 20

SECTION .text

global _main
_main:
	push _setAdmin
	push start_msg
	call _printf
	add esp, 8

	push username_prompt
	call _printf
	add esp, 4

	push username
	call _gets
	add esp, 4

	push password_prompt
	call _printf
	add esp, 4

	push password
	call _gets
	add esp, 4

	push real_username
	push username
	call _strcmp
	add esp, 8
	push eax

	push real_password
	push password
	call _strcmp
	add esp, 8
	pop ebx
	or eax, ebx
	cmp eax, 0
	je _login_successful
	jmp _login_unsuccessful
_login_successful:
	mov dword [is_logged_in], 1
	call _getAndSetPath
	jmp _end_login_check
_login_unsuccessful:
	mov dword [is_logged_in], 0
_end_login_check:

	cmp dword [is_logged_in], 1
	je _user_is_logged_in
	jmp _user_is_not_logged_in
_user_is_logged_in:
	push logged_in_result
	call _printf
	add esp, 4
	cmp dword [is_admin], 1
	je _user_is_admin
	jmp _user_is_not_admin
_user_is_admin:
	push admin_result
	call _printf
	add esp, 4
	jmp _end_admin_check
_user_is_not_admin:
	push not_admin_result
	call _printf
	add esp, 4
_end_admin_check:
	jmp _end_login_result_check
_user_is_not_logged_in:
	push not_logged_in_result
	call _printf
	add esp, 4
_end_login_result_check:

	ret

global _setAdmin
_setAdmin:
	push granting_admin
	call _printf
	add esp, 4
	mov dword [is_admin], 1
	ret

global _getAndSetPath
_getAndSetPath:
	sub esp, 24
	mov dword [esp], 1
_do_while_1:
	cmp dword [esp], 0
	je _check_first
	jmp _end_check_first
_check_first:
	push paths_error
	call _printf
	add esp, 4
_end_check_first:
	mov dword [esp], 0

	push paths_prompt
	call _printf
	add esp, 4

	lea eax, [esp+4]
	push eax
	call _gets
	add esp, 4

	lea eax, [esp+4]
	push 6
	push real_path_start
	push eax
	call _strncmp
	add esp, 12
	cmp eax, 0
	je _end_do_while_1
	jmp _do_while_1
_end_do_while_1:

	add esp, 24
	ret
```

Now, I've made our lives a little easier by inserting a printf statement that gives us the address of `\_setAdmin`.  In reality, you would need to either decompile the program back to assembly (which surprisingly isn't very hard, there are tools that will do this for you) to insert similar statements, or you would need to use a debugger like WinDBG to get the address.  Once, you have the address, you're all set. 

Let's assume we used a debugger and got the address `0x012F1B5F`. Create a hex file (a txt file written using a hex editor) that has the following contents:
```
     00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
000  65 6d 63 67 65 65 65 0d 0a 70 61 73 73 77 6f 72 emcgeee..passwor
010  64 0d 0d 0a 2f 68 6f 6d 65 2f 65 6d 63 67 65 65 d../home/emcgee/
020  68 68 68 68 68 68 68 00 5f 1b 2f 01 04 1b 2f 01 hhhhhhh.........
```

Notice the payload (in stack smashing also known as a cuckoo's nest) at the end of /home/emcgee/hhhhhhh.  It is in little endian, but it is the same address we got earlier.  What are we doing.  Notice that we don't have the `push ebp` and `mov ebp, esp` instructions here.  This means that the data immediately following our string `tempPath` and integer `first` on the stack is the return address.  We are writing beyond the end of the array to change where the function returns.  By setting the value equal to the address of `\_setAdmin`, we can force `\_setAdmin` to execute even if there is no code that directly calls it. 

You might be wondering about the extra address, `0x012F1B04`.  By counting the number of instructions (and the bytes they take) between `\_setAdmin` and `jmp _end_login_check` in main, we can calculate what return address we should use for `\_setAdmin`.  Because `\_setAdmin` wasn't originally called, we just need to put an address there as if it was called. This will cause `\_setAdmin` to return to `jmp _end_login_check` just like `\_getAndSetPath` should have, continuing execution with admin priviledges.

Now, once again, modern C compilers make this more difficult to accomplish, but it is still possible to do with some thought.  One of the methods used to prevent this is to use the heap trick that we've been using in class, but this isn't always efficient.  Another method is to auto-insert bounds checks at the end of each method to ensure the stack is still sane.
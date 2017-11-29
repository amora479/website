---
title: "CPS 230 Lecture 25"
---

# Lecture 25: Preemptive Task Switching

## What is it?

If you recall from the lecture on cooperative task switching, preemptive switching is when the OS handles the switching for you.  In other words, you don't call `yield`.

## Accomplishing It

We need a way to fire a method on a regular interval.  That method will be our replacement for yield.  Fortunately, there is an interrupt (INT 8) that fires every 18.2 seconds.  Let's use that to call yield.

Like when we covered cooperative task switching this is going to be a long example.  I'll break it up and explain the parts individually.  If you just need the full example, its at the bottom.

## Overriding the Interrupt

We covered how to do this in lecture 24.  To refresh your memory, there is a 2 byte offset at address 32 (8\*4) and a 2 byte segment at offset 34 (8\*4+2).  We will insert the address of our handler into these locations overriding the default handler.  BUT WAIT!!!!

Unlike last time, (the keyboard driver is dumb and doesn't do much), the INT 8 handler is actually very important.  It keeps the clock updated and keeps the interrupt executions synchronized.  If the original handler doesn't run, all of our interrupts will stop working. So, we need to run both our code and the original code.  Fortunately, we saved a pointer to the original handler.  Instead of calling iret to exit our handler, we'll just jump to the original handler and let it call iret instead.

``` asm
IVT8_OFFSET_SLOT	equ	4 * 8
IVT8_SEGMENT_SLOT	equ	IVT8_OFFSET_SLOT + 2

SECTION .text
_main:
	mov	ax, 0x0000
	mov	es, ax
	
	; install interrupt hook
	cli
	mov ax, [es:IVT8_OFFSET_SLOT]
	mov [ivt8_offset], ax
	mov ax, [es:IVT8_SEGMENT_SLOT]
	mov [ivt8_segment], ax

	mov ax, _timer_isr
	mov [es:IVT8_OFFSET_SLOT], ax
	mov ax, cs
	mov [es:IVT8_SEGMENT_SLOT], ax
	sti

	...

_timer_isr:
	...
	jmp	far [cs:ivt8_offset]

	...

SECTION .data
	...

	ivt8_offset	dw 0
	ivt8_segment dw 0
```

## Better Spawn and Yield

If you thought the original spawn and yield methods were a bit inefficient, you are completely correct, and there is actually a better way of writing them.  Rather than doing a `cmp cl, 31`, we can simply and cl by 31 (this only works because the number of stacks is a multiple of 2). We will need to change one thing though.  We need to make our task statuses an array of words rather than bytes.  This makes the effective address calculations easier

``` asm
; dx should contain the address of the function to run
_spawn_new_task:
	pusha
	mov cx, [current_task]
	mov bx, cx
	mov [stack_pointers+bx], sp
	
	add bx, 2
sp_while:
	cmp bx, cx
	jne sp_continue_search
	jmp sp_done
sp_continue_search:
	and bx, 0x003F ; max of 31
	cmp byte [task_status+bx], 0
	je sp_found
	add bx, 2
	jmp sp_while
sp_found:
	mov byte [task_status+bx], 1
	mov sp, [stack_pointers+bx]
	push dx
	pusha
	pushf
	mov [stack_pointers+bx], sp
	mov bx, cx
	mov sp, [stack_pointers+bx]
sp_done:
	popa
	ret
```

``` asm
_yield:
	pushf
	pusha
	; save current stack pointer
	mov cx, [current_task]
	mov bx, cx
	mov [stack_pointers+bx], sp

	add bx, 2
y_while:
	cmp bx, cx
	jne y_continue_search
	jmp y_done
y_continue_search:
	and bx, 0x003F ; max of 31
	cmp byte [task_status+bx], 1
	je y_found
	add bx, 2
	jmp y_while
y_found:
	mov sp, [stack_pointers+bx]
	mov [current_task], bx
y_done:
	; pop registers and flags
	popa
	popf
```

Now, we can't use our original trick of overloading the return address of ret.  This won't work because we are being called from within and interrupt, and interrupts (unlike call) don't push the return address onto the stack.  But interrupts do push something else.  They push the flags, cs and ip (in that order).  cs and ip are basically a return address so we'll just modify our spawn method slightly in how it configures the stack.

Instead of
``` asm 
push dx
pusha
pushf
```
we'll do
``` asm 
pushf
push cs
push dx
pusha
```

Now, we simply need to plug (a slightly modified) yield into the body of the timer interrupt routine.

``` asm
_timer_isr:
	pusha
	; save current stack pointer
	mov cx, [current_task]
	mov bx, cx
	mov [stack_pointers+bx], sp

	add bx, 2
y_while:
	cmp bx, cx
	jne y_continue_search
	jmp y_done
y_continue_search:
	and bx, 0x003F ; max of 31
	cmp byte [task_status+bx], 1
	je y_found
	add bx, 2
	jmp y_while
y_found:
	mov sp, [stack_pointers+bx]
	mov [current_task], bx
y_done:
	; pop registers
	popa
	jmp	far [cs:ivt8_offset]
```

Remember the interrupt pushes flags, cs and ip and iret pops them.  Let those two instructions handle the dirty work and we'll just make sure we push the registers.

## Handling Race Conditions

If take the cooperative switching program we wrote, and make the above changes, everything should work, but there will be a slight problem.  Occasionally, a thread will be interrupted during the middle of printing. You'll wind up with lines like:
 
``` text
I am tasI am task A
k MAIN
I am task B
```

That's probably not what we want.  We need a way to block certain (critcal or shared) sections of code and prevent other threads from entering them until the current thread is done.  This is also called a mutex or a semaphore.

Most high level languages implement these for you, but, we're in assembly.  We have to implement them ourselves.  Fortunately, there is a very handy command we can use `xchg`.  `xchg` copies a memory address value into a register and the register into the memory address, "exchanging" their values.

So let's see how to use this command, and then I'll explain.

``` asm
_mutex:
	push ax
	mov ax, 0
mutex_loop:
	xchg [mutex], ax
	cmp ax, 0
	je mutex_loop
	pop ax
	ret

_release_mutex:
	push ax
	mov ax, 1
	xchg [mutex], ax
	pop ax
	ret

SECTION .data
	mutex: dw 1
```

When mutex has a value of 1, it is "unlocked" or a thread can enter the "critical" or shared section of code.  When mutex is 0, it is locked and threads must wait to enter.

When a thread calls mutex, it exchanges mutex and 0 (using ax).  If ax gets the value 1, we're clear to enter.  Any other thread that tries this will get 0 and loop forever (occasionally getting interrupted of course).

When we're done, we have to release, in which we exchange mutex with 1 (using ax).  This will unlock the mutex so that we (or another thread) can grab it again.

## Full Example

``` asm
bits 16

org 0x100

IVT8_OFFSET_SLOT	equ	4 * 8
IVT8_SEGMENT_SLOT	equ	IVT8_OFFSET_SLOT + 2

SECTION .text
_main:
	mov	ax, 0x0000
	mov	es, ax
	
	; install interrupt hook
	cli
	mov ax, [es:IVT8_OFFSET_SLOT]
	mov [ivt8_offset], ax
	mov ax, [es:IVT8_SEGMENT_SLOT]
	mov [ivt8_segment], ax

	mov ax, _timer_isr
	mov [es:IVT8_OFFSET_SLOT], ax
	mov ax, cs
	mov [es:IVT8_SEGMENT_SLOT], ax
	sti

	; main task is always active to start
	mov byte [task_status], 1

	mov dx, _task_a
	call _spawn_new_task

	mov dx, _task_b
	call _spawn_new_task

loop_forever_main:
	mov si, task_main_str
	call _putstring
	jmp loop_forever_main	
	; does not terminate or return

_timer_isr:
	pusha
	; save current stack pointer
	mov cx, [current_task]
	mov bx, cx
	mov [stack_pointers+bx], sp

	add bx, 2
y_while:
	cmp bx, cx
	jne y_continue_search
	jmp y_done
y_continue_search:
	and bx, 0x003F ; max of 31
	cmp byte [task_status+bx], 1
	je y_found
	add bx, 2
	jmp y_while
y_found:
	mov sp, [stack_pointers+bx]
	mov [current_task], bx
y_done:
	; pop registers
	popa
	jmp	far [cs:ivt8_offset]

; dx should contain the address of the function to run
_spawn_new_task:
	pusha
	mov cx, [current_task]
	mov bx, cx
	mov [stack_pointers+bx], sp
	
	add bx, 2
sp_while:
	cmp bx, cx
	jne sp_continue_search
	jmp sp_done
sp_continue_search:
	and bx, 0x003F ; max of 31
	cmp byte [task_status+bx], 0
	je sp_found
	add bx, 2
	jmp sp_while
sp_found:
	mov byte [task_status+bx], 1
	mov sp, [stack_pointers+bx]
	pushf
	push cs
	push dx
	pusha
	mov [stack_pointers+bx], sp
	mov bx, cx
	mov sp, [stack_pointers+bx]
sp_done:
	popa
	ret

_task_a:
loop_forever_1:
	mov si, task_a_str
	call _putstring
	jmp loop_forever_1
	; does not terminate or return

_task_b:
loop_forever_2:
	mov si, task_b_str
	call _putstring
	jmp loop_forever_2
	; does not terminate or return

_putchar:
	mov ax, dx
	mov ah, 0x0E
	mov cx, 1
	int 0x10
	ret

_putstring:
	call _mutex
putstring_while:
	cmp byte [si], 0
	jne putstring_continue
	jmp pustring_done
putstring_continue:
	mov dl, [si]
	mov dh, 0
	call _putchar
	inc si
	jmp putstring_while
pustring_done:
	call _release_mutex
	ret

_mutex:
	push ax
	mov ax, 0
mutex_loop:
	xchg [mutex], ax
	cmp ax, 0
	je mutex_loop
	pop ax
	ret

_release_mutex:
	push ax
	mov ax, 1
	xchg [mutex], ax
	pop ax
	ret

SECTION .data
	task_main_str: db "I am task MAIN", 13, 10, 0
	task_a_str: db "I am task A", 13, 10, 0
	task_b_str: db "I am task B", 13, 10, 0

	mutex: dw 1

	ivt8_offset	dw 0
	ivt8_segment dw 0

	current_task: db 0
	stacks: times (256 * 31) db 0 ; 31 fake stacks of size 256 bytes
	task_status: times 32 db 0 ; 0 means inactive, 1 means active
	stack_pointers: dw 0 ; the first pointer needs to be to the real stack !
					dw stacks + (256 * 1)
					dw stacks + (256 * 2)
					dw stacks + (256 * 3)
					dw stacks + (256 * 4)
					dw stacks + (256 * 5)
					dw stacks + (256 * 6)
					dw stacks + (256 * 7)
					dw stacks + (256 * 8)
					dw stacks + (256 * 9)
					dw stacks + (256 * 10)
					dw stacks + (256 * 11)
					dw stacks + (256 * 12)
					dw stacks + (256 * 13)
					dw stacks + (256 * 14)
					dw stacks + (256 * 15)
					dw stacks + (256 * 16)
					dw stacks + (256 * 17)
					dw stacks + (256 * 18)
					dw stacks + (256 * 19)
					dw stacks + (256 * 20)
					dw stacks + (256 * 21)
					dw stacks + (256 * 22)
					dw stacks + (256 * 23)
					dw stacks + (256 * 24)
					dw stacks + (256 * 25)
					dw stacks + (256 * 26)
					dw stacks + (256 * 27)
					dw stacks + (256 * 28)
					dw stacks + (256 * 29)
					dw stacks + (256 * 30)
					dw stacks + (256 * 31)
```
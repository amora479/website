---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 22: Co-operative Tasks

Today's lecture is going to be a different.  We're going to discuss how to accomplish something (or rather simulate something) that is actually impossible on older comptuers.  That is... multitasking.

## Modern Processor Architectures

Modern processors can actually run multiple threads of execution in parallel, but this is because of the advent of multi-core architectures.  Each thread can be assigned to a core, and the cores run the tasks in a true parallel fashion.  However, we've had multitasking on computers since before the advent of multicore machines, or at least it has looked like we did.

## Multitasking Without Multitasking

On older processors with a single core, you can achieve what looks like multitasking by periodically switching between tasks.  As long as the processor is fast enough and you make sure that each task is getting adequate time, the only discernable difference is that your task takes a bit longer to execute.

## Two Types

There are two types of multitasking: preemptive and cooperative.  Preemptive means that the processor gets to define how many clock cycles you get to execute and then it sends a signal alerting the task that its time is up and the processor is switching tasks.  Cooperative multitasking means that you place "yield" statements periodically in your code.  When a yield is executed, you tell the processor you're at a good place to stop and someone else can run for a bit.

Cooperative multitasking is actually easier to accomplish so we'll write a program that runs two tasks, A and B.  Each task will be rather simple.  It will print "I am task A/B" then yield.  Our setup, though, will support up to 32 tasks.

Note:  This example is going to be quite involved with a lot of parts.  I will call out the parts individually and explain them as we go, then the full example will be listed at the end of the notes.

## Example

### Saving Registers / Stacks

Before we get into the gritty details, I need to introduce two commands that we haven't used, but are about to become very important: `pusha` and `pushf`.  `pusha` pushes all the general purposes registers onto the stack and its twin `popa` restores them. Likewise `pushf` pushes the flags register onto the stack and its twin `popf` restores it.

The general purposes registers of course include ax, bx, cx, and dx.  Also included are si and di as well as sp and bp.

### Making a New Task

In order to make a new task, we're gonna need some things.  Each task is going to need its own stack (we have to save a tasks registers and state before we switch so we can restore it).  We're also going to need the tasks status (whether its active or inactive).  So let's reserve those items in a .data section.

``` asm
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

Here we have a few things we haven't seen before so I'll explain.  `times` means to repeat the initialization for that many bytes.  So `times (256 * 31) db 0` reserves 7396 bytes all initialized to 0.

What we are going to do is support up to 32 tasks (31 + main).  Each task has a status to tell us if there is a task loaded there as well as a stack (main just reuses the starting stack).  The stack pointers array is really just a list of pointers to the top of each task's stack (once again, main needs to use the starting stack).

Alright, so to spawn a new task, we need to do a couple of things:

1. Find an empty task slot.  If there isn't one, we don't spawn a task.
1. Set the selected slot to active.
1. Change the stack pointer to the top of the task slot's stack.
1. Push the address of the function we want to run.
1. Push the registers.
1. Push the flags.
1. Restore the original stack pointer.

And here is that in assembly:

``` asm
; dx should contain the address of the function to run
_spawn_new_task:
	; save current stack pointer
	mov bx, stack_pointers
	add bx, [current_task]
	add bx, [current_task] ; add twice because we have two bytes
	mov [bx], sp
	; switch to new stack
	mov cx, 0
	mov cl, [current_task]
	inc cl
sp_loop_for_available_stack:
	cmp cl, byte [current_task]
	jne sp_check_for_overflow
	jmp sp_no_available_stack
sp_check_for_overflow:
	cmp cl, 31
	jg sp_reset
	jmp sp_check_if_available
sp_reset:
	mov cl, 0
	jmp sp_loop_for_available_stack
sp_check_if_available:
	mov bx, task_status
	add bx, cx
	cmp byte [bx], 0
	je sp_is_available
	inc cx
	jmp sp_loop_for_available_stack
sp_is_available:
	mov bx, task_status
	add bx, cx
	mov byte [bx], 1
	; push a fake return address
	mov bx, stack_pointers
	add bx, cx
	add bx, cx
	mov sp, [bx]
	push dx
	; push registers
	pusha
	; push flags
	pushf
	; update stack pointer for task
	mov bx, stack_pointers
	add bx, cx
	add bx, cx ; add twice because we have two bytes
	mov [bx], sp
	; restore to original stack
sp_no_available_stack:
	mov bx, stack_pointers
	add bx, [current_task]
	add bx, [current_task] ; add twice because we have two bytes
	mov sp, [bx]
	ret
```

### Yielding

So the top of each stack should contain: flags, registers, return address.  Yielding then is actually pretty simple.

1. Save the current registers (return address is already at the top).
1. Save the current flags.
1. Make sure to update our stack pointer.
1. Find the next available task.
1. Pop the flags.
1. Pop the registers.
1. Return to that stack's caller.

And here is that in assembly:

``` asm
_yield:
	; push registers
	pusha
	; push flags
	pushf
	; save current stack pointer
	mov bx, stack_pointers
	add bx, [current_task]
	add bx, [current_task] ; add twice because we have two bytes
	mov [bx], sp
	; switch to new stack
	mov cx, 0
	mov cl, [current_task]
	inc cl
y_check_for_overflow:
	cmp cl, 31
	jg y_reset
	jmp y_check_if_enabled
y_reset:
	mov cl, 0
	jmp y_check_for_overflow
y_check_if_enabled:
	mov bx, task_status
	add bx, cx
	cmp byte [bx], 1
	je y_task_available
	inc cx
	jmp y_check_for_overflow
y_task_available:
	mov bx, cx
	mov [current_task], bx
	; update stack pointer
	mov bx, stack_pointers
	add bx, [current_task]
	add bx, [current_task] ; add twice because we have two bytes
	mov sp, [bx]
	; pop flags
	popf
	; pop registers
	popa
	ret
```


## Full Example

``` asm
bits 16

org 0x100

SECTION .text
_main:
	; main task is always active
	mov byte [task_status], 1

	mov dx, _task_a
	call _spawn_new_task

	mov dx, _task_b
	call _spawn_new_task

loop_forever_main:
	mov si, task_main_str
	call _putstring
	call _yield
	jmp loop_forever_main	
	; does not terminate or return

; dx should contain the address of the function to run
_spawn_new_task:
	; save current stack pointer
	mov bx, stack_pointers
	add bx, [current_task]
	add bx, [current_task] ; add twice because we have two bytes
	mov [bx], sp
	; switch to new stack
	mov cx, 0
	mov cl, [current_task]
	inc cl
sp_loop_for_available_stack:
	cmp cl, byte [current_task]
	jne sp_check_for_overflow
	jmp sp_no_available_stack
sp_check_for_overflow:
	cmp cl, 31
	jg sp_reset
	jmp sp_check_if_available
sp_reset:
	mov cl, 0
	jmp sp_loop_for_available_stack
sp_check_if_available:
	mov bx, task_status
	add bx, cx
	cmp byte [bx], 0
	je sp_is_available
	inc cx
	jmp sp_loop_for_available_stack
sp_is_available:
	mov bx, task_status
	add bx, cx
	mov byte [bx], 1
	; push a fake return address
	mov bx, stack_pointers
	add bx, cx
	add bx, cx
	mov sp, [bx]
	push dx
	; push registers
	pusha
	; push flags
	pushf
	; update stack pointer for task
	mov bx, stack_pointers
	add bx, cx
	add bx, cx ; add twice because we have two bytes
	mov [bx], sp
	; restore to original stack
sp_no_available_stack:
	mov bx, stack_pointers
	add bx, [current_task]
	add bx, [current_task] ; add twice because we have two bytes
	mov sp, [bx]
	ret

_yield:
	; push registers
	pusha
	; push flags
	pushf
	; save current stack pointer
	mov bx, stack_pointers
	add bx, [current_task]
	add bx, [current_task] ; add twice because we have two bytes
	mov [bx], sp
	; switch to new stack
	mov cx, 0
	mov cl, [current_task]
	inc cl
y_check_for_overflow:
	cmp cl, 31
	jg y_reset
	jmp y_check_if_enabled
y_reset:
	mov cl, 0
	jmp y_check_for_overflow
y_check_if_enabled:
	mov bx, task_status
	add bx, cx
	cmp byte [bx], 1
	je y_task_available
	inc cx
	jmp y_check_for_overflow
y_task_available:
	mov bx, cx
	mov [current_task], bx
	; update stack pointer
	mov bx, stack_pointers
	add bx, [current_task]
	add bx, [current_task] ; add twice because we have two bytes
	mov sp, [bx]
	; pop flags
	popf
	; pop registers
	popa
	ret

_task_a:
loop_forever_1:
	mov si, task_a_str
	call _putstring
	call _yield
	jmp loop_forever_1
	; does not terminate or return

_task_b:
loop_forever_2:
	mov si, task_b_str
	call _putstring
	call _yield
	jmp loop_forever_2
	; does not terminate or return

_putchar:
	mov ax, dx
	mov ah, 0x0E
	mov cx, 1
	int 0x10
	ret

_putstring:
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
	ret

SECTION .data
	task_main_str: db "I am task MAIN", 13, 10, 0
	task_a_str: db "I am task A", 13, 10, 0
	task_b_str: db "I am task B", 13, 10, 0

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
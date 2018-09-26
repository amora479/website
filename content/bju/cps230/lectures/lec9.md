---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lecture 9: Control Flow in Assembly (If/Else If/Else Statements)

## Calling Scanf

We need to take one more side trip into the land of functions to talk about how scanf is called.  Remember, with scanf, we are really just passing the address of the location we want scanf to store the value it reads.  So the pushes and pops are more or less the same.  The only thing that isn't is the parameter.

``` asm
bits 64
default rel

extern scanf
extern printf

SECTION .data

	a: dq 0
	fmt1: db "%d\n", 0
	fmt2: db "%d", 10, 0

SECTION .text

global main
main:
	mov rdx, a ; pass the address of a
	mov rcx, fmt1
	call scanf
	
	mov rdx, [a] ; copy the actual value of a
	mov rcx, fmt2
	call printf
	ret
```

## Jumping

Say there is a block of code you wanna skip (or block of instructions in this case), you have two options, you can either remove the instructions (no fun) or you can jump over them (more fun).

```
	jmp continue_here
	add esp, 8
continue_here:
```

The `jmp` command is essentially a goto and it takes an address, or for those of us who don't want to calculate the address of an instruction manually, a label.  The program counter is then updated by the `jmp` instruction so the next command is the one after the label.  There are both conditional jumps as well as unconditional.  `jmp` is unconditional.  The unconditional jump is actually quite powerful as you can basically go anywhere in the program you want.  Conditional jumps are more limited as they can only go a limited distance from the current command.  We'll be using jumps to accomplish both if statements and while loops.

## If Statements

The general structure for if / else if / else statements in assembly is going to be the following:

``` asm
... perform condition check for if ...
... jump if true to true_part_1 ...
... jump to false_part_1 ...
true_part_1:
	... code for true ...
	... jump to end_if ...
false_part_1:
... perform condition check for else if ...
... jump if true to true_part_2 ...
... jump to false_part_2 ...
true_part_2:
	... code for else if ...
	... jump to end_if ...
false_part_2:
	... code for else ...
end_if:
```

This can be adapated to handle any number of else if conditions.  It can also be adapted to handle a lack of else conditions, just increment the `_<numbers>` accordingly.
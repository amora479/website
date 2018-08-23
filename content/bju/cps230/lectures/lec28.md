---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 28: ARM Assembly

We've spent this semester covering Intel based assembly (using NASM).  But, lest you think every platform out there uses NASM-based Intel assembly, Intel assembly isn't even the most widely used assembly language anymore.

Well, to be fair, it depends on what you mean by "widely used".  In this case, I am referring to processors supported by the assembly langauge.  In this case, ARM assembly wins without contest.  The reason is simple.  Nearly every small electronics device (including most phones) use an ARM chip under the hood.  ARM processors are known for their efficiency and low power usage.  Part of this efficiency comes from how the architecture is designed.

## Registers

ARM has 16 registers (creatively named R0-R15).  R13 doubles as the stack pointer, R14 doubles as the return address register and R15 holds the program counter.  One thing to note here is that ARM never auto pushes to the stack so if you don't need the stack, you get another register.

In addition to these, there is also the CPSR register which contains the state of the current program.

ARM is a bit different that what we've seen.  It's not a Fetch-Decode-Execute model, but rather a load-store model.  This means that there are no instructions for operating on memory.  If you want to perform an operation with a block of memory, you load that memory into a register, operate on the register and then return the result to memory.

## Arithmetic

ARM is unique in how many registers you are allowed to use when doing arithmetic operations.  Well at least for add, subtract and multply anyway: the instructions take the form `<instruction> <destination>, <operand1>, <operand2>`.

Despite that uniqueness, ARM does have some quirks when it comes to arithmetic.  There is no divide instruction!  To perform division, you either have to do shifts or call a C standard library function provided by most ARM assemblers.

## Logical Operations

Logical operations (and, or, xor, etc) have the same form as arithmetic operations (using three operands).

## Conditional Instructions

One other interesting feature of ARM is the ability to execute instructions based on flags.  I'm sure your familiar with conditional jumps (from Intel assembly), but imagine conditional adds, subtracts and calls.  This basically allows you to inject if statements into your assembly by simply appending a qualifier to the end of the instruction.

## Fixed-width Instructions

The final quirk I want to cover is that of fixed-width instructions.  If you remember from our lecture on linkers, in Intel Assembly some instructions are a different size.  In ARM assembly this is not the case (or if it is, the instruction is size adjusted so it fits into the architectures width).  So in 16-bit ARM chips, program instructions are always 2 bytes (even if the instruction doesn't use the full 16 bits).  What this loses in space efficiency, it makes up for in time, processing and complexity.

## Example 1

Let's take a sample C statement

``` C
x = (a + b) - c;
```

and convert it into ARM

``` asm
ADR r4,a     ; get address for a
LDR r0,[r4]  ; get value of a
ADR r4,b     ; get address for b, reusing r4
LDR r1,[r4]  ; get value of b
ADD r3,r0,r1 ; compute a+b
ADR r4,c     ; get address for c
LDR r2,[r4]  ; get value of c
SUB r3,r3,r2 ; complete computation of x
ADR r4,x     ; get address for x
STR r3,[r4]  ; store value of x
```

## Example 2

Let's take a sample C statement

``` C
if (i == 0) {
	i = i +10;
}
```

and convert it into ARM

``` asm
SUBS  R1, R1, #0
ADDEQ R1, R1, #10
```

## Example 3

Let's take a sample C statement

``` C
for ( i = 0 ; i < 15 ; i++) {
	j = j + j;
}
```

and convert it into ARM

``` asm
		SUB   	R0, R0, R0   ; i -> R0 and i = 0
start  	CMP 	R0, #15      ;   is i < 15?
		ADDLT	R1, R1, R1   ;   j = j + j
		ADDLT	R0, R0, #1   ;   i++
		BLT 	start
```
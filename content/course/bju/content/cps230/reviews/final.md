---
title: "CPS 230 Final Review"
---

# Final Review

1. Be able to convert between bases
1. Be able to perform basic bit operations (and, or, not, xor, etc)
1. Be familiar with the roles of various registers
	1. SP is the stack pointer register
	1. BP is the frame register
	1. AX, BX, CX, DX, SP, BP, SI, DI are considered to be general purpose registers
	1. IP points to the next instruction, etc
1. Given a snippet of assembly, describe what it does, and be able to answer questions about it (i.e. what is the value is X register / memory address after line 3)
1. Be familiar with the ways to trigger an interrupt (instructions, exceptions and hardware)
1. Be familiar with Cooperative vs Preemptive
	1. Cooperative code is simpler but it is prone to bugs locking the system
	1. Preemptive requires "less" work on the programmer (no yields) but race conditions are possible
	1. Modern computers provide preemptive cooperation
1. Be familiar with how to boot from disk (setup stack, read program sectors from disk into specific memory address using interrupts, jump to program)
1. Be familiar with the differences between 16-bit, 32-bit and 64-bit assembly

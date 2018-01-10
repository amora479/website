---
title: "CPS 230 Lecture 0"
---

# Lecture 0: Terms

The purpose of this lecture is provide you with a general overview of computer architecture and how things fit together.

## Data

If I were to ask you what the binary string `1001100` represents, your answers would probably differ.  It could be an integer, part of a string, a machine instruction.  Data is comprised of two elements, bits and context.  You must have both.

## General Computer Architecture

We start our tour of the architecture of a general computer with the below image.

![img](/course/bju/content/cps230/images/lec_0_img_1.png)

There is a lot going on here, so let's break it down:

* CPU (Central Processing Unit) - the "brains" of the computer. This is where all instructions are executed.  It consists of a couple of subparts:
	* Registers - tiny (for our purposes 32-bit) blocks of memory
	* ALU (Arithmatic Logic Unit) - this is where operations actually occur
	* Program Counter - a pointer to the next instruction (or in some architectures the current one)
* Main Memory (RAM) - where programs and their data are stored 
* Disk - "long-term" storage

Main Memory and Disk access are slow (think thousands of clock cycles) so in order to speed up access, caches have been added over time.  There are three main caches in modern architectures and their names are pretty easy: L1, L2 and L3.  (Computer scientists aren't always creative namers.)

![img](/course/bju/content/cps230/images/lec_0_img_2.png)

As you move higher into the memory hierarchy, the cost of producing the memory increases dramatically, but its time to access decreases.

## Program Memory Layout

When a program is executed, it is fetched from disk into RAM where the program has a specific layout.

![img](/course/bju/content/cps230/images/lec_0_img_3.png)

At the lowest possible memory address, we have the program itself (or rather a binary representation of its instructions) followed by the read / write data (think variables or data reserved in the program that can be mutated).  Next we have our heap which grows up in memory and at the top of our memory space, we have our stack.  (In between, sometimes there is a protected space.  For our purposes, we'll say this protected space contains shared libraries.  However, this space isn't always there.)

The instructions your program executes can be categorized into 4 groups based on what they do:

* Load - bring a value from memory into a register
* Store - put a value in a register into memory
* Operate - perform an operation on two registers (or sometimes a register and a memory address).
* Jump - modify the program counter

## Abstractions

These are one of the biggest concepts in computer science.  They allow us to accomplish work without having to worry about the underlying details, and something that we, as computer scientists, use daily is actually an important abstraction, the OS.  The Operating System hides many of the gritty details about using periphierals, executing instructions, etc. from us behind an abstraction layer.  For the most part, we'll use this layer throughout the semester to make our lives a bit easier.  However, we will do some bare-metal programming later in the semester so you can get a feel for how it is done.

